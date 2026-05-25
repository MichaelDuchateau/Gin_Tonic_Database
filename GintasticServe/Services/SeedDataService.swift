import Foundation
import Observation

/// Loads seed JSON files into memory at app launch.
/// This service is the sole consumer of Seeds/*.json.
/// It NEVER writes to Swift Data — it is a read-only lookup catalogue.
@Observable
final class SeedDataService {
    private(set) var gins: [SeedGin] = []
    private(set) var tonics: [SeedTonic] = []
    private(set) var garnishes: [SeedGarnish] = []
    private(set) var pairings: [SeedPairing] = []

    init() { load() }

    // MARK: - Search

    func searchGins(query: String) -> [SeedGin] {
        guard !query.trimmingCharacters(in: .whitespaces).isEmpty else { return gins }
        let q = query.lowercased()
        return gins.filter {
            $0.name.lowercased().contains(q) ||
            $0.distillery.lowercased().contains(q) ||
            $0.country.lowercased().contains(q) ||
            $0.botanicals.contains(where: { $0.lowercased().contains(q) })
        }
    }

    func gin(withId id: String) -> SeedGin? {
        gins.first { $0.id == id }
    }

    func pairings(forGinId ginId: String) -> [SeedPairing] {
        pairings.filter { $0.ginId == ginId }
    }

    func tonic(withId id: String) -> SeedTonic? {
        tonics.first { $0.id == id }
    }

    func garnish(withId id: String) -> SeedGarnish? {
        garnishes.first { $0.id == id }
    }

    func garnishes(withIds ids: [String]) -> [SeedGarnish] {
        ids.compactMap { garnish(withId: $0) }
    }

    // MARK: - Private loading

    private func load() {
        gins      = decode("gins")
        tonics    = decode("tonics")
        garnishes = decode("garnishes")
        pairings  = decode("pairings")
    }

    private func decode<T: Decodable>(_ resource: String) -> [T] {
        guard let url = Bundle.main.url(forResource: resource, withExtension: "json"),
              let data = try? Data(contentsOf: url) else {
            assertionFailure("Missing seed file: \(resource).json")
            return []
        }
        do {
            return try JSONDecoder().decode([T].self, from: data)
        } catch {
            assertionFailure("Failed to decode \(resource).json: \(error)")
            return []
        }
    }
}
