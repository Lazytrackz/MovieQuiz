//
//  GameResult.swift
//  MovieQuiz
//
//  Created by Aleksey Kosichenko on 18.04.2026.
//

import Foundation

//MARK: - GameResultModel

struct GameResult {
    
    // MARK: - Properties
    
    let correctAnswers: Int
    let totalGameQuestions: Int
    let endGameDate: Date
    
    // MARK: - Methods
    
    func checkBestGameResult(previousGameResult: GameResult) -> Bool {
        correctAnswers > previousGameResult.correctAnswers
    }
    
}
