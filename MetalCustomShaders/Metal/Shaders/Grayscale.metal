//
//  Grayscale.metal
//  MetalCustomShaders
//
//  Created by Rouzbeh Abadi on 13.05.23.
//

#include <metal_stdlib>
using namespace metal;

kernel void grayscale(texture2d<float, access::read> inTexture [[texture(0)]],
                      texture2d<float, access::write> outTexture [[texture(1)]],
                      uint2 gid [[thread_position_in_grid]]) {
    float4 color = inTexture.read(gid);
    float gray = dot(color.rgb, float3(0.299, 0.587, 0.114));
    outTexture.write(float4(gray, gray, gray, 1.0), gid);
}
