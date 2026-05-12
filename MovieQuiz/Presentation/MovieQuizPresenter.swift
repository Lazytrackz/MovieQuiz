//
//  MovieQuizPresenter.swift
//  MovieQuiz
//
//  Created by Aleksey Kosichenko on 12.05.2026.
//

import Foundation

final class MovieQuizPresenter {
    
    let questionsAmount: Int = 10
    private var currentQuestionIndex: Int = 0
    
    func isLastQuestion() -> Bool {
        currentQuestionIndex == questionsAmount - 1
        
    }
    
    func resetQuestionIndex() {
        currentQuestionIndex = 0
    }
    
    func switchToNextQuestion() {
        currentQuestionIndex += 1
        
    }
    
    
    func convert(model: QuizQuestion) -> QuizStepViewModel {
         QuizStepViewModel(
            //image: UIImage(data: model.imageData) ?? UIImage(),
            image: model.imageData,
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
    }
    
    
    
    
    
    
    
}
