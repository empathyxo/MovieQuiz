import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate {
    @IBOutlet private weak var previewImage: UIImageView!
    @IBOutlet private weak var indexLabel: UILabel!
    @IBOutlet private weak var questionLabel: UILabel!
    @IBOutlet private weak var yesButton: UIButton!
    @IBOutlet private weak var noButton: UIButton!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    private var currentQuestionIndex = 0
    private var correctAnswers = 0
    private let questionsAmount = 10
    private var questionFactory: QuestionFactoryProtocol?
    private var currentQuestion: QuizQuestion?
    private var alertPresenter: AlertPresenter?
    private var statisticService: StatisticServiceProtocol = StatisticService()
    
    private let dateFormatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateFormat = "dd.MM.yyyy HH:mm"
            return formatter
        }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
        self.questionFactory = questionFactory
        
        showLoadingIndicator()
        questionFactory.loadData()
        didLoadDataFromServer()
        
        //инициализация AlertPresenter
        alertPresenter = AlertPresenter(viewController: self)
    }
    func didLoadDataFromServer() {
        activityIndicator.isHidden = true
        questionFactory?.requestNextQuestion()
    }

    func didFailToLoadData(with error: Error) {
        showNetworkError(message: error.localizedDescription)
    }
    //отображение и скрытие индикатора загрузки
    private func showLoadingIndicator() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    private func hideLoadingIndicator() {
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
    }
    //функция показа сетевой ошибки
    private func showNetworkError(message: String) {
        hideLoadingIndicator()
        
        let alert = AlertModel(title: "Ошибка", message: message, buttonText: "Попробовать еще раз") {
            [weak self] in
            guard let self = self else {return}
            self.currentQuestionIndex = 0
            self.correctAnswers = 0
            
            self.questionFactory?.requestNextQuestion()
        }
        alertPresenter?.show(quizresult: alert)
    }
//конвертируем viewmodel вопросов во viewmodel экрана
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        return QuizStepViewModel(image: UIImage(data: model.image) ?? UIImage(), question: model.text, questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
    }
//функция для смены вопроса
    private func show(quizstep: QuizStepViewModel){
        previewImage.image = quizstep.image
        questionLabel.text = quizstep.question
        indexLabel.text = quizstep.questionNumber
        enableButtons()
 }
//функция для показа алерта с результатами
    private func show(quizresult: QuizResultsViewModel) {
        let alertModel = AlertModel(title: quizresult.title, message: quizresult.text, buttonText: quizresult.buttonText, completion: {[weak self] in
            guard let self = self else {return}
            self.currentQuestionIndex = 0
            self.correctAnswers = 0
            //self.gamesCount += 1
            self.questionFactory?.requestNextQuestion()
        })
        alertPresenter?.show(quizresult: alertModel)
    }
//функция для отображения рамки правильного/неправильного ответа
    private func showAnswerResult(isCorrect: Bool){
        if isCorrect{
            correctAnswers += 1
        }

        previewImage.layer.masksToBounds = true
        previewImage.layer.borderWidth = 8

        previewImage.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor: UIColor.ypRed.cgColor
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else {return}
            self.showNextQuestionOrResults()
            self.previewImage.layer.borderWidth = 0
        }

    }
//функция для определения конца игры или переключения вопроса
    private func showNextQuestionOrResults() {
        if currentQuestionIndex == questionsAmount - 1 {
            statisticService.store(correct: correctAnswers, total: questionsAmount)
            let bestGame = statisticService.bestGame
            let formattedDate = dateFormatter.string(from: bestGame.date)
            let result = QuizResultsViewModel(title: "Этот раунд завершен!", text: "Ваш результат: \(correctAnswers)/\(questionsAmount)\nКоличество сыгранных квизов: \(statisticService.gamesCount)\nРекорд: \(bestGame.correct)/\(bestGame.total) (\(formattedDate))\nСредняя точность: \(String(format: "%.2f", statisticService.totalAccuracy))%", buttonText: "Сыграть еще раз")
            show(quizresult: result)
        } else {
            currentQuestionIndex += 1
            
            self.questionFactory?.requestNextQuestion()
        }
    }
    
    // MARK: - QuestionFactoryDelegate
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question = question else {return}
        currentQuestion = question
        let viewModel = convert(model: question)
        DispatchQueue.main.async { [weak self] in
            self?.show(quizstep: viewModel)
        }
    }
//реализация нажатия кнопки ДА
    @IBAction func yesButtonTouched(_ sender: Any) {
        guard let currentQuestion = currentQuestion else {return}
        let answer = true
        disableButtons()
        showAnswerResult(isCorrect: answer == currentQuestion.correctAnswer)
    }
//реализация нажатия кнопки НЕТ
    @IBAction func noButtonTouched(_ sender: Any) {
        guard let currentQuestion = currentQuestion else {return}
        let answer = false
        disableButtons()
        showAnswerResult(isCorrect: answer == currentQuestion.correctAnswer)
    }
    private func disableButtons() {
           yesButton.isEnabled = false
           noButton.isEnabled = false
       }
       
       private func enableButtons() {
           yesButton.isEnabled = true
           noButton.isEnabled = true
       }

}
