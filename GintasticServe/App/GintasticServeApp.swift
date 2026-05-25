import SwiftUI
import SwiftData

@main
struct GintasticServeApp: App {
    private let container: ModelContainer
    private let seedService = SeedDataService()

    init() {
        do {
            container = try ModelContainerFactory.makeContainer()
        } catch {
            fatalError("Failed to create ModelContainer: \(error)")
        }
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(seedService)
        }
        .modelContainer(container)
    }
}
