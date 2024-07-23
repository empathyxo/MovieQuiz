//
//  MovieQuizUITests.swift
//  MovieQuizUITests
//
//  Created by empathyxo on 23.07.2024.
//

import XCTest
@testable import MovieQuiz

final class MovieQuizUITests: XCTestCase {
    
    var app: XCUIApplication!

    override func setUpWithError() throws {
        try super.setUpWithError()
        
        app = XCUIApplication()
        app.launch()

        continueAfterFailure = false
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        
        app.terminate()
        app = nil
    }
    
    func testYesButton() throws {
        //find first Poster
        sleep(3)
        let firstPoster = app.images["Poster"]
        let firstPosterData = firstPoster.screenshot().pngRepresentation
        //find and tap Yes button
        app.buttons["Yes"].tap()
        sleep(3)
        //find another Poster
        let secondPoster = app.images["Poster"]
        let secondPosterData = secondPoster.screenshot().pngRepresentation
        //Compare first Poster with the second one
        XCTAssertNotEqual(firstPosterData, secondPosterData)
    }
    
    func testNoButton () throws {
        //find first poster
        sleep(3)
        let firstPoster = app.images["Poster"]
        let firstPosterData = firstPoster.screenshot().pngRepresentation
        //find and tap No button
        app.buttons["No"].tap()
        sleep(3)
        //find another button
        let secondPoster = app.images["Poster"]
        let secondPosterData = secondPoster.screenshot().pngRepresentation
        //Compare first Poster with the second one
        XCTAssertNotEqual(firstPosterData, secondPosterData)
    }
    func testGameFinish() throws {
        sleep(3)
        //вызываем тап по кнопке 10 раз
        for _ in 1...10 {
            app.buttons["No"].tap()
            sleep(3)
        }
        //находим алерт
        let alert = app.alerts["alert"]
        //выполняем проверку появления алерта
        XCTAssertTrue(alert.exists)
        XCTAssertTrue(alert.label == "Этот раунд завершен!")
        XCTAssertTrue(alert.buttons.firstMatch.label == "Сыграть еще раз")
    }

    func testAlertDismiss() throws {
        sleep(3)
        //вызываем тап по кнопке 10 раз
        for _ in 1...10 {
            app.buttons["No"].tap()
            sleep(3)
        }
        //находим алерт и нажимаем кнопку
        let alert = app.alerts["alert"]
        alert.buttons.firstMatch.tap()
        
        sleep(3)
        //находим лейбл количества вопросов
        let indexLabel = app.staticTexts["Index"]
        //проверяем, что после нажатия произошел сброс игры
        XCTAssertFalse(alert.exists)
        XCTAssertTrue(indexLabel.label == "1/10")
    }

    func testExample() throws {
        let app = XCUIApplication()
        app.launch()
    }
}
