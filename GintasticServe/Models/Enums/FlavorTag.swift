enum FlavorTag: String, Codable, CaseIterable, Identifiable {
    case juniper, citrus, floral, herbal, spice, earthy,
         sweet, fruity, woody, marine, cucumber, tropical,
         smoky, vegetal, anise

    var id: String { rawValue }

    var label: String { rawValue.capitalized }
}
