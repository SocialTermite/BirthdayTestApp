//
//  UserDefaultStorage.swift
//  BirthdayTestApp
//
//  Created by Konstantin Bondar on 19.01.2024.
//

import Foundation


class UserDefaultStorage: Storage {
    private let childKey = "child_key"
    private let userDefaults = UserDefaults.standard
    
    private var child: Child?
    
    init() {
        child = retrieveChild() ?? .init(name: "Cristiano Ronaldo", birthday: Date(timeIntervalSince1970: 1618605464), image: nil)
    }
    
    func store(child: Child) {
        self.child = child
        if let data = try? JSONEncoder().encode(child) {
            userDefaults.set(data, forKey: childKey)
        }
    }
    
    func retrieveChild() -> Child? {
        guard let storedData = userDefaults.data(forKey: childKey),
              let loadedChild = try? JSONDecoder().decode(Child.self, from: storedData) else {
            return nil
        }
        return loadedChild
    }
    
    func clearAll() {
        userDefaults.removeObject(forKey: childKey)
    }
}
