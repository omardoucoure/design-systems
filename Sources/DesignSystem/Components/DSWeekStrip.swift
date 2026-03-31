import SwiftUI

// MARK: - DSWeekStripItem

public struct DSWeekStripItem: Identifiable {
    public let id: Int
    public let letter: LocalizedStringKey
    public let number: Int

    public init(id: Int? = nil, letter: LocalizedStringKey, number: Int) {
        self.id = id ?? number
        self.letter = letter
        self.number = number
    }
}

// MARK: - DSWeekStrip

/// A horizontal scrollable week day strip with letter + number layout.
///
/// Figma: HStack, gap=xs(8), each item = VStack(letter + number),
/// rounded-sm, p=sm(12), surfacePrimary120 when selected.
///
/// Usage (modifier API):
/// ```swift
/// DSWeekStrip(items: weekDays, selectedId: $selectedDay)
/// ```
///
/// The component has no visual customization modifiers — it reads all styling from the theme.
public struct DSWeekStrip: View {
    @Environment(\.theme) private var theme

    // Core (required)
    private var _items: [DSWeekStripItem]
    @Binding private var _selectedId: Int

    // MARK: - Init

    /// Creates a week strip with the given day items and selection binding.
    public init(items: [DSWeekStripItem], selectedId: Binding<Int>) {
        self._items = items
        self.__selectedId = selectedId
    }

    public var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: theme.spacing.xs) {
                ForEach(_items) { item in
                    let isSelected = item.id == _selectedId
                    Button {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            _selectedId = item.id
                        }
                    } label: {
                        VStack(spacing: theme.spacing.xxs) {
                            Text(item.letter)
                                .font(theme.typography.tiny.font)
                                .tracking(theme.typography.tiny.tracking)

                            Text("\(item.number)")
                                .font(theme.typography.h5.font)
                                .tracking(theme.typography.h5.tracking)
                        }
                        .padding(theme.spacing.sm)
                        .foregroundStyle(isSelected ? theme.colors.textNeutral05 : theme.colors.textNeutral9)
                        .background(isSelected ? theme.colors.surfacePrimary120 : theme.colors.surfaceNeutral05)
                        .clipShape(RoundedRectangle(cornerRadius: theme.radius.sm))
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }
}
