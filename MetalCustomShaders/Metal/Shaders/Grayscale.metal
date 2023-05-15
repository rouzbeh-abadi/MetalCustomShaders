//
//  Grayscale.metal
//  MetalCustomShaders
//
//  Created by Rouzbeh Abadi on 13.05.23.
//

#include <metal_stdlib>
using namespace metal;

// This is the kernel function that converts an RGB image to grayscale.
kernel void grayscale(texture2d<float, access::read> inTexture [[texture(0)]],  // The input texture to read from.
                      texture2d<float, access::write> outTexture [[texture(1)]], // The output texture to write to.
                      uint2 gid [[thread_position_in_grid]]) { // The grid position of the thread.
    // Read the color of the pixel at the grid position from the input texture.
    float4 color = inTexture.read(gid);
    // Convert the color to grayscale using the dot product of the color and the BT.601 luma coefficients.
    float gray = dot(color.rgb, float3(0.299, 0.587, 0.114));
    // Write the grayscale color to the output texture at the grid position.
    outTexture.write(float4(gray, gray, gray, 1.0), gid);
}

