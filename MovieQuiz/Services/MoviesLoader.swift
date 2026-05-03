//
//  MoviesLoader.swift
//  MovieQuiz
//
//  Created by Aleksey Kosichenko on 29.04.2026.
//

import Foundation


//MARK: - MoviesLoaderStruct

struct MoviesLoader: MoviesLoading {
    
    // MARK: - Properties
    
    private let networkClient = NetworkClient()
    private var mostPopularMoviesUrl: URL {
         
            guard let url = URL(string: "https://tv-api.com/en/API/Top250Movies/k_zcuw1ytf") else {
                preconditionFailure("Unable to construct mostPopularMoviesUrl")
            }
            return url
        }
    
    // MARK: - Methods
    
    func loadMovies(handler: @escaping (Result<MostPopularMovies, Error>) -> Void) {
        networkClient.fetch(url: mostPopularMoviesUrl, handler: {result in
            
            switch result {
            case .success(let data):
                do {
                    let movies = try JSONDecoder().decode(MostPopularMovies.self, from: data)
                    handler(.success(movies))
                } catch {
                    handler(.failure(error))
                }
            case .failure(let error):
                handler(.failure(error))
            }
        })
    }
}
