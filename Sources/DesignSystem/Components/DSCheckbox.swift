import SwiftUI

// MARK: - DSCheckbox

/// A themed checkbox with label and optional description.
///
/// Usage:
/// ```swift
/// DSCheckbox(isOn: $accepted)
///     .label("Accept terms")
///
/// DSCheckbox(isOn: $subscribe)
///     .label("Newsletter")
///     .description("Receive weekly updates")
/// ```
public struct DSCheckbox: View {
    @Environment(\.theme) private var theme

    @Binding private var isOn: Bool
    private var _label: LocalizedStringKey?
    private var _description: LocalizedStringKey?
    private var _labelFont: TypographyStyle?

    // MARK: - Init

    public init(isOn: Binding<Bool>) {
        self._isOn = isOn
    }

    // MARK: - Deprecated init

    @available(*, deprecated, message: "Use DSCheckbox(isOn:) with .label(), .description(), .labelFont() modifiers instead")
    public init(
        isOn: Binding<Bool>,
        label: LocalizedStringKey?,
        description: LocalizedStringKey? = nil,
        labelFont: TypographyStyle? = nil
    ) {
        self._isOn = isOn
        self._label = label
        self._description = description
        self._labelFont = labelFont
    }

    // MARK: - Modifiers

    public func label(_ label: LocalizedStringKey) -> DSCheckbox {
        var copy = self
        copy._label = label
        return copy
    }

    public func description(_ description: LocalizedStringKey) -> DSCheckbox {
        var copy = self
        copy._description = description
        return copy
    }

    public func labelFont(_ font: TypographyStyle) -> DSCheckbox {
        var copy = self
        copy._labelFont = font
        return copy
    }

    // MARK: - Body

    public var body: some View {
        Button {
            isOn.toggle()
        } label: {
            if _label != nil {
                HStack(alignment: .center, spacing: theme.spacing.sm) {
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
            RoundedRectangle(cornerRadius: theme.radius.xxs)
                .stroke(
                    isOn ? theme.colors.surfacePrimary100 : theme.colors.borderNeutral95,
                    lineWidth: theme.borders.widthSm
                )
                .frame(width: 18, height: 18)

            if isOn {
                RoundedRectangle(cornerRadius: theme.radius.xxs)
                    .fill(theme.colors.surfacePrimary100)
                    .frame(width: 18, height: 18)
                    .overlay(
                        Image(systemName: "checkmark")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundStyle(theme.colors.textNeutral05)
                    )
            }
        }
        .animation(.easeInOut(duration: 0.15), value: isOn)
    }

    @ViewBuilder
    private var textContent: some View {
        VStack(alignment: .leading, spacing: 2) {
            if let _label {
                let style = _labelFont ?? theme.typography.body
                Text(_label)
                    .font(style.font)
                    .tracking(style.tracking)
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
