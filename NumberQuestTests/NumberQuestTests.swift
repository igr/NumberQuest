import Testing
@testable import NumberQuest

struct NumberQuestTests {

    @Test func testMirrorTrick() async throws {
        let mirrorTrick = MirrorTrick(duration: 1)

        // Test reversing a 3-digit number
        let result1 = mirrorTrick.triggerOnGuess(target: 100, guess: 123)
        #expect(result1 == 321)

        // Test reversing a 2-digit number
        let result2 = mirrorTrick.triggerOnGuess(target: 100, guess: 45)
        #expect(result2 == 540)

        // Test reversing a single digit
        let result3 = mirrorTrick.triggerOnGuess(target: 100, guess: 7)
        #expect(result3 == 700)

        // Test with numbers that have trailing zeros
        let result4 = mirrorTrick.triggerOnGuess(target: 100, guess: 120)
        #expect(result4 == 21) // "120" reversed is "021" which becomes 21

        // Test with 4-digit number
        let result5 = mirrorTrick.triggerOnGuess(target: 100, guess: 1234)
        #expect(result5 == 4321)
    }

}
