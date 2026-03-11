import SwiftUI

// MARK: - DSNavigationMenuItem

/// A menu item for `DSNavigationMenu`.
public struct DSNavigationMenuItem: Identifiable {
    public let id: String
    public let label: LocalizedStringKey
    public let icon: DSIcon
    public let isSelected: Bool

    public init(
        id: String,
        label: LocalizedStringKey,
        icon: DSIcon,
        isSelected: Bool = false
    ) {
        self.id = id
        self.label = label
        self.icon = icon
        self.isSelected = isSelected
    }
}

// MARK: - DSNavigationMenuProfile

/// Profile data for the bottom of `DSNavigationMenu`.
public struct DSNavigationMenuProfile {
    public let image: String
    public let name: LocalizedStringKey
    public let subtitle: LocalizedStringKey

    public init(
        image: String,
        name: LocalizedStringKey,
        subtitle: LocalizedStringKey
    ) {
        self.image = image
        self.name = name
        self.subtitle = subtitle
    }
}

// MARK: - DSNavigationMenu

/// A side navigation menu with icon+label rows and an optional profile row.
///
/// Figma: "Menu" in [Navigation] 8 (node 481:14200)
///
/// Each item displays a DSButton-style icon pill followed by a `bodySemiBold` label.
/// The selected item uses `surfaceSecondary100` for the icon background;
/// unselected items use `surfaceNeutral2`.
///
/// Usage:
/// ```swift
/// DSNavigationMenu(
///     items: [
///         DSNavigationMenuItem(id: "msg", label: "Messages", icon: .replyToMessage),
///         DSNavigationMenuItem(id: "gal", label: "Gallery", icon: .mediaImageList, isSelected: true),
///     ],
///     profile: DSNavigationMenuProfile(
///         image: "nav8_profile",
///         name: "Hristo Hristov",
///         subtitle: "Visual Designer"
///     )
/// )
/// ```
public struct DSNavigationMenu: View {
    @Environment(\.theme) private var theme

    private let items: [DSNavigationMenuItem]
    private let profile: DSNavigationMenuProfile?
    private let onSelect: ((String) -> Void)?

    public init(
        items: [DSNavigationMenuItem],
        profile: DSNavigationMenuProfile? = nil,
        onSelect: ((String) -> Void)? = nil
    ) {
        self.items = items
        self.profile = profile
        self.onSelect = onSelect
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ForEach(items) { item in
                menuRow(item)
            }

            if let profile = profile {
                profileRow(profile)
            }
        }
        .padding(.horizontal, theme.spacing.xxs)
        .padding(.vertical, theme.spacing.sm)
        .clipShape(RoundedRectangle(cornerRadius: theme.radius.xl))
    }

    // MARK: - Menu Row

    private func menuRow(_ item: DSNavigationMenuItem) -> some View {
        Button {
            onSelect?(item.id)
        } label: {
            HStack(spacing: theme.spacing.md) {
                iconPill(item.icon, isSelected: item.isSelected)

                Text(item.label)
                    .font(theme.typography.bodySemiBold.font)
                    .tracking(theme.typography.bodySemiBold.tracking)
                    .foregroundStyle(theme.colors.textNeutral9)
            }
            .padding(theme.spacing.md)
        }
        .buttonStyle(.plain)
    }

    // MARK: - Icon Pill

    private func iconPill(_ icon: DSIcon, isSelected: Bool) -> some View {
        Image(dsIcon: icon)
            .resizable()
            .renderingMode(.template)
            .scaledToFit()
            .frame(width: 24, height: 24)
            .foregroundStyle(theme.colors.textNeutral9)
            .padding(.horizontal, theme.spacing.md)
            .padding(.vertical, theme.spacing.xs)
            .frame(height: 40)
            .background(
                isSelected
                    ? theme.colors.surfaceSecondary100
                    : theme.colors.surfaceNeutral2
            )
            .clipShape(Capsule())
    }

    // MARK: - Profile Row

    private func profileRow(_ profile: DSNavigationMenuProfile) -> some View {
        HStack(spacing: theme.spacing.md) {
            Image(profile.image)
                .resizable()
                .scaledToFill()
                .frame(width: 56, height: 48)
                .clipShape(RoundedRectangle(cornerRadius: theme.radius.sm))

            VStack(alignment: .leading, spacing: 0) {
                Text(profile.name)
                    .font(theme.typography.bodySemiBold.font)
                    .tracking(theme.typography.bodySemiBold.tracking)
                    .foregroundStyle(theme.colors.textNeutral9)

                Text(profile.subtitle)
                    .font(theme.typography.captionRegular.font)
                    .tracking(theme.typography.captionRegular.tracking)
                    .foregroundStyle(theme.colors.textNeutral8)
                    .opacity(0.75)
            }
        }
        .padding(theme.spacing.md)
    }
}
