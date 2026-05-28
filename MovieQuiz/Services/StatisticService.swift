//
//  StatisticService.swift
//  MovieQuiz
//
//  Created by Aleksey Kosichenko on 18.04.2026.
//

import Foundation

//MARK: - StatisticService

final class StatisticService {
    
    // MARK: - Properties
    
    private var totalQuestionsAmount: Int = 0
    private var totalCorrectAnswersAmount: Int = 0
    private let storage: UserDefaults = .standard
    private var questionCount = 0
    
    // MARK: - Private Methods
    
    private func getQuestionsAmount() -> Int {
        storage.integer(forKey: Keys.totalQuestionsAmount.rawValue)
    }
    
    private func setQuestionsAmount() {
        let questionAmount = gamesCount * questionCount
        storage.set(questionAmount, forKey: Keys.totalQuestionsAmount.rawValue)
    }
    
    private func getCorrectAnswersAmount() -> Int {
        storage.integer(forKey: Keys.totalCorrectAnswersAmount.rawValue)
    }
    
    private func setCorrectAnswersAmount(correctAnswers: GameResult) {
        let test = getCorrectAnswersAmount() + correctAnswers.correctAnswers
        storage.set(test , forKey: Keys.totalCorrectAnswersAmount.rawValue)
    }
    
    private func calculateTotalAccuracy() {
        totalQuestionsAmount = getQuestionsAmount()
        totalCorrectAnswersAmount = getCorrectAnswersAmount()
        
        if totalQuestionsAmount > 0 {
            totalAccuracy = (Double(totalCorrectAnswersAmount)/Double(totalQuestionsAmount))*100
        }
        else {
            totalAccuracy = 0
        }
    }
}

extension StatisticService: StatisticServiceProtocol {
    
    // MARK: - Properties
    
    var gamesCount: Int {
        get {
            storage.integer(forKey: Keys.gamesCount.rawValue)
        }
        set {
            storage.set(newValue, forKey: Keys.gamesCount.rawValue)
        }
    }
    
    var bestGameResult: GameResult {
        get {
            let correctAnswers = storage.integer(forKey: Keys.correctAnswers.rawValue)
            let totalGameQuestions = storage.integer(forKey: Keys.totalGameQuestions.rawValue)
            let endGameDate = storage.object(forKey: Keys.endGameDate.rawValue) as? Date ?? Date()
            
            return GameResult(correctAnswers: correctAnswers, totalGameQuestions: totalGameQuestions, endGameDate: endGameDate)
        }
        set {
            storage.set(newValue.correctAnswers, forKey: Keys.correctAnswers.rawValue)
            storage.set(newValue.totalGameQuestions, forKey: Keys.totalGameQuestions.rawValue)
            storage.set(newValue.endGameDate, forKey: Keys.endGameDate.rawValue)
        }
    }
    
    var totalAccuracy: Double {
        get {
            storage.double(forKey: Keys.totalAccuracy.rawValue)
        }
        set {
            storage.set(newValue, forKey: Keys.totalAccuracy.rawValue)
        }
    }
    
    // MARK: - Methods
    
    func storeGameResult(for gameResult: GameResult) {
        gamesCount += 1
        setQuestionsAmount()
        setCorrectAnswersAmount(correctAnswers: gameResult)
        calculateTotalAccuracy()
        
        if gameResult.checkBestGameResult(previousGameResult: bestGameResult) {
            bestGameResult = gameResult
        }
    }
    
    func setQuestionsCount(amount: Int) {
        questionCount = amount
    }
    
}

