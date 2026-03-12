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
/// Usage:
/// ```swift
/// DSIconSidebar(
///     avatar: Image("profile"),
///     sections: [
///         DSIconSidebarSection(items: [
///             DSIconSidebarItem(id: "cart", icon: .cart),
///             DSIconSidebarItem(id: "gallery", icon: .mediaImageList, isSelected: true),
///         ]),
///         DSIconSidebarSection(items: [
///             DSIconSidebarItem(id: "search", icon: .search),
///             DSIconSidebarItem(id: "settings", icon: .settings),
///         ]),
///         DSIconSidebarSection(items: [
///             DSIconSidebarItem(id: "logout", icon: .logOut),
///         ]),
///     ]
/// )
/// ```
public struct DSIconSidebar: View {
    @Environment(\.theme) private var theme

    private let avatar: Image?
    private let sections: [DSIconSidebarSection]
    private let onItemTap: ((String) -> Void)?

    public init(
        avatar: Image? = nil,
        sections: [DSIconSidebarSection],
        onItemTap: ((String) -> Void)? = nil
    ) {
        self.avatar = avatar
        self.sections = sections
        self.onItemTap = onItemTap
    }

    public var body: some View {
        VStack(spacing: theme.spacing.lg) {
            // Avatar at top
            if let avatar {
                DSAvatar(style: .image(avatar), size: 40)
            }

            // Sections separated by dividers
            ForEach(Array(sections.enumerated()), id: \.offset) { index, section in
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
            onItemTap?(item.id)
        } label: {
            Image(dsIcon: item.icon)
                .resizable()
                .renderingMode(.template)
                .scaledToFit()
                .frame(width: 24, height: 24)
                .foregroundStyle(theme.colors.textNeutral0_5)
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
            .fill(theme.colors.textNeutral0_5.opacity(0.2))
            .frame(height: 1)
    }
}
