import SwiftUI

struct GarnishPickerView: View {
    let allGarnishes: [Garnish]
    @Binding var selected: Set<Garnish>

    var body: some View {
        ForEach(GarnishCategory.allCases) { category in
            let group = allGarnishes.filter { $0.category == category }
            if !group.isEmpty {
                Section(category.rawValue) {
                    ForEach(group) { garnish in
                        Button {
                            if selected.contains(garnish) { selected.remove(garnish) }
                            else { selected.insert(garnish) }
                        } label: {
                            HStack {
                                Text(garnish.name)
                                Spacer()
                                if selected.contains(garnish) {
                                    Image(systemName: "checkmark").foregroundStyle(.accentColor)
                                }
                            }
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
        }
    }
}
