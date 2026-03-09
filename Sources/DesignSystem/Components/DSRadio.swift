import SwiftUI

// MARK: - DSRadio

/// A themed radio button with label and optional description.
///
/// Usage:
/// ```swift
/// DSRadio(isSelected: option == .a, label: "Option A") { option = .a }
/// ```
public struct DSRadio: View {
    @Environment(\.theme) private var theme

    private let isSelected: Bool
    private let label: LocalizedStringKey?
    private let description: LocalizedStringKey?
    private let action: () -> Void

    public init(
        isSelected: Bool,
        label: LocalizedStringKey? = nil,
        description: LocalizedStringKey? = nil,
        action: @escaping () -> Void
    ) {
        self.isSelected = isSelected
        self.label = label
        self.description = description
        self.action = action
    }

    public var body: some View {
        Button(action: action) {
            if label != nil {
                HStack(alignment: .top, spacing: theme.spacing.sm) {
                    radioIcon
                    textContent
                    Spacer(minLength: 0)
                }
            } else {
                radioIcon
            }
        }
        .buttonStyle(.plain)
    }

    private var radioIcon: some View {
        ZStack {
            Circle()
                .stroke(
                    isSelected ? theme.colors.surfacePrimary100 : theme.colors.borderNeutral9_5,
                    lineWidth: theme.borders.widthMd
                )
                .frame(width: 20, height: 20)

            if isSelected {
                Circle()
                    .fill(theme.colors.surfacePrimary100)
                    .frame(width: 10, height: 10)
            }
        }
        .animation(.easeInOut(duration: 0.15), value: isSelected)
    }

    @ViewBuilder
    private var textContent: some View {
        VStack(alignment: .leading, spacing: 2) {
            if let label {
                Text(label)
                    .font(theme.typography.body.font)
                    .tracking(theme.typography.body.tracking)
                    .foregroundStyle(theme.colors.textNeutral9)
            }

            if let description {
                Text(description)
                    .font(theme.typography.caption.font)
                    .tracking(theme.typography.caption.tracking)
                    .foregroundStyle(theme.colors.textNeutral8)
            }
        }
    }
}
