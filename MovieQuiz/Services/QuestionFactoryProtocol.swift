protocol QuestionFactoryProtocol {
    var questionsAmount: Int { get }
    
    func requestNextQuestion()
}
