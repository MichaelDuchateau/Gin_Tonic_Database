import Foundation
import Observation
import SwiftData

@Observable
final class CabinetViewModel {
    var searchText: String = ""
    var sortOrder: SortOrder = .name
    var filterStyle: GinStyle? = nil

    enum SortOrder: String, CaseIterable, Identifiable {
        case name       = "Name"
        case dateAdded  = "Date Added"
        case abv        = "ABV"
        case rating     = "Rating"
        var id: String { rawValue }
    }

    func filtered(_ gins: [Gin], status: CabinetStatus) -> [Gin] {
        var result = gins.filter { $0.cabinetStatus == status }

        if let style = filterStyle {
            result = result.filter { $0.style == style }
        }

        if !searchText.isEmpty {
            let q = searchText.lowercased()
            result = result.filter {
                $0.name.lowercased().contains(q) ||
                $0.distillery.lowercased().contains(q) ||
                $0.country.lowercased().contains(q)
            }
        }

        switch sortOrder {
        case .name:      return result.sorted { $0.name < $1.name }
        case .dateAdded: return result.sorted { $0.dateAdded > $1.dateAdded }
        case .abv:       return result.sorted { $0.abv > $1.abv }
        case .rating:    return result.sorted { ($0.userRating ?? 0) > ($1.userRating ?? 0) }
        }
    }

    func advanceStatus(of gin: Gin, context: ModelContext) {
        let next = gin.cabinetStatus.nextStatus
        gin.cabinetStatus = next
        if next.setsAcquiredDate { gin.dateAcquired = .now }
        gin.updatedAt = .now
        try? context.save()
    }

    func delete(_ gin: Gin, context: ModelContext) {
        context.delete(gin)
        try? context.save()
    }
}
