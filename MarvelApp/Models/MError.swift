//
//  MError.swift
//  MarvelApp
//
//  Created by zeyad on 1/27/21.
//  Copyright © 2021 zeyad. All rights reserved.
//

import Foundation

import Foundation

enum MError: String , Error {
    case invalidURL = "This URL created an invalid request."
    case connectionError = "Unable to complete your request. Check your internet connection."
    case invalidResponse = "Invalid response from the server. Please try again."
    case invalidDate = "The data received from the server is invalid. Please try again."
    case decodeError = "Unable to decode the data received from the server. Please try again."
    case updateFail = "Unable to update favorites."
}
