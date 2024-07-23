import UIKit

final class MovieQuizViewController: UIViewController {
    @IBOutlet weak var previewImage: UIImageView!
    @IBOutlet private weak var indexLabel: UILabel!
    @IBOutlet private weak var questionLabel: UILabel!
    @IBOutlet weak var yesButton: UIButton!
    @IBOutlet weak var noButton: UIButton!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    private var presenter: MovieQuizPresenter!
    private var alertPresenter: AlertPresenter?
    
    private let dateFormatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateFormat = "dd.MM.yyyy HH:mm"
            return formatter
        }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = MovieQuizPresenter(viewController: self)
        alertPresenter = AlertPresenter(viewController: self)
    }
    //отображение и скрытие индикатора загрузки
    func showLoadingIndicator() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    func hideLoadingIndicator() {
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
    }
    //функция показа сетевой ошибки
    func showNetworkError(message: String) {
        hideLoadingIndicator()
        
        let alert = AlertModel(title: "Ошибка", message: message, buttonText: "Попробовать еще раз") {
            [weak self] in
            guard let self = self else {return}
            self.presenter.restartGame()
        }
        alertPresenter?.show(quizresult: alert)
    }
    
//функция для смены вопроса
    func show(quizstep: QuizStepViewModel){
        previewImage.image = quizstep.image
        questionLabel.text = quizstep.question
        indexLabel.text = quizstep.questionNumber
        changeStateButton(isEnabled: true)
 }
//функция для показа алерта с результатами
    func show(quizresult: QuizResultsViewModel) {
        let alertModel = AlertModel(title: quizresult.title, message: quizresult.text, buttonText: quizresult.buttonText, completion: {[weak self] in
            guard let self = self else {return}
            self.presenter.restartGame()
        })
        alertPresenter?.show(quizresult: alertModel)
    }
    
    func highlightImageBorder(isCorrectAnswer: Bool) {
        previewImage.layer.masksToBounds = true
        previewImage.layer.borderWidth = 8
        previewImage.layer.borderColor = isCorrectAnswer ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
    }
//реализация нажатия кнопки ДА
    @IBAction func yesButtonTouched(_ sender: Any) {
        presenter.yesButtonTouched()
        changeStateButton(isEnabled: false)
    }
//реализация нажатия кнопки НЕТ
    @IBAction func noButtonTouched(_ sender: Any) {
        presenter.noButtonTouched()
        changeStateButton(isEnabled: false)
    }
    
    private func changeStateButton(isEnabled: Bool) {
            noButton.isEnabled = isEnabled
            yesButton.isEnabled = isEnabled
        }

}
