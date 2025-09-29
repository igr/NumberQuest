import os
import Foundation
import SwiftData

/// Repository responsible for all GameProgressData SwiftData operations.
class GameRepo {

    private static let logger = Logger(
        subsystem: Bundle.main.bundleIdentifier!,
        category: String(describing: GameRepo.self)
    )
    
    private var context: ModelContext?
    private var gameProgress: GameProgressData
    
    init() {
        self.gameProgress = .init()
    }
    
    /// Fetch or create persistent progress data
    func setupGameProgress(context: ModelContext) {
        self.context = context
        //if let existing = _gameProgress { return existing }
        let descriptor = FetchDescriptor<GameProgressData>()
        do {
            let existingProgress = try context.fetch(descriptor)
            if let existing = existingProgress.first {
                gameProgress = existing
                Self.logger.info("Game loaded from storage")
                return
            } else {
                let newProgress = GameProgressData()
                context.insert(newProgress)
                try context.save()
                gameProgress = newProgress
                Self.logger.info("Game not found, creating new one")
                return
            }
        } catch {
            Self.logger.warning("Error fetching GameProgressData: \(error)")
            let newProgress = GameProgressData()
            context.insert(newProgress)
            do {
                try context.save()
            } catch {
                Self.logger.error("Error saving new GameProgressData after fetch failure: \(error)")
            }
            gameProgress = newProgress
            return
        }
    }
    
    /// Get cached progress object (must call setupGameProgress first)
    var progress: GameProgressData {
        return gameProgress
    }
    
    /// Update progress data for minimum attempts (returns true if updated)
    func updateMinAttempts(_ attempts: Int) {
        //guard let progress = _gameProgress else { return }
        if attempts < progress.getMinAttempts() {
            progress.setMinAttempts(attempts)
            save()
        }
    }
    
    /// Mark a trick as encountered
    func markTrickEncountered(_ trickType: TrickType) {
        //guard let progress = _gameProgress else { return }
        progress.setTrickState(trickType, true)
        save()
    }
    
    /// Mark all active tricks as encountered
    func markTricksEncountered(_ activeTricks: [ActiveTrick]) {
        //guard let progress = _gameProgress else { return }
        for activeTrick in activeTricks {
            progress.setTrickState(activeTrick.trick.type, true)
        }
        save()
    }
    
    /// Save context
    private func save() {
        do {
            try context!.save()
        } catch {
            Self.logger.error("Error saving progress data: \(error)")
        }
    }
}
