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
/// Usage:
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
///         ],
///         onItemTap: { item in print(item.label) }
///     )
/// }
/// ```
public struct DSBottomNavOverlay: View {
    @Environment(\.theme) private var theme

    @Binding private var isPresented: Bool
    private let items: [DSBottomNavOverlayItem]
    private let onItemTap: ((DSBottomNavOverlayItem) -> Void)?

    public init(
        isPresented: Binding<Bool>,
        items: [DSBottomNavOverlayItem],
        onItemTap: ((DSBottomNavOverlayItem) -> Void)? = nil
    ) {
        self._isPresented = isPresented
        self.items = items
        self.onItemTap = onItemTap
    }

    public var body: some View {
        ZStack {
            // Dimmed background
            theme.colors.surfaceNeutral0_5
                .opacity(0.9)
                .ignoresSafeArea()

            // Content area — bottom-aligned buttons
            VStack {
                Spacer()

                VStack(spacing: theme.spacing.sm) {
                    ForEach(items) { item in
                        navButton(item)
                    }

                    // Close button
                    DSButton(style: .filledC, size: .big, icon: .xmark) {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            isPresented = false
                        }
                    }
                }
                .padding(.horizontal, theme.spacing.xl)
                .padding(.bottom, theme.spacing.xl)
            }
        }
    }

    // MARK: - Nav Button

    private func navButton(_ item: DSBottomNavOverlayItem) -> some View {
        Button {
            onItemTap?(item)
        } label: {
            HStack {
                Text(item.label)
                    .font(theme.typography.bodySemiBold.font)
                    .tracking(theme.typography.bodySemiBold.tracking)
                    .foregroundStyle(theme.colors.textNeutral0_5)

                Spacer()

                DSIconImage(.arrowRightLong, size: 24, color: theme.colors.textNeutral0_5)
            }
            .padding(.horizontal, theme.spacing.lg)
            .padding(.vertical, theme.spacing.md)
            .background(theme.colors.surfacePrimary100)
            .clipShape(Capsule())
        }
        .buttonStyle(.plain)
    }
}
