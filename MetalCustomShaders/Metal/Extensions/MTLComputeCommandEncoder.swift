//
//  MTLComputeCommandEncoder.swift
//  MetalCustomShaders
//
//  Created by Rouzbeh Abadi on 13.05.23.
//

import Metal

extension MTLComputeCommandEncoder {

    /// Configures and dispatches a compute pipeline state with input and output textures, thread group count, and thread groups.
    ///
    /// - Parameters:
    ///   - pipelineState: The compute pipeline state to set.
    ///   - inputTexture: The input texture to set at index 0.
    ///   - outputTexture: The output texture to set at index 1.
    ///   - threadGroupCount: The thread group count.
    ///   - threadGroups: The thread groups.
    func dispatchComputePipelineState(pipelineState: MTLComputePipelineState,
                                      inputTexture: MTLTexture,
                                      outputTexture: MTLTexture,
                                      threadGroupCount: MTLSize,
                                      threadGroups: MTLSize) {
        setComputePipelineState(pipelineState)
        setTexture(inputTexture, index: 0)
        setTexture(outputTexture, index: 1)
        dispatchThreadgroups(threadGroups, threadsPerThreadgroup: threadGroupCount)
    }
}
