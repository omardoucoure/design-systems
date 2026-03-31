import SwiftUI

// MARK: - DSToggle

/// A themed toggle switch with optional label and description.
///
/// Usage:
/// ```swift
/// DSToggle(isOn: $darkMode)
///     .label("Dark mode")
///     .description("Enable dark appearance")
/// ```
public struct DSToggle: View {
    @Environment(\.theme) private var theme

    @Binding private var isOn: Bool
    private var _label: LocalizedStringKey?
    private var _description: LocalizedStringKey?

    // MARK: - Initializers

    /// Minimal init — configure with modifiers.
    public init(isOn: Binding<Bool>) {
        self._isOn = isOn
    }

    /// Legacy init — prefer modifier-based API.
    @available(*, deprecated, message: "Use DSToggle(isOn:) with .label() and .description() modifiers")
    public init(
        isOn: Binding<Bool>,
        label: LocalizedStringKey? = nil,
        description: LocalizedStringKey? = nil
    ) {
        self._isOn = isOn
        self._label = label
        self._description = description
    }

    // MARK: - Modifiers

    public func label(_ label: LocalizedStringKey) -> DSToggle {
        var copy = self
        copy._label = label
        return copy
    }

    public func description(_ description: LocalizedStringKey) -> DSToggle {
        var copy = self
        copy._description = description
        return copy
    }

    // MARK: - Body

    public var body: some View {
        if _label != nil || _description != nil {
            HStack(alignment: .top, spacing: theme.spacing.sm) {
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

                Spacer(minLength: 0)

                toggleSwitch
            }
        } else {
            toggleSwitch
        }
    }

    private var toggleSwitch: some View {
        Button {
            withAnimation(.easeInOut(duration: 0.2)) {
                isOn.toggle()
            }
        } label: {
            ZStack(alignment: isOn ? .trailing : .leading) {
                Capsule()
                    .fill(isOn ? theme.colors.surfacePrimary100 : theme.colors.surfaceNeutral3)
                    .frame(width: 48, height: 28)

                Circle()
                    .fill(theme.colors.surfaceNeutral05)
                    .frame(width: 22, height: 22)
                    .padding(3)
                    .shadow(color: .black.opacity(0.15), radius: 2, y: 1)
            }
        }
        .buttonStyle(.plain)
    }
}
