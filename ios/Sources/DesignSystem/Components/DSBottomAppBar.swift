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
    public let systemIcon: String
    public let badgeCount: Int?

    public init(
        id: String,
        label: LocalizedStringKey,
        systemIcon: String,
        badgeCount: Int? = nil
    ) {
        self.id = id
        self.label = label
        self.systemIcon = systemIcon
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

    private let items: [DSBottomBarItem]
    @Binding private var selectedId: String
    private let style: DSBottomAppBarStyle
    private let fabIcon: String?
    private let onFabTap: (() -> Void)?

    public init(
        items: [DSBottomBarItem],
        selectedId: Binding<String>,
        style: DSBottomAppBarStyle = .labeled,
        fabIcon: String? = nil,
        onFabTap: (() -> Void)? = nil
    ) {
        self.items = items
        self._selectedId = selectedId
        self.style = style
        self.fabIcon = fabIcon
        self.onFabTap = onFabTap
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
        HStack {
            let halfCount = items.count / 2
            let leftItems = Array(items.prefix(halfCount))
            let rightItems = Array(items.suffix(items.count - halfCount))

            ForEach(leftItems) { item in
                iconButton(item)
            }

            if let fabIcon {
                fabButton(icon: fabIcon, size: 56)
            }

            ForEach(rightItems) { item in
                iconButton(item)
            }
        }
        .padding(.horizontal, theme.spacing.lg)
        .padding(.top, theme.spacing.md)
        .padding(.bottom, theme.spacing.xs)
        .frame(maxWidth: .infinity)
        .background(theme.colors.surfaceNeutral2)
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

            if let fabIcon {
                fabButton(icon: fabIcon, size: 40)
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
        .padding(.top, theme.spacing.lg)
        .padding(.bottom, theme.spacing.xs)
        .frame(maxWidth: .infinity)
        .background(theme.colors.surfaceNeutral2)
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
    }

    // MARK: - Shared Components

    private func iconButton(_ item: DSBottomBarItem) -> some View {
        let isSelected = item.id == selectedId

        return Button {
            selectedId = item.id
        } label: {
            Image(systemName: item.systemIcon)
                .font(.system(size: 24))
                .frame(width: 24, height: 24)
                .foregroundStyle(theme.colors.textNeutral9)
                .frame(height: 40)
                .padding(.horizontal, theme.spacing.md)
                .background(
                    isSelected
                        ? theme.colors.surfaceSecondary100
                        : Color.clear
                )
                .clipShape(Capsule())
        }
        .buttonStyle(.plain)
    }

    private func labeledButton(_ item: DSBottomBarItem) -> some View {
        let isSelected = item.id == selectedId

        return Button {
            selectedId = item.id
        } label: {
            VStack(spacing: 4) {
                ZStack(alignment: .topTrailing) {
                    Image(systemName: item.systemIcon)
                        .font(.system(size: 24))
                        .frame(width: 24, height: 24)
                        .foregroundStyle(theme.colors.textNeutral9)
                        .frame(height: 40)
                        .padding(.horizontal, theme.spacing.md)
                        .background(
                            isSelected
                                ? theme.colors.surfaceSecondary100
                                : Color.clear
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
                    .foregroundStyle(theme.colors.textNeutral9)
            }
            .frame(maxWidth: .infinity)
        }
        .buttonStyle(.plain)
    }

    private func fabButton(icon: String, size: CGFloat) -> some View {
        Button {
            onFabTap?()
        } label: {
            Image(systemName: icon)
                .font(.system(size: 24))
                .frame(width: 24, height: 24)
                .foregroundStyle(theme.colors.textNeutral0_5)
                .frame(height: size)
                .padding(.horizontal, size == 56 ? theme.spacing.lg : theme.spacing.md)
                .background(theme.colors.surfacePrimary120)
                .clipShape(Capsule())
        }
        .buttonStyle(.plain)
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
