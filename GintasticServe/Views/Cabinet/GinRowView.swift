import SwiftUI

struct GinRowView: View {
    let gin: Gin

    var body: some View {
        HStack(spacing: 12) {
            AsyncImage(url: gin.bottleImageURL.flatMap(URL.init)) { phase in
                switch phase {
                case .success(let img): img.resizable().scaledToFit()
                default: Image(systemName: "wineglass").font(.title2).foregroundStyle(.secondary)
                }
            }
            .frame(width: 36, height: 52)
            .clipShape(RoundedRectangle(cornerRadius: 4))

            VStack(alignment: .leading, spacing: 2) {
                Text(gin.name).font(.headline)
                Text(gin.distillery).font(.subheadline).foregroundStyle(.secondary)
                HStack(spacing: 6) {
                    Text(gin.country).font(.caption).foregroundStyle(.secondary)
                    Text("·").foregroundStyle(.tertiary)
                    Text(String(format: "%.1f%%", gin.abv)).font(.caption).foregroundStyle(.secondary)
                    Text("·").foregroundStyle(.tertiary)
                    Text(gin.style.rawValue).font(.caption).foregroundStyle(.secondary)
                }
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 4) {
                CabinetStatusBadge(status: gin.cabinetStatus)
                if let rating = gin.userRating {
                    RatingViewReadOnly(rating: rating)
                }
            }
        }
        .padding(.vertical, 4)
    }
}
