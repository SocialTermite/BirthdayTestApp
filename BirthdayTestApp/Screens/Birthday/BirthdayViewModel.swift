//
//  BirthdayViewModel.swift
//  BirthdayTestApp
//
//  Created by Konstantin Bondar on 19.01.2024.
//

import Foundation

// better to create a protocol but for now it's ok to use direct class.
class BirthdayViewModel {
    private let storage: Storage
    
    var updateUI: (() -> Void)?

    private var child: Child {
        didSet {
            storage.store(child: child)
            updateUI?()
        }
    }
    
    init(storage: Storage) {
        self.storage = storage
        if let child = storage.retrieveChild() {
            self.child = child
        } else {
            assertionFailure("storage empty")
            self.child = .init(name: "", birthday: Date(), image: nil)
        }
    }
    
    var title: String {
        return ("Today".localized + " \(child.name) " + "is".localized).uppercased()
    }
    
    var dateRepresentation: (item: String, count: Int) {
        let currentDate = Date()
        let calendar = Calendar.current
    
        let difference = calendar.dateComponents([.year, .month], from: child.birthday, to: currentDate)
        if let years = difference.year, let months = difference.month {
            if years > 0 {
                return ("\(years == 1 ? "year".localized : "years".localized)", years)
            } else if months >= 0 {
                return ("\(months <= 1 ? "month".localized : "months".localized)", months)
            }
        }
        return ("", 0)    }
    
    var portrait: UIImage? {
        child.image
    }
    
    func changePortrait(to image: UIImage) {
        child = .init(name: child.name, birthday: child.birthday, image: image)
    }
    
    func loadChild() {
        updateUI?()
    }
    
    func numberImage(number: Int) -> UIImage {
        let map: [Int: UIImage] = [
            0: ._0,
            1: ._1,
            2: ._2,
            3: ._3,
            4: ._4,
            5: ._5,
            6: ._6,
            7: ._7,
            8: ._8,
            9: ._9,
            10: ._10,
            11: ._11,
            12: ._12,
        ]
        return map[number] ?? ._0
    }

}
