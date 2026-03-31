import SwiftUI

// MARK: - DSStatItem

public struct DSStatItem: Identifiable {
    public let id: String
    public let label: LocalizedStringKey

    public init(id: String, label: LocalizedStringKey) {
        self.id = id
        self.label = label
    }
}

// MARK: - DSStatRow

/// A row of equal-width stat columns with vertical dividers between them.
///
/// Usage (modifier-based):
/// ```swift
/// DSStatRow(items: stats) { item in
///     Text("1,268")
///         .font(theme.typography.largeSemiBold.font)
/// }
/// .statDividerColor(theme.colors.textNeutral9)
/// ```
public struct DSStatRow<ValueContent: View>: View {
    @Environment(\.theme) private var theme

    private let _items: [DSStatItem]
    private let _valueContent: (DSStatItem) -> ValueContent
    private var _dividerColor: Color?

    // MARK: - Minimal init

    public init(
        items: [DSStatItem],
        @ViewBuilder valueContent: @escaping (DSStatItem) -> ValueContent
    ) {
        self._items = items
        self._valueContent = valueContent
    }

    // MARK: - Deprecated init

    @available(*, deprecated, message: "Use DSStatRow(items:valueContent:) with .statDividerColor() modifier instead")
    public init(
        items: [DSStatItem],
        dividerColor: Color?,
        @ViewBuilder valueContent: @escaping (DSStatItem) -> ValueContent
    ) {
        self._items = items
        self._dividerColor = dividerColor
        self._valueContent = valueContent
    }

    // MARK: - Modifiers

    /// Sets the color of the vertical dividers between stat columns.
    public func statDividerColor(_ color: Color) -> DSStatRow {
        var copy = self
        copy._dividerColor = color
        return copy
    }

    // MARK: - Body

    public var body: some View {
        HStack(spacing: 0) {
            ForEach(Array(_items.enumerated()), id: \.element.id) { index, item in
                VStack(spacing: 0) {
                    _valueContent(item)

                    Text(item.label)
                        .font(.system(size: 10, weight: .medium))
                        .tracking(-0.2)
                        .foregroundStyle(theme.colors.textNeutral9.opacity(theme.colors.textOpacity50))
                }
                .padding(theme.spacing.md)
                .frame(maxWidth: .infinity)

                if index < _items.count - 1 {
                    Rectangle()
                        .fill(_dividerColor ?? theme.colors.textNeutral9)
                        .frame(width: theme.borders.widthSm)
                }
            }
        }
    }
}
