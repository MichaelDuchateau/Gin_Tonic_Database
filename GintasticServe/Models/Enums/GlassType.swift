enum GlassType: String, Codable, CaseIterable, Identifiable {
    case copa     = "Copa / Balloon"
    case highball = "Highball"
    case rocks    = "Rocks / Old Fashioned"
    case flute    = "Flute"

    var id: String { rawValue }
}
