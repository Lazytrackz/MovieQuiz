//
//  MoviesLoadingProtocol.swift
//  MovieQuiz
//
//  Created by Aleksey Kosichenko on 02.05.2026.
//

import Foundation

//MARK: - MoviesLoadingProtocol

protocol MoviesLoading {
    func loadMovies(handler: @escaping (Result<MostPopularMovies, Error>) -> Void)
}
