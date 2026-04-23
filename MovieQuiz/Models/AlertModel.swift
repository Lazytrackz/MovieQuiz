//
//  AlertModel.swift
//  MovieQuiz
//
//  Created by Aleksey Kosichenko on 14.04.2026.
//

import Foundation

//MARK: - AlertModel

struct AlertModel {
    
    // MARK: - Properties
    
    var title: String
    var message: String
    var buttonText: String
    var completion: () -> Void
}
