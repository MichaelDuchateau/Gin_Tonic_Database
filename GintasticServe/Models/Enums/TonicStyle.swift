enum TonicStyle: String, Codable, CaseIterable, Identifiable {
    case indian        = "Indian"
    case mediterranean = "Mediterranean"
    case light         = "Light / Slim"
    case aromatic      = "Aromatic"
    case elderflower   = "Elderflower"
    case citrus        = "Citrus"
    case cucumber      = "Cucumber"
    case berry         = "Berry"
    case spiced        = "Spiced"
    case other         = "Other"

    var id: String { rawValue }
}
