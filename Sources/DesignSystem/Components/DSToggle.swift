import SwiftUI

// MARK: - DSToggle

/// A themed toggle switch with label and optional description.
///
/// Usage:
/// ```swift
/// DSToggle(isOn: $darkMode, label: "Dark mode")
/// ```
public struct DSToggle: View {
    @Environment(\.theme) private var theme

    @Binding private var isOn: Bool
    private let label: LocalizedStringKey?
    private let description: LocalizedStringKey?

    public init(
        isOn: Binding<Bool>,
        label: LocalizedStringKey? = nil,
        description: LocalizedStringKey? = nil
    ) {
        self._isOn = isOn
        self.label = label
        self.description = description
    }

    public var body: some View {
        if label != nil || description != nil {
            HStack(alignment: .top, spacing: theme.spacing.sm) {
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
                    .fill(theme.colors.surfaceNeutral0_5)
                    .frame(width: 22, height: 22)
                    .padding(3)
                    .shadow(color: .black.opacity(0.15), radius: 2, y: 1)
            }
        }
        .buttonStyle(.plain)
    }
}
