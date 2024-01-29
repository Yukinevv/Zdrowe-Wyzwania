//
//  CustomError.swift
//  FitnessApp
//
//  Created by Adrian Rodzic on 01/05/2023.
//

import Foundation

enum CustomError: LocalizedError {
    case auth(description: String)
    case `default`(description: String? = nil)

    // Opis bledu
    var errorDescription: String? {
        switch self {
        case let .auth(description):
            return description
        case let .default(description):
            return description ?? "Coś poszło nie tak"
        }
    }
}
