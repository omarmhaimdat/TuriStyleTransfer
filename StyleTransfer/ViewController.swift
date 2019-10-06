//
//  ViewController.swift
//  StyleTransfer
//
//  Created by M'haimdat omar on 05-10-2019.
//  Copyright © 2019 M'haimdat omar. All rights reserved.
//

import UIKit
import Vision

let screenWidth = UIScreen.main.bounds.width

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var style: Int?
    
    let logo: UIImageView = {
        let image = UIImageView(image: #imageLiteral(resourceName: "default").resized(newSize: CGSize(width: screenWidth, height: screenWidth)))
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    let style_1: BtnPleinLarge = {
        let button = BtnPleinLarge()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(buttonToUploadStyle1(_:)), for: .touchUpInside)
        button.setTitle("Style 1", for: .normal)
        let icon = UIImage(named: "upload")?.resized(newSize: CGSize(width: 50, height: 50))
        button.addRightImage(image: icon!, offset: 30)
        button.backgroundColor = .systemOrange
        button.layer.borderColor = UIColor.systemOrange.cgColor
        button.layer.shadowOpacity = 0.3
        button.layer.shadowColor = UIColor.systemOrange.cgColor
        button.layer.shadowOffset = CGSize(width: 1, height: 5)
        button.layer.cornerRadius = 10
        button.layer.shadowRadius = 8
        button.layer.masksToBounds = true
        button.clipsToBounds = false
        button.contentHorizontalAlignment = .left
        button.layoutIfNeeded()
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 20)
        button.titleEdgeInsets.left = 0
        
        return button
    }()
    
    let style_2: BtnPleinLarge = {
        let button = BtnPleinLarge()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(buttonToUploadStyle2(_:)), for: .touchUpInside)
        button.setTitle("Style 2", for: .normal)
        let icon = UIImage(named: "upload")?.resized(newSize: CGSize(width: 50, height: 50))
        button.addRightImage(image: icon!, offset: 30)
        button.backgroundColor = .systemRed
        button.layer.borderColor = UIColor.systemRed.cgColor
        button.layer.shadowOpacity = 0.3
        button.layer.shadowColor = UIColor.systemRed.cgColor
        button.layer.shadowOffset = CGSize(width: 1, height: 5)
        button.layer.cornerRadius = 10
        button.layer.shadowRadius = 8
        button.layer.masksToBounds = true
        button.clipsToBounds = false
        button.contentHorizontalAlignment = .left
        button.layoutIfNeeded()
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 20)
        button.titleEdgeInsets.left = 0
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = #colorLiteral(red: 0.9693209529, green: 0.9324963689, blue: 0.973600328, alpha: 1)
        
        addSubviews()
        setupLayout()
        
    }
    
    func addSubviews() {
        view.addSubview(logo)
        view.addSubview(style_1)
        view.addSubview(style_2)
    }
    
    func setupLayout() {
        
        logo.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        logo.topAnchor.constraint(equalTo: self.view.safeTopAnchor, constant: 20).isActive = true
        
        style_2.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        style_2.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -120).isActive = true
        style_2.widthAnchor.constraint(equalToConstant: view.frame.width - 40).isActive = true
        style_2.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        style_1.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        style_1.widthAnchor.constraint(equalToConstant: view.frame.width - 40).isActive = true
        style_1.heightAnchor.constraint(equalToConstant: 80).isActive = true
        style_1.bottomAnchor.constraint(equalTo: style_2.topAnchor, constant: -40).isActive = true
        
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            
            let model = MyStyleTransfer_30000()
            
            let numStyles  = 2
            let styleIndex = self.style! - 1
            
            let styleArray = try? MLMultiArray(shape: [numStyles] as [NSNumber], dataType: .double)
            
            for i in 0...((styleArray?.count)!-1) {
                styleArray?[i] = 0.0
            }
            styleArray?[styleIndex] = 1.0
            
            if let image = pixelBuffer(from: pickedImage) {
                do {
                    let predictionOutput = try model.prediction(image: image, index: styleArray!)

                    let ciImage = CIImage(cvPixelBuffer: predictionOutput.stylizedImage)
                    let tempContext = CIContext(options: nil)
                    let tempImage = tempContext.createCGImage(ciImage, from: CGRect(x: 0, y: 0, width: CVPixelBufferGetWidth(predictionOutput.stylizedImage), height: CVPixelBufferGetHeight(predictionOutput.stylizedImage)))
                    let controller = OutputViewController()
                    controller.outputImage.image = UIImage(cgImage: tempImage!)
                    picker.dismiss(animated: true, completion: nil)
                    self.present(controller, animated: true, completion: nil)
                } catch let error as NSError {
                    print("CoreML Model Error: \(error)")
                }
            }
            
        }
            
        picker.dismiss(animated: true, completion: nil)
    }
    
    
    
    @objc func buttonToUploadStyle1(_ sender: BtnPleinLarge) {
        self.style = 1
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    @objc func buttonToUploadStyle2(_ sender: BtnPleinLarge) {
        self.style = 2
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func pixelBuffer(from image: UIImage) -> CVPixelBuffer? {
        
        UIGraphicsBeginImageContextWithOptions(CGSize(width: 1024, height: 1024), true, 2.0)
        image.draw(in: CGRect(x: 0, y: 0, width: 1024, height: 1024))
        _ = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()

        let attrs = [kCVPixelBufferCGImageCompatibilityKey: kCFBooleanTrue, kCVPixelBufferCGBitmapContextCompatibilityKey: kCFBooleanTrue] as CFDictionary
        var pixelBuffer : CVPixelBuffer?
        let status = CVPixelBufferCreate(kCFAllocatorDefault, 1024, 1024, kCVPixelFormatType_32ARGB, attrs, &pixelBuffer)
        guard (status == kCVReturnSuccess) else {
            return nil
        }

        CVPixelBufferLockBaseAddress(pixelBuffer!, CVPixelBufferLockFlags(rawValue: 0))
        let pixelData = CVPixelBufferGetBaseAddress(pixelBuffer!)

        let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
        let context = CGContext(data: pixelData, width: 1024, height: 1024, bitsPerComponent: 8, bytesPerRow: CVPixelBufferGetBytesPerRow(pixelBuffer!), space: rgbColorSpace, bitmapInfo: CGImageAlphaInfo.noneSkipFirst.rawValue)

        context?.translateBy(x: 0, y: 1024)
        context?.scaleBy(x: 1.0, y: -1.0)

        UIGraphicsPushContext(context!)
        image.draw(in: CGRect(x: 0, y: 0, width: 1024, height: 1024))
        UIGraphicsPopContext()
        CVPixelBufferUnlockBaseAddress(pixelBuffer!, CVPixelBufferLockFlags(rawValue: 0))

        return pixelBuffer
    }
    
    
}
