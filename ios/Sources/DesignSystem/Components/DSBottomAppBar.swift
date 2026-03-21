import SwiftUI

// MARK: - Bottom App Bar Style

public enum DSBottomAppBarStyle: Sendable, CaseIterable {
    /// Docked bar with icon-only items and a center FAB. Top corners rounded.
    case full
    /// Floating capsule bar with icon-only items and a center FAB.
    case floating
    /// Docked bar with icon + label + optional badges. Top corners rounded.
    case labeled
}

// MARK: - Bottom App Bar Item

public struct DSBottomBarItem: Identifiable {
    public let id: String
    public let label: LocalizedStringKey
    public let systemIcon: String?
    public let icon: DSIcon?
    public let badgeCount: Int?

    /// Create an item with an SF Symbol icon.
    public init(
        id: String,
        label: LocalizedStringKey,
        systemIcon: String,
        badgeCount: Int? = nil
    ) {
        self.id = id
        self.label = label
        self.systemIcon = systemIcon
        self.icon = nil
        self.badgeCount = badgeCount
    }

    /// Create an item with a DSIcon asset icon.
    public init(
        id: String,
        label: LocalizedStringKey,
        icon: DSIcon,
        badgeCount: Int? = nil
    ) {
        self.id = id
        self.label = label
        self.systemIcon = nil
        self.icon = icon
        self.badgeCount = badgeCount
    }
}

// MARK: - DSBottomAppBar

/// A themed bottom app bar matching the Figma Bottom App Bar component.
///
/// Three styles are available:
/// - `.full`: Icon-only docked bar with a center FAB button and top-rounded corners.
/// - `.floating`: Floating capsule bar with a center FAB button.
/// - `.labeled`: Docked bar with icon + label + optional badges.
///
/// Usage:
/// ```swift
/// // Full style with FAB
/// DSBottomAppBar(items: tabs, selectedId: $tab, style: .full,
///                fabIcon: "plus", onFabTap: { })
///
/// // Labeled style with badges
/// DSBottomAppBar(items: labeledTabs, selectedId: $tab, style: .labeled)
/// ```
public struct DSBottomAppBar: View {
    @Environment(\.theme) private var theme
    @Namespace private var tabNamespace

    private let items: [DSBottomBarItem]
    @Binding private var selectedId: String
    private let style: DSBottomAppBarStyle
    private let fabSystemIcon: String?
    private let fabDSIcon: DSIcon?
    private let fabColor: Color?
    private let fabForegroundColor: Color?
    private let fabBadgeCount: Int?
    private let onFabTap: (() -> Void)?
    private let embedded: Bool

    /// - Parameter embedded: When `true`, removes the container background, clip shape, and shadow.
    ///   Use this when the bar is embedded in a parent that already provides the background.
    public init(
        items: [DSBottomBarItem],
        selectedId: Binding<String>,
        style: DSBottomAppBarStyle = .labeled,
        fabIcon: String? = nil,
        fabColor: Color? = nil,
        fabForegroundColor: Color? = nil,
        fabBadgeCount: Int? = nil,
        onFabTap: (() -> Void)? = nil,
        embedded: Bool = false
    ) {
        self.items = items
        self._selectedId = selectedId
        self.style = style
        self.fabSystemIcon = fabIcon
        self.fabDSIcon = nil
        self.fabColor = fabColor
        self.fabForegroundColor = fabForegroundColor
        self.fabBadgeCount = fabBadgeCount
        self.onFabTap = onFabTap
        self.embedded = embedded
    }

    /// Init with a DSIcon for the FAB button.
    public init(
        items: [DSBottomBarItem],
        selectedId: Binding<String>,
        style: DSBottomAppBarStyle = .labeled,
        fabIcon: DSIcon,
        fabColor: Color? = nil,
        fabForegroundColor: Color? = nil,
        fabBadgeCount: Int? = nil,
        onFabTap: (() -> Void)? = nil,
        embedded: Bool = false
    ) {
        self.items = items
        self._selectedId = selectedId
        self.style = style
        self.fabSystemIcon = nil
        self.fabDSIcon = fabIcon
        self.fabColor = fabColor
        self.fabForegroundColor = fabForegroundColor
        self.fabBadgeCount = fabBadgeCount
        self.onFabTap = onFabTap
        self.embedded = embedded
    }

    public var body: some View {
        switch style {
        case .full:
            fullBar
        case .floating:
            floatingBar
        case .labeled:
            labeledBar
        }
    }

    // MARK: - Full Style

    private var fullBar: some View {
        fullBarContent
            .padding(.horizontal, theme.spacing.lg)
            .padding(.top, theme.spacing.md)
            .padding(.bottom, theme.spacing.xs)
            .frame(maxWidth: .infinity)
            .modifier(DockedContainerModifier(embedded: embedded))
    }

    private var fullBarContent: some View {
        HStack {
            let halfCount = items.count / 2
            let leftItems = Array(items.prefix(halfCount))
            let rightItems = Array(items.suffix(items.count - halfCount))

            ForEach(leftItems) { item in
                iconButton(item)
            }

            if hasFab {
                fabButton(size: 56)
            }

            ForEach(rightItems) { item in
                iconButton(item)
            }
        }
    }

    // MARK: - Floating Style

    private var floatingBar: some View {
        HStack {
            let halfCount = items.count / 2
            let leftItems = Array(items.prefix(halfCount))
            let rightItems = Array(items.suffix(items.count - halfCount))

            ForEach(leftItems) { item in
                iconButton(item)
            }

            if hasFab {
                fabButton(size: 40)
            }

            ForEach(rightItems) { item in
                iconButton(item)
            }
        }
        .padding(theme.spacing.md)
        .frame(maxWidth: .infinity)
        .background(theme.colors.surfaceNeutral2)
        .clipShape(Capsule())
        .shadow(color: .black.opacity(0.03), radius: 4, x: 0, y: 8)
        .shadow(color: .black.opacity(0.08), radius: 12, x: 0, y: 20)
        .padding(.horizontal, 20)
    }

    // MARK: - Labeled Style

    private var labeledBar: some View {
        HStack {
            ForEach(items) { item in
                labeledButton(item)
            }
        }
        .padding(.horizontal, theme.spacing.md)
        .padding(.top, theme.spacing.md)
        .padding(.bottom, theme.spacing.md)
        .frame(maxWidth: .infinity)
        .modifier(DockedContainerModifier(embedded: embedded))
    }

    // MARK: - Shared Components

    private func iconButton(_ item: DSBottomBarItem) -> some View {
        let isSelected = item.id == selectedId

        return Button {
            withAnimation(.spring(response: 0.4, dampingFraction: 0.75)) {
                selectedId = item.id
            }
        } label: {
            itemIconView(item)
                .frame(width: 24, height: 24)
                .scaleEffect(isSelected ? 1.12 : 1.0)
                .foregroundStyle(theme.colors.textNeutral9)
                .frame(height: 40)
                .padding(.horizontal, theme.spacing.md)
                .background {
                    if isSelected {
                        Capsule()
                            .fill(theme.colors.surfaceSecondary100)
                            .matchedGeometryEffect(id: "tabPill", in: tabNamespace)
                    }
                }
                .clipShape(Capsule())
        }
        .buttonStyle(TabBarButtonStyle())
    }

    private func labeledButton(_ item: DSBottomBarItem) -> some View {
        let isSelected = item.id == selectedId

        return Button {
            withAnimation(.spring(response: 0.4, dampingFraction: 0.75)) {
                selectedId = item.id
            }
        } label: {
            VStack(spacing: 4) {
                ZStack(alignment: .topTrailing) {
                    itemIconView(item)
                        .frame(width: 24, height: 24)
                        .scaleEffect(isSelected ? 1.12 : 1.0)
                        .foregroundStyle(theme.colors.textNeutral9)
                        .frame(height: 40)
                        .padding(.horizontal, theme.spacing.md)
                        .background {
                            if isSelected {
                                Capsule()
                                    .fill(theme.colors.surfaceSecondary100)
                                    .matchedGeometryEffect(id: "tabPill", in: tabNamespace)
                            }
                        }
                        .clipShape(Capsule())

                    if let count = item.badgeCount {
                        badgeView(count: count)
                            .offset(x: 2, y: 0)
                    }
                }

                Text(item.label)
                    .font(.system(size: 12, weight: .semibold))
                    .tracking(-0.24)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
                    .foregroundStyle(theme.colors.textNeutral9)
                    .opacity(isSelected ? 1.0 : 0.6)
            }
            .frame(maxWidth: .infinity)
        }
        .buttonStyle(TabBarButtonStyle())
    }

    private var hasFab: Bool {
        fabSystemIcon != nil || fabDSIcon != nil
    }

    private func fabButton(size: CGFloat) -> some View {
        let isCustom = fabColor != nil
        let hPadding = isCustom ? theme.spacing.md : (size == 56 ? theme.spacing.lg : theme.spacing.md)
        let vPadding = isCustom ? theme.spacing.xs : (size == 56 ? theme.spacing.md : theme.spacing.xs)

        return ZStack(alignment: .topTrailing) {
            Button {
                onFabTap?()
            } label: {
                Group {
                    if let fabDSIcon {
                        Image(dsIcon: fabDSIcon)
                            .resizable()
                            .renderingMode(.template)
                            .scaledToFit()
                    } else if let fabSystemIcon {
                        Image(systemName: fabSystemIcon)
                            .font(.system(size: 24))
                    }
                }
                .frame(width: 24, height: 24)
                .foregroundStyle(fabForegroundColor ?? theme.colors.textNeutral0_5)
                .padding(.horizontal, hPadding)
                .padding(.vertical, vPadding)
                .background(fabColor ?? theme.colors.surfacePrimary120)
                .clipShape(Capsule())
            }
            .buttonStyle(.plain)
            .frame(height: size)

            if let fabBadgeCount {
                DSBadge(variant: .numberSemantic, count: fabBadgeCount)
                    .offset(x: 2, y: 0)
            }
        }
    }

    @ViewBuilder
    private func itemIconView(_ item: DSBottomBarItem) -> some View {
        if let dsIcon = item.icon {
            Image(dsIcon: dsIcon)
                .resizable()
                .renderingMode(.template)
                .scaledToFit()
        } else if let systemIcon = item.systemIcon {
            Image(systemName: systemIcon)
                .font(.system(size: 24))
        }
    }

    private func badgeView(count: Int) -> some View {
        Text("\(count)")
            .font(.system(size: 10, weight: .semibold))
            .tracking(-0.2)
            .foregroundStyle(theme.colors.textNeutral9)
            .frame(minWidth: 16, minHeight: 16)
            .padding(.horizontal, theme.spacing.xxs)
            .padding(.vertical, 2)
            .background(theme.colors.infoFocus)
            .clipShape(Capsule())
    }
}

// MARK: - Docked Container Modifier

/// Applies docked background when not embedded.
private struct DockedContainerModifier: ViewModifier {
    let embedded: Bool
    @Environment(\.theme) private var theme

    func body(content: Content) -> some View {
        content
            .background(
                theme.colors.surfaceNeutral2
                    .clipShape(
                        UnevenRoundedRectangle(
                            topLeadingRadius: theme.radius.xl,
                            bottomLeadingRadius: 0,
                            bottomTrailingRadius: 0,
                            topTrailingRadius: theme.radius.xl
                        )
                    )
                    .shadow(color: .black.opacity(0.02), radius: 4, x: 0, y: -8)
                    .shadow(color: .black.opacity(0.18), radius: 32, x: 0, y: -11)
                    .opacity(embedded ? 0 : 1)
            )
    }
}

// MARK: - Bottom Bar Inset Environment

private struct DSBottomBarInsetKey: EnvironmentKey {
    static let defaultValue: CGFloat = 0
}

public extension EnvironmentValues {
    /// The height of the DSBottomBarLayout bar.
    var dsBottomBarInset: CGFloat {
        get { self[DSBottomBarInsetKey.self] }
        set { self[DSBottomBarInsetKey.self] = newValue }
    }
}

/// Adds a bottom safe area inset matching the DSBottomBarLayout bar height.
/// Apply on each NavigationStack inside a DSBottomBarLayout when using
/// ZStack-based tab switching.
public struct DSBottomBarContentInset: ViewModifier {
    @Environment(\.dsBottomBarInset) private var inset

    public func body(content: Content) -> some View {
        content
            .safeAreaInset(edge: .bottom, spacing: 0) {
                Color.clear.frame(height: inset)
            }
    }
}

public extension View {
    /// Adds bottom safe area inset matching the DSBottomBarLayout bar height.
    func dsBottomBarContentInset() -> some View {
        modifier(DSBottomBarContentInset())
    }
}

// MARK: - DSBottomBarLayout

/// A container that pairs content with a DSBottomAppBar.
/// Uses `.safeAreaInset(edge: .bottom)` to push content above the bar.
///
/// Usage:
/// ```swift
/// DSBottomBarLayout(
///     items: tabs,
///     selectedId: $selectedTab,
///     style: .labeled
/// ) {
///     MyPageView()
/// }
/// ```
public struct DSBottomBarLayout<Content: View>: View {
    private let items: [DSBottomBarItem]
    @Binding private var selectedId: String
    private let style: DSBottomAppBarStyle
    private let fabSystemIcon: String?
    private let fabDSIcon: DSIcon?
    private let fabColor: Color?
    private let fabForegroundColor: Color?
    private let fabBadgeCount: Int?
    private let onFabTap: (() -> Void)?
    private let content: Content

    @State private var barHeight: CGFloat = 140

    public init(
        items: [DSBottomBarItem],
        selectedId: Binding<String>,
        style: DSBottomAppBarStyle = .labeled,
        fabIcon: String? = nil,
        fabColor: Color? = nil,
        fabForegroundColor: Color? = nil,
        fabBadgeCount: Int? = nil,
        onFabTap: (() -> Void)? = nil,
        @ViewBuilder content: () -> Content
    ) {
        self.items = items
        self._selectedId = selectedId
        self.style = style
        self.fabSystemIcon = fabIcon
        self.fabDSIcon = nil
        self.fabColor = fabColor
        self.fabForegroundColor = fabForegroundColor
        self.fabBadgeCount = fabBadgeCount
        self.onFabTap = onFabTap
        self.content = content()
    }

    public init(
        items: [DSBottomBarItem],
        selectedId: Binding<String>,
        style: DSBottomAppBarStyle = .labeled,
        fabIcon: DSIcon,
        fabColor: Color? = nil,
        fabForegroundColor: Color? = nil,
        fabBadgeCount: Int? = nil,
        onFabTap: (() -> Void)? = nil,
        @ViewBuilder content: () -> Content
    ) {
        self.items = items
        self._selectedId = selectedId
        self.style = style
        self.fabSystemIcon = nil
        self.fabDSIcon = fabIcon
        self.fabColor = fabColor
        self.fabForegroundColor = fabForegroundColor
        self.fabBadgeCount = fabBadgeCount
        self.onFabTap = onFabTap
        self.content = content()
    }

    public var body: some View {
        content
            .environment(\.dsBottomBarInset, barHeight)
            .safeAreaInset(edge: .bottom, spacing: 0) {
                DSBottomAppBar(
                    items: items,
                    selectedId: $selectedId,
                    style: style,
                    fabIcon: fabSystemIcon,
                    fabColor: fabColor,
                    fabForegroundColor: fabForegroundColor,
                    fabBadgeCount: fabBadgeCount,
                    onFabTap: onFabTap
                )
                .background(
                    GeometryReader { geo in
                        Color.clear.preference(key: BottomBarHeightKey.self, value: geo.size.height)
                    }
                )
            }
            .onPreferenceChange(BottomBarHeightKey.self) { barHeight = $0 }
    }
}

// MARK: - Bar Height Preference Key

private struct BottomBarHeightKey: PreferenceKey {
    static let defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = max(value, nextValue())
    }
}

// MARK: - Tab Bar Button Style

/// Press-down scale animation for tab bar buttons.
private struct TabBarButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.85 : 1.0)
            .animation(.spring(response: 0.25, dampingFraction: 0.6), value: configuration.isPressed)
    }
}
