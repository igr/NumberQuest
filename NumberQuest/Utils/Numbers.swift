import Foundation

/// Utility functions for number manipulation in the game
struct Numbers {
    
    /// Clips a number to be within the valid game range of 0-999
    /// - Parameter value: The number to clip
    /// - Returns: A number constrained between 0 and 999 inclusive
    static func clip(_ value: Int) -> Int {
        return min(999, max(0, value))
    }
}
