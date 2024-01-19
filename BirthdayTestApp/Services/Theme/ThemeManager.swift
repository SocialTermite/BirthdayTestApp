//
//  ThemeManager.swift
//  BirthdayTestApp
//
//  Created by Konstantin Bondar on 19.01.2024.
//

import Foundation

protocol ThemeObserver: AnyObject, Hashable {
    func themeChanged(_ theme: Theme)
}

class ThemeManager {
    static let shared = ThemeManager()
    
    private(set) var theme: Theme = .init(rawValue: Int.random(in: 0..<3)) ?? .blue {
        didSet {
            guard theme != oldValue else { return }
            subscribers.forEach {
                ($0 as? any ThemeObserver)?.themeChanged(theme)
            }
        }
    }
    
    private var subscribers: Set<AnyHashable> = []
    
    func subscribe(observer: any ThemeObserver) {
        _ = subscribers.insert(observer)
    }
    
    func unsubscribe(observer: any ThemeObserver) {
        subscribers.remove(observer)
    }
    
    func changeTheme(to theme: Theme) {
        self.theme = theme
    }
    
    private init() { }
}

