import SwiftUI
import SwiftData

struct SettingsView: View {
    @Query private var gins: [Gin]
    @Query private var tonics: [Tonic]
    @Query private var pairings: [GinTonicPairing]
    @Query private var recipes: [Recipe]

    var body: some View {
        List {
            Section("Library") {
                LabeledContent("Gins in Cabinet", value: "\(gins.count)")
                LabeledContent("Tonics", value: "\(tonics.count)")
                LabeledContent("Pairings", value: "\(pairings.count)")
                LabeledContent("Recipes", value: "\(recipes.count)")
            }

            Section("About") {
                LabeledContent("App", value: "The Gintastic Serve")
                LabeledContent("Version", value: Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0")
            }

            // Placeholder for future settings
            Section("Preferences") {
                // Default volumes, default glass type, etc. — v1.1
                Text("More settings coming in a future update.")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .navigationTitle("Settings")
    }
}
