//
//  Saturation.metal
//  MetalCustomShaders
//
//  Created by Rouzbeh Abadi on 14.05.23.
//

#include <metal_stdlib>
using namespace metal;

/**
 * @struct saturate_input
 * @brief Structure to encapsulate saturation factor.
 */
struct saturate_input {
    float saturationFactor; ///< Saturation factor to be applied to the image.
};

/**
 * @fn rgb2hsv
 * @brief Converts RGB color model to HSV.
 * @param c RGB color as a vector.
 * @return HSV color as a vector.
 */
float3 rgb2hsv(float3 c) {
    float4 K = float4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
    float4 p = mix(float4(c.bg, K.wz), float4(c.gb, K.xy), step(c.b, c.g));
    float4 q = mix(float4(p.xyw, c.r), float4(c.r, p.yzx), step(p.x, c.r));
    float d = q.x - min(q.w, q.y);
    float e = 1.0e-10;
    return float3(abs(q.z + (q.w - q.y) / (6.0 * d + e)), d / (q.x + e), q.x);
}

/**
 * @fn hsv2rgb
 * @brief Converts HSV color model to RGB.
 * @param c HSV color as a vector.
 * @return RGB color as a vector.
 */
float3 hsv2rgb(float3 c) {
    float4 K = float4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
    float3 p = abs(fract(c.xxx + K.xyz) * 6.0 - K.www);
    return c.z * mix(K.xxx, clamp(p - K.xxx, 0.0, 1.0), c.y);
}

/**
 * @fn saturationAdjust
 * @brief Kernel function to adjust saturation of an image.
 * @param inputTexture The input image as a 2D texture to read from.
 * @param outputTexture The output image as a 2D texture to write to.
 * @param input A saturate_input object containing the saturation factor.
 * @param gid The thread position in grid.
 */
kernel void saturationAdjust(texture2d<float, access::read>  inputTexture [[ texture(0) ]],
                             texture2d<float, access::write> outputTexture [[ texture(1) ]],
                             constant saturate_input& input [[ buffer(0) ]],
                             uint2 gid [[ thread_position_in_grid ]]) {
    float4 color = inputTexture.read(gid); // Read color from the input texture at the grid position.
    float3 rgbColor = color.rgb; // Extract the RGB components of the color.
    float3 hsvColor = rgb2hsv(rgbColor); // Convert the RGB color to HSV.
    hsvColor.y *= input.saturationFactor; // Adjust the saturation component of the HSV color.
    hsvColor.y = clamp(hsvColor.y, 0.0, 1.0); // Clamp the saturation to the range [0,1].
    rgbColor = hsv2rgb(hsvColor); // Convert the HSV color back to RGB.
    outputTexture.write(float4(rgbColor, color.a), gid); // Write the adjusted color to the output texture at the grid position.
}



