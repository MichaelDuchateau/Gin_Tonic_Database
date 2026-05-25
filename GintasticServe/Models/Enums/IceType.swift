enum IceType: String, Codable, CaseIterable, Identifiable {
    case cubed   = "Ice cubes"
    case crushed = "Crushed ice"
    case sphere  = "Ice sphere"
    case large   = "Large block"
    case none    = "No ice"

    var id: String { rawValue }
}
