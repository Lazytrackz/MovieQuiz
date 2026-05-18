//
//  StatisticServiceProtocol.swift
//  MovieQuiz
//
//  Created by Aleksey Kosichenko on 18.04.2026.
//

import Foundation

//MARK: - StatisticServiceProtocol

protocol StatisticServiceProtocol {
    
    // MARK: - Properties
    
    var gamesCount: Int { get }
    var bestGameResult: GameResult { get }
    var totalAccuracy: Double { get }
    
    // MARK: - Methods
    
    func storeGameResult(for previousGameResult: GameResult)
    func setQuestionsCount(amount: Int)
    
}
