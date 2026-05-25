import Foundation
import SwiftData

@Model
final class Garnish {
    @Attribute(.unique) var id: UUID
    var name: String
    var category: GarnishCategory
    var preparation: String?
    var isUserAdded: Bool

    init(
        id: UUID = UUID(),
        name: String,
        category: GarnishCategory = .other,
        preparation: String? = nil,
        isUserAdded: Bool = true
    ) {
        self.id = id
        self.name = name
        self.category = category
        self.preparation = preparation
        self.isUserAdded = isUserAdded
    }
}
