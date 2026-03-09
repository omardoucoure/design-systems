import SwiftUI

// MARK: - Dropdown Item

public struct DSDropdownItem: Identifiable, Sendable {
    public let id: String
    public let label: LocalizedStringKey

    public init(id: String, label: LocalizedStringKey) {
        self.id = id
        self.label = label
    }
}

// MARK: - DSDropdown

/// A themed dropdown that extends DSTextField with a chevron trigger and popup menu.
///
/// Usage:
/// ```swift
/// DSDropdown(
///     items: [DSDropdownItem(id: "1", label: "Option 1")],
///     selectedId: $selectedId,
///     placeholder: "Choose option"
/// )
/// ```
public struct DSDropdown: View {
    @Environment(\.theme) private var theme

    private let items: [DSDropdownItem]
    @Binding private var selectedId: String?
    private let placeholder: LocalizedStringKey
    private let label: LocalizedStringKey?
    private let variant: InputVariant

    @State private var isExpanded = false

    public init(
        items: [DSDropdownItem],
        selectedId: Binding<String?>,
        placeholder: LocalizedStringKey,
        label: LocalizedStringKey? = nil,
        variant: InputVariant = .filled
    ) {
        self.items = items
        self._selectedId = selectedId
        self.placeholder = placeholder
        self.label = label
        self.variant = variant
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            triggerButton
            if isExpanded {
                menuContent
                    .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .animation(.easeInOut(duration: 0.2), value: isExpanded)
    }

    // MARK: - Trigger

    private var triggerButton: some View {
        Button {
            isExpanded.toggle()
        } label: {
            HStack(spacing: 12) {
                VStack(alignment: .leading, spacing: 0) {
                    if let label, selectedItem != nil {
                        Text(label)
                            .font(theme.typography.small.font)
                            .tracking(theme.typography.small.tracking)
                            .foregroundStyle(theme.colors.textNeutral9.opacity(0.75))
                    }

                    if let selectedItem {
                        Text(selectedItem.label)
                            .font(theme.typography.body.font)
                            .tracking(theme.typography.body.tracking)
                            .foregroundStyle(theme.colors.textNeutral9)
                    } else {
                        Text(placeholder)
                            .font(theme.typography.body.font)
                            .tracking(theme.typography.body.tracking)
                            .foregroundStyle(theme.colors.textNeutral9.opacity(0.5))
                    }
                }

                Spacer()

                Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundStyle(theme.colors.textNeutral9)
            }
            .padding(.horizontal, theme.spacing.md)
            .padding(.vertical, theme.spacing.md)
            .frame(height: 56)
            .background(triggerBackground)
            .clipShape(RoundedRectangle(cornerRadius: triggerRadius))
            .overlay(triggerBorder)
        }
        .buttonStyle(.plain)
    }

    // MARK: - Menu

    private var menuContent: some View {
        VStack(spacing: 0) {
            ForEach(items) { item in
                let isSelected = item.id == selectedId

                Button {
                    selectedId = item.id
                    isExpanded = false
                } label: {
                    HStack {
                        Text(item.label)
                            .font(theme.typography.body.font)
                            .tracking(theme.typography.body.tracking)
                            .foregroundStyle(
                                theme.colors.textNeutral9
                                    .opacity(isSelected ? 1.0 : 0.5)
                            )

                        Spacer()

                        if isSelected {
                            Image(systemName: "checkmark")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundStyle(theme.colors.textNeutral9)
                        }
                    }
                    .padding(.horizontal, theme.spacing.md)
                    .padding(.vertical, theme.spacing.md)
                    .contentShape(Rectangle())
                }
                .buttonStyle(DropdownItemButtonStyle(theme: theme))
            }
        }
        .padding(.vertical, theme.spacing.xxs)
        .background(theme.colors.surfaceNeutral0_5)
        .clipShape(RoundedRectangle(cornerRadius: theme.radius.lg))
        .elevation(theme.elevation.sm)
        .padding(.top, theme.spacing.xxs)
    }

    // MARK: - Resolved Styles

    private var selectedItem: DSDropdownItem? {
        items.first { $0.id == selectedId }
    }

    private var triggerBackground: Color {
        switch variant {
        case .filled:
            return isExpanded ? theme.colors.surfaceNeutral0_5 : theme.colors.surfaceNeutral2
        case .lined:
            return .clear
        }
    }

    private var triggerRadius: CGFloat {
        switch variant {
        case .filled: return theme.radius.md
        case .lined: return 0
        }
    }

    private var triggerBorder: some View {
        Group {
            switch variant {
            case .filled:
                RoundedRectangle(cornerRadius: theme.radius.md)
                    .stroke(
                        isExpanded ? theme.colors.infoFocus : theme.colors.borderNeutral2,
                        lineWidth: theme.borders.widthSm
                    )
            case .lined:
                VStack {
                    Spacer()
                    Rectangle()
                        .fill(isExpanded ? theme.colors.infoFocus : theme.colors.borderNeutral9_5)
                        .frame(height: theme.borders.widthSm)
                }
            }
        }
    }
}

// MARK: - Item Button Style (pressed state)

private struct DropdownItemButtonStyle: ButtonStyle {
    let theme: ThemeConfiguration

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .background(
                Group {
                    if configuration.isPressed {
                        RoundedRectangle(cornerRadius: theme.radius.xxl)
                            .fill(theme.colors.surfaceNeutral0_5)
                            .padding(.horizontal, theme.spacing.md)
                    }
                }
            )
    }
}
