import SwiftUI

enum CabinetStatus: String, Codable, CaseIterable, Identifiable {
    case own      = "Own"
    case had      = "Had"
    case wishlist = "Wishlist"

    var id: String { rawValue }

    var color: Color {
        switch self {
        case .own:      return .green
        case .had:      return Color(.systemGray)
        case .wishlist: return .orange
        }
    }

    var systemImage: String {
        switch self {
        case .own:      return "cabinet.fill"
        case .had:      return "checkmark.circle.fill"
        case .wishlist: return "star.circle.fill"
        }
    }

    var nextStatus: CabinetStatus {
        switch self {
        case .wishlist: return .own
        case .own:      return .had
        case .had:      return .wishlist
        }
    }

    var nextStatusLabel: String {
        switch self {
        case .wishlist: return "I bought it"
        case .own:      return "I finished it"
        case .had:      return "Add again"
        }
    }

    var setsAcquiredDate: Bool { self == .own }
}
