import Foundation

struct SeedTonic: Codable, Identifiable {
    let id: String
    let name: String
    let brand: String
    let style: String
    let flavorDescription: String?
    let flavorTags: [String]
    let officialURL: String?
}
