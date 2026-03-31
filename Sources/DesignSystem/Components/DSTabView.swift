import SwiftUI

// MARK: - Tab Bar Visibility

public class DSTabBarVisibility: ObservableObject {
    @Published public var isHidden = false
    public init() {}
}

private struct DSTabBarVisibilityKey: EnvironmentKey {
    static let defaultValue: DSTabBarVisibility? = nil
}

public extension EnvironmentValues {
    var dsTabBarVisibility: DSTabBarVisibility? {
        get { self[DSTabBarVisibilityKey.self] }
        set { self[DSTabBarVisibilityKey.self] = newValue }
    }
}

public struct DSTabBarHiddenModifier: ViewModifier {
    @Environment(\.dsTabBarVisibility) private var visibility
    public func body(content: Content) -> some View {
        content
            .onAppear { visibility?.isHidden = true }
            .onDisappear { visibility?.isHidden = false }
    }
}

public extension View {
    func dsTabBarHidden() -> some View {
        modifier(DSTabBarHiddenModifier())
    }
}

// MARK: - DSTabBarState

/// ObservableObject that DSBottomAppBar observes directly.
/// Bypasses safeAreaInset's isolated render context.
public class DSTabBarState: ObservableObject {
    @Published public var selectedId: String
    @Published public var style: DSBottomAppBarStyle

    public init(selectedId: String, style: DSBottomAppBarStyle) {
        self.selectedId = selectedId
        self.style = style
    }
}

private struct DSTabBarStateKey: EnvironmentKey {
    static let defaultValue: DSTabBarState? = nil
}

public extension EnvironmentValues {
    var dsTabBarState: DSTabBarState? {
        get { self[DSTabBarStateKey.self] }
        set { self[DSTabBarStateKey.self] = newValue }
    }
}

// MARK: - DSTabView

/// A tab container with a DSBottomAppBar integrated as a safe-area inset.
///
/// DSTabView has generic ViewBuilder content and bindings as core params.
/// The style binding variant and constant-style variant are both available.
///
/// Usage:
/// ```swift
/// DSTabView(selection: $selectedTab, tabs: tabItems) {
///     // tab content
/// }
/// ```
public struct DSTabView<Content: View>: View {
    @Binding private var _selection: String
    @Binding private var _style: DSBottomAppBarStyle
    private let _tabs: [DSBottomBarItem]
    private let _content: Content
    @StateObject private var _tabBarVisibility = DSTabBarVisibility()
    @StateObject private var _tabBarState: DSTabBarState

    public init(
        selection: Binding<String>,
        tabs: [DSBottomBarItem],
        styleBinding: Binding<DSBottomAppBarStyle>,
        @ViewBuilder content: () -> Content
    ) {
        self.__selection = selection
        self.__style = styleBinding
        self._tabs = tabs
        self._content = content()
        self.__tabBarState = StateObject(wrappedValue: DSTabBarState(
            selectedId: selection.wrappedValue,
            style: styleBinding.wrappedValue
        ))
    }

    public init(
        selection: Binding<String>,
        tabs: [DSBottomBarItem],
        style: DSBottomAppBarStyle = .labeled,
        @ViewBuilder content: () -> Content
    ) {
        self.__selection = selection
        self.__style = .constant(style)
        self._tabs = tabs
        self._content = content()
        self.__tabBarState = StateObject(wrappedValue: DSTabBarState(
            selectedId: selection.wrappedValue,
            style: style
        ))
    }

    public var body: some View {
        _content
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .safeAreaInset(edge: .bottom, spacing: 0) {
                if !_tabBarVisibility.isHidden {
                    DSTabBarView(tabs: _tabs, tabBarState: _tabBarState)
                } else {
                    Color.clear.frame(height: 0)
                }
            }
            .environment(\.dsTabBarVisibility, _tabBarVisibility)
            .environment(\.dsTabBarState, _tabBarState)
            .onChange(of: _selection) { newValue in
            if _tabBarState.selectedId != newValue {
                _tabBarState.selectedId = newValue
            }
            }
            .onChange(of: _style) { newValue in
                if _tabBarState.style != newValue {
                    _tabBarState.style = newValue
                }
            }
            .onChange(of: _tabBarState.selectedId) { newValue in
                if _selection != newValue {
                    _selection = newValue
                }
            }
    }
}

// MARK: - DSTabBarView

/// Thin wrapper that observes DSTabBarState directly — always re-renders when state changes,
/// regardless of safeAreaInset isolation.
private struct DSTabBarView: View {
    let tabs: [DSBottomBarItem]
    @ObservedObject var tabBarState: DSTabBarState

    var body: some View {
        DSBottomAppBar(
            items: tabs,
            selectedId: Binding(
                get: { tabBarState.selectedId },
                set: { tabBarState.selectedId = $0 }
            )
        )
        .barStyle(tabBarState.style)
    }
}
