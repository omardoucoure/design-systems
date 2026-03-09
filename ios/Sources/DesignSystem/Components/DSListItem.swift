import SwiftUI

// MARK: - DSListItem

/// A themed list item row matching the Figma List component.
///
/// Supports generic leading and trailing content slots, with convenience
/// initializers for common patterns (icon + arrow).
///
/// Usage:
/// ```swift
/// // Minimal
/// DSListItem(headline: "Settings")
///
/// // Icon + arrow (convenience)
/// DSListItem(
///     headline: "Privacy",
///     leadingIcon: "lock",
///     showTrailingArrow: true
/// )
///
/// // Generic leading/trailing content
/// DSListItem(headline: "Notifications") {
///     DSToggle(isOn: .constant(true))
/// } trailing: {
///     DSBadge(variant: .numberBrand, count: 5)
/// }
/// ```
public struct DSListItem<Leading: View, Trailing: View>: View {
    @Environment(\.theme) private var theme

    private let overline: LocalizedStringKey?
    private let headline: LocalizedStringKey
    private let supportingText: LocalizedStringKey?
    private let metadata: LocalizedStringKey?
    private let showDivider: Bool
    private let action: (() -> Void)?
    private let leading: Leading
    private let trailing: Trailing

    // MARK: - Full Generic Init

    public init(
        overline: LocalizedStringKey? = nil,
        headline: LocalizedStringKey,
        supportingText: LocalizedStringKey? = nil,
        metadata: LocalizedStringKey? = nil,
        showDivider: Bool = false,
        action: (() -> Void)? = nil,
        @ViewBuilder leading: () -> Leading,
        @ViewBuilder trailing: () -> Trailing
    ) {
        self.overline = overline
        self.headline = headline
        self.supportingText = supportingText
        self.metadata = metadata
        self.showDivider = showDivider
        self.action = action
        self.leading = leading()
        self.trailing = trailing()
    }

    // MARK: - Body

    public var body: some View {
        let content = HStack(spacing: theme.components.listItem.rowGap) {
            leading

            VStack(alignment: .leading, spacing: 0) {
                if let overline {
                    Text(overline)
                        .font(theme.typography.small.font)
                        .tracking(theme.typography.small.tracking)
                        .foregroundStyle(theme.colors.textNeutral9.opacity(theme.colors.textOpacity75))
                }

                Text(headline)
                    .font(theme.typography.bodySemiBold.font)
                    .tracking(theme.typography.bodySemiBold.tracking)
                    .foregroundStyle(theme.colors.textNeutral9)

                if let supportingText {
                    Text(supportingText)
                        .font(theme.typography.body.font)
                        .tracking(theme.typography.body.tracking)
                        .foregroundStyle(theme.colors.textNeutral8.opacity(theme.colors.textOpacity75))
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            if metadata != nil {
                if let metadata {
                    Text(metadata)
                        .font(theme.typography.body.font)
                        .tracking(theme.typography.body.tracking)
                        .foregroundStyle(theme.colors.textNeutral8.opacity(theme.colors.textOpacity75))
                        .padding(.horizontal, theme.spacing.xs)
                        .padding(.vertical, theme.components.listItem.metadataVerticalPadding)
                }
            }

            trailing
        }
        .padding(theme.spacing.md)
        .background(theme.colors.surfaceNeutral2)

        if let action {
            Button(action: action) { content }
                .buttonStyle(.plain)
                .overlay(alignment: .bottom) { dividerView }
        } else {
            content
                .overlay(alignment: .bottom) { dividerView }
        }
    }

    @ViewBuilder
    private var dividerView: some View {
        if showDivider {
            Rectangle()
                .fill(theme.colors.borderNeutral3)
                .frame(height: 1)
        }
    }
}

// MARK: - Convenience Init (Leading = icon, Trailing = arrow)

extension DSListItem where Leading == AnyView, Trailing == AnyView {

    /// Convenience initializer matching the original API with optional icon and arrow.
    public init(
        overline: LocalizedStringKey? = nil,
        headline: LocalizedStringKey,
        supportingText: LocalizedStringKey? = nil,
        leadingIcon: String? = nil,
        metadata: LocalizedStringKey? = nil,
        showTrailingArrow: Bool = false,
        showDivider: Bool = false,
        action: (() -> Void)? = nil
    ) {
        self.overline = overline
        self.headline = headline
        self.supportingText = supportingText
        self.metadata = metadata
        self.showDivider = showDivider
        self.action = action

        if let leadingIcon {
            self.leading = AnyView(
                Image(systemName: leadingIcon)
                    .font(.system(size: ListItemComponentTokens.shared.leadingIconSize))
                    .frame(width: ListItemComponentTokens.shared.leadingIconSize, height: ListItemComponentTokens.shared.leadingIconSize)
                    .padding(ListItemComponentTokens.shared.iconPadding)
            )
        } else {
            self.leading = AnyView(EmptyView())
        }

        if showTrailingArrow {
            self.trailing = AnyView(
                Image(systemName: "arrow.right")
                    .font(.system(size: ListItemComponentTokens.shared.trailingIconSize))
                    .padding(.horizontal, ListItemComponentTokens.shared.metadataVerticalPadding)
                    .padding(.vertical, ListItemComponentTokens.shared.iconPadding)
            )
        } else {
            self.trailing = AnyView(EmptyView())
        }
    }
}

// MARK: - Convenience Init (Leading only)

extension DSListItem where Trailing == EmptyView {

    public init(
        overline: LocalizedStringKey? = nil,
        headline: LocalizedStringKey,
        supportingText: LocalizedStringKey? = nil,
        metadata: LocalizedStringKey? = nil,
        showDivider: Bool = false,
        action: (() -> Void)? = nil,
        @ViewBuilder leading: () -> Leading
    ) {
        self.overline = overline
        self.headline = headline
        self.supportingText = supportingText
        self.metadata = metadata
        self.showDivider = showDivider
        self.action = action
        self.leading = leading()
        self.trailing = EmptyView()
    }
}

// MARK: - Convenience Init (Trailing only)

extension DSListItem where Leading == EmptyView {

    public init(
        overline: LocalizedStringKey? = nil,
        headline: LocalizedStringKey,
        supportingText: LocalizedStringKey? = nil,
        metadata: LocalizedStringKey? = nil,
        showDivider: Bool = false,
        action: (() -> Void)? = nil,
        @ViewBuilder trailing: () -> Trailing
    ) {
        self.overline = overline
        self.headline = headline
        self.supportingText = supportingText
        self.metadata = metadata
        self.showDivider = showDivider
        self.action = action
        self.leading = EmptyView()
        self.trailing = trailing()
    }
}
