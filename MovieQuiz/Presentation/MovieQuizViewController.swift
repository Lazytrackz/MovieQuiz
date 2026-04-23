import UIKit


//MARK: - ViewController

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate  {

    // MARK: - IBOutlets
    
    @IBOutlet weak var yesButton: UIButton!
    @IBOutlet weak var noButton: UIButton!
    @IBOutlet weak private var counterLabel: UILabel!
    @IBOutlet weak private var imageView: UIImageView!
    @IBOutlet weak private var textLabel: UILabel!
    
    // MARK: - Properties
    
    private var currentQuestionIndex = 0
    private var correctAnswers = 0
    private var questionsAmount = 10
    private var questionFactory: QuestionFactoryProtocol?
    private var currentQuestion: QuizQuestion?
    private var alertPresenter: AlertPresenter = AlertPresenter()
    private var staticService: StatisticServiceProtocol?
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.dateFormat = "(dd.MM.yy HH:mm)"
        return formatter
    }()
    
    
    // MARK: - Constants
    
    private enum AlertTitle {
        static let titleString = "Этот раунд окончен!"
        static let buttonString = "Сыграть ещё раз"
        static let messageResultString = "Ваш результат: "
        static let gameCountString = "Количество сыгранных квизов: "
        static let bestGameString = "Рекорд: "
        static let totalAccuracyString = "Средняя точность: "
    }
    
   
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let staticService = StatisticService()
        staticService.setQuestionsCount(amount: questionsAmount)
        self.staticService = staticService
        
        let questionFactory = QuestionFactory()
        questionFactory.setDelegate(self)
        self.questionFactory = questionFactory
        
      
        self.questionFactory?.requestNextQuestion()
    }
    
    
    // MARK: - QuestionFactoryDelegate
    
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question else {
            return
        }
        currentQuestion = question
        let viewModel = convert(model: question)
        show(quiz: viewModel)
    }
            
    // MARK: - Actions
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        guard let currentQuestion = currentQuestion else {
            return
        }
        showAnswerResult(isCorrect: !currentQuestion.correctAnswer)
    }
    
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        guard let currentQuestion = currentQuestion else {
            return
        }
        showAnswerResult(isCorrect: currentQuestion.correctAnswer)
    }
    
    // MARK: - Private Methods
    
    
  
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
         QuizStepViewModel(
             image: UIImage(named: model.imageName) ?? UIImage(),
             question: model.text,
             questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
    }
    
    private func show(quiz step: QuizStepViewModel) {
        imageView.layer.cornerRadius = 20
        imageView.layer.borderWidth = 0
        counterLabel.text = step.questionNumber
        imageView.image = step.image
        textLabel.text = step.question
        enableButtons(true)
    }
    
    private func setImageBorder(currentImageView: UIImageView,
                                 borderColor: Bool) {
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = borderColor ? UIColor.ypGreenIOS.cgColor : UIColor.ypRedIOS.cgColor
        imageView.layer.cornerRadius = 20
    }
    
     private func showResult(quiz result: QuizResultsViewModel) {
        let alertModel = AlertModel(title: result.title,
                                    message: result.text,
                                    buttonText: result.buttonText,
                                    completion:{ [weak self] in
            guard let self = self else { return }
            beginNewGame()})
         
         alertPresenter.showEndGameAlert(alertModel: alertModel, controller: self)
    }
    
    private func showNextQuestionOrResults() {
        if currentQuestionIndex == questionsAmount - 1 {
            let message = setGameResult()
            let quizResult = QuizResultsViewModel (title: AlertTitle.titleString, text: message, buttonText: AlertTitle.buttonString)
            showResult(quiz: quizResult)}
        else {
            currentQuestionIndex += 1
            self.questionFactory?.requestNextQuestion()
        }
    }
    
    private func showAnswerResult(isCorrect: Bool) {
        
        enableButtons(false)
        
        if isCorrect {
            setImageBorder(currentImageView: imageView, borderColor: isCorrect)
            correctAnswers += 1
        }else {
            setImageBorder(currentImageView: imageView, borderColor: isCorrect)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self else {return}
            showNextQuestionOrResults()
        }
    }
    
    private func beginNewGame() {
        self.currentQuestionIndex = 0
        self.correctAnswers = 0
        questionFactory?.requestNextQuestion()
    }
    
    private func setGameResult() -> String {
        let gameResult = GameResult(correctAnswers: correctAnswers, totalGameQuestions: questionsAmount, endGameDate: Date())
        
        staticService?.storeGameResult(for: gameResult)
        guard let staticService = staticService else {return "0"}
       
        //guard let gamesCount = staticService?.gamesCount else {return "0"}
        //guard let bestGame = staticService?.bestGameResult else {return "0"}
        //guard let totalAccuracy = staticService?.totalAccuracy else {return "0"}
        
        
        let gamesCount = staticService.gamesCount
        let bestGame = staticService.bestGameResult
        let totalAccuracy = staticService.totalAccuracy
        
        //let bestGameString = staticService.bestGameResult.correctAnswers
        //let totalQuestionsString = staticService.bestGameResult.totalGameQuestions
        //let time = dateFormatter.string(from: staticService.bestGameResult.endGameDate)
        
        let bestGameString = bestGame.correctAnswers
        let totalQuestionsString = bestGame.totalGameQuestions
        let time = dateFormatter.string(from: bestGame.endGameDate)
     
        
        let message = " \(AlertTitle.messageResultString)\(correctAnswers)/\(questionsAmount)\n \(AlertTitle.gameCountString)\(gamesCount)\n \(AlertTitle.bestGameString) \(bestGameString)/\(totalQuestionsString) \(time)\n \(AlertTitle.totalAccuracyString)\(String(format: "%.2f", totalAccuracy))%"
        
        return message
    }
    
    private func enableButtons(_ isEnable: Bool) {
        if isEnable {
            yesButton.isEnabled = true
            noButton.isEnabled = true
        }
        else {
            yesButton.isEnabled = false
            noButton.isEnabled = false
        }
    }
}

