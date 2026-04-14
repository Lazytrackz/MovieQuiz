//
//  QuestionFactory.swift
//  MovieQuiz
//
//  Created by Aleksey Kosichenko on 12.04.2026.
//

import Foundation


class QuestionFactory : QuestionFactoryProtocol {
    
    weak var delegate: QuestionFactoryDelegate?
    
    func setDelegate(_ delegate: QuestionFactoryDelegate) {
           self.delegate = delegate
       }
    
    private let questions: [QuizQuestion] = [
        QuizQuestion (imageString: "The Godfather",
                      text: "Рейтинг этого фильма больше чем 6?",
                      correctAnswer: true),
        QuizQuestion (imageString: "The Dark Knight",
                      text: "Рейтинг этого фильма больше чем 6?",
                      correctAnswer: true),
        QuizQuestion (imageString: "Kill Bill",
                      text: "Рейтинг этого фильма больше чем 6?",
                      correctAnswer: true),
        QuizQuestion (imageString: "The Avengers",
                      text: "Рейтинг этого фильма больше чем 6?",
                      correctAnswer: true),
        QuizQuestion (imageString: "Deadpool",
                      text: "Рейтинг этого фильма больше чем 6?",
                      correctAnswer: true),
        QuizQuestion (imageString: "The Green Knight",
                      text: "Рейтинг этого фильма больше чем 6?",
                      correctAnswer: true),
        QuizQuestion (imageString: "Old",
                      text: "Рейтинг этого фильма больше чем 6?",
                      correctAnswer: false),
        QuizQuestion (imageString: "The Ice Age Adventures of Buck Wild",
                      text: "Рейтинг этого фильма больше чем 6?",
                      correctAnswer: false),
        QuizQuestion (imageString: "Tesla",
                      text: "Рейтинг этого фильма больше чем 6?",
                      correctAnswer: false),
        QuizQuestion (imageString: "Vivarium",
                      text: "Рейтинг этого фильма больше чем 6?",
                      correctAnswer: false),
        ]
    
    
    
    func requestNextQuestion() {
        guard let index = (0..<questions.count).randomElement() else {
            delegate?.didReceiveNextQuestion(question: nil)
            return
        }
        
        let question = questions[safe: index]
        delegate?.didReceiveNextQuestion(question: question)
        
    }
    
    
    
}
