enum GarnishCategory: String, Codable, CaseIterable, Identifiable {
    case citrus    = "Citrus"
    case herb      = "Herb"
    case spice     = "Spice"
    case floral    = "Floral"
    case vegetable = "Vegetable"
    case berry     = "Berry"
    case other     = "Other"

    var id: String { rawValue }
}
