//
//  AlertModel.swift
//  MovieQuiz
//
//  Created by empathyxo on 07.07.2024.
//

import Foundation

struct AlertModel {
    let title: String
    let message: String
    let buttonText: String
    let completion: (() -> Void)?
}
