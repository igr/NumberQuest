import SwiftUI
import SwiftData

@Model
class GameProgressData {
    var trickStates: [String: Bool] = [:]
    var minAttempts: Int
    
    init() {
        minAttempts = Int.max
        for trick in AllTricks.tricks {
            trickStates[trick.type.asString] = false
        }        
    }
    
    func getTrickState(_ trickType: TrickType) -> Bool {
        return trickStates[trickType.asString] ?? false
    }
    
    func setTrickState(_ trickType: TrickType, _ state: Bool) {
        trickStates[trickType.asString] = state
    }
    
    func getMinAttempts() -> Int {
        return minAttempts
    }
    
    func setMinAttempts(_ attempts: Int) {
        minAttempts = attempts
    }
}

