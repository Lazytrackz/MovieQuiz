//
//  MovieQuizControllerTest.swift
//  MovieQuizControllerTest
//
//  Created by Aleksey Kosichenko on 15.05.2026.
//

import XCTest
@testable import MovieQuiz

final class MovieQuizViewControllerMock: MovieQuizViewControllerProtocol {
    
    
    func show(quiz step: QuizStepViewModel) {
        
    }
    func setImageBorder(borderColor: Bool) {
        
    }
    func showResult(quiz result: QuizResultsViewModel) {
        
    }
    func showNetworkError(message: String) {
        
    }
    func showImageDataError(message: String) {
        
    }
    func enableButtons(_ isEnable: Bool) {
        
    }
    func setActivityIndicator(isActive: Bool) {
        
    }
}
    
    
final class MovieQuizPresenterTests: XCTestCase {
    
    func testPresenterConvertModel() throws {
        let viewControllerMock = MovieQuizViewControllerMock()
        let presenter = MovieQuizPresenter(viewController: viewControllerMock)
        
        let emptyData = Data()
        let question = QuizQuestion(imageData: emptyData, text: "Question Text", correctAnswer: true)
        let viewModel = presenter.convert(model: question)
        
        XCTAssertEqual(viewModel.image, emptyData)
        XCTAssertEqual(viewModel.question, "Question Text")
        XCTAssertEqual(viewModel.questionNumber, "1/10")
    }
    
}

