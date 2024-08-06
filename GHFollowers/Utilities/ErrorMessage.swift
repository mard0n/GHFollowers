//
//  ErrorMessage.swift
//  GHFollowers
//
//  Created by Mardon Mashrabov on 06/08/2024.
//

import Foundation

enum ErrorMessage: String, Error {
    case networkError = "Network call failed. Please try again"
    case badResponse = "Bad response. Please try again"
    case noData = "Couldn't find followers. Please try again"
    case noUserFound = "Couldn't find a user with this name"
}
