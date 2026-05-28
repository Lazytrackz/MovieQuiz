//
//  MovieQuizPresenter.swift
//  MovieQuiz
//
//  Created by Aleksey Kosichenko on 12.05.2026.
//

import Foundation

final class MovieQuizPresenter: QuestionFactoryDelegate {
    
    // MARK: - Properties
    
    private let questionsAmount: Int = 10
    private var currentQuestionIndex: Int = 0
    private var currentQuestion: QuizQuestion?
    weak private var viewController: MovieQuizViewControllerProtocol?
    private var questionFactory: QuestionFactoryProtocol?
    private var staticService: StatisticServiceProtocol?
    private var correctAnswers: Int = 0
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.dateFormat = "(dd.MM.yy HH:mm)"
        return formatter
    }()
    
    init(viewController: MovieQuizViewControllerProtocol) {
        self.viewController = viewController
        
        staticService = StatisticService()
        staticService?.setQuestionsCount(amount: self.questionsAmount)
        
        questionFactory = QuestionFactory(delegate: self, moviesLoader: MoviesLoader(), movieQuizViewController: MovieQuizViewController(), alertPresenter: AlertPresenter())
        
        questionFactory?.loadData()
        viewController.setActivityIndicator(isActive: true)
    }
    
    
    // MARK: - QuestionFactoryDelegate
    
    func didLoadDataFromServer() {
        viewController?.setActivityIndicator(isActive: false)
        questionFactory?.requestNextQuestion()
    }
    
    func didFailToLoadData(with error: any Error) {
        viewController?.showNetworkError(message: error.localizedDescription)
    }
    
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question else {
            return
        }
        currentQuestion = question
        let viewModel = convert(model: question)
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.show(quiz: viewModel)
        }
    }
    
    // MARK: - Private Properties
    
    private func proceedToNextQuestionOrResults() {
        if self.isLastQuestion() {
            let message = setGameResult()
            let quizResult = QuizResultsViewModel (title: EndGameAlertTitle.titleString, text: message, buttonText: EndGameAlertTitle.buttonString)
            viewController?.showResult(quiz: quizResult)}
        else {
            self.switchToNextQuestion()
            questionFactory?.requestNextQuestion()
        }
    }
    
    private func proceedWithAnswer(isCorrect: Bool) {
        viewController?.enableButtons(false)
        viewController?.setImageBorder(borderColor: isCorrect)
        self.didAnswer(isCorrectAnswer: isCorrect)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self else {return}
            
            self.proceedToNextQuestionOrResults()
        }
    }
    
    private func setGameResult() -> String {
        let gameResult = GameResult(correctAnswers: correctAnswers, totalGameQuestions: questionsAmount, endGameDate: Date())
        staticService?.storeGameResult(for: gameResult)
        
        guard
            let gamesCount = staticService?.gamesCount,
            let bestGame = staticService?.bestGameResult,
            let totalAccuracy = staticService?.totalAccuracy
        else {
            return "0"}
        
        let bestGameString = bestGame.correctAnswers
        let totalQuestionsString = bestGame.totalGameQuestions
        let time = dateFormatter.string(from: bestGame.endGameDate)
        
        let message = """
            \(EndGameAlertTitle
                .messageResultString)\(correctAnswers)/\(self.questionsAmount) 
            \(EndGameAlertTitle
                .gameCountString)\(gamesCount) 
            \(EndGameAlertTitle.bestGameString)\(bestGameString)/\(totalQuestionsString) \(time) 
            \(EndGameAlertTitle
                .totalAccuracyString)\(String(format: "%.2f", totalAccuracy))%
            """
        
        return message
    }
    
    private func didAnswer(isYes: Bool) {
        guard let currentQuestion = currentQuestion else {
            return
        }
        let givenAnswer = isYes
        self.proceedWithAnswer(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    
    func convert(model: QuizQuestion) -> QuizStepViewModel { //cделать private после тестов
        QuizStepViewModel(
            image: model.imageData,
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
    }
    
    private func isLastQuestion() -> Bool {
        currentQuestionIndex == questionsAmount - 1
    }
    
    private func switchToNextQuestion() {
        currentQuestionIndex += 1
    }
    
    private func didAnswer(isCorrectAnswer: Bool) {
        if isCorrectAnswer {
            correctAnswers += 1
        }
    }
    
    // MARK: - Properties
    
    func yesButtonClicked() {
        didAnswer(isYes: true)
    }
    
    func noButtonClicked() {
        didAnswer(isYes: false)
    }
    
    func restartGame() {
        currentQuestionIndex = 0
        correctAnswers = 0
        questionFactory?.requestNextQuestion()
    }
    
}
