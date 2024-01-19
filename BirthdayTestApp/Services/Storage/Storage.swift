//
//  Storage.swift
//  BirthdayTestApp
//
//  Created by Konstantin Bondar on 19.01.2024.
//

import Foundation

protocol Storage {
    func store(child: Child)
    func retrieveChild() -> Child?
}
