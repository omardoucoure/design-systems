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
/// Minimal init with modifier-based configuration:
/// ```swift
/// DSDropdown(
///     items: [DSDropdownItem(id: "1", label: "Option 1")],
///     selectedId: $selectedId
/// )
/// .placeholder("Choose option")
/// .label("Size")
/// .variant(.lined)
/// ```
public struct DSDropdown: View {
    @Environment(\.theme) private var theme

    // Core (required)
    private var _items: [DSDropdownItem]
    @Binding private var _selectedId: String?

    // Configurable via modifiers (with defaults)
    private var _placeholder: LocalizedStringKey = "Select"
    private var _label: LocalizedStringKey?
    private var _variant: InputVariant = .filled

    @State private var isExpanded = false

    // MARK: - New minimal init

    public init(
        items: [DSDropdownItem],
        selectedId: Binding<String?>
    ) {
        self._items = items
        self.__selectedId = selectedId
    }

    // MARK: - Deprecated init (preserves backward compatibility)

    @available(*, deprecated, message: "Use DSDropdown(items:selectedId:) with .placeholder(), .label(), .variant() modifiers instead")
    public init(
        items: [DSDropdownItem],
        selectedId: Binding<String?>,
        placeholder: LocalizedStringKey,
        label: LocalizedStringKey? = nil,
        variant: InputVariant = .filled
    ) {
        self._items = items
        self.__selectedId = selectedId
        self._placeholder = placeholder
        self._label = label
        self._variant = variant
    }

    // MARK: - Modifiers

    public func placeholder(_ value: LocalizedStringKey) -> DSDropdown {
        var copy = self
        copy._placeholder = value
        return copy
    }

    public func label(_ value: LocalizedStringKey) -> DSDropdown {
        var copy = self
        copy._label = value
        return copy
    }

    public func variant(_ value: InputVariant) -> DSDropdown {
        var copy = self
        copy._variant = value
        return copy
    }

    // MARK: - Body

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
                    if let _label, selectedItem != nil {
                        Text(_label)
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
                        Text(_placeholder)
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
            ForEach(_items) { item in
                let isSelected = item.id == _selectedId

                Button {
                    _selectedId = item.id
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
        .background(theme.colors.surfaceNeutral05)
        .clipShape(RoundedRectangle(cornerRadius: theme.radius.lg))
        .elevation(theme.elevation.sm)
        .padding(.top, theme.spacing.xxs)
    }

    // MARK: - Resolved Styles

    private var selectedItem: DSDropdownItem? {
        _items.first { $0.id == _selectedId }
    }

    private var triggerBackground: Color {
        switch _variant {
        case .filled:
            return isExpanded ? theme.colors.surfaceNeutral05 : theme.colors.surfaceNeutral2
        case .lined:
            return .clear
        }
    }

    private var triggerRadius: CGFloat {
        switch _variant {
        case .filled: return theme.radius.md
        case .lined: return 0
        }
    }

    private var triggerBorder: some View {
        Group {
            switch _variant {
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
                        .fill(isExpanded ? theme.colors.infoFocus : theme.colors.borderNeutral95)
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
                            .fill(theme.colors.surfaceNeutral05)
                            .padding(.horizontal, theme.spacing.md)
                    }
                }
            )
    }
}
