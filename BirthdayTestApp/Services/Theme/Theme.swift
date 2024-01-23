//
//  Theme.swift
//  BirthdayTestApp
//
//  Created by Konstantin Bondar on 19.01.2024.
//

import UIKit

enum Theme: Int {
    case blue
    case yellow
    case green
    
    var light: UIColor {
        switch self {
        case .blue:
            return .blueLight
        case .yellow:
            return .yellowLight
        case .green:
            return .greenLight
        }
    }
    
    var dark: UIColor {
        switch self {
        case .blue:
            return .blueDark
        case .yellow:
            return .yellowDark
        case .green:
            return .greenDark
        }
    }
    
    var addImage: UIImage {
        switch self {
        case .blue:
            return .cameraIconBlue
        case .yellow:
            return .cameraIconYellow
        case .green:
            return .cameraIconGreen
        }
    }
    
    var portraitPlaceholderImage: UIImage {
        switch self {
        case .blue:
            return .placeholderImageBlue
        case .yellow:
            return .placeholderImageYellow
        case .green:
            return .placeholderImageGreen
        }
    }
    
    var fullPortraitPlaceholderImage: UIImage {
        switch self {
        case .blue:
            return .fullPlaceholderImageBlue
        case .yellow:
            return .fullPlaceholderImageYellow
        case .green:
            return .fullPlaceholderImageGreen
        }
    }
    
    var foregroundImage: UIImage {
        switch self {
        case .blue:
            return .foregroundBlue
        case .yellow:
            return .foregroundYellow
        case .green:
            return .foregroundGreen
        }
    }
    
    static let text = UIColor.mainText
}
