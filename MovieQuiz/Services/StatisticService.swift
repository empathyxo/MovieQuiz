//
//  StatisticService.swift
//  MovieQuiz
//
//  Created by empathyxo on 16.07.2024.
//

import Foundation

final class StatisticService: StatisticServiceProtocol {
    private let storage: UserDefaults = .standard
    private enum Keys: String {
        case gamesCount
        case bestGameCorrect
        case bestGameTotal
        case bestGameDate
        case totalCorrectAnswers
        case totalQuestions
        
    }
    
    var gamesCount: Int {
        get {
            return storage.integer(forKey: Keys.gamesCount.rawValue)
        }
        set{
            storage.set(newValue, forKey: Keys.gamesCount.rawValue)
        }
    }
    
    var bestGame: GameResult {
        get {
            let correct = storage.integer(forKey: Keys.bestGameCorrect.rawValue)
            let total = storage.integer(forKey: Keys.bestGameTotal.rawValue)
            let date = storage.object(forKey: Keys.bestGameDate.rawValue) as? Date ?? Date()
            return GameResult(correct: correct, total: total, date: date)
        }
        set {
            storage.set(newValue.correct, forKey: Keys.bestGameCorrect.rawValue)
            storage.set(newValue.total, forKey: Keys.bestGameTotal.rawValue)
            storage.set(newValue.date, forKey: Keys.bestGameDate.rawValue)
                }
    }
    
    var totalAccuracy: Double {
        get {
            let totalCorrectAnswers = storage.double(forKey: Keys.totalCorrectAnswers.rawValue)
            let totalQuestions = storage.integer(forKey: Keys.totalQuestions.rawValue)
            return totalQuestions == 0 ? 0 : (totalCorrectAnswers / Double(totalQuestions)) * 100
        }
        set {
            storage.set(newValue, forKey: Keys.totalCorrectAnswers.rawValue)
        }
    }
    
    func store(correct count: Int, total amount: Int) {
        // Увеличиваем счетчик игр
        gamesCount += 1
                
        // Обновляем лучший результат, если текущий результат лучше
        let currentGame = GameResult(correct: count, total: amount, date: Date())
        if currentGame.compareResult(new: bestGame) {
        bestGame = currentGame
        }
                
        // Обновляем общую точность
        let previousTotalCorrectAnswers = storage.double(forKey: Keys.totalCorrectAnswers.rawValue)
        let previousTotalQuestions = storage.double(forKey: Keys.totalQuestions.rawValue)
        let newTotalCorrectAnswers = previousTotalCorrectAnswers + Double(count)
        let newTotalQuestions = previousTotalQuestions + Double(amount)
                
        storage.set(newTotalCorrectAnswers, forKey: Keys.totalCorrectAnswers.rawValue)
        storage.set(newTotalQuestions, forKey: Keys.totalQuestions.rawValue)
    }
}
