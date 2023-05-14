//
//  MetalImageProcessing.swift
//  MetalCustomShaders
//
//  Created by Rouzbeh Abadi on 13.05.23.
//

import Metal
import UIKit


/// An enumeration that defines the types of filters that can be applied to an image.
///
/// - grayscale: A filter that converts the color image into grayscale.
/// - derivatives: A filter that applies the derivatives filter to the image. This filter is typically used for edge detection.
/// - none: A case that represents no filter. When this case is used, the original image is returned without any filtering.
enum Filter {
    case grayscale
    case derivatives
    case saturation(factor: Float)
    case none
}

/// `MetalImageProcessing` is a class that encapsulates operations related to image processing using Metal.
class MetalImageProcessing {
    // The shared singleton instance
    static let shared: MetalImageProcessing = {
        do {
            return try MetalImageProcessing()
        } catch {
            fatalError("Failed to initialize MetalImageProcessing: \(error)")
        }
    }()

    // The Metal device
    var device: MTLDevice
    private let commandQueue: MTLCommandQueue

    // Private initializer
    private init() throws {
        guard let device = MTLCreateSystemDefaultDevice(),
              let commandQueue = device.makeCommandQueue() else {
            throw NSError(domain: "MetalError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Metal is not supported on this device"])
        }
        self.device = device
        self.commandQueue = commandQueue
    }
    
}

// MARK: - Image Processing

extension MetalImageProcessing {

    /// Applies the specified filter to an image using Metal.
    ///
    /// This function first retrieves the Metal function for the filter, then prepares the input and output textures.
    /// It then configures and dispatches threads to the GPU to perform the filter operation, and finally converts the output texture back to an image.
    ///
    /// - Parameters:
    ///   - filter: The type of filter to apply.
    ///   - image: The input image.
    ///
    /// - Returns: The output image after applying the filter.
    ///
    /// - Throws: An error if any step of the process fails.
    func apply(filter: Filter, to image: UIImage) throws -> UIImage {
        let functionName: String
        var input: SaturationInput?

        switch filter {
        case .grayscale:
            functionName = "grayscale"
        case .derivatives:
            functionName = "derivatives"
        case .saturation(let factor):
            functionName = "saturationAdjust"
            input = SaturationInput(saturationFactor: factor)
        case .none:
            return image
        }

    

        guard let library = device.makeDefaultLibrary(),
              let function = library.makeFunction(name: functionName),
              let pipelineState = try? device.makeComputePipelineState(function: function) else {
            throw NSError(domain: "MetalError", code: 2, userInfo: [NSLocalizedDescriptionKey: "Failed to create pipeline state"])
        }
        
        guard let cgImage = image.cgImage else {
            throw NSError(domain: "MetalError", code: 3, userInfo: [NSLocalizedDescriptionKey: "Failed to get CGImage from UIImage"])
        }
        
        let orientedImage = UIImage(cgImage: cgImage, scale: image.scale, orientation: image.imageOrientation)
        
        guard let inputTexture = convertToTexture(image: orientedImage) else {
            throw NSError(domain: "MetalError", code: 4, userInfo: [NSLocalizedDescriptionKey: "Failed to convert UIImage to MTLTexture"])
        }
        
        let outputTextureDescriptor = MTLTextureDescriptor.texture2DDescriptor(pixelFormat: .rgba8Unorm, width: inputTexture.width, height: inputTexture.height, mipmapped: false)
        outputTextureDescriptor.usage = [.shaderWrite]
        guard let outputTexture = device.makeTexture(descriptor: outputTextureDescriptor) else {
            throw NSError(domain: "MetalError", code: 5, userInfo: [NSLocalizedDescriptionKey: "Failed to create output MTLTexture"])
        }
        
        guard let commandBuffer = commandQueue.makeCommandBuffer(),
              let commandEncoder = commandBuffer.makeComputeCommandEncoder() else {
            throw NSError(domain: "MetalError", code: 6, userInfo: [NSLocalizedDescriptionKey: "Failed to create command buffer/encoder"])
        }
        
        if let input = input {
              var metalInput = SaturationInput(saturationFactor: input.saturationFactor)
              let inputBuffer = device.makeBuffer(bytes: &metalInput, length: MemoryLayout<SaturationInput>.stride, options: [])
              commandEncoder.setBuffer(inputBuffer, offset: 0, index: 0)
          }
        
        commandEncoder.setComputePipelineState(pipelineState)
        commandEncoder.setTexture(inputTexture, index: 0)
        commandEncoder.setTexture(outputTexture, index: 1)
        let threadGroupCount = MTLSizeMake(8, 8, 1)
        let threadGroups = MTLSizeMake((inputTexture.width + threadGroupCount.width - 1) / threadGroupCount.width,
                                       (inputTexture.height + threadGroupCount.height - 1) / threadGroupCount.height,
                                       1)
        
        commandEncoder.dispatchThreadgroups(threadGroups, threadsPerThreadgroup: threadGroupCount)
        commandEncoder.endEncoding()
        commandBuffer.commit()
        commandBuffer.waitUntilCompleted()

        guard let outputImage = convertToImage(texture: outputTexture) else {
            throw NSError(domain: "MetalError", code: 7, userInfo: [NSLocalizedDescriptionKey: "Failed to convert MTLTexture to UIImage"])
        }
        
        guard let finalCgImage = outputImage.cgImage else {
            throw NSError(domain: "MetalError", code: 8, userInfo: [NSLocalizedDescriptionKey: "Failed to get CGImage from output UIImage"])
        }
        
        let finalImage = UIImage(cgImage: finalCgImage, scale: outputImage.scale, orientation: image.imageOrientation)
        
        return finalImage
    }

}



// MARK: - Image Conversion

extension MetalImageProcessing {
    
    /// Converts a UIImage to a Metal texture.
    ///
    /// - Parameter image: The UIImage to be converted.
    /// - Returns: The Metal texture representation of the image.
    private func convertToTexture(image: UIImage) -> MTLTexture? {
        guard let cgImage = image.cgImage else {
            return nil
        }

        let width = cgImage.width
        let height = cgImage.height

        let bytesPerPixel = 4
        let bytesPerRow = bytesPerPixel * width

        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo.byteOrder32Big.rawValue | CGImageAlphaInfo.premultipliedLast.rawValue
        let context = CGContext(data: nil, width: width, height: height, bitsPerComponent: 8, bytesPerRow: bytesPerRow, space: colorSpace, bitmapInfo: bitmapInfo)

        context?.draw(cgImage, in: CGRect(x: 0, y: 0, width: width, height: height))

        guard let data = context?.data else {
            return nil
        }

        let textureDescriptor = MTLTextureDescriptor.texture2DDescriptor(pixelFormat: .rgba8Unorm, width: width, height: height, mipmapped: false)
        let texture = device.makeTexture(descriptor: textureDescriptor)

        let region = MTLRegionMake2D(0, 0, width, height)
        texture?.replace(region: region, mipmapLevel: 0, withBytes: data, bytesPerRow: bytesPerRow)

        return texture
    }

    /// Converts a Metal texture to a UIImage.
    ///
    /// - Parameter texture: The Metal texture to be converted.
    /// - Returns: The UIImage representation of the texture.
    private func convertToImage(texture: MTLTexture) -> UIImage? {
        let width = texture.width
        let height = texture.height

        let bytesPerPixel = 4
        let bytesPerRow = bytesPerPixel * width

        let totalBytes = bytesPerRow * height

        var pixelData = [UInt8](repeating: 0, count: totalBytes)

        let region = MTLRegionMake2D(0, 0, width, height)
        texture.getBytes(&pixelData, bytesPerRow: bytesPerRow, from: region, mipmapLevel: 0)

        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo.byteOrder32Big.rawValue | CGImageAlphaInfo.premultipliedLast.rawValue
        let context = CGContext(data: &pixelData, width: width, height: height, bitsPerComponent: 8, bytesPerRow: bytesPerRow, space: colorSpace, bitmapInfo: bitmapInfo)

        guard let cgImage = context?.makeImage() else {
            return nil
        }

        let image = UIImage(cgImage: cgImage)
        return image
    }

}

