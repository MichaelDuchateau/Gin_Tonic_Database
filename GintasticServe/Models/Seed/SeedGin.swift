import Foundation

struct SeedGin: Codable, Identifiable {
    let id: String
    let name: String
    let distillery: String
    let country: String
    let region: String?
    let style: String
    let abv: Double
    let botanicals: [String]
    let tasteNose: String?
    let tastePalate: String?
    let tasteFinish: String?
    let flavorTags: [String]
    let officialURL: String?
    let bottleImageURL: String?
}
