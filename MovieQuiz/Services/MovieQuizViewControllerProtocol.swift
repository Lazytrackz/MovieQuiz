//
//  MovieQuizViewControllerProtocol.swift
//  MovieQuiz
//
//  Created by Aleksey Kosichenko on 15.05.2026.
//

import Foundation

protocol MovieQuizViewControllerProtocol: AnyObject {
    
    func show(quiz step: QuizStepViewModel)
    func setImageBorder(borderColor: Bool)
    func showResult(quiz result: QuizResultsViewModel)
    func showNetworkError(message: String)
    func showImageDataError(message: String)
    func enableButtons(_ isEnable: Bool)
    func setActivityIndicator(isActive: Bool)
    
    
    
    
}
