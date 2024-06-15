import UIKit

final class MovieQuizViewController: UIViewController {
    @IBOutlet private weak var previewImage: UIImageView!
    @IBOutlet private weak var indexLabel: UILabel!
    @IBOutlet private weak var questionLabel: UILabel!
    
private var currentQuestionIndex = 0
private var correctAnswers = 0
//viewmodel для вопросов
private struct QuizQuestion {
    let image: String
    let text: String
    let correctAnswer: Bool
}
// создаем массив с mock-данными
private let questions: [QuizQuestion] = [
    QuizQuestion(image: "The Godfather", text: "Рейтинг этого фильма больше, чем 6?", correctAnswer: true),
    QuizQuestion(image: "The Dark Knight", text: "Рейтинг этого фильма больше, чем 6?", correctAnswer: true),
    QuizQuestion(image: "Kill Bill", text: "Рейтинг этого фильма больше, чем 6?", correctAnswer: true),
    QuizQuestion(image: "The Avengers", text: "Рейтинг этого фильма больше, чем 6?", correctAnswer: true),
    QuizQuestion(image: "Deadpool", text: "Рейтинг этого фильма больше, чем 6?", correctAnswer: true),
    QuizQuestion(image: "The Green Knight", text: "Рейтинг этого фильма больше, чем 6?", correctAnswer: true),
    QuizQuestion(image: "Old", text: "Рейтинг этого фильма больше, чем 6?", correctAnswer: false),
    QuizQuestion(image: "The Ice Age Adventures of Buck Wild", text: "Рейтинг этого фильма больше, чем 6?", correctAnswer: false),
    QuizQuestion(image: "Tesla", text: "Рейтинг этого фильма больше, чем 6?", correctAnswer: false),
    QuizQuestion(image: "Vivarium", text: "Рейтинг этого фильма больше, чем 6?", correctAnswer: false)
]
//viewmodel для экрана
private struct QuizStepViewModel {
    let image: UIImage
    let question: String
    let questionNumber: String
}
//viewmodel для алерта с результатом
private struct QuizResultsViewModel {
  let title: String
  let text: String
  let buttonText: String
}
//конвертируем viewmodel вопросов во viewmodel экрана
private func convert(model: QuizQuestion) -> QuizStepViewModel {
    let questionStep = QuizStepViewModel (image: UIImage(named: model.image) ?? UIImage(), question: model.text, questionNumber: "\(currentQuestionIndex + 1)/\(questions.count)")
    return questionStep
}
//функция для смены вопроса
private func show(quizstep: QuizStepViewModel){
    previewImage.image = quizstep.image
    questionLabel.text = quizstep.question
    indexLabel.text = quizstep.questionNumber
 }
//функция для показа алерта с результатами
private func show(quizresult: QuizResultsViewModel) {
    let alert = UIAlertController(title: quizresult.title, message: quizresult.text, preferredStyle: .alert)
    let action = UIAlertAction(title: quizresult.buttonText, style: .default) {_ in

        self.currentQuestionIndex = 0
        self.correctAnswers = 0

        let reset = self.convert(model: self.questions[self.currentQuestionIndex])
        self.show(quizstep: reset)
    }

    alert.addAction(action)
    self.present(alert, animated: true, completion: nil)
}
//функция для отображения рамки правильного/неправильного ответа
private func showAnswerResult(isCorrect: Bool){
    if isCorrect{
        correctAnswers += 1
    }

    previewImage.layer.masksToBounds = true
    previewImage.layer.borderWidth = 8

    previewImage.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor: UIColor.ypRed.cgColor
    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
        self.showNextQuestionOrResults()
        self.previewImage.layer.borderWidth = 0
    }

}
//функция для определения конца игры или переключения вопроса
private func showNextQuestionOrResults() {
    if currentQuestionIndex == questions.count - 1 {
        let result = QuizResultsViewModel(title: "Этот раунд завершен!", text: "Ваш результат: \(correctAnswers)/\(questions.count)", buttonText: "Сыграть еще раз")
        show(quizresult: result)
    } else {
        currentQuestionIndex += 1
        let nextQuestion = convert(model: questions[currentQuestionIndex])
        show(quizstep: nextQuestion)
    }
}

override func viewDidLoad() {
    super.viewDidLoad()
    //отображаем первый вопрос на экране
    let firstQuestion = convert(model: questions[currentQuestionIndex])
    show(quizstep: firstQuestion)
}
//реализация нажатия кнопки ДА
    @IBAction func yesButtonTouched(_ sender: Any) {
    let currentQuestion = questions[currentQuestionIndex]
    let answer = true
    showAnswerResult(isCorrect: answer == currentQuestion.correctAnswer)
}
//реализация нажатия кнопки НЕТ
    @IBAction func noButtonTouched(_ sender: Any) {
    let currentQuestion = questions[currentQuestionIndex]
    let answer = false
    showAnswerResult(isCorrect: answer == currentQuestion.correctAnswer)
}

}

/*
Mock-данные

Картинка: The Godfather
Настоящий рейтинг: 9,2
Вопрос: Рейтинг этого фильма больше чем 6?
Ответ: ДА

Картинка: The Dark Knight
Настоящий рейтинг: 9
Вопрос: Рейтинг этого фильма больше чем 6?
Ответ: ДА

Картинка: Kill Bill
Настоящий рейтинг: 8,1
Вопрос: Рейтинг этого фильма больше чем 6?
Ответ: ДА

Картинка: The Avengers
Настоящий рейтинг: 8
Вопрос: Рейтинг этого фильма больше чем 6?
Ответ: ДА

Картинка: Deadpool
Настоящий рейтинг: 8
Вопрос: Рейтинг этого фильма больше чем 6?
Ответ: ДА

Картинка: The Green Knight
Настоящий рейтинг: 6,6
Вопрос: Рейтинг этого фильма больше чем 6?
Ответ: ДА

Картинка: Old
Настоящий рейтинг: 5,8
Вопрос: Рейтинг этого фильма больше чем 6?
Ответ: НЕТ

Картинка: The Ice Age Adventures of Buck Wild
Настоящий рейтинг: 4,3
Вопрос: Рейтинг этого фильма больше чем 6?
Ответ: НЕТ

Картинка: Tesla
Настоящий рейтинг: 5,1
Вопрос: Рейтинг этого фильма больше чем 6?
Ответ: НЕТ

Картинка: Vivarium
Настоящий рейтинг: 5,8
Вопрос: Рейтинг этого фильма больше чем 6?
Ответ: НЕТ
*/
