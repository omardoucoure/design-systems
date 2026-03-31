import SwiftUI

// MARK: - DSDayPickerItem

public struct DSDayPickerItem: Identifiable {
    public let id: String
    public let label: LocalizedStringKey

    public init(id: String, label: LocalizedStringKey) {
        self.id = id
        self.label = label
    }
}

// MARK: - DSDayPicker

/// A horizontal scrollable day picker with capsule-shaped selection.
///
/// Usage (modifier API):
/// ```swift
/// DSDayPicker(items: dayItems, selectedId: $selectedDay)
/// ```
///
/// The component has no visual customization modifiers — it reads all styling from the theme.
public struct DSDayPicker: View {
    @Environment(\.theme) private var theme

    // Core (required)
    private var _items: [DSDayPickerItem]
    @Binding private var _selectedId: String

    // MARK: - Init

    /// Creates a day picker with the given items and selection binding.
    public init(items: [DSDayPickerItem], selectedId: Binding<String>) {
        self._items = items
        self.__selectedId = selectedId
    }

    public var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: theme.spacing.xxs) {
                ForEach(Array(_items.enumerated()), id: \.element.id) { index, item in
                    let isSelected = item.id == _selectedId
                    Button {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                            _selectedId = item.id
                        }
                    } label: {
                        Text(item.label)
                            .font(theme.typography.label.font)
                            .tracking(theme.typography.label.tracking)
                            .foregroundStyle(isSelected ? theme.colors.textNeutral05 : theme.colors.textNeutral9)
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
        guard let selectedIndex = _items.firstIndex(where: { $0.id == _selectedId }) else {
            return 1.0
        }
        let distance = abs(index - _items.distance(from: _items.startIndex, to: selectedIndex))
        switch distance {
        case 0: return 1.0
        case 1: return 1.0
        case 2: return 0.7
        case 3: return 0.5
        default: return 0.3
        }
    }
}
