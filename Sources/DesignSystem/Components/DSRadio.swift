import SwiftUI

// MARK: - DSRadio

/// A themed radio button with optional label and description.
///
/// Usage:
/// ```swift
/// DSRadio(isSelected: option == .a) { option = .a }
///     .label("Option A")
///     .description("First option")
/// ```
public struct DSRadio: View {
    @Environment(\.theme) private var theme

    private let isSelected: Bool
    private let action: () -> Void
    private var _label: LocalizedStringKey?
    private var _description: LocalizedStringKey?

    // MARK: - Initializers

    /// Minimal init — configure with modifiers.
    public init(isSelected: Bool, action: @escaping () -> Void) {
        self.isSelected = isSelected
        self.action = action
    }

    /// Legacy init — prefer modifier-based API.
    @available(*, deprecated, message: "Use DSRadio(isSelected:action:) with .label() and .description() modifiers")
    public init(
        isSelected: Bool,
        label: LocalizedStringKey? = nil,
        description: LocalizedStringKey? = nil,
        action: @escaping () -> Void
    ) {
        self.isSelected = isSelected
        self._label = label
        self._description = description
        self.action = action
    }

    // MARK: - Modifiers

    public func label(_ label: LocalizedStringKey) -> DSRadio {
        var copy = self
        copy._label = label
        return copy
    }

    public func description(_ description: LocalizedStringKey) -> DSRadio {
        var copy = self
        copy._description = description
        return copy
    }

    // MARK: - Body

    public var body: some View {
        Button(action: action) {
            if _label != nil {
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
                    isSelected ? theme.colors.surfacePrimary100 : theme.colors.borderNeutral95,
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
            if let _label {
                Text(_label)
                    .font(theme.typography.body.font)
                    .tracking(theme.typography.body.tracking)
                    .foregroundStyle(theme.colors.textNeutral9)
            }

            if let _description {
                Text(_description)
                    .font(theme.typography.caption.font)
                    .tracking(theme.typography.caption.tracking)
                    .foregroundStyle(theme.colors.textNeutral8)
            }
        }
    }
}
