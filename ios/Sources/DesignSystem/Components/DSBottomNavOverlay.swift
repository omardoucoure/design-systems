import SwiftUI

// MARK: - DSBottomNavOverlayItem

/// A single navigation item in the bottom overlay menu.
public struct DSBottomNavOverlayItem: Identifiable {
    public let id: String
    public let label: String

    public init(id: String, label: String) {
        self.id = id
        self.label = label
    }
}

// MARK: - DSBottomNavOverlay

/// A full-screen bottom navigation overlay with pill-shaped menu buttons and an X close button.
///
/// Figma: [Navigation] 7 (node 481:14430)
///
/// Shows a 90% opacity overlay on top of the page content with vertically stacked
/// navigation buttons (surfacePrimary100) and a close button (surfacePrimary120) at the bottom.
///
/// Usage (modifier-based):
/// ```swift
/// @State private var showMenu = false
///
/// ZStack {
///     pageContent
///     DSBottomNavOverlay(
///         isPresented: $showMenu,
///         items: [
///             DSBottomNavOverlayItem(id: "messages", label: "Messages"),
///             DSBottomNavOverlayItem(id: "trending", label: "Trending"),
///         ]
///     )
///     .onItemTap { item in print(item.label) }
/// }
/// ```
public struct DSBottomNavOverlay: View {
    @Environment(\.theme) private var theme

    // Core params (init)
    @Binding private var _isPresented: Bool
    private let _items: [DSBottomNavOverlayItem]

    // Modifier params
    private var _onItemTap: ((DSBottomNavOverlayItem) -> Void)?

    /// Creates a bottom nav overlay. Use `.onItemTap()` modifier for tap handling.
    public init(
        isPresented: Binding<Bool>,
        items: [DSBottomNavOverlayItem]
    ) {
        self.__isPresented = isPresented
        self._items = items
    }

    // MARK: - Deprecated Init

    @available(*, deprecated, message: "Use init(isPresented:items:) with .onItemTap() modifier")
    public init(
        isPresented: Binding<Bool>,
        items: [DSBottomNavOverlayItem],
        onItemTap: ((DSBottomNavOverlayItem) -> Void)? = nil
    ) {
        self.__isPresented = isPresented
        self._items = items
        self._onItemTap = onItemTap
    }

    // MARK: - Modifiers

    /// Sets the callback invoked when a navigation item is tapped.
    public func onItemTap(_ handler: @escaping (DSBottomNavOverlayItem) -> Void) -> Self {
        var copy = self
        copy._onItemTap = handler
        return copy
    }

    public var body: some View {
        ZStack {
            // Dimmed background
            theme.colors.surfaceNeutral05
                .opacity(0.9)
                .ignoresSafeArea()

            // Content area — bottom-aligned buttons
            VStack {
                Spacer()

                VStack(spacing: theme.spacing.sm) {
                    ForEach(_items) { item in
                        navButton(item)
                    }

                    // Close button
                    DSButton {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            _isPresented = false
                        }
                    }.buttonStyle(.filledC).icon(.xmark)
                }
                .padding(.horizontal, theme.spacing.xl)
                .padding(.bottom, theme.spacing.xl)
            }
        }
    }

    // MARK: - Nav Button

    private func navButton(_ item: DSBottomNavOverlayItem) -> some View {
        Button {
            _onItemTap?(item)
        } label: {
            HStack {
                Text(item.label)
                    .font(theme.typography.bodySemiBold.font)
                    .tracking(theme.typography.bodySemiBold.tracking)
                    .foregroundStyle(theme.colors.textNeutral05)

                Spacer()

                DSIconImage(.arrowRightLong, size: 24, color: theme.colors.textNeutral05)
            }
            .padding(.horizontal, theme.spacing.lg)
            .padding(.vertical, theme.spacing.md)
            .background(theme.colors.surfacePrimary100)
            .clipShape(Capsule())
        }
        .buttonStyle(.plain)
    }
}
