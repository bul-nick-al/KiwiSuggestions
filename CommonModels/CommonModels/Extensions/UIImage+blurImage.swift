//
//  UIImage+blurImage.swift
//  CommonModels
//
//  Created by Николай Булдаков on 31.05.2021.
//

import UIKit

extension UIImage {
    public func blurImage(radius: Double) -> UIImage? {
        let context = CIContext(options: nil)
        let inputImage = CIImage(image: self)
        let originalOrientation = imageOrientation
        let originalScale = scale

        let filter = CIFilter(name: "CIGaussianBlur")
        filter?.setValue(inputImage, forKey: kCIInputImageKey)
        filter?.setValue(radius, forKey: kCIInputRadiusKey)

        guard
            let outputImage = filter?.outputImage,
            let extent = inputImage?.extent,
            let cgImage = context.createCGImage(outputImage, from: extent)
        else { return nil }

        return UIImage(cgImage: cgImage, scale: originalScale, orientation: originalOrientation)
    }
}
