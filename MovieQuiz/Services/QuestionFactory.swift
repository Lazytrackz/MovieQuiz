//
//  QuestionFactory.swift
//  MovieQuiz
//
//  Created by Aleksey Kosichenko on 12.04.2026.
//

import Foundation
import Logging


//MARK: - QuestionFactory

final class QuestionFactory : QuestionFactoryProtocol {
    
    // MARK: - Properties
    
    private let logger = Logger(label: "MovieQuiz.QuestionFactory")
    weak var delegate: QuestionFactoryDelegate?
    private let moviesLoader: MoviesLoading
    private var movies: [MostPopularMovie] = []
    private let movieQuizViewController: MovieQuizViewController
    private let alertPresenter: AlertPresenter
 

    
    init(delegate: QuestionFactoryDelegate? = nil, moviesLoader: MoviesLoading, movieQuizViewController: MovieQuizViewController, alertPresenter: AlertPresenter) {
        self.delegate = delegate
        self.moviesLoader = moviesLoader
        self.movieQuizViewController = movieQuizViewController
        self.alertPresenter = alertPresenter
    }
    

    /* private let questions: [QuizQuestion] = [
        QuizQuestion (imageName: "The Godfather",
                      text: "Рейтинг этого фильма больше чем 6?",
                      correctAnswer: true),
        QuizQuestion (imageName: "The Dark Knight",
                      text: "Рейтинг этого фильма больше чем 6?",
                      correctAnswer: true),
        QuizQuestion (imageName: "Kill Bill",
                      text: "Рейтинг этого фильма больше чем 6?",
                      correctAnswer: true),
        QuizQuestion (imageName: "The Avengers",
                      text: "Рейтинг этого фильма больше чем 6?",
                      correctAnswer: true),
        QuizQuestion (imageName: "Deadpool",
                      text: "Рейтинг этого фильма больше чем 6?",
                      correctAnswer: true),
        QuizQuestion (imageName: "The Green Knight",
                      text: "Рейтинг этого фильма больше чем 6?",
                      correctAnswer: true),
        QuizQuestion (imageName: "Old",
                      text: "Рейтинг этого фильма больше чем 6?",
                      correctAnswer: false),
        QuizQuestion (imageName: "The Ice Age Adventures of Buck Wild",
                      text: "Рейтинг этого фильма больше чем 6?",
                      correctAnswer: false),
        QuizQuestion (imageName: "Tesla",
                      text: "Рейтинг этого фильма больше чем 6?",
                      correctAnswer: false),
        QuizQuestion (imageName: "Vivarium",
                      text: "Рейтинг этого фильма больше чем 6?",
                      correctAnswer: false),
        ]
    */
    
    // MARK: - Private Methods
    
    private func showImageDataError(message: String) {
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            let alertModel = AlertModel(title: ErrorAlertTitle.titleString,
                                        message: message,
                                        buttonText: ErrorAlertTitle.buttonString){ [weak self] in guard let self = self else { return }
                movieQuizViewController.beginNewGame()
            }
            alertPresenter.show(alertModel: alertModel, controller: movieQuizViewController, accessibilityId: "ImageError")
        }
    }
    
    

    
    // MARK: - Methods

    func loadData() {
        moviesLoader.loadMovies { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                switch result {
                case .success(let mostPopularMovies):
                    
                    if !mostPopularMovies.items.isEmpty {
                        self.movies = mostPopularMovies.items
                        self.delegate?.didLoadDataFromServer()
                    }
                case .failure(let error):
                    self.delegate?.didFailToLoadData(with: error)
                }
            }
        }
    }
    
    func requestNextQuestion() {
        DispatchQueue.global().async { [weak self] in
            guard let self = self else { return }
            
            let index = (0..<self.movies.count).randomElement() ?? 0
            guard let movie = self.movies[safe: index] else { return }
            var imageData = Data()
        
            do {
                imageData = try Data(contentsOf: movie.resizedImageURL)
                
            } catch {
                //print("Failed to load image")
                logger.warning("Failed to load image")
                showImageDataError(message: "Failed to load image")
            }
            
            let rating = Float(movie.rating) ?? 0
            let randomRatingIndex = Int.random(in: 7..<10)
            let text = "Рейтинг этого фильма больше чем \(randomRatingIndex)?"
            let correctAnswer = rating > Float(randomRatingIndex)
            
            let question = QuizQuestion(imageData: imageData,
                                        text: text,
                                        correctAnswer: correctAnswer)
            
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.delegate?.didReceiveNextQuestion(question: question)
            }
        }
        
    }
    
    
    
    
}
