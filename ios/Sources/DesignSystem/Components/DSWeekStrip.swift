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
/// Usage:
/// ```swift
/// DSWeekStrip(
///     items: [
///         DSWeekStripItem(letter: "M", number: 6),
///         DSWeekStripItem(letter: "T", number: 7),
///         DSWeekStripItem(letter: "W", number: 8),
///     ],
///     selectedId: $selectedDay
/// )
/// ```
public struct DSWeekStrip: View {
    @Environment(\.theme) private var theme

    private let items: [DSWeekStripItem]
    @Binding private var selectedId: Int

    public init(items: [DSWeekStripItem], selectedId: Binding<Int>) {
        self.items = items
        self._selectedId = selectedId
    }

    public var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: theme.spacing.xs) {
                ForEach(items) { item in
                    let isSelected = item.id == selectedId
                    Button {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            selectedId = item.id
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
                        .foregroundStyle(isSelected ? theme.colors.textNeutral0_5 : theme.colors.textNeutral9)
                        .background(isSelected ? theme.colors.surfacePrimary120 : theme.colors.surfaceNeutral0_5)
                        .clipShape(RoundedRectangle(cornerRadius: theme.radius.sm))
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }
}
