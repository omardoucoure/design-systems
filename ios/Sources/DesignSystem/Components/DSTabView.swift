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

public struct DSTabView<Content: View>: View {
    @Binding private var selection: String
    @Binding private var style: DSBottomAppBarStyle
    private let tabs: [DSBottomBarItem]
    private let content: Content
    @StateObject private var tabBarVisibility = DSTabBarVisibility()
    @StateObject private var tabBarState: DSTabBarState

    public init(
        selection: Binding<String>,
        tabs: [DSBottomBarItem],
        styleBinding: Binding<DSBottomAppBarStyle>,
        @ViewBuilder content: () -> Content
    ) {
        self._selection = selection
        self._style = styleBinding
        self.tabs = tabs
        self.content = content()
        self._tabBarState = StateObject(wrappedValue: DSTabBarState(
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
        self._selection = selection
        self._style = .constant(style)
        self.tabs = tabs
        self.content = content()
        self._tabBarState = StateObject(wrappedValue: DSTabBarState(
            selectedId: selection.wrappedValue,
            style: style
        ))
    }

    public var body: some View {
        ZStack(alignment: .bottom) {
            content
                .frame(maxWidth: .infinity, maxHeight: .infinity)

            if !tabBarVisibility.isHidden {
                DSTabBarView(tabs: tabs, tabBarState: tabBarState)
            }
        }
        .environment(\.dsTabBarVisibility, tabBarVisibility)
        .environment(\.dsTabBarState, tabBarState)
        .onChange(of: selection) { newValue in
            if tabBarState.selectedId != newValue {
                tabBarState.selectedId = newValue
            }
        }
        .onChange(of: style) { newValue in
            if tabBarState.style != newValue {
                tabBarState.style = newValue
            }
        }
        .onChange(of: tabBarState.selectedId) { newValue in
            if selection != newValue {
                selection = newValue
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
            ),
            style: tabBarState.style
        )
        .ignoresSafeArea(edges: .bottom)
    }
}
