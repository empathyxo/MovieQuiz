//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by empathyxo on 07.07.2024.
//

import Foundation

protocol QuestionFactoryDelegate: AnyObject {
    func didReceiveNextQuestion(question: QuizQuestion?)
}
