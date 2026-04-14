//
//  EventDelegateProtocol.swift
//  MovieQuiz
//
//  Created by Aleksey Kosichenko on 13.04.2026.
//

import Foundation

protocol EventDelegate: AnyObject {
    func eventOccurred(data: String) // Метод, который будет вызван при событии
}
