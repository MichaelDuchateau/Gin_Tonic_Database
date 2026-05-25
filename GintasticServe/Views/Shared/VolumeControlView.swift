import SwiftUI

struct VolumeControlView: View {
    let label: String
    @Binding var volume: Int
    var range: ClosedRange<Int> = 20...100
    var step: Int = 5

    var body: some View {
        HStack {
            Text(label)
            Spacer()
            Stepper("\(volume) ml", value: $volume, in: range, step: step)
                .fixedSize()
        }
    }
}
