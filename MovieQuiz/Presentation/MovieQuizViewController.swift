import UIKit


//MARK: - ViewController

final class MovieQuizViewController: UIViewController {
 
    // MARK: - Structs
    
    struct QuizQuestion {
        let image: String
        let text: String
        let correctAnswer: Bool
    }
    
    struct QuizStepViewModel {
        let image: UIImage
        let question: String
        let questionNumber: String
    }
    
    struct QuizResultsViewModel {
        let title: String
        let text: String
        let buttonText: String
    }
    
    // MARK: - IBOutlets
    
    @IBOutlet weak private var counterLabel: UILabel!
    @IBOutlet weak private var imageView: UIImageView!
    @IBOutlet weak private var textLabel: UILabel!
    
    // MARK: - Properties
    
    private var currentQuestionIndex = 0
    private var correctAnswers = 0
    private var questions = [QuizQuestion]()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        questions = setMoviesList()
        let currentQuestion = questions[currentQuestionIndex]
        show(quiz: convert(model: currentQuestion))
    }
    
    // MARK: - Actions
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        let currentQuestion = questions[currentQuestionIndex].correctAnswer
        showAnswerResult(isCorrect: !currentQuestion)
    }
    
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        let currentQuestion = questions[currentQuestionIndex].correctAnswer
        showAnswerResult(isCorrect: currentQuestion)
    }
    
    // MARK: - Private Methods
    
    private func setMoviesList() -> [QuizQuestion] {
        let moviesList: [QuizQuestion] = [
            QuizQuestion (image: "The Godfather",
                          text: "Рейтинг этого фильма больше чем 6?",
                          correctAnswer: true),
            QuizQuestion (image: "The Dark Knight",
                          text: "Рейтинг этого фильма больше чем 6?",
                          correctAnswer: true),
            QuizQuestion (image: "Kill Bill",
                          text: "Рейтинг этого фильма больше чем 6?",
                          correctAnswer: true),
            QuizQuestion (image: "The Avengers",
                          text: "Рейтинг этого фильма больше чем 6?",
                          correctAnswer: true),
            QuizQuestion (image: "Deadpool",
                          text: "Рейтинг этого фильма больше чем 6?",
                          correctAnswer: true),
            QuizQuestion (image: "The Green Knight",
                          text: "Рейтинг этого фильма больше чем 6?",
                          correctAnswer: true),
            QuizQuestion (image: "Old",
                          text: "Рейтинг этого фильма больше чем 6?",
                          correctAnswer: false),
            QuizQuestion (image: "The Ice Age Adventures of Buck Wild",
                          text: "Рейтинг этого фильма больше чем 6?",
                          correctAnswer: false),
            QuizQuestion (image: "Tesla",
                          text: "Рейтинг этого фильма больше чем 6?",
                          correctAnswer: false),
            QuizQuestion (image: "Vivarium",
                          text: "Рейтинг этого фильма больше чем 6?",
                          correctAnswer: false),
            ]
        return moviesList
    }
    
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        let questionStep = QuizStepViewModel(
             image: UIImage(named: model.image) ?? UIImage(),
             question: model.text,
             questionNumber: "\(currentQuestionIndex + 1)/\(questions.count)")
         return questionStep
        
    }
    
    private func show(quiz step: QuizStepViewModel) {
        imageView.layer.borderWidth = 0
        counterLabel.text = step.questionNumber
        imageView.image = step.image
        textLabel.text = step.question
        
    }
    
    private func setImageBordert(currentImageVeiw: UIImageView,
                                 borderColor: Bool) {
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = borderColor ? UIColor.ypGreenIOS.cgColor : UIColor.ypRedIOS.cgColor
        imageView.layer.cornerRadius = 6
    }
    
    private func show(quiz result: QuizResultsViewModel) {
        let alert = UIAlertController(
            title: result.title,
            message: result.text,
            preferredStyle: .alert)
        
        let action = UIAlertAction(title: result.buttonText, style: .default) { _ in
            self.currentQuestionIndex = 0
            self.correctAnswers = 0
            let firstQuestion = self.questions[self.currentQuestionIndex]
            let viewModel = self.convert(model: firstQuestion)
            self.show(quiz: viewModel)
        }
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    private func showNextQuestionOrResults() {
      if currentQuestionIndex == questions.count - 1 { // 1
          let quizResult = QuizResultsViewModel (title: "Этот раунд окончен!", text: "Ваш результат: \(correctAnswers)", buttonText: "Сыграть ещё раз")
          show(quiz: quizResult)} else {
        currentQuestionIndex += 1
          let nextQuestion = questions[currentQuestionIndex]
          let viewModel = convert(model: nextQuestion)
          show(quiz: viewModel)
      }
    }
    
    private func showAnswerResult(isCorrect: Bool) {
        if isCorrect {
            setImageBordert(currentImageVeiw: imageView, borderColor: isCorrect)
            correctAnswers += 1
        }else {
            setImageBordert(currentImageVeiw: imageView, borderColor: isCorrect)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
           self.showNextQuestionOrResults()
        }
    }
    
    
   
    
    
    
    
   
    
    
    
    
    
    
    
    
    
    
    
    
}

/*
 Mock-данные
 
 
 Картинка: The Godfather
 Настоящий рейтинг: 9,2
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА
 
 
 Картинка: The Dark Knight
 Настоящий рейтинг: 9
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА
 
 
 Картинка: Kill Bill
 Настоящий рейтинг: 8,1
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА
 
 
 Картинка: The Avengers
 Настоящий рейтинг: 8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА
 
 
 Картинка: Deadpool
 Настоящий рейтинг: 8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА
 
 
 Картинка: The Green Knight
 Настоящий рейтинг: 6,6
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА
 
 
 Картинка: Old
 Настоящий рейтинг: 5,8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ
 
 
 Картинка: The Ice Age Adventures of Buck Wild
 Настоящий рейтинг: 4,3
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ
 
 
 Картинка: Tesla
 Настоящий рейтинг: 5,1
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ
 
 
 Картинка: Vivarium
 Настоящий рейтинг: 5,8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ
*/
