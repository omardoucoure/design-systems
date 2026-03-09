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
/// Usage:
/// ```swift
/// DSStatRow(items: stats, dividerColor: theme.colors.textNeutral9) { item in
///     Text("1,268")
///         .font(theme.typography.largeSemiBold.font)
/// }
/// ```
public struct DSStatRow<ValueContent: View>: View {
    @Environment(\.theme) private var theme

    private let items: [DSStatItem]
    private let dividerColor: Color?
    private let valueContent: (DSStatItem) -> ValueContent

    public init(
        items: [DSStatItem],
        dividerColor: Color? = nil,
        @ViewBuilder valueContent: @escaping (DSStatItem) -> ValueContent
    ) {
        self.items = items
        self.dividerColor = dividerColor
        self.valueContent = valueContent
    }

    public var body: some View {
        HStack(spacing: 0) {
            ForEach(Array(items.enumerated()), id: \.element.id) { index, item in
                VStack(spacing: 0) {
                    valueContent(item)

                    Text(item.label)
                        .font(theme.typography.tiny.font)
                        .tracking(theme.components.statRow.labelTracking)
                        .foregroundStyle(theme.colors.textNeutral9.opacity(theme.colors.textOpacity50))
                }
                .padding(theme.spacing.md)
                .frame(maxWidth: .infinity)

                if index < items.count - 1 {
                    Rectangle()
                        .fill(dividerColor ?? theme.colors.textNeutral9)
                        .frame(width: theme.borders.widthSm)
                }
            }
        }
    }
}
