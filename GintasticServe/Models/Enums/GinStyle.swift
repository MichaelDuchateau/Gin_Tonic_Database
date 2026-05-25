enum GinStyle: String, Codable, CaseIterable, Identifiable {
    case londonDry    = "London Dry"
    case contemporary = "Contemporary"
    case navy         = "Navy Strength"
    case aged         = "Aged / Barrel"
    case sloe         = "Sloe Gin"
    case oldTom       = "Old Tom"
    case genever      = "Genever"
    case american     = "American / New Western"
    case japanese     = "Japanese"
    case other        = "Other"

    var id: String { rawValue }
}
