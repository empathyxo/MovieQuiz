//
//  GameResult.swift
//  MovieQuiz
//
//  Created by empathyxo on 16.07.2024.
//

import Foundation

struct GameResult {
    let correct: Int
    let total: Int
    let date: Date
    func compareResult(new:GameResult) -> Bool {
        correct > new.correct
    }
}
