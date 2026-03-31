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
/// Usage (modifier API):
/// ```swift
/// // Full style with FAB
/// DSBottomAppBar(items: tabs, selectedId: $tab)
///     .barStyle(.full)
///     .fabIcon("plus")
///     .onFabTap { }
///
/// // Labeled style with badges
/// DSBottomAppBar(items: labeledTabs, selectedId: $tab)
///     .barStyle(.labeled)
///
/// // Floating with DSIcon FAB
/// DSBottomAppBar(items: tabs, selectedId: $tab)
///     .barStyle(.floating)
///     .fabDSIcon(.cart)
///     .fabColor(.red)
///     .fabBadgeCount(3)
/// ```
public struct DSBottomAppBar: View {
    @Environment(\.theme) private var theme

    // Core (required)
    private var _items: [DSBottomBarItem]
    @Binding private var _selectedId: String

    // Modifier props (optional, with defaults)
    private var _style: DSBottomAppBarStyle = .labeled
    private var _fabSystemIcon: String? = nil
    private var _fabDSIcon: DSIcon? = nil
    private var _fabColor: Color? = nil
    private var _fabForegroundColor: Color? = nil
    private var _fabBadgeCount: Int? = nil
    private var _onFabTap: (() -> Void)? = nil
    private var _embedded: Bool = false

    // MARK: - New Modifier API

    /// Creates a bottom app bar with the given tab items and selection binding.
    public init(items: [DSBottomBarItem], selectedId: Binding<String>) {
        self._items = items
        self.__selectedId = selectedId
    }

    /// Sets the bar style (`.full`, `.floating`, or `.labeled`). Default is `.labeled`.
    public func barStyle(_ style: DSBottomAppBarStyle) -> Self {
        var copy = self; copy._style = style; return copy
    }

    /// Sets an SF Symbol icon for the center FAB button.
    public func fabIcon(_ systemName: String) -> Self {
        var copy = self; copy._fabSystemIcon = systemName; copy._fabDSIcon = nil; return copy
    }

    /// Sets a DSIcon for the center FAB button.
    public func fabDSIcon(_ icon: DSIcon) -> Self {
        var copy = self; copy._fabDSIcon = icon; copy._fabSystemIcon = nil; return copy
    }

    /// Sets the background color of the FAB button.
    public func fabColor(_ color: Color) -> Self {
        var copy = self; copy._fabColor = color; return copy
    }

    /// Sets the foreground (icon) color of the FAB button.
    public func fabForegroundColor(_ color: Color) -> Self {
        var copy = self; copy._fabForegroundColor = color; return copy
    }

    /// Sets the badge count displayed on the FAB button.
    public func fabBadgeCount(_ count: Int) -> Self {
        var copy = self; copy._fabBadgeCount = count; return copy
    }

    /// Sets the action triggered when the FAB button is tapped.
    public func onFabTap(_ action: @escaping () -> Void) -> Self {
        var copy = self; copy._onFabTap = action; return copy
    }

    /// When `true`, removes the container background, clip shape, and shadow.
    /// Use when the bar is embedded in a parent that already provides the background.
    public func embedded(_ value: Bool = true) -> Self {
        var copy = self; copy._embedded = value; return copy
    }

    // MARK: - Deprecated Inits

    @available(*, deprecated, message: "Use DSBottomAppBar(items:selectedId:) with modifier methods instead")
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
        self._items = items
        self.__selectedId = selectedId
        self._style = style
        self._fabSystemIcon = fabIcon
        self._fabDSIcon = nil
        self._fabColor = fabColor
        self._fabForegroundColor = fabForegroundColor
        self._fabBadgeCount = fabBadgeCount
        self._onFabTap = onFabTap
        self._embedded = embedded
    }

    @available(*, deprecated, message: "Use DSBottomAppBar(items:selectedId:) with .fabDSIcon() modifier instead")
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
        self._items = items
        self.__selectedId = selectedId
        self._style = style
        self._fabSystemIcon = nil
        self._fabDSIcon = fabIcon
        self._fabColor = fabColor
        self._fabForegroundColor = fabForegroundColor
        self._fabBadgeCount = fabBadgeCount
        self._onFabTap = onFabTap
        self._embedded = embedded
    }

    // MARK: - Body

    public var body: some View {
        switch _style {
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
            .padding(.bottom, 0)
            .frame(maxWidth: .infinity)
            .modifier(DockedContainerModifier(embedded: _embedded))
    }

    private var fullBarContent: some View {
        HStack {
            let halfCount = _items.count / 2
            let leftItems = Array(_items.prefix(halfCount))
            let rightItems = Array(_items.suffix(_items.count - halfCount))

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
            let halfCount = _items.count / 2
            let leftItems = Array(_items.prefix(halfCount))
            let rightItems = Array(_items.suffix(_items.count - halfCount))

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
            ForEach(_items) { item in
                labeledButton(item)
            }
        }
        .padding(.horizontal, theme.spacing.md)
        .padding(.top, theme.spacing.md)
        .padding(.bottom, 0)
        .frame(maxWidth: .infinity)
        .modifier(DockedContainerModifier(embedded: _embedded))
    }

    // MARK: - Docked Container

    // MARK: - Shared Components

    private func iconButton(_ item: DSBottomBarItem) -> some View {
        let isSelected = item.id == _selectedId

        return Button {
            withAnimation(.spring(response: 0.35, dampingFraction: 0.7)) {
                _selectedId = item.id
            }
        } label: {
            itemIconView(item)
                .frame(width: 24, height: 24)
                .scaleEffect(isSelected ? 1.12 : 1.0)
                .foregroundStyle(theme.colors.textNeutral9)
                .frame(height: 40)
                .padding(.horizontal, theme.spacing.md)
                .background(
                    Capsule()
                        .fill(isSelected ? theme.colors.surfaceSecondary100 : Color.clear)
                )
                .clipShape(Capsule())
        }
        .buttonStyle(TabBarButtonStyle())
    }

    private func labeledButton(_ item: DSBottomBarItem) -> some View {
        let isSelected = item.id == _selectedId

        return Button {
            withAnimation(.spring(response: 0.35, dampingFraction: 0.7)) {
                _selectedId = item.id
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
                        .background(
                            Capsule()
                                .fill(isSelected ? theme.colors.surfaceSecondary100 : Color.clear)
                        )
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
        _fabSystemIcon != nil || _fabDSIcon != nil
    }

    private func fabButton(size: CGFloat) -> some View {
        // Figma: BIG container is `size` tall, inner button padding depends on fabColor presence
        // Default FAB: h=size, px=lg(24) — e.g. plus icon FAB
        // Custom color FAB: natural height from padding, px=md(16) — e.g. cart icon FAB
        let isCustom = _fabColor != nil
        let hPadding = isCustom ? theme.spacing.md : (size == 56 ? theme.spacing.lg : theme.spacing.md)
        let vPadding = isCustom ? theme.spacing.xs : (size == 56 ? theme.spacing.md : theme.spacing.xs)

        return ZStack(alignment: .topTrailing) {
            Button {
                _onFabTap?()
            } label: {
                Group {
                    if let _fabDSIcon {
                        Image(dsIcon: _fabDSIcon)
                            .resizable()
                            .renderingMode(.template)
                            .scaledToFit()
                    } else if let _fabSystemIcon {
                        Image(systemName: _fabSystemIcon)
                            .font(.system(size: 24))
                    }
                }
                .frame(width: 24, height: 24)
                .foregroundStyle(_fabForegroundColor ?? theme.colors.textNeutral05)
                .padding(.horizontal, hPadding)
                .padding(.vertical, vPadding)
                .background(_fabColor ?? theme.colors.surfacePrimary120)
                .clipShape(Capsule())
            }
            .buttonStyle(.plain)
            .frame(height: size)

            if let _fabBadgeCount {
                DSBadge(.numberSemantic).count(_fabBadgeCount)
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

/// Applies docked background + safe area padding when not embedded.
/// Extracted as a ViewModifier so theme changes always trigger re-render
/// (avoids the `let` + `@ViewBuilder` + `if/else` caching issue).
private struct DockedContainerModifier: ViewModifier {
    let embedded: Bool
    @Environment(\.theme) private var theme

    private var bottomSafeAreaInset: CGFloat {
        (UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap(\.windows)
            .first(where: \.isKeyWindow)?
            .safeAreaInsets.bottom) ?? 0
    }

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
                    .ignoresSafeArea(.container, edges: .bottom)
                    .opacity(embedded ? 0 : 1)
            )
    }
}

// MARK: - Bar Height Preference Key

private struct BottomBarHeightKey: PreferenceKey {
    static let defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = max(value, nextValue())
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

/// Reads `dsBottomBarInset` from the environment and adds a matching
/// bottom safe area inset. Apply on each NavigationStack inside a
/// DSBottomBarLayout when using ZStack-based tab switching.
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

/// A container that pairs content with a DSBottomAppBar overlay.
/// Automatically injects a bottom safe area inset matching the bar height,
/// so all ScrollView/List children get correct bottom spacing for free —
/// no manual padding needed in individual pages.
///
/// Usage (modifier API):
/// ```swift
/// DSBottomBarLayout(items: tabs, selectedId: $selectedTab) {
///     MyPageView()
/// }
/// .barStyle(.labeled)
/// .fabIcon("plus")
/// .onFabTap { }
/// ```
public struct DSBottomBarLayout<Content: View>: View {
    // Core
    private var _items: [DSBottomBarItem]
    @Binding private var _selectedId: String
    private var _content: Content

    // Modifier props
    private var _style: DSBottomAppBarStyle = .labeled
    private var _fabSystemIcon: String? = nil
    private var _fabDSIcon: DSIcon? = nil
    private var _fabColor: Color? = nil
    private var _fabForegroundColor: Color? = nil
    private var _fabBadgeCount: Int? = nil
    private var _onFabTap: (() -> Void)? = nil

    @State private var barHeight: CGFloat = 0

    // MARK: - New Modifier API

    /// Creates a bottom bar layout with tab items, selection binding, and content.
    public init(
        items: [DSBottomBarItem],
        selectedId: Binding<String>,
        @ViewBuilder content: () -> Content
    ) {
        self._items = items
        self.__selectedId = selectedId
        self._content = content()
    }

    /// Sets the bar style (`.full`, `.floating`, or `.labeled`). Default is `.labeled`.
    public func barStyle(_ style: DSBottomAppBarStyle) -> Self {
        var copy = self; copy._style = style; return copy
    }

    /// Sets an SF Symbol icon for the center FAB button.
    public func fabIcon(_ systemName: String) -> Self {
        var copy = self; copy._fabSystemIcon = systemName; copy._fabDSIcon = nil; return copy
    }

    /// Sets a DSIcon for the center FAB button.
    public func fabDSIcon(_ icon: DSIcon) -> Self {
        var copy = self; copy._fabDSIcon = icon; copy._fabSystemIcon = nil; return copy
    }

    /// Sets the background color of the FAB button.
    public func fabColor(_ color: Color) -> Self {
        var copy = self; copy._fabColor = color; return copy
    }

    /// Sets the foreground (icon) color of the FAB button.
    public func fabForegroundColor(_ color: Color) -> Self {
        var copy = self; copy._fabForegroundColor = color; return copy
    }

    /// Sets the badge count displayed on the FAB button.
    public func fabBadgeCount(_ count: Int) -> Self {
        var copy = self; copy._fabBadgeCount = count; return copy
    }

    /// Sets the action triggered when the FAB button is tapped.
    public func onFabTap(_ action: @escaping () -> Void) -> Self {
        var copy = self; copy._onFabTap = action; return copy
    }

    // MARK: - Deprecated Inits

    @available(*, deprecated, message: "Use DSBottomBarLayout(items:selectedId:content:) with modifier methods instead")
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
        self._items = items
        self.__selectedId = selectedId
        self._style = style
        self._fabSystemIcon = fabIcon
        self._fabDSIcon = nil
        self._fabColor = fabColor
        self._fabForegroundColor = fabForegroundColor
        self._fabBadgeCount = fabBadgeCount
        self._onFabTap = onFabTap
        self._content = content()
    }

    @available(*, deprecated, message: "Use DSBottomBarLayout(items:selectedId:content:) with .fabDSIcon() modifier instead")
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
        self._items = items
        self.__selectedId = selectedId
        self._style = style
        self._fabSystemIcon = nil
        self._fabDSIcon = fabIcon
        self._fabColor = fabColor
        self._fabForegroundColor = fabForegroundColor
        self._fabBadgeCount = fabBadgeCount
        self._onFabTap = onFabTap
        self._content = content()
    }

    // MARK: - Body

    public var body: some View {
        _content
            .environment(\.dsBottomBarInset, barHeight)
            .safeAreaInset(edge: .bottom, spacing: 0) {
                DSBottomAppBar(items: _items, selectedId: $_selectedId)
                    .barStyle(_style)
                    .fabIconIfNeeded(_fabSystemIcon, dsIcon: _fabDSIcon)
                    .fabColorIfNeeded(_fabColor)
                    .fabForegroundColorIfNeeded(_fabForegroundColor)
                    .fabBadgeCountIfNeeded(_fabBadgeCount)
                    .onFabTapIfNeeded(_onFabTap)
                    .background(
                        GeometryReader { geo in
                            Color.clear.preference(key: BottomBarHeightKey.self, value: geo.size.height)
                        }
                    )
            }
            .onPreferenceChange(BottomBarHeightKey.self) { barHeight = $0 }
    }
}

// MARK: - Internal Conditional Modifier Helpers

extension DSBottomAppBar {
    /// Internal helper: conditionally applies fabIcon or fabDSIcon.
    fileprivate func fabIconIfNeeded(_ systemName: String?, dsIcon: DSIcon?) -> Self {
        var copy = self
        if let systemName { copy._fabSystemIcon = systemName; copy._fabDSIcon = nil }
        if let dsIcon { copy._fabDSIcon = dsIcon; copy._fabSystemIcon = nil }
        return copy
    }

    /// Internal helper: conditionally applies fabColor.
    fileprivate func fabColorIfNeeded(_ color: Color?) -> Self {
        guard let color else { return self }
        var copy = self; copy._fabColor = color; return copy
    }

    /// Internal helper: conditionally applies fabForegroundColor.
    fileprivate func fabForegroundColorIfNeeded(_ color: Color?) -> Self {
        guard let color else { return self }
        var copy = self; copy._fabForegroundColor = color; return copy
    }

    /// Internal helper: conditionally applies fabBadgeCount.
    fileprivate func fabBadgeCountIfNeeded(_ count: Int?) -> Self {
        guard let count else { return self }
        var copy = self; copy._fabBadgeCount = count; return copy
    }

    /// Internal helper: conditionally applies onFabTap.
    fileprivate func onFabTapIfNeeded(_ action: (() -> Void)?) -> Self {
        guard let action else { return self }
        var copy = self; copy._onFabTap = action; return copy
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
