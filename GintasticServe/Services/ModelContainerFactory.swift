import Foundation
import SwiftData

enum ModelContainerFactory {
    static func makeContainer() throws -> ModelContainer {
        let schema = Schema([
            Gin.self,
            Tonic.self,
            Garnish.self,
            GinTonicPairing.self,
            Recipe.self
        ])
        let config = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        return try ModelContainer(for: schema, configurations: [config])
    }

    /// In-memory container for SwiftUI previews and unit tests.
    static func makePreviewContainer() throws -> ModelContainer {
        let schema = Schema([
            Gin.self,
            Tonic.self,
            Garnish.self,
            GinTonicPairing.self,
            Recipe.self
        ])
        let config = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)
        return try ModelContainer(for: schema, configurations: [config])
    }
}
