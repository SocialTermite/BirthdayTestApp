//
//  ChildInputViewModel.swift
//  BirthdayTestApp
//
//  Created by Konstantin Bondar on 20.01.2024.
//

import UIKit

class ChildInputViewModel {
    let storage: Storage
    
    private lazy var name: String? = self.child?.name {
        didSet {
            guard name != oldValue else { return }
            tryToStoreChild()
        }
    }
    private lazy var birthday: Date? = child?.birthday  {
        didSet {
            guard birthday != oldValue else { return }
            tryToStoreChild()
        }
    }
    
    private lazy var portrait: UIImage? = child?.image  {
        didSet { tryToStoreChild() } }
    
    private lazy var child: Child? = storage.retrieveChild() {
        didSet {
            guard let child, child != oldValue else { return }
            storage.store(child: child)
        }
    }
    
    private func tryToStoreChild() {
        guard let name, let birthday else {
            updateUI?(false)
            return
        }
        
        child = .init(name: name, birthday: birthday, image: portrait)
        updateUI?(true)
    }
    
    var isChildInfoIsFullFiled: Bool {
        return (name != nil) && (birthday != nil)
    }
    
    var updateUI: ((Bool) -> Void)?
    
    init(storage: Storage) {
        self.storage = storage
    }
    
    var childName: String? {
        name
    }
    
    var childBirthday: Date? {
        birthday
    }
    
    var childPortrait: UIImage? {
        portrait
    }
    
    func refresh() {
        child = storage.retrieveChild()
        portrait = child?.image ?? portrait
        name = child?.name ?? name
        birthday = child?.birthday ?? birthday
    }
    
    func changeName(to name: String) {
        self.name = name
    }
    
    func changeBirthday(to date: Date) {
        self.birthday = date
    }
    
    func changePortrait(to image: UIImage) {
        self.portrait = image
    }
    
    func clearAll() {
        name = nil
        birthday = nil
        portrait = nil
        storage.clearAll()
        child = nil
        updateUI?(false)
    }
}
