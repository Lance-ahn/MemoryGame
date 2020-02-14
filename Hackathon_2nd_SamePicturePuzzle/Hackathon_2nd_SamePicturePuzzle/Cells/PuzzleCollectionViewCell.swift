//
//  PuzzleCollectionViewCell.swift
//  puzzle
//
//  Created by macbook on 2020/01/31.
//  Copyright © 2020 Lance. All rights reserved.
//

import UIKit

class PuzzleCollectionViewCell: UICollectionViewCell {
    
    private let imageView = UIImageView()
    static let identifier = "PuzzleCollectionViewCell"
    override var isSelected: Bool {
        didSet {
            if isSelected {
                openAnimate()
                print("셀 선택 여부: \(isSelected)")
            } else {
                closeAnimate()
                print("셀 선택 여부: \(isSelected)")
            }
        }
    }
    
//    var imageName = ""
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    func openAnimate() {
        UIView.transition(with: self, duration: 0.3, options: .transitionFlipFromLeft, animations: nil, completion: nil)
    }
    
    func closeAnimate() {
        UIView.transition(with: self, duration: 0.3, options: .transitionFlipFromRight, animations: nil, completion: nil)
    }
    
//    func imageInfo(imageName: String) {
//        self.imageName = imageName
//        cardImage.image = UIImage(named: imageName)
//    }
    
    func configure(image: String) {
        imageView.image = UIImage(named: image)
    }
    
    private func setupUI() {
        configure(image: "back")
        [imageView].forEach {
            contentView.addSubview($0)
        }
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
        
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
