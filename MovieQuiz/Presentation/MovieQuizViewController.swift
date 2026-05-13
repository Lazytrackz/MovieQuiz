import UIKit


//MARK: - ViewController

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate  {

    // MARK: - IBOutlets
    
    @IBOutlet weak var yesButton: UIButton!
    @IBOutlet weak var noButton: UIButton!
    @IBOutlet weak private var counterLabel: UILabel!
    @IBOutlet weak private var imageView: UIImageView!
    @IBOutlet weak private var textLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    // MARK: - Properties
    
    
    private var presenter = MovieQuizPresenter()
    //private var currentQuestionIndex = 0 //del latter
    private var correctAnswers = 0
    //private var questionsAmount = 10 //del latter
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
    
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter.viewController = self
        staticService = StatisticService()
        staticService?.setQuestionsCount(amount: presenter.questionsAmount)
        questionFactory = QuestionFactory(delegate: self, moviesLoader: MoviesLoader(), movieQuizViewController: self, alertPresenter: AlertPresenter())
    
        activityIndicator.startAnimating()
        activityIndicator.hidesWhenStopped = true
      
        self.questionFactory?.loadData()
    }
    
    
    // MARK: - QuestionFactoryDelegate
    
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question else {
            return
        }
        currentQuestion = question
        let viewModel = presenter.convert(model: question)
        show(quiz: viewModel)
    }
    
    func didLoadDataFromServer() {
        //hideLoadingIndicator()
        activityIndicator.stopAnimating()
        questionFactory?.requestNextQuestion()
    
    }
    
    func didFailToLoadData(with error: any Error) {
        showNetworkError(message: error.localizedDescription)
    }
            
    // MARK: - Actions
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        guard let currentQuestion = currentQuestion else {
            return
        }
        //showAnswerResult(isCorrect: !currentQuestion.correctAnswer)
        presenter.currentQuestion = currentQuestion
        presenter.noButtonClicked()
    }
    
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        guard let currentQuestion = currentQuestion else {
            return
        }
        
        //showAnswerResult(isCorrect: currentQuestion.correctAnswer)
        
        presenter.currentQuestion = currentQuestion
        presenter.yesButtonClicked()
        
    }
    
    // MARK: - Private Methods
    
   /* private func convert(model: QuizQuestion) -> QuizStepViewModel {
         QuizStepViewModel(
            image: UIImage(data: model.imageData) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
    }*/
    
    private func show(quiz step: QuizStepViewModel) {
        imageView.layer.cornerRadius = 20
        imageView.layer.borderWidth = 0
        counterLabel.text = step.questionNumber
        imageView.image = UIImage(data: step.image) ?? UIImage()
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
         
         alertPresenter.show(alertModel: alertModel, controller: self, accessibilityId: "GameResults")
    }
    
    private func showNextQuestionOrResults() {
        if presenter.isLastQuestion() {
            let message = setGameResult()
            let quizResult = QuizResultsViewModel (title: EndGameAlertTitle.titleString, text: message, buttonText: EndGameAlertTitle.buttonString)
            showResult(quiz: quizResult)}
        
        
        else {
            presenter.switchToNextQuestion()
            self.questionFactory?.requestNextQuestion()
        }
    }
    
    func showAnswerResult(isCorrect: Bool) {
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
    
    private func setGameResult() -> String {
        let gameResult = GameResult(correctAnswers: correctAnswers, totalGameQuestions: presenter.questionsAmount, endGameDate: Date())
        
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
                .messageResultString)\(correctAnswers)/\(presenter.questionsAmount) 
            \(EndGameAlertTitle
                .gameCountString)\(gamesCount) 
            \(EndGameAlertTitle.bestGameString)\(bestGameString)/\(totalQuestionsString) \(time) 
            \(EndGameAlertTitle
                .totalAccuracyString)\(String(format: "%.2f", totalAccuracy))%
            """
        
        return message
    }
    
    private func enableButtons(_ isEnable: Bool) {
        yesButton.isEnabled = isEnable
        noButton.isEnabled = isEnable
        
    }
    
    private func showNetworkError(message: String) {
        activityIndicator.stopAnimating()
        
        let alertModel = AlertModel(title: ErrorAlertTitle.titleString,
                                    message: message,
                                    buttonText: ErrorAlertTitle.buttonString){ [weak self] in guard let self = self else { return }
           beginNewGame()
        }
        alertPresenter.show(alertModel: alertModel, controller: self, accessibilityId: "NetworkError")
    }
    
    
    // MARK: - Methods
    
    func beginNewGame() {
        //self.currentQuestionIndex = 0
        self.presenter.resetQuestionIndex()
        self.correctAnswers = 0
        activityIndicator.startAnimating()
        //showLoadingIndicator()
        self.questionFactory?.loadData()
    }
    
}

