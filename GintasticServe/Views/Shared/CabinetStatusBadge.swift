import SwiftUI

struct CabinetStatusBadge: View {
    let status: CabinetStatus

    var body: some View {
        Label(status.rawValue, systemImage: status.systemImage)
            .font(.caption.weight(.medium))
            .foregroundStyle(status.color)
            .padding(.horizontal, 8)
            .padding(.vertical, 3)
            .background(status.color.opacity(0.12), in: Capsule())
    }
}
