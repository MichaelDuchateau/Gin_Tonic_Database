import Foundation
import Observation
import SwiftData

@Observable
final class DiscoverViewModel {
    var searchText: String = ""
    var results: [SeedGin] = []
    var selectedSeedGin: SeedGin? = nil
    var pendingStatus: CabinetStatus = .own
    var showAddSheet: Bool = false

    private let seedService: SeedDataService

    init(seedService: SeedDataService) {
        self.seedService = seedService
    }

    func search() {
        results = seedService.searchGins(query: searchText)
    }

    func seedPairings(for gin: SeedGin) -> [SeedPairing] {
        seedService.pairings(forGinId: gin.id)
    }

    func seedTonic(for pairing: SeedPairing) -> SeedTonic? {
        seedService.tonic(withId: pairing.tonicId)
    }

    func seedGarnishes(for pairing: SeedPairing) -> [SeedGarnish] {
        seedService.garnishes(withIds: pairing.garnishIds)
    }

    func addToCabinet(gin seedGin: SeedGin, status: CabinetStatus, context: ModelContext) {
        let gin = Gin.from(seed: seedGin, status: status)
        context.insert(gin)
        try? context.save()
        showAddSheet = false
    }

    func isAlreadyInCabinet(_ seedGin: SeedGin, existingGins: [Gin]) -> Bool {
        existingGins.contains { $0.seedId == seedGin.id }
    }
}
