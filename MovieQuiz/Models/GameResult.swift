import Foundation

struct GameResult {
    let correct: Int
    let total: Int
    let date: Date

    func isBetterThan(gameResult: GameResult) -> Bool {
        gameResult.correct > correct
    }
}
