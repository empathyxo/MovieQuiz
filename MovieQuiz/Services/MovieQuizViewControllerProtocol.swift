//
//  MovieQuizViewControllerProtocol.swift
//  MovieQuiz
//
//  Created by empathyxo on 24.07.2024.
//

import Foundation

protocol MovieQuizViewControllerProtocol: AnyObject {
    func show(quizstep: QuizStepViewModel)
    func show(quizresult: QuizResultsViewModel)
    
    func highlightImageBorder(isCorrectAnswer: Bool)
    func resetImageBorder()
    
    func showLoadingIndicator()
    func hideLoadingIndicator()
    
    func showNetworkError(message: String)
    
    func changeStateButton(isEnabled: Bool)
}
