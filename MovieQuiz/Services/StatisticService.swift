import Foundation

final class StatisticService: StatisticServiceProtocol {
    
    private enum Keys: String {
        case gamesCount
        case bestGameCorrect
        case bestGameTotal
        case bestGameDate
        case totalCorrectAnswers
        case totalQuestionsAsked
    }
    
    private let storage: UserDefaults = .standard
    
    var gamesCount: Int {
        get {
            storage.integer(forKey: Keys.gamesCount.rawValue)
        }
        set {
            storage.set(newValue, forKey: Keys.gamesCount.rawValue)
        }
    }
    
    var totalCorrectAnswers: Int {
        get {
            storage.integer(forKey: Keys.totalCorrectAnswers.rawValue)
        }
        set {
            storage.set(newValue, forKey: Keys.totalCorrectAnswers.rawValue)
        }
    }
    
    var totalQuestionsAsked: Int {
        get {
            storage.integer(forKey: Keys.totalQuestionsAsked.rawValue)
        }
        set {
            storage.set(newValue, forKey: Keys.totalQuestionsAsked.rawValue)
        }
    }
    
    var bestGame: GameResult {
        get {
            return GameResult(
                correct: storage.integer(forKey: Keys.bestGameCorrect.rawValue),
                total: storage.integer(forKey: Keys.bestGameTotal.rawValue),
                date: storage.object(forKey: Keys.bestGameDate.rawValue) as? Date ?? Date()
            )
        }
        set {
            storage.set(newValue.correct, forKey: Keys.bestGameCorrect.rawValue)
            storage.set(newValue.total, forKey: Keys.bestGameTotal.rawValue)
            storage.set(newValue.date, forKey: Keys.bestGameDate.rawValue)
        }
    }
    
    
    var totalAccuracy: Double {
        Double(totalCorrectAnswers)/Double(totalQuestionsAsked) * 100
    }
    
    func store(result: GameResult, questionAmount: Int) {
        self.totalQuestionsAsked += questionAmount
        self.totalCorrectAnswers += result.correct
        self.gamesCount += 1
        
        if self.bestGame.isBetterThan(gameResult: result) {
            self.bestGame = result
        }
    }
}
