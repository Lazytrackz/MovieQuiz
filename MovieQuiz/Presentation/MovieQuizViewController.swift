import UIKit


//MARK: - ViewController

final class MovieQuizViewController: UIViewController, MovieQuizViewControllerProtocol {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak private var yesButton: UIButton!
    @IBOutlet weak private var noButton: UIButton!
    @IBOutlet weak private var counterLabel: UILabel!
    @IBOutlet weak private var imageView: UIImageView!
    @IBOutlet weak private var textLabel: UILabel!
    @IBOutlet weak private var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - Properties
    
    private var presenter: MovieQuizPresenter!
    //private var questionFactory: QuestionFactoryProtocol?
    private var alertPresenter: AlertPresenter = AlertPresenter()
    //private var staticService: StatisticServiceProtocol?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter = MovieQuizPresenter(viewController: self)
        activityIndicator.hidesWhenStopped = true
    }
    
    // MARK: - Actions
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        presenter.noButtonClicked()
    }
    
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        presenter.yesButtonClicked()
    }
    
    // MARK: - Methods
    
    func show(quiz step: QuizStepViewModel) {
        imageView.layer.cornerRadius = 20
        imageView.layer.borderWidth = 0
        counterLabel.text = step.questionNumber
        imageView.image = UIImage(data: step.image) ?? UIImage()
        textLabel.text = step.question
        enableButtons(true)
    }
    
    func setImageBorder(borderColor: Bool) {
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = borderColor ? UIColor.ypGreenIOS.cgColor : UIColor.ypRedIOS.cgColor
        imageView.layer.cornerRadius = 20
    }
    
    func showResult(quiz result: QuizResultsViewModel) {
        let alertModel = AlertModel(title: result.title,
                                    message: result.text,
                                    buttonText: result.buttonText,
                                    completion:{ [weak self] in
            guard let self = self else { return }
            self.presenter.restartGame()
            
        })
        
        alertPresenter.show(alertModel: alertModel, controller: self, accessibilityId: "GameResults")
    }
    
    
    func showNetworkError(message: String) {
        activityIndicator.stopAnimating()
        
        let alertModel = AlertModel(title: ErrorAlertTitle.titleString,
                                    message: message,
                                    buttonText: ErrorAlertTitle.buttonString){ [weak self] in guard let self = self else { return }
            self.presenter.restartGame()
        }
        alertPresenter.show(alertModel: alertModel, controller: self, accessibilityId: "NetworkError")
    }
    
    func showImageDataError(message: String) {
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            let alertModel = AlertModel(title: ErrorAlertTitle.titleString,
                                        message: message,
                                        buttonText: ErrorAlertTitle.buttonString){ [weak self] in guard let self = self else { return }
                self.presenter.restartGame()
            }
            alertPresenter.show(alertModel: alertModel, controller: self, accessibilityId: "ImageError")
        }
    }
    
    func enableButtons(_ isEnable: Bool) {
        yesButton.isEnabled = isEnable
        noButton.isEnabled = isEnable
        
    }
    
    func setActivityIndicator(isActive: Bool) {
        if isActive {
            activityIndicator.startAnimating()
        }else {
            activityIndicator.stopAnimating()
        }
        
    }
    
    
}

