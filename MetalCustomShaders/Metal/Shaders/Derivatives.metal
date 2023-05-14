//
//  Derivatives.metal
//  MetalCustomShaders
//
//  Created by Rouzbeh Abadi on 13.05.23.
//

#include <metal_stdlib>
using namespace metal;

kernel void derivatives(texture2d<half, access::read>  inTexture  [[ texture(0) ]],
                                 texture2d<half, access::write> outTexture [[ texture(1) ]],
                                 uint2                          gid        [[ thread_position_in_grid ]]) {
    constexpr int kernel_size = 3;
    constexpr int radius = kernel_size / 2;
    const int width = inTexture.get_width();
    const int height = inTexture.get_height();

    if (static_cast<int>(gid.x) < radius || static_cast<int>(gid.x) >= width - radius ||
        static_cast<int>(gid.y) < radius || static_cast<int>(gid.y) >= height - radius) {
        return;
    }
    
    half3x3 horizontal_kernel = half3x3(0, 0, 0,
                                        -1, 0, 1,
                                        0, 0, 0);
    half3x3 vertical_kernel = half3x3(0, -1, 0,
                                      0, 0, 0,
                                      0, 1, 0);
    
    half3 result_horizontal(0,0,0);
    half3 result_vertical(0,0,0);
    for(int j = 0; j <= kernel_size - 1; j++) {
        for(int i = 0; i <= kernel_size - 1; i++) {
            uint2 texture_index(gid.x + (i - radius), gid.y + (j - radius));
            result_horizontal += horizontal_kernel[i][j] * inTexture.read(texture_index).rgb;
            result_vertical += vertical_kernel[i][j] * inTexture.read(texture_index).rgb;
        }
    }
    
    half3 bt601 = half3(0.299, 0.587, 0.114);
    half gray_horizontal = dot(result_horizontal.rgb, bt601);
    half gray_vertical = dot(result_vertical.rgb, bt601);
    half magnitude = length(half2(gray_horizontal, gray_vertical));
    
    outTexture.write(half4(half3(magnitude), 1), gid);
}





