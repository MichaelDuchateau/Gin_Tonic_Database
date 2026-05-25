import SwiftUI

struct TasteProfileView: View {
    let gin: Gin

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            if !gin.flavorTags.isEmpty {
                FlavorTagView(tags: gin.flavorTags)
            }
            if let nose = gin.tasteNose {
                LabeledContent("Nose", value: nose)
            }
            if let palate = gin.tastePalate {
                LabeledContent("Palate", value: palate)
            }
            if let finish = gin.tasteFinish {
                LabeledContent("Finish", value: finish)
            }
            if gin.tasteNose == nil && gin.tastePalate == nil && gin.tasteFinish == nil {
                Text("No tasting notes yet.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.vertical, 4)
    }
}
