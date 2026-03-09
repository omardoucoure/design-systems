import SwiftUI

// MARK: - Top App Bar Style

public enum DSTopAppBarStyle: Sendable {
    /// Small title, left-aligned. (Figma: Small-Icons)
    case small
    /// Small title, centered. (Figma: Small-Centered)
    case smallCentered
    /// Medium: action row on top, title below. (Figma: Medium-Icons)
    case medium
    /// Large title below action row. (Figma: Large-Icons)
    case large
    /// Avatar/icon left, centered logo, trailing icon. (Figma: Logo)
    case logo
    /// Menu icon left, search field center, trailing actions. (Figma: Search)
    case search
    /// Leading image + title, trailing actions. (Figma: Image-Button)
    case imageTitle
}

// MARK: - DSTopAppBar

/// A themed top navigation bar with multiple layout styles.
///
/// Usage:
/// ```swift
/// // Standard styles
/// DSTopAppBar(title: "Settings", style: .small, onBack: { }) {
///     DSButton(style: .neutral, size: .medium, systemIcon: "gear") {}
/// }
///
/// // Logo style
/// DSTopAppBar(leadingIcon: "person.circle", onLeadingTap: { }) {
///     Image("logo")
/// } actions: {
///     DSButton(style: .neutral, size: .medium, systemIcon: "line.3.horizontal") {}
/// }
///
/// // Search style
/// DSTopAppBar(searchPlaceholder: "Search...") {
///     DSButton(style: .neutral, size: .medium, systemIcon: "plus.circle") {}
/// }
/// ```
public struct DSTopAppBar<CenterContent: View, Actions: View>: View {
    @Environment(\.theme) private var theme

    private let title: LocalizedStringKey?
    private let style: DSTopAppBarStyle
    private let onBack: (() -> Void)?
    private let leadingIcon: String?
    private let onLeadingTap: (() -> Void)?
    private let searchPlaceholder: LocalizedStringKey?
    private let onSearchTap: (() -> Void)?
    private let centerContent: CenterContent
    private let actions: Actions

    // MARK: - Standard Init (backward compatible)

    public init(
        title: LocalizedStringKey,
        style: DSTopAppBarStyle = .small,
        onBack: (() -> Void)? = nil,
        @ViewBuilder actions: () -> Actions = { EmptyView() }
    ) where CenterContent == EmptyView {
        self.title = title
        self.style = style
        self.onBack = onBack
        self.leadingIcon = nil
        self.onLeadingTap = nil
        self.searchPlaceholder = nil
        self.onSearchTap = nil
        self.centerContent = EmptyView()
        self.actions = actions()
    }

    // MARK: - Logo Init

    public init(
        leadingIcon: String,
        onLeadingTap: @escaping () -> Void,
        @ViewBuilder center: () -> CenterContent,
        @ViewBuilder actions: () -> Actions
    ) {
        self.title = nil
        self.style = .logo
        self.onBack = nil
        self.leadingIcon = leadingIcon
        self.onLeadingTap = onLeadingTap
        self.searchPlaceholder = nil
        self.onSearchTap = nil
        self.centerContent = center()
        self.actions = actions()
    }

    // MARK: - Search Init

    public init(
        searchPlaceholder: LocalizedStringKey = "Search...",
        onSearchTap: (() -> Void)? = nil,
        leadingIcon: String = "line.3.horizontal",
        onLeadingTap: (() -> Void)? = nil,
        @ViewBuilder actions: () -> Actions
    ) where CenterContent == EmptyView {
        self.title = nil
        self.style = .search
        self.onBack = nil
        self.leadingIcon = leadingIcon
        self.onLeadingTap = onLeadingTap
        self.searchPlaceholder = searchPlaceholder
        self.onSearchTap = onSearchTap
        self.centerContent = EmptyView()
        self.actions = actions()
    }

    // MARK: - Image-Title Init

    public init(
        title: LocalizedStringKey,
        @ViewBuilder leadingImage: () -> CenterContent,
        @ViewBuilder actions: () -> Actions
    ) {
        self.title = title
        self.style = .imageTitle
        self.onBack = nil
        self.leadingIcon = nil
        self.onLeadingTap = nil
        self.searchPlaceholder = nil
        self.onSearchTap = nil
        self.centerContent = leadingImage()
        self.actions = actions()
    }

    // MARK: - Body

    public var body: some View {
        VStack(spacing: 0) {
            switch style {
            case .small:
                smallBar
            case .smallCentered:
                centeredBar
            case .medium:
                actionRow
                mediumTitle
            case .large:
                actionRow
                largeTitle
            case .logo:
                logoBar
            case .search:
                searchBar
            case .imageTitle:
                imageTitleBar
            }
        }
        .background(theme.colors.surfaceNeutral0_5)
    }

    // MARK: - Small (left-aligned)

    private var smallBar: some View {
        HStack(spacing: theme.spacing.xs) {
            backButton
            Text(title ?? "")
                .font(theme.typography.bodySemiBold.font)
                .tracking(theme.typography.bodySemiBold.tracking)
                .foregroundStyle(theme.colors.textNeutral9)
            Spacer()
            actions
        }
        .padding(.horizontal, theme.spacing.sm)
        .frame(height: 64)
    }

    // MARK: - Small Centered

    private var centeredBar: some View {
        HStack(spacing: theme.spacing.xs) {
            backButton
            Spacer()
            Text(title ?? "")
                .font(theme.typography.h5.font)
                .tracking(theme.typography.h5.tracking)
                .foregroundStyle(theme.colors.textNeutral9)
            Spacer()
            actions
        }
        .padding(.horizontal, theme.spacing.sm)
        .frame(height: 64)
    }

    // MARK: - Action Row (shared by medium + large)

    private var actionRow: some View {
        HStack(spacing: theme.spacing.xs) {
            backButton
            Spacer()
            actions
        }
        .padding(.horizontal, theme.spacing.sm)
        .frame(height: 64)
    }

    // MARK: - Medium Title

    private var mediumTitle: some View {
        HStack {
            Text(title ?? "")
                .font(theme.typography.h5.font)
                .tracking(theme.typography.h5.tracking)
                .foregroundStyle(theme.colors.textNeutral9)
            Spacer()
        }
        .padding(.horizontal, theme.spacing.md)
        .padding(.bottom, theme.spacing.sm)
    }

    // MARK: - Large Title

    private var largeTitle: some View {
        HStack {
            Text(title ?? "")
                .font(theme.typography.h3.font)
                .tracking(theme.typography.h3.tracking)
                .foregroundStyle(theme.colors.textNeutral9)
            Spacer()
        }
        .padding(.horizontal, theme.spacing.md)
        .padding(.bottom, theme.spacing.sm)
    }

    // MARK: - Logo Bar

    private var logoBar: some View {
        HStack(spacing: theme.spacing.xs) {
            if let leadingIcon, let onLeadingTap {
                iconCapsuleButton(icon: leadingIcon, action: onLeadingTap)
            }

            Spacer()
            centerContent
            Spacer()

            actions
        }
        .padding(.horizontal, theme.spacing.sm)
        .frame(height: 64)
    }

    // MARK: - Search Bar

    private var searchBar: some View {
        HStack(spacing: theme.spacing.md) {
            if let leadingIcon {
                iconCapsuleButton(icon: leadingIcon, action: onLeadingTap ?? {})
            }

            HStack(spacing: theme.spacing.xs) {
                Button(action: onSearchTap ?? {}) {
                    HStack(spacing: 12) {
                        Image(systemName: "magnifyingglass")
                            .font(.system(size: 20))
                            .foregroundStyle(theme.colors.textNeutral9.opacity(0.5))
                            .frame(width: 24, height: 24)

                        Text(searchPlaceholder ?? "Search...")
                            .font(theme.typography.body.font)
                            .tracking(theme.typography.body.tracking)
                            .foregroundStyle(theme.colors.textNeutral9.opacity(0.5))

                        Spacer()
                    }
                    .padding(.horizontal, theme.spacing.md)
                    .padding(.vertical, theme.spacing.sm)
                    .background(theme.colors.surfaceNeutral2)
                    .clipShape(RoundedRectangle(cornerRadius: theme.radius.md))
                    .overlay(
                        RoundedRectangle(cornerRadius: theme.radius.md)
                            .stroke(theme.colors.borderNeutral2, lineWidth: theme.borders.widthMd)
                    )
                }
                .buttonStyle(.plain)

                actions
            }
        }
        .padding(.leading, theme.spacing.sm)
        .padding(.trailing, theme.spacing.xs)
        .frame(height: 64)
    }

    // MARK: - Image-Title Bar

    private var imageTitleBar: some View {
        HStack(spacing: theme.spacing.xs) {
            HStack(spacing: theme.spacing.md) {
                centerContent
                    .frame(width: 56, height: 40)
                    .clipShape(RoundedRectangle(cornerRadius: theme.radius.sm))

                Text(title ?? "")
                    .font(theme.typography.h5.font)
                    .tracking(theme.typography.h5.tracking)
                    .foregroundStyle(theme.colors.textNeutral9)
            }

            Spacer()
            actions
        }
        .padding(theme.spacing.sm)
        .frame(height: 64)
    }

    // MARK: - Shared Components

    @ViewBuilder
    private var backButton: some View {
        if let onBack {
            DSButton(style: .neutral, size: .medium, icon: .arrowLeftLong) {
                onBack()
            }
        }
    }

    private func iconCapsuleButton(icon: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(systemName: icon)
                .font(.system(size: 20, weight: .medium))
                .foregroundStyle(theme.colors.textNeutral9)
                .frame(width: 40, height: 40)
                .background(theme.colors.surfaceNeutral2)
                .clipShape(Capsule())
        }
        .buttonStyle(.plain)
    }
}
