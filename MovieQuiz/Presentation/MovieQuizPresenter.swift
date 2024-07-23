//
//  MovieQuizPresenter.swift
//  MovieQuiz
//
//  Created by empathyxo on 23.07.2024.
//

import UIKit

final class MovieQuizPresenter {
    
    let questionsAmount: Int = 10
    private var currentQuestionIndex: Int = 0
    
    //конвертируем viewmodel вопросов во viewmodel экрана
    func convert(model: QuizQuestion) -> QuizStepViewModel {
        return QuizStepViewModel(image: UIImage(data: model.image) ?? UIImage(), question: model.text, questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
    }
    
    func isLastQuestion() -> Bool {
        currentQuestionIndex == questionsAmount - 1
    }
        
    func resetQuestionIndex() {
        currentQuestionIndex = 0
    }
        
    func switchToNextQuestion() {
        currentQuestionIndex += 1
    }
}
