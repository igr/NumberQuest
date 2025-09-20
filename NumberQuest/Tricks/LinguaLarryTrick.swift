
struct LinguaLarryTrick: GameTrick {
    var type = TrickType.linguaLarry
    var icon = "🈳"
    var name = "Language Larry"
    var message = "Reply language changed."
    var description = "Each turn, the reply to your guess is shown in a random language."
    var duration = 2
    
    func triggerOnShowMiss(systemMessage: SystemMessage) -> SystemMessage? {
        switch (systemMessage.messageType) {
        case .tooLow(let currentGuess, _):
            let randomTranslation = tooLowTranslations.randomElement() ?? "Too Low"
            return SystemMessage(type: .tooLow(currentGuess: currentGuess, content: "\(randomTranslation)"))
        case .tooHigh(let currentGuess, _):
            let randomTranslation = tooHighTranslations.randomElement() ?? "Too High"
            return SystemMessage(type: .tooHigh(currentGuess: currentGuess, content: "\(randomTranslation)"))
        default:
            return nil
        }
    }
    
    let tooHighTranslations: [String] = [
        "太高",           // Mandarin Chinese
        "Demasiado alto", // Spanish
        "Too High",       // English
        "बहुत ऊँचा",      // Hindi
        "مرتفـع جدًا",    // Arabic
        "খুব উঁচু",       // Bengali
        "Muito alto",     // Portuguese
        "Слишком высоко", // Russian
        "高すぎる",        // Japanese
        "ਬਹੁਤ ਉੱਚਾ",      // Punjabi
        "Zu hoch",        // German
        "Kelewihan dhuwur", // Javanese
        "너무 높다",       // Korean
        "Trop haut",      // French
        "Çok yüksek",     // Turkish
        "Quá cao",        // Vietnamese
        "بہت اونچا",      // Urdu
        "Troppo alto",    // Italian
        "खूप उंच",         // Marathi
        "చాలా ఎత్తు"        // Telugu
    ]
    let tooLowTranslations: [String] = [
        "太低",           // Mandarin Chinese
        "Demasiado bajo", // Spanish
        "Too Low",        // English
        "बहुत नीचा",      // Hindi
        "منخفض جدًا",     // Arabic
        "খুব নিচু",       // Bengali
        "Muito baixo",    // Portuguese
        "Слишком низко",  // Russian
        "低すぎる",        // Japanese
        "ਬਹੁਤ ਨੀਵਾਂ",     // Punjabi
        "Zu niedrig",     // German
        "Kelewihan endhek", // Javanese
        "너무 낮다",       // Korean
        "Trop bas",       // French
        "Çok düşük",      // Turkish
        "Quá thấp",       // Vietnamese
        "بہت نیچا",      // Urdu
        "Troppo basso",   // Italian
        "खूप खाली",        // Marathi
        "చాలా తక్కువ"       // Telugu
    ]
}
