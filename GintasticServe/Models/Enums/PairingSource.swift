enum PairingSource: String, Codable, CaseIterable, Identifiable {
    case distilleryRecommended = "Distillery recommended"
    case editorial             = "Editorial / curated"
    case userCreated           = "User created"

    var id: String { rawValue }
}
