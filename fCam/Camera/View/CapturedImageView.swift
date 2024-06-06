//
//  CapturedImageView.swift
//  fCam
//
//  Created by Muhammad M. Munir on 18/11/23.
//

import UIKit
import SwiftUI

final class CapturedImageViewWrapper: UIView {
    var image: UIImage? {
        didSet {
            guard let image = image else { return }
            imageView.image = image
        }
    }
    
    private let imageView : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 8
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView(){
        translatesAutoresizingMaskIntoConstraints = false
        addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor, constant: 2),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 2),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -2),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -2),
            imageView.widthAnchor.constraint(equalToConstant: 50),
            imageView.heightAnchor.constraint(equalToConstant: 50),
        ])
    }
}

struct CapturedImageView: UIViewRepresentable {
    typealias UIViewType = CapturedImageViewWrapper
    
    @Binding var uiImage: UIImage?
    
    func makeUIView(context: Context) -> CapturedImageViewWrapper {
        let imageView = CapturedImageViewWrapper()
        imageView.image = uiImage
        return imageView
    }
    
    func updateUIView(
        _ uiView: CapturedImageViewWrapper,
        context: Context
    ) {
        uiView.image = uiImage
    }
}
