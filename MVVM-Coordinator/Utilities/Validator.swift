//
//  Validator.swift
//  MVVM-Coordinator
//
//  Created by ha.van.duc on 1/17/19.
//  Copyright © 2019 ha.van.duc. All rights reserved.
//

import Foundation
import UIKit

extension String {
    func trimed() -> Bool {
        return self.trimmingCharacters(in: .whitespaces).isEmpty
    }

    var isEmail: Bool {
        let regex = "[a-zA-Z0-9_#!$%&`*+-{|}~^/=?.]+@[a-zA-Z0-9]+(\\.[a-zA-Z0-9.-]+)*\\.[a-zA-Z0-9]+"
        return self.matchesRegex(withRegex: regex)
    }

    var isPassword: Bool {
        let regex = "[a-zA-Z0-9]+"
        return self.matchesRegex(withRegex: regex)
    }

    func isNickName() -> Bool {
        let regex = "[^\\p{In_Miscellaneous_Symbols_and_Pictographs}\\p{In_Emoticons}\\s　]+"
        return self.matchesRegex(withRegex: regex)
    }

    private func matchesRegex(withRegex regex: String) -> Bool {
        do {
            let regex = try NSRegularExpression(pattern: regex)
            let results = regex.rangeOfFirstMatch(in: self, range: NSRange(self.startIndex..., in: self))
            return results.location == 0 && results.length == self.count
        } catch {
            return false
        }
    }

    func trimMaxCount(max: Int) -> String {
        if self.count > max {
            let index = self.index(self.startIndex, offsetBy: max)
            let result = self[..<index]
            return result + "..."
        }
        return self
    }
}


enum ValidationResult {
    case success
    case failed(String)
    case empty

    var isValid: Bool {
        switch self {
        case .success:
            return true
        default:
            return false
        }
    }

    var description: String {
        switch self {
        case .success, .empty:
            return ""
        case .failed(let stringError):
            return stringError
        }
    }
}

struct Validator {
    static func isValidEmail(email: String) -> ValidationResult {
        if email.isEmpty {
            return .empty
        } else if email.isEmail {
            return .success
        } else {
            let errorString = "Not valid email"
            return .failed(errorString)
        }
    }

    static func isValidPassword(password: String) -> ValidationResult {
        if password.isEmpty {
            return .empty
        } else if password.isPassword {
            return .success
        } else {
            let errorString = "Not valid password"
            return .failed(errorString)
        }
    }
}
