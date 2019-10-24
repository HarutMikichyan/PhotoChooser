//
//  PhotoChooserCollectionViewCell.swift
//  PhotoChooser
//
//  Created by Harut Mikichyan on 10/21/19.
//  Copyright © 2019 Harut Mikichyan. All rights reserved.
//

import UIKit

class PhotoChooserCollectionViewCell: UICollectionViewCell {
    static let id = "imagesCellId"
    
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 12
        return iv
    }()
    
    private let checkMarkImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "checkMark")
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(imageView)
        imageViewAddAutoLayout()
        addSubview(checkMarkImageView)
        checkMarkAddAutoLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func changeCheckMarkStatus(isSelected: Bool) {
        checkMarkImageView.isHidden = isSelected
    }
    
    private func imageViewAddAutoLayout() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        imageView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        imageView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
    }
    
    private func checkMarkAddAutoLayout() {
        checkMarkImageView.translatesAutoresizingMaskIntoConstraints = false
        
        checkMarkImageView.widthAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: 1/3).isActive = true
        checkMarkImageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: 1/3).isActive = true
        checkMarkImageView.trailingAnchor.constraint(equalTo: imageView.trailingAnchor).isActive = true
        checkMarkImageView.topAnchor.constraint(equalTo: imageView.topAnchor).isActive = true
    }
}
