import UIKit


//MARK: - ViewController

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate  {

    // MARK: - IBOutlets
    
    @IBOutlet weak private var counterLabel: UILabel!
    @IBOutlet weak private var imageView: UIImageView!
    @IBOutlet weak private var textLabel: UILabel!
    
    // MARK: - Properties
    
    private var currentQuestionIndex = 0
    private var correctAnswers = 0
    
    private let questionsAmount: Int = 10
    private var questionFactory: QuestionFactoryProtocol?
    private var currentQuestion: QuizQuestion?
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let questionFactory = QuestionFactory() // 2
            questionFactory.setDelegate(self)        // 3
            self.questionFactory = questionFactory  // 4

        
        self.questionFactory?.requestNextQuestion()
        
    
        
    }
    
    
    // MARK: - QuestionFactoryDelegate
    


    func didReceiveNextQuestion(question: QuizQuestion?) {
        
        // проверка, что вопрос не nil
        guard let question = question else {
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
        let questionStep = QuizStepViewModel(
             image: UIImage(named: model.imageString) ?? UIImage(),
             question: model.text,
             questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
         return questionStep
        
    }
    
    private func show(quiz step: QuizStepViewModel) {
        imageView.layer.cornerRadius = 20
        imageView.layer.borderWidth = 0
        counterLabel.text = step.questionNumber
        imageView.image = step.image
        textLabel.text = step.question
        
    }
    
    private func setImageBorder(currentImageVeiw: UIImageView,
                                 borderColor: Bool) {
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = borderColor ? UIColor.ypGreenIOS.cgColor : UIColor.ypRedIOS.cgColor
        imageView.layer.cornerRadius = 20
    }
    
    private func showResult(quiz result: QuizResultsViewModel) {
        let alert = UIAlertController(
            title: result.title,
            message: result.text,
            preferredStyle: .alert)
        
        let action = UIAlertAction(title: result.buttonText, style: .default) { [weak self] _ in
            guard let self = self else { return
            }
            self.currentQuestionIndex = 0
            self.correctAnswers = 0
            questionFactory?.requestNextQuestion()
        }
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    func showNextQuestionOrResults() {
    
        if currentQuestionIndex == questionsAmount - 1 {
            let quizResult = QuizResultsViewModel (title: "Этот раунд окончен!", text: "Ваш результат: \(correctAnswers)", buttonText: "Сыграть ещё раз")
            showResult(quiz: quizResult)}
        else {
            currentQuestionIndex += 1
            self.questionFactory?.requestNextQuestion()
        }
    }
    
    func showAnswerResult(isCorrect: Bool) {
        if isCorrect {
            setImageBorder(currentImageVeiw: imageView, borderColor: isCorrect)
            correctAnswers += 1
        }else {
            setImageBorder(currentImageVeiw: imageView, borderColor: isCorrect)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self else {return}
            showNextQuestionOrResults()
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
