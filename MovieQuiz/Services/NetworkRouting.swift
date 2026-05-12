//
//  NetworkClientProtocol.swift
//  MovieQuiz
//
//  Created by Aleksey Kosichenko on 08.05.2026.
//

import Foundation

protocol NetworkRouting {
    func fetch(url: URL, handler: @escaping (Result<Data, Error>) -> Void)
}
