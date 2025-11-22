import UIKit

protocol MovieQuizViewControllerProtocol: AnyObject {
    func show(quiz step: QuizStepViewModel)
    func show(result: QuizResultsViewModel)
    
    func highlightImageBorder(isCorrectAnswer: Bool)
    
    func showLoadingIndicator()
    func hideLoadingIndicator()
    
    func showNetworkError(message: String)
    
    func enableButtons()
}

final class MovieQuizViewController: UIViewController, MovieQuizViewControllerProtocol {

    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var textLabel: UILabel!
    @IBOutlet private var counterLabel: UILabel!
    @IBOutlet private var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet var buttons: [UIButton]!
    
    private var presenter: MovieQuizPresenter!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.layer.cornerRadius = 20
                
        presenter = MovieQuizPresenter(viewController: self)
    }
    
    private var questionFactory: QuestionFactoryProtocol?
        
    private let alertPresenter = AlertPresenter()
    
    
    func show(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
    }
    
    func show(result: QuizResultsViewModel) {
        
        let model = AlertModel(
            title: result.title,
            message: result.text,
            buttonText: result.buttonText,
            completion: { [weak self] in
                guard let self else { return }
                presenter.restartGame()
                self.questionFactory?.requestNextQuestion()
            })
        
        alertPresenter.show(viewController: self, model: model)
    }

    
    func highlightImageBorder(isCorrectAnswer: Bool) {
        imageView.layer.borderColor = isCorrectAnswer ? UIColor.green.cgColor : UIColor.red.cgColor
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.cornerRadius = 20
        
        disableButtons()
    }
    
    func enableButtons() {
        imageView.layer.borderColor = UIColor.clear.cgColor
        buttons.forEach {
            $0.isEnabled = true
            $0.alpha = 1
        }
    }
    
    func disableButtons() {
        buttons.forEach {
            $0.isEnabled = false
            $0.alpha = 0.5
        }
    }
    
    func showLoadingIndicator() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    func hideLoadingIndicator() {
        activityIndicator.isHidden = true
        activityIndicator.stopAnimating()
    }
    
    func showNetworkError(message: String) {
        hideLoadingIndicator()
        
        alertPresenter.show(
            viewController: self,
            model: AlertModel(
                title: "Ошибка",
                message: message,
                buttonText: "Попробовать ещё раз",
                completion: { [weak self] in
                    guard let self else { return }
                    
                    presenter.restartGame()
                    self.questionFactory?.requestNextQuestion()
                }
            )
        )
    }
    
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        presenter.yesButtonClicked()
    }
        
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        presenter.noButtonClicked()
    }
}
