import SwiftUI

// MARK: - DSUserCardStat

/// A single stat item shown in the bottom row of DSUserCard.
public struct DSUserCardStat {
    public let value: LocalizedStringKey
    public let label: LocalizedStringKey

    public init(value: LocalizedStringKey, label: LocalizedStringKey) {
        self.value = value
        self.label = label
    }
}

// MARK: - DSUserCard

/// A profile card with avatar, name, bio, a separator, and a stats + actions row.
///
/// Matches the Figma "Text" card component (node 1017:70585).
///
/// Usage:
/// ```swift
/// DSUserCard(
///     name: "Hristo Hristov",
///     bio: "Sports superhero. Training for the office chair Olympics…",
///     avatarImage: Image("avatar"),
///     stat: DSUserCardStat(value: "98%", label: "done"),
///     onSignOut: { },
///     onEdit: { }
/// )
/// ```
public struct DSUserCard: View {
    @Environment(\.theme) private var theme

    private let name: LocalizedStringKey
    private let bio: LocalizedStringKey
    private let readMoreLabel: LocalizedStringKey
    private let avatarImage: Image?
    private let stat: DSUserCardStat
    private let signOutLabel: LocalizedStringKey
    private let editLabel: LocalizedStringKey
    private let onSignOut: () -> Void
    private let onEdit: () -> Void

    public init(
        name: LocalizedStringKey,
        bio: LocalizedStringKey,
        readMoreLabel: LocalizedStringKey = "read more",
        avatarImage: Image? = nil,
        stat: DSUserCardStat,
        signOutLabel: LocalizedStringKey = "Sign Out",
        editLabel: LocalizedStringKey = "Edit",
        onSignOut: @escaping () -> Void,
        onEdit: @escaping () -> Void
    ) {
        self.name = name
        self.bio = bio
        self.readMoreLabel = readMoreLabel
        self.avatarImage = avatarImage
        self.stat = stat
        self.signOutLabel = signOutLabel
        self.editLabel = editLabel
        self.onSignOut = onSignOut
        self.onEdit = onEdit
    }

    public var body: some View {
        DSCard(background: theme.colors.surfaceNeutral2, radius: theme.radius.xl, padding: 0) {
            VStack(alignment: .leading, spacing: theme.spacing.lg) {
                topSection
                DSDivider(style: .fullBleed)
                bottomSection
            }
            .padding(theme.spacing.xl)
        }
    }

    // MARK: - Top section

    private var topSection: some View {
        HStack(alignment: .top, spacing: theme.spacing.lg) {
            VStack(alignment: .leading, spacing: theme.spacing.sm) {
                Text(name)
                    .font(theme.typography.h4.font)
                    .tracking(theme.typography.h4.tracking)
                    .foregroundStyle(theme.colors.textNeutral9)
                    .frame(maxWidth: .infinity, alignment: .leading)

                bioText
            }

            if let avatarImage {
                avatarImage
                    .resizable()
                    .scaledToFill()
                    .frame(width: 61, height: 64)
                    .clipShape(RoundedRectangle(cornerRadius: theme.radius.md))
            }
        }
    }

    private var bioText: some View {
        (Text(bio)
            .font(theme.typography.bodyRegular.font)
            .tracking(theme.typography.bodyRegular.tracking)
         + Text(" ") + Text(readMoreLabel)
            .font(theme.typography.label.font)
            .tracking(theme.typography.label.tracking))
        .foregroundStyle(theme.colors.textNeutral9)
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    // MARK: - Bottom section

    private var bottomSection: some View {
        HStack(spacing: theme.spacing.sm) {
            // Stat column
            VStack(alignment: .leading, spacing: 0) {
                Text(stat.value)
                    .font(theme.typography.largeSemiBold.font)
                    .tracking(theme.typography.largeSemiBold.tracking)
                    .foregroundStyle(theme.colors.textNeutral9)

                Text(stat.label)
                    .font(theme.typography.smallRegular.font)
                    .tracking(theme.typography.smallRegular.tracking)
                    .foregroundStyle(theme.colors.textNeutral9.opacity(0.75))
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            DSButton(signOutLabel, style: .neutralLight, size: .medium, icon: .logOut, iconPosition: .right) {
                onSignOut()
            }

            DSButton(editLabel, style: .filledA, size: .medium, icon: .editPencil, iconPosition: .right) {
                onEdit()
            }
        }
    }
}

