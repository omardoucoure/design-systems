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
/// Usage (modifier-based):
/// ```swift
/// // Standard styles — title + optional actions in init, style/back as modifiers
/// DSTopAppBar(title: "Settings") {
///     DSButton {}.buttonStyle(.neutral).buttonSize(.medium).systemIcon("gear")
/// }
/// .appBarStyle(.small)
/// .onBack { dismiss() }
///
/// // Logo style
/// DSTopAppBar(leadingIcon: "person.circle", onLeadingTap: { }) {
///     Image("logo")
/// } actions: {
///     DSButton {}.buttonStyle(.neutral).buttonSize(.medium).systemIcon("line.3.horizontal")
/// }
///
/// // Search style
/// DSTopAppBar(searchPlaceholder: "Search...") {
///     DSButton {}.buttonStyle(.neutral).buttonSize(.medium).systemIcon("plus.circle")
/// }
/// ```
public struct DSTopAppBar<CenterContent: View, Actions: View>: View {
    @Environment(\.theme) private var theme

    private var _title: LocalizedStringKey?
    private var _style: DSTopAppBarStyle
    private var _onBack: (() -> Void)?
    private var _leadingIcon: String?
    private var _onLeadingTap: (() -> Void)?
    private var _searchPlaceholder: LocalizedStringKey?
    private var _onSearchTap: (() -> Void)?
    private let _centerContent: CenterContent
    private let _actions: Actions

    // MARK: - Standard Init (modifier-based)

    /// Creates a standard top app bar with a title and optional trailing actions.
    ///
    /// Use `.appBarStyle(_:)` to set the layout (default: `.small`),
    /// and `.onBack { }` to add a back button.
    public init(
        title: LocalizedStringKey,
        @ViewBuilder actions: () -> Actions = { EmptyView() }
    ) where CenterContent == EmptyView {
        self._title = title
        self._style = .small
        self._onBack = nil
        self._leadingIcon = nil
        self._onLeadingTap = nil
        self._searchPlaceholder = nil
        self._onSearchTap = nil
        self._centerContent = EmptyView()
        self._actions = actions()
    }

    // MARK: - Logo Init

    public init(
        leadingIcon: String,
        onLeadingTap: @escaping () -> Void,
        @ViewBuilder center: () -> CenterContent,
        @ViewBuilder actions: () -> Actions
    ) {
        self._title = nil
        self._style = .logo
        self._onBack = nil
        self._leadingIcon = leadingIcon
        self._onLeadingTap = onLeadingTap
        self._searchPlaceholder = nil
        self._onSearchTap = nil
        self._centerContent = center()
        self._actions = actions()
    }

    // MARK: - Search Init

    public init(
        searchPlaceholder: LocalizedStringKey = "Search...",
        onSearchTap: (() -> Void)? = nil,
        leadingIcon: String = "line.3.horizontal",
        onLeadingTap: (() -> Void)? = nil,
        @ViewBuilder actions: () -> Actions
    ) where CenterContent == EmptyView {
        self._title = nil
        self._style = .search
        self._onBack = nil
        self._leadingIcon = leadingIcon
        self._onLeadingTap = onLeadingTap
        self._searchPlaceholder = searchPlaceholder
        self._onSearchTap = onSearchTap
        self._centerContent = EmptyView()
        self._actions = actions()
    }

    // MARK: - Image-Title Init

    public init(
        title: LocalizedStringKey,
        @ViewBuilder leadingImage: () -> CenterContent,
        @ViewBuilder actions: () -> Actions
    ) {
        self._title = title
        self._style = .imageTitle
        self._onBack = nil
        self._leadingIcon = nil
        self._onLeadingTap = nil
        self._searchPlaceholder = nil
        self._onSearchTap = nil
        self._centerContent = leadingImage()
        self._actions = actions()
    }

    // MARK: - Deprecated Standard Init

    /// Deprecated: Use `DSTopAppBar(title:actions:)` with `.appBarStyle(_:)` and `.onBack { }` modifiers instead.
    @available(*, deprecated, message: "Use DSTopAppBar(title:actions:).appBarStyle(_:).onBack { } instead")
    public init(
        title: LocalizedStringKey,
        style: DSTopAppBarStyle,
        onBack: (() -> Void)? = nil,
        @ViewBuilder actions: () -> Actions = { EmptyView() }
    ) where CenterContent == EmptyView {
        self._title = title
        self._style = style
        self._onBack = onBack
        self._leadingIcon = nil
        self._onLeadingTap = nil
        self._searchPlaceholder = nil
        self._onSearchTap = nil
        self._centerContent = EmptyView()
        self._actions = actions()
    }

    // MARK: - Modifiers

    /// Sets the app bar layout style.
    public func appBarStyle(_ style: DSTopAppBarStyle) -> Self {
        var copy = self
        copy._style = style
        return copy
    }

    /// Adds a back button with the given action.
    public func onBack(_ action: @escaping () -> Void) -> Self {
        var copy = self
        copy._onBack = action
        return copy
    }

    // MARK: - Body

    public var body: some View {
        VStack(spacing: 0) {
            switch _style {
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
        .background(.ultraThinMaterial)
        // Progressive fade extending below the bar — mimics the iOS 26 scroll edge
        // effect where content blurs/fades out as it scrolls under the top bar.
        .overlay(alignment: .bottom) {
            LinearGradient(
                colors: [
                    theme.colors.surfaceNeutral05.opacity(0.6),
                    theme.colors.surfaceNeutral05.opacity(0)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .frame(height: 24)
            .offset(y: 24)
            .allowsHitTesting(false)
        }
    }

    // MARK: - Small (left-aligned)

    private var smallBar: some View {
        HStack(spacing: theme.spacing.xs) {
            backButton
            Text(_title ?? "")
                .font(theme.typography.bodySemiBold.font)
                .tracking(theme.typography.bodySemiBold.tracking)
                .foregroundStyle(theme.colors.textNeutral9)
            Spacer()
            _actions
        }
        .padding(.horizontal, theme.spacing.sm)
        .frame(height: 64)
    }

    // MARK: - Small Centered

    private var centeredBar: some View {
        HStack(spacing: theme.spacing.xs) {
            backButton
            Spacer()
            Text(_title ?? "")
                .font(theme.typography.h5.font)
                .tracking(theme.typography.h5.tracking)
                .foregroundStyle(theme.colors.textNeutral9)
            Spacer()
            _actions
        }
        .padding(.horizontal, theme.spacing.sm)
        .frame(height: 64)
    }

    // MARK: - Action Row (shared by medium + large)

    private var actionRow: some View {
        HStack(spacing: theme.spacing.xs) {
            backButton
            Spacer()
            _actions
        }
        .padding(.horizontal, theme.spacing.sm)
        .frame(height: 64)
    }

    // MARK: - Medium Title

    private var mediumTitle: some View {
        HStack {
            Text(_title ?? "")
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
            Text(_title ?? "")
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
            if let _leadingIcon, let _onLeadingTap {
                iconCapsuleButton(icon: _leadingIcon, action: _onLeadingTap)
            }

            Spacer()
            _centerContent
            Spacer()

            _actions
        }
        .padding(.horizontal, theme.spacing.sm)
        .frame(height: 64)
    }

    // MARK: - Search Bar

    private var searchBar: some View {
        HStack(spacing: theme.spacing.md) {
            if let _leadingIcon {
                iconCapsuleButton(icon: _leadingIcon, action: _onLeadingTap ?? {})
            }

            HStack(spacing: theme.spacing.xs) {
                Button(action: _onSearchTap ?? {}) {
                    HStack(spacing: 12) {
                        Image(systemName: "magnifyingglass")
                            .font(.system(size: 20))
                            .foregroundStyle(theme.colors.textNeutral9.opacity(0.5))
                            .frame(width: 24, height: 24)

                        Text(_searchPlaceholder ?? "Search...")
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

                _actions
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
                _centerContent
                    .frame(width: 56, height: 40)
                    .clipShape(RoundedRectangle(cornerRadius: theme.radius.sm))

                Text(_title ?? "")
                    .font(theme.typography.h5.font)
                    .tracking(theme.typography.h5.tracking)
                    .foregroundStyle(theme.colors.textNeutral9)
            }

            Spacer()
            _actions
        }
        .padding(theme.spacing.sm)
        .frame(height: 64)
    }

    // MARK: - Shared Components

    @ViewBuilder
    private var backButton: some View {
        if let _onBack {
            DSButton {
                _onBack()
            }.buttonStyle(.neutral).buttonSize(.medium).icon(.arrowLeftLong)
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
