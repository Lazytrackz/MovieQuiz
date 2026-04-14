//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Aleksey Kosichenko on 13.04.2026.
//

import Foundation

protocol QuestionFactoryDelegate: AnyObject {
    func didReceiveNextQuestion(question: QuizQuestion?)

}
