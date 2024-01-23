//
//  PortraitView.swift
//  BirthdayTestApp
//
//  Created by Konstantin Bondar on 19.01.2024.
//

import UIKit

protocol PortraitViewDelegate: AnyObject {
    func changePortraitPressed()
}

final class PortraitView: UIView {
    
    private let circleLayer = CAShapeLayer()
    private let changePortraitButton = UIButton(type: .custom)
    private let placeholderImageView = UIImageView()
    private let portraitImageView = UIImageView()
    
    weak var delegate: PortraitViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    func updatePortrait(to image: UIImage) {
        portraitImageView.image = image
    }
    
    private func setupView() {
        setupCircle()
        setupPlaceholder()
        setupPortrait()
        setupButton()
        
        let theme = ThemeManager.shared.theme
        updateColors(with: theme)
        updateImages(with: theme)
    }
    
    private func setupPlaceholder() {
        placeholderImageView.image = ThemeManager.shared.theme.portraitPlaceholderImage
        placeholderImageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(placeholderImageView)
        
        NSLayoutConstraint.activate([
            placeholderImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            placeholderImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            placeholderImageView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.5),
            placeholderImageView.heightAnchor.constraint(equalTo: placeholderImageView.widthAnchor) 
        ])
    }
    
    private func setupPortrait() {
        portraitImageView.clipsToBounds = true
        addSubview(portraitImageView)
    }
    
    private func setupCircle() {
        let path = UIBezierPath(ovalIn: bounds)
        
        circleLayer.path = path.cgPath
        circleLayer.lineWidth = Constants.Numbers.portraitBorderWidth
        
        
        layer.addSublayer(circleLayer)
    }
    
    private func setupButton() {
        changePortraitButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        
        addSubview(changePortraitButton)
    }
    
    @objc private func buttonTapped() {
        delegate?.changePortraitPressed()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let angleInRadians = CGFloat.pi * Constants.Numbers.changePortraitButtonPositionAngle / 180.0
        let radius = min(bounds.width, bounds.height) / 2
        
        let buttonCenterX = bounds.width / 2 + radius * cos(angleInRadians)
        let buttonCenterY = bounds.height / 2 - radius * sin(angleInRadians)
        
        let buttonSize: CGFloat = Constants.Numbers.changePortraitButtonSize
        changePortraitButton.frame = CGRect(x: buttonCenterX - buttonSize / 2,
                                            y: buttonCenterY - buttonSize / 2,
                                            width: buttonSize,
                                            height: buttonSize)
        
        portraitImageView.layer.cornerRadius = bounds.width / 2
        let borderHalfSize = Constants.Numbers.portraitBorderWidth / 2.0
        portraitImageView.frame = .init(x: bounds.minX + borderHalfSize / 2 , y: bounds.minY + borderHalfSize / 2,
                                        width: bounds.width - borderHalfSize, height: bounds.height - borderHalfSize)
    }
    
    private func updateColors(with theme: Theme) {
        circleLayer.strokeColor = theme.dark.cgColor
        circleLayer.fillColor = theme.light.cgColor
    }
    
    private func updateImages(with theme: Theme) {
        changePortraitButton.setImage(theme.addImage, for: .normal)
        placeholderImageView.image = theme.portraitPlaceholderImage
    }
}

extension PortraitView: ThemeObserver {
    func themeChanged(_ theme: Theme) {
        updateColors(with: theme)
    }
}
