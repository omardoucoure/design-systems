import SwiftUI

// MARK: - DSCheckbox

/// A themed checkbox with label and optional description.
///
/// Usage:
/// ```swift
/// DSCheckbox(isOn: $accepted, label: "Accept terms")
/// DSCheckbox(isOn: $subscribe, label: "Newsletter", description: "Receive weekly updates")
/// ```
public struct DSCheckbox: View {
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
        Button {
            isOn.toggle()
        } label: {
            if label != nil {
                HStack(alignment: .top, spacing: theme.spacing.sm) {
                    checkboxIcon
                    textContent
                    Spacer(minLength: 0)
                }
            } else {
                checkboxIcon
            }
        }
        .buttonStyle(.plain)
    }

    private var checkboxIcon: some View {
        ZStack {
            RoundedRectangle(cornerRadius: theme.radius.xs)
                .stroke(
                    isOn ? theme.colors.surfacePrimary100 : theme.colors.borderNeutral9_5,
                    lineWidth: theme.borders.widthMd
                )
                .frame(width: 20, height: 20)

            if isOn {
                RoundedRectangle(cornerRadius: theme.radius.xs)
                    .fill(theme.colors.surfacePrimary100)
                    .frame(width: 20, height: 20)
                    .overlay(
                        Image(systemName: "checkmark")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundStyle(theme.colors.textNeutral0_5)
                    )
            }
        }
        .animation(.easeInOut(duration: 0.15), value: isOn)
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
