import Foundation

struct SeedPairing: Codable, Identifiable {
    let id: String
    let ginId: String
    let tonicId: String
    let ginVolumeMl: Int
    let tonicVolumeMl: Int
    let glassType: String
    let iceType: String
    let garnishIds: [String]
    let notes: String?
    let source: String
}
