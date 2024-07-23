//
//  ArrayTests.swift
//  MovieQuizTests
//
//  Created by empathyxo on 23.07.2024.
//

import XCTest
@testable import MovieQuiz  //импорт приложения для тестов

class ArrayTests: XCTestCase {
    func testGetValueInRange() throws{
        //Given
        let array = [1, 2, 3, 4, 5]
        //When
        let value = array[safe: 2]
        //Then
        XCTAssertNotNil(value)
        
        XCTAssertEqual(value, 3)
    }
    
    func testGetValueOutOfRange() throws {
        //Given
        let array = [1, 2, 3, 4, 5]
        //When
        let value = array[safe: 20]
        //Then
        XCTAssertNil(value)
    }
}
