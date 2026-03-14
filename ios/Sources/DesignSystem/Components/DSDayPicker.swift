import SwiftUI

// MARK: - DSDayPickerItem

/// A single selectable item in a ``DSDayPicker``.
public struct DSDayPickerItem: Identifiable {
    public let id: String
    public let label: LocalizedStringKey

    public init(id: String, label: LocalizedStringKey) {
        self.id = id
        self.label = label
    }
}

// MARK: - DSDayPicker

/// Horizontal scrolling day picker with capsule-shaped selections and opacity-based distance fading.
///
/// Items further from the current selection fade out to draw focus to the active day.
///
/// ```swift
/// DSDayPicker(
///     items: days,
///     selectedId: $selectedDay
/// )
/// ```
public struct DSDayPicker: View {
    @Environment(\.theme) private var theme

    private let items: [DSDayPickerItem]
    @Binding private var selectedId: String

    public init(items: [DSDayPickerItem], selectedId: Binding<String>) {
        self.items = items
        self._selectedId = selectedId
    }

    public var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: theme.spacing.xxs) {
                ForEach(Array(items.enumerated()), id: \.element.id) { index, item in
                    let isSelected = item.id == selectedId
                    Button {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                            selectedId = item.id
                        }
                    } label: {
                        Text(item.label)
                            .font(theme.typography.label.font)
                            .tracking(theme.typography.label.tracking)
                            .foregroundStyle(isSelected ? theme.colors.textNeutral0_5 : theme.colors.textNeutral9)
                            .padding(.horizontal, theme.spacing.sm)
                            .padding(.vertical, theme.spacing.xxs)
                            .frame(height: 32)
                            .background(isSelected ? theme.colors.surfacePrimary120 : .clear)
                            .clipShape(Capsule())
                    }
                    .buttonStyle(.plain)
                    .opacity(isSelected ? 1.0 : opacityForDistance(index: index))
                }
            }
            .padding(.horizontal, theme.spacing.xs)
            .padding(.vertical, theme.spacing.md)
        }
    }

    private func opacityForDistance(index: Int) -> Double {
        guard let selectedIndex = items.firstIndex(where: { $0.id == selectedId }) else {
            return 1.0
        }
        let distance = abs(index - items.distance(from: items.startIndex, to: selectedIndex))
        switch distance {
        case 0: return 1.0
        case 1: return 1.0
        case 2: return 0.7
        case 3: return 0.5
        default: return 0.3
        }
    }
}
