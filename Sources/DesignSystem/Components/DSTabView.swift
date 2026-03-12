import SwiftUI

// MARK: - Tab Bar Visibility

/// Observable object to control DS tab bar visibility from child views.
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

/// View modifier that hides the DS tab bar when this view appears and shows it when it disappears.
public struct DSTabBarHiddenModifier: ViewModifier {
    @Environment(\.dsTabBarVisibility) private var visibility

    public func body(content: Content) -> some View {
        content
            .onAppear { visibility?.isHidden = true }
            .onDisappear { visibility?.isHidden = false }
    }
}

public extension View {
    /// Hides the DSTabView bottom bar while this view is on screen.
    func dsTabBarHidden() -> some View {
        modifier(DSTabBarHiddenModifier())
    }
}

// MARK: - DSTabView

/// A custom tab container that avoids the native TabView entirely.
/// Uses a ZStack with manual tab switching to prevent iOS 26's native
/// tab bar from interfering with the custom DSBottomAppBar.
public struct DSTabView<Content: View>: View {
    @Environment(\.theme) private var theme
    @Binding private var selection: String
    private let tabs: [DSBottomBarItem]
    private let style: DSBottomAppBarStyle
    private let content: Content
    @StateObject private var tabBarVisibility = DSTabBarVisibility()

    public init(
        selection: Binding<String>,
        tabs: [DSBottomBarItem],
        style: DSBottomAppBarStyle = .labeled,
        @ViewBuilder content: () -> Content
    ) {
        self._selection = selection
        self.tabs = tabs
        self.style = style
        self.content = content()
    }

    public var body: some View {
        VStack(spacing: 0) {
            ZStack {
                content
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)

            if !tabBarVisibility.isHidden {
                barContent
            }
        }
        .environment(\.dsTabBarVisibility, tabBarVisibility)
    }

    @ViewBuilder
    private var barContent: some View {
        switch style {
        case .floating:
            DSBottomAppBar(
                items: tabs,
                selectedId: $selection,
                style: .floating
            )

        case .full, .labeled:
            DSBottomAppBar(
                items: tabs,
                selectedId: $selection,
                style: style,
                embedded: true
            )
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
            )
        }
    }
}
