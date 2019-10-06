//
//  OutputViewController.swift
//  StyleTransfer
//
//  Created by M'haimdat omar on 05-10-2019.
//  Copyright © 2019 M'haimdat omar. All rights reserved.
//

import UIKit

class OutputViewController: UIViewController {
    
    let outputImage: UIImageView = {
        let image = UIImageView(image: UIImage())
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    let dissmissButton: BtnPleinLarge = {
        let button = BtnPleinLarge()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(buttonToDissmiss(_:)), for: .touchUpInside)
        button.setTitle("Done", for: .normal)
        button.backgroundColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
        button.layer.borderColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1).cgColor
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 0.9693209529, green: 0.9324963689, blue: 0.973600328, alpha: 1)
        addSubviews()
        setupLayout()
    }
    
    func addSubviews() {
        view.addSubview(dissmissButton)
        view.addSubview(outputImage)
    }
    
    func setupLayout() {
        
        dissmissButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        dissmissButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        dissmissButton.widthAnchor.constraint(equalToConstant: view.frame.width - 40).isActive = true
        dissmissButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100).isActive = true
        
        outputImage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        outputImage.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -30).isActive = true
        outputImage.widthAnchor.constraint(equalToConstant: view.frame.width - 50).isActive = true
        
    }
    
    @objc func buttonToDissmiss(_ sender: BtnPleinLarge) {
        self.dismiss(animated: true, completion: nil)
    }
}
