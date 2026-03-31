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
/// Usage (modifier-based):
/// ```swift
/// DSUserCard(name: "Hristo Hristov", onSignOut: { }, onEdit: { })
///     .bio("Sports superhero. Training for the office chair Olympics…")
///     .stat(DSUserCardStat(value: "98%", label: "done"))
///     .avatarImage(Image("avatar"))
/// ```
public struct DSUserCard: View {
    @Environment(\.theme) private var theme

    // Core (required)
    private let _name: LocalizedStringKey
    private let _onSignOut: () -> Void
    private let _onEdit: () -> Void

    // Optional (modifier-configured)
    private var _bio: LocalizedStringKey?
    private var _readMoreLabel: LocalizedStringKey = "read more"
    private var _avatarImage: Image?
    private var _stat: DSUserCardStat?
    private var _signOutLabel: LocalizedStringKey = "Sign Out"
    private var _editLabel: LocalizedStringKey = "Edit"

    // MARK: - New minimal init

    public init(
        name: LocalizedStringKey,
        onSignOut: @escaping () -> Void,
        onEdit: @escaping () -> Void
    ) {
        self._name = name
        self._onSignOut = onSignOut
        self._onEdit = onEdit
    }

    // MARK: - Deprecated init (backward-compatible)

    @available(*, deprecated, message: "Use minimal init + modifiers: DSUserCard(name:onSignOut:onEdit:).bio(...).stat(...)")
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
        self._name = name
        self._bio = bio
        self._readMoreLabel = readMoreLabel
        self._avatarImage = avatarImage
        self._stat = stat
        self._signOutLabel = signOutLabel
        self._editLabel = editLabel
        self._onSignOut = onSignOut
        self._onEdit = onEdit
    }

    // MARK: - Modifiers

    public func bio(_ bio: LocalizedStringKey) -> DSUserCard {
        var copy = self; copy._bio = bio; return copy
    }

    public func stat(_ stat: DSUserCardStat) -> DSUserCard {
        var copy = self; copy._stat = stat; return copy
    }

    public func readMoreLabel(_ label: LocalizedStringKey) -> DSUserCard {
        var copy = self; copy._readMoreLabel = label; return copy
    }

    public func avatarImage(_ image: Image?) -> DSUserCard {
        var copy = self; copy._avatarImage = image; return copy
    }

    public func signOutLabel(_ label: LocalizedStringKey) -> DSUserCard {
        var copy = self; copy._signOutLabel = label; return copy
    }

    public func editLabel(_ label: LocalizedStringKey) -> DSUserCard {
        var copy = self; copy._editLabel = label; return copy
    }

    // MARK: - Body

    public var body: some View {
        DSCard {
            VStack(alignment: .leading, spacing: theme.spacing.lg) {
                topSection
                if _stat != nil {
                    DSDivider()
                    bottomSection
                }
            }
            .padding(theme.spacing.xl)
        }
        .cardPadding(0)
    }

    // MARK: - Top section

    private var topSection: some View {
        HStack(alignment: .top, spacing: theme.spacing.lg) {
            VStack(alignment: .leading, spacing: theme.spacing.sm) {
                Text(_name)
                    .font(theme.typography.h4.font)
                    .tracking(theme.typography.h4.tracking)
                    .foregroundStyle(theme.colors.textNeutral9)
                    .frame(maxWidth: .infinity, alignment: .leading)

                if _bio != nil {
                    bioText
                }
            }

            if let _avatarImage {
                _avatarImage
                    .resizable()
                    .scaledToFill()
                    .frame(width: 61, height: 64)
                    .clipShape(RoundedRectangle(cornerRadius: theme.radius.md))
            }
        }
    }

    @ViewBuilder
    private var bioText: some View {
        if let bio = _bio {
            (Text(bio)
                .font(theme.typography.bodyRegular.font)
                .tracking(theme.typography.bodyRegular.tracking)
             + Text(" ") + Text(_readMoreLabel)
                .font(theme.typography.label.font)
                .tracking(theme.typography.label.tracking))
            .foregroundStyle(theme.colors.textNeutral9)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }

    // MARK: - Bottom section

    @ViewBuilder
    private var bottomSection: some View {
        if let stat = _stat {
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

                DSButton(_signOutLabel) {
                    _onSignOut()
                }.buttonStyle(.neutralLight).buttonSize(.medium).icon(.logOut, position: .right)

                DSButton(_editLabel) {
                    _onEdit()
                }.buttonStyle(.filledA).buttonSize(.medium).icon(.editPencil, position: .right)
            }
        }
    }
}
