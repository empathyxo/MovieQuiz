//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by empathyxo on 07.07.2024.
//

import UIKit

class AlertPresenter {
    private weak var viewController: UIViewController?
    init(viewController: UIViewController) {
        self.viewController = viewController
    }
   func show(quizresult: AlertModel) {
       let alert = UIAlertController(title: quizresult.title, message: quizresult.message, preferredStyle: .alert)
       let action = UIAlertAction(title: quizresult.buttonText, style: .default) {_ in
           quizresult.completion?()
       }
       alert.addAction(action)
       viewController?.present(alert, animated: true, completion: nil)
    }
}
