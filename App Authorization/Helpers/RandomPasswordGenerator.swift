//
//  RandomPasswordGenerator.swift
//  App Authorization
//
//  Created by Mike on 12/19/18.
//  Copyright © 2018 William Nau. All rights reserved.
//

import Foundation

/**
 * Get a random password to suggest to the user.
 * If no rules are specified, the password is generated
 */
public class RandomPasswordGenerator {
    private var minLength: Int!
    private var maxLength: Int!
    private var acceptedCharacters: String!
    private var uppercase: Int?
    private var lowercase: Int?
    private var numeric: Int?
    private var specialCharacter: Int?
    
    private let RUNTIME_ERROR_LESS_THAN_ZERO = "Enter a positive number above zero, nil, or exclude from RandomPasswordGenerator init."
    private let RUNTIME_ERROR_MORE_THAN_MIN_LENGTH = "Enter a positive number less than the minimum password length, nil, or exclude from RandomPasswordGenerator init."
    
    init(minLength: Int, maxLength: Int, acceptedCharacters: String, uppercase: Int? = nil, lowercase: Int? = nil, numeric: Int? = nil, specialCharacter: Int? = nil) throws {
        self.minLength = minLength
        self.maxLength = maxLength
        self.acceptedCharacters = acceptedCharacters
        var ruleCount = 0
        if let upper = uppercase {
            if let message = checkRulesForErrors(rule: upper, ruleID: "UPPERCASE") {
                throw RuntimeError(message)
            } else {
                self.uppercase = upper
                ruleCount = upper
            }
        }
        if let lower = lowercase {
            if let message = checkRulesForErrors(rule: lower, ruleID: "LOWERCASE") {
                throw RuntimeError(message)
            } else {
                self.lowercase = lower
                ruleCount += lower
            }
        }
        if let num = numeric {
            if let message = checkRulesForErrors(rule: num, ruleID: "MUNERIC") {
                throw RuntimeError(message)
            } else {
                self.numeric = num
                ruleCount += num
            }
        }
        if let special = specialCharacter {
            if let message = checkRulesForErrors(rule: special, ruleID: "SPECIAL CHARACTER") {
                throw RuntimeError(message)
            } else {
                self.specialCharacter = special
                ruleCount += special
            }
        }
        if ruleCount > minLength {
            throw RuntimeError("RULE COUNT: Rules exceed the minimum length of your password.")
        }
    }
    
    public func getPassword() -> String {
        let length = Int.random(in: minLength...maxLength)
        let password = String((0...length).compactMap{ _ in acceptedCharacters.randomElement() })
        if let _ = uppercase {
            let _ = test(regEx: ".*[A-Z]+.*", with: password)
        }
        if let _ = lowercase {
            let _ = test(regEx: ".*[a-z]+.*", with: password)
        }
        if let _ = numeric {
            let _ = test(regEx: ".*[0-9]+.*", with: password)
        }
        if let _ = specialCharacter {
            let _ = test(regEx: ".*[!@#$%^&*_]+.*", with: password)
        }
        return password
    }
    
    private func test(regEx: String, with field: String) -> String? {
        let texttest = NSPredicate(format:"SELF MATCHES %@", regEx)
        guard texttest.evaluate(with: field) else { return getPassword() }
        return nil
    }
    
    private func checkRulesForErrors(rule: Int, ruleID: String) -> String? {
        if rule < 0 {
            return "\(ruleID): \(RUNTIME_ERROR_LESS_THAN_ZERO)"
        } else if rule > minLength {
            return "\(ruleID): \(RUNTIME_ERROR_MORE_THAN_MIN_LENGTH)"
        }
        return nil
    }
}

struct RuntimeError: Error {
    let message: String
    
    init(_ message: String) {
        self.message = message
    }
    
    public var localizedDescription: String {
        return message
    }
}
