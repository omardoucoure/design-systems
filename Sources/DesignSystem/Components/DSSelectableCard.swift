import SwiftUI

/// A themed single-select option row: a card with a leading label and a trailing
/// check indicator. When selected it draws a 2pt inset ring in the secondary color
/// and switches the label to a semibold weight.
///
/// Usage:
/// ```swift
/// DSSelectableCard("2–5 years", isSelected: level == .midr) { level = .mid }
/// ```
public struct DSSelectableCard: View {
    @Environment(\.theme) private var theme

    private let title: LocalizedStringKey
    private let isSelected: Bool
    private let action: () -> Void
    private var _ringColor: Color?

    public init(_ title: LocalizedStringKey, isSelected: Bool, action: @escaping () -> Void) {
        self.title = title
        self.isSelected = isSelected
        self.action = action
    }

    public func ringColor(_ color: Color) -> Self {
        var copy = self
        copy._ringColor = color
        return copy
    }

    public var body: some View {
        Button(action: action) {
            HStack(spacing: theme.spacing.sm) {
                Text(title)
                    .typographyStyle(isSelected ? theme.typography.bodySemiBold : theme.typography.body)
                    .foregroundStyle(theme.colors.textNeutral9)
                Spacer(minLength: theme.spacing.sm)
                indicator
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(theme.spacing.lg)
            .background(theme.colors.surfaceNeutral2, in: RoundedRectangle(cornerRadius: theme.radius.xl))
            .overlay(
                RoundedRectangle(cornerRadius: theme.radius.xl)
                    .strokeBorder(ring, lineWidth: isSelected ? 2 : 0)
            )
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }

    private var ring: Color {
        _ringColor ?? theme.colors.surfaceSecondary100
    }

    private var indicator: some View {
        RoundedRectangle(cornerRadius: theme.radius.xs)
            .fill(isSelected ? ring : theme.colors.surfaceNeutral05)
            .overlay(
                RoundedRectangle(cornerRadius: theme.radius.xs)
                    .strokeBorder(theme.colors.borderNeutral3, lineWidth: isSelected ? 0 : 1.5)
            )
            .overlay {
                if isSelected {
                    DSIconImage(.check, size: 16, color: theme.colors.textNeutral05)
                }
            }
            .frame(width: 24, height: 24)
    }
}
