//
//  MovieQuizPresenter.swift
//  MovieQuiz
//
//  Created by empathyxo on 23.07.2024.
//

import UIKit

final class MovieQuizPresenter: QuestionFactoryDelegate {
    
    let questionsAmount: Int = 10
    private var currentQuestionIndex: Int = 0
    var correctAnswers: Int = 0
    var currentQuestion: QuizQuestion?
    private var questionFactory: QuestionFactoryProtocol?
    private var statisticService: StatisticServiceProtocol = StatisticService()
    private weak var viewController: MovieQuizViewController?
    
    init (viewController: MovieQuizViewController){
        self.viewController = viewController
        questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
        questionFactory?.loadData()
        viewController.showLoadingIndicator()
    }
    func didLoadDataFromServer() {
        viewController?.hideLoadingIndicator()
        questionFactory?.requestNextQuestion()
    }

    func didFailToLoadData(with error: Error) {
        viewController?.showNetworkError(message: error.localizedDescription)
    }
    
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question = question else {return}
        currentQuestion = question
        let viewModel = convert(model: question)
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.show(quizstep: viewModel)
        }
    }
    
    private let dateFormatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateFormat = "dd.MM.yyyy HH:mm"
            return formatter
        }()
    
    //конвертируем viewmodel вопросов во viewmodel экрана
    func convert(model: QuizQuestion) -> QuizStepViewModel {
        return QuizStepViewModel(image: UIImage(data: model.image) ?? UIImage(), question: model.text, questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
    }
    
    func isLastQuestion() -> Bool {
        currentQuestionIndex == questionsAmount - 1
    }
        
    func restartGame() {
        currentQuestionIndex = 0
        correctAnswers = 0
        questionFactory?.requestNextQuestion()
    }
        
    func switchToNextQuestion() {
        currentQuestionIndex += 1
    }
    func didAnswer(isCorrectAnswer: Bool){
        correctAnswers += 1
    }
    
    private func didAnswer(isYes: Bool) {
        guard let currentQuestion = currentQuestion else {return}
        let givenAnswer = isYes
        viewController?.showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    //реализация нажатия кнопки ДА
    func yesButtonTouched() {
        didAnswer(isYes: true)
    }
    //реализация нажатия кнопки НЕТ
    func noButtonTouched() {
        didAnswer(isYes: false)
    }
    
    //функция для определения конца игры или переключения вопроса
    func showNextQuestionOrResults() {
        if self.isLastQuestion() {
            statisticService.store(correct: correctAnswers, total: questionsAmount)
            let bestGame = statisticService.bestGame
            let formattedDate = dateFormatter.string(from: bestGame.date)
            let result = QuizResultsViewModel(title: "Этот раунд завершен!", text: "Ваш результат: \(correctAnswers)/\(questionsAmount)\nКоличество сыгранных квизов: \(statisticService.gamesCount)\nРекорд: \(bestGame.correct)/\(bestGame.total) (\(formattedDate))\nСредняя точность: \(String(format: "%.2f", statisticService.totalAccuracy))%", buttonText: "Сыграть еще раз")
            viewController?.show(quizresult: result)
        } else {
            self.switchToNextQuestion()
            questionFactory?.requestNextQuestion()
        }
    }
}
