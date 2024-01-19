//
//  String+Extensions.swift
//  BirthdayTestApp
//
//  Created by Konstantin Bondar on 19.01.2024.
//

import Foundation

extension String {
    var localized: String {
        NSLocalizedString(self, comment: "")
    }
}
