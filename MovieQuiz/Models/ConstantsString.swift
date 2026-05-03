//
//  ConstantsString.swift
//  MovieQuiz
//
//  Created by Aleksey Kosichenko on 02.05.2026.
//

import Foundation

//MARK: - Constants

enum EndGameAlertTitle {
    
    static let titleString = "Этот раунд окончен!"
    static let buttonString = "Сыграть ещё раз"
    static let messageResultString = "Ваш результат: "
    static let gameCountString = "Количество сыгранных квизов: "
    static let bestGameString = "Рекорд: "
    static let totalAccuracyString = "Средняя точность: "
}

enum ErrorAlertTitle {
    static let titleString = "Ошибка"
    static let buttonString = "Попробовать ещё раз"
}

enum Keys: String {
    case gamesCount
    case correctAnswers
    case totalGameQuestions
    case endGameDate
    case totalAccuracy
    case totalQuestionsAmount
    case totalCorrectAnswersAmount
}
