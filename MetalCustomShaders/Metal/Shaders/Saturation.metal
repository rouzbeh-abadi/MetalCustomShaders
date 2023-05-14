//
//  Saturation.metal
//  MetalCustomShaders
//
//  Created by Rouzbeh Abadi on 14.05.23.
//

#include <metal_stdlib>
using namespace metal;


struct saturate_input {
    float saturationFactor;
};

float3 rgb2hsv(float3 c) {
    float4 K = float4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
    float4 p = mix(float4(c.bg, K.wz), float4(c.gb, K.xy), step(c.b, c.g));
    float4 q = mix(float4(p.xyw, c.r), float4(c.r, p.yzx), step(p.x, c.r));
    float d = q.x - min(q.w, q.y);
    float e = 1.0e-10;
    return float3(abs(q.z + (q.w - q.y) / (6.0 * d + e)), d / (q.x + e), q.x);
}

float3 hsv2rgb(float3 c) {
    float4 K = float4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
    float3 p = abs(fract(c.xxx + K.xyz) * 6.0 - K.www);
    return c.z * mix(K.xxx, clamp(p - K.xxx, 0.0, 1.0), c.y);
}

kernel void saturationAdjust(texture2d<float, access::read>  inputTexture [[ texture(0) ]],
                             texture2d<float, access::write> outputTexture [[ texture(1) ]],
                             constant saturate_input& input [[ buffer(0) ]],
                             uint2 gid [[ thread_position_in_grid ]]) {
    float4 color = inputTexture.read(gid);
    float3 rgbColor = color.rgb;
    float3 hsvColor = rgb2hsv(rgbColor);
    hsvColor.y *= input.saturationFactor;
    hsvColor.y = clamp(hsvColor.y, 0.0, 1.0); // Make sure the saturation stays between 0 and 1
    rgbColor = hsv2rgb(hsvColor);
    outputTexture.write(float4(rgbColor, color.a), gid);
}


