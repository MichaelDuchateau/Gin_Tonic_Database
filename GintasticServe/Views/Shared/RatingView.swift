import SwiftUI

struct RatingView: View {
    @Binding var rating: Int?
    var maxStars: Int = 5
    var interactive: Bool = true

    var body: some View {
        HStack(spacing: 4) {
            ForEach(1...maxStars, id: \.self) { star in
                Image(systemName: star <= (rating ?? 0) ? "star.fill" : "star")
                    .foregroundStyle(star <= (rating ?? 0) ? .yellow : Color(.systemGray3))
                    .font(.title3)
                    .onTapGesture {
                        guard interactive else { return }
                        if rating == star { rating = nil } else { rating = star }
                    }
            }
        }
    }
}

struct RatingViewReadOnly: View {
    let rating: Int?

    var body: some View {
        if let r = rating {
            HStack(spacing: 2) {
                Image(systemName: "star.fill").foregroundStyle(.yellow)
                Text("\(r)").font(.caption.weight(.semibold))
            }
        }
    }
}
