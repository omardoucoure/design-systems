import SwiftUI

// MARK: - DSIconSidebarItem

/// A single item in `DSIconSidebar`.
public struct DSIconSidebarItem: Identifiable {
    public let id: String
    public let icon: DSIcon
    public var isSelected: Bool

    public init(id: String, icon: DSIcon, isSelected: Bool = false) {
        self.id = id
        self.icon = icon
        self.isSelected = isSelected
    }
}

// MARK: - DSIconSidebarSection

/// A group of items separated by dividers in `DSIconSidebar`.
public struct DSIconSidebarSection {
    public let items: [DSIconSidebarItem]

    public init(items: [DSIconSidebarItem]) {
        self.items = items
    }
}

// MARK: - DSIconSidebar

/// A vertical capsule-shaped sidebar with icon-only buttons, an avatar, and divider-separated sections.
///
/// Figma: [Navigation] 3 (node 946:244997)
///
/// The sidebar has a dark primary background (`surfacePrimary100`) with a full capsule radius.
/// Selected items use `surfaceSecondary100` background; unselected items blend with the sidebar.
///
/// Usage (modifier-based):
/// ```swift
/// DSIconSidebar(sections: [
///     DSIconSidebarSection(items: [
///         DSIconSidebarItem(id: "cart", icon: .cart),
///         DSIconSidebarItem(id: "gallery", icon: .mediaImageList, isSelected: true),
///     ]),
///     DSIconSidebarSection(items: [
///         DSIconSidebarItem(id: "search", icon: .search),
///         DSIconSidebarItem(id: "settings", icon: .settings),
///     ]),
/// ])
/// .avatar(Image("profile"))
/// .onItemTap { id in print(id) }
/// ```
public struct DSIconSidebar: View {
    @Environment(\.theme) private var theme

    // Core params (init)
    private let _sections: [DSIconSidebarSection]

    // Modifier params
    private var _avatar: Image?
    private var _onItemTap: ((String) -> Void)?

    /// Creates an icon sidebar with sections. Use modifiers for avatar and tap handling.
    public init(sections: [DSIconSidebarSection]) {
        self._sections = sections
    }

    // MARK: - Deprecated Init

    @available(*, deprecated, message: "Use init(sections:) with .avatar() and .onItemTap() modifiers")
    public init(
        avatar: Image? = nil,
        sections: [DSIconSidebarSection],
        onItemTap: ((String) -> Void)? = nil
    ) {
        self._sections = sections
        self._avatar = avatar
        self._onItemTap = onItemTap
    }

    // MARK: - Modifiers

    /// Sets the avatar image displayed at the top of the sidebar.
    public func avatar(_ image: Image) -> Self {
        var copy = self
        copy._avatar = image
        return copy
    }

    /// Sets the callback invoked when a sidebar item is tapped.
    public func onItemTap(_ handler: @escaping (String) -> Void) -> Self {
        var copy = self
        copy._onItemTap = handler
        return copy
    }

    public var body: some View {
        VStack(spacing: theme.spacing.lg) {
            // Avatar at top
            if let avatar = _avatar {
                DSAvatar(style: .image(avatar), size: 40)
            }

            // Sections separated by dividers
            ForEach(Array(_sections.enumerated()), id: \.offset) { index, section in
                if index > 0 {
                    divider
                }

                ForEach(section.items) { item in
                    iconButton(item)
                }
            }
        }
        .padding(.horizontal, theme.spacing.md)
        .padding(.vertical, theme.spacing.lg)
        .background(theme.colors.surfacePrimary100)
        .clipShape(Capsule())
    }

    // MARK: - Icon Button

    private func iconButton(_ item: DSIconSidebarItem) -> some View {
        Button {
            _onItemTap?(item.id)
        } label: {
            Image(dsIcon: item.icon)
                .resizable()
                .renderingMode(.template)
                .scaledToFit()
                .frame(width: 24, height: 24)
                .foregroundStyle(theme.colors.textNeutral05)
                .frame(width: 40, height: 40)
                .background(
                    item.isSelected
                        ? theme.colors.surfaceSecondary100
                        : theme.colors.surfacePrimary100
                )
                .clipShape(Capsule())
        }
        .buttonStyle(.plain)
    }

    // MARK: - Divider

    private var divider: some View {
        Rectangle()
            .fill(theme.colors.textNeutral05.opacity(0.2))
            .frame(height: 1)
    }
}
