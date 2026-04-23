//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Aleksey Kosichenko on 13.04.2026.
//

import Foundation

//MARK: - QuestionFactoryDelegate

protocol QuestionFactoryDelegate: AnyObject {

    // MARK: - Methods
    
    func didReceiveNextQuestion(question: QuizQuestion?)

}
