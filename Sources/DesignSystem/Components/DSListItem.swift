import SwiftUI

// MARK: - DSListItem

/// A themed list item row matching the Figma List component.
///
/// Supports generic leading and trailing content slots, with modifier-based
/// customization for optional properties.
///
/// Usage:
/// ```swift
/// // Minimal
/// DSListItem("Settings") {
///     EmptyView()
/// } trailing: {
///     EmptyView()
/// }
///
/// // With modifiers
/// DSListItem("Privacy") {
///     Image(systemName: "lock")
/// } trailing: {
///     Image(systemName: "chevron.right")
/// }
/// .overline("Category")
/// .metadata("3m ago")
/// .showDivider()
///
/// // Leading only
/// DSListItem("Notifications") {
///     DSProgressCircle(progress: 0.8, size: 40)
/// }
/// .supportingText("3 new")
///
/// // No slots
/// DSListItem("Simple row")
///     .metadata("Info")
/// ```
public struct DSListItem<Leading: View, Trailing: View>: View {
    @Environment(\.theme) private var theme

    // Core (required)
    private let _headline: LocalizedStringKey
    private let _leading: Leading
    private let _trailing: Trailing

    // Configurable via modifiers (all have defaults)
    private var _overline: LocalizedStringKey?
    private var _supportingText: LocalizedStringKey?
    private var _metadata: LocalizedStringKey?
    private var _showDivider: Bool = false
    private var _action: (() -> Void)?

    // MARK: - Init (full generic: leading + trailing)

    /// Full generic init with leading and trailing view builders.
    public init(
        _ headline: LocalizedStringKey,
        @ViewBuilder leading: () -> Leading,
        @ViewBuilder trailing: () -> Trailing
    ) {
        self._headline = headline
        self._leading = leading()
        self._trailing = trailing()
    }

    // MARK: - Modifiers

    public func overline(_ text: LocalizedStringKey) -> Self {
        var copy = self
        copy._overline = text
        return copy
    }

    public func supportingText(_ text: LocalizedStringKey) -> Self {
        var copy = self
        copy._supportingText = text
        return copy
    }

    public func metadata(_ text: LocalizedStringKey) -> Self {
        var copy = self
        copy._metadata = text
        return copy
    }

    public func showDivider(_ show: Bool = true) -> Self {
        var copy = self
        copy._showDivider = show
        return copy
    }

    public func onAction(_ action: @escaping () -> Void) -> Self {
        var copy = self
        copy._action = action
        return copy
    }

    // MARK: - Deprecated inits (backward compat)

    @available(*, deprecated, message: "Use DSListItem(headline) { leading } trailing: { trailing } with modifier chain instead")
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
        self._overline = overline
        self._headline = headline
        self._supportingText = supportingText
        self._metadata = metadata
        self._showDivider = showDivider
        self._action = action
        self._leading = leading()
        self._trailing = trailing()
    }

    // MARK: - Body

    public var body: some View {
        let content = HStack(spacing: theme.components.listItem.rowGap) {
            _leading

            VStack(alignment: .leading, spacing: 0) {
                if let _overline {
                    Text(_overline)
                        .font(theme.typography.small.font)
                        .tracking(theme.typography.small.tracking)
                        .foregroundStyle(theme.colors.textNeutral9.opacity(theme.colors.textOpacity75))
                }

                Text(_headline)
                    .font(theme.typography.bodySemiBold.font)
                    .tracking(theme.typography.bodySemiBold.tracking)
                    .foregroundStyle(theme.colors.textNeutral9)

                if let _supportingText {
                    Text(_supportingText)
                        .font(theme.typography.body.font)
                        .tracking(theme.typography.body.tracking)
                        .foregroundStyle(theme.colors.textNeutral8.opacity(theme.colors.textOpacity75))
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            if _metadata != nil {
                if let _metadata {
                    Text(_metadata)
                        .font(theme.typography.body.font)
                        .tracking(theme.typography.body.tracking)
                        .foregroundStyle(theme.colors.textNeutral8.opacity(theme.colors.textOpacity75))
                        .padding(.horizontal, theme.spacing.xs)
                        .padding(.vertical, theme.components.listItem.metadataVerticalPadding)
                }
            }

            _trailing
        }
        .padding(theme.spacing.md)
        .background(theme.colors.surfaceNeutral2)

        if let _action {
            Button(action: _action) { content }
                .buttonStyle(.plain)
                .overlay(alignment: .bottom) { dividerView }
        } else {
            content
                .overlay(alignment: .bottom) { dividerView }
        }
    }

    @ViewBuilder
    private var dividerView: some View {
        if _showDivider {
            Rectangle()
                .fill(theme.colors.borderNeutral3)
                .frame(height: 1)
        }
    }
}

// MARK: - Convenience Init (Leading only)

extension DSListItem where Trailing == EmptyView {

    /// Leading-only init. Trailing defaults to EmptyView.
    public init(
        _ headline: LocalizedStringKey,
        @ViewBuilder leading: () -> Leading
    ) {
        self._headline = headline
        self._leading = leading()
        self._trailing = EmptyView()
    }

    @available(*, deprecated, message: "Use DSListItem(headline) { leading } with modifier chain instead")
    public init(
        overline: LocalizedStringKey? = nil,
        headline: LocalizedStringKey,
        supportingText: LocalizedStringKey? = nil,
        metadata: LocalizedStringKey? = nil,
        showDivider: Bool = false,
        action: (() -> Void)? = nil,
        @ViewBuilder leading: () -> Leading
    ) {
        self._overline = overline
        self._headline = headline
        self._supportingText = supportingText
        self._metadata = metadata
        self._showDivider = showDivider
        self._action = action
        self._leading = leading()
        self._trailing = EmptyView()
    }
}

// MARK: - Convenience Init (Trailing only)

extension DSListItem where Leading == EmptyView {

    /// Trailing-only init. Leading defaults to EmptyView.
    public init(
        _ headline: LocalizedStringKey,
        @ViewBuilder trailing: () -> Trailing
    ) {
        self._headline = headline
        self._leading = EmptyView()
        self._trailing = trailing()
    }

    @available(*, deprecated, message: "Use DSListItem(headline) { trailing } with modifier chain instead")
    public init(
        overline: LocalizedStringKey? = nil,
        headline: LocalizedStringKey,
        supportingText: LocalizedStringKey? = nil,
        metadata: LocalizedStringKey? = nil,
        showDivider: Bool = false,
        action: (() -> Void)? = nil,
        @ViewBuilder trailing: () -> Trailing
    ) {
        self._overline = overline
        self._headline = headline
        self._supportingText = supportingText
        self._metadata = metadata
        self._showDivider = showDivider
        self._action = action
        self._leading = EmptyView()
        self._trailing = trailing()
    }
}

// MARK: - Convenience Init (No slots)

extension DSListItem where Leading == EmptyView, Trailing == EmptyView {

    /// Minimal init with no leading or trailing content.
    public init(_ headline: LocalizedStringKey) {
        self._headline = headline
        self._leading = EmptyView()
        self._trailing = EmptyView()
    }
}

// MARK: - Convenience Init (Leading = icon, Trailing = arrow) — Deprecated

extension DSListItem where Leading == AnyView, Trailing == AnyView {

    @available(*, deprecated, message: "Use DSListItem(headline) with leading/trailing ViewBuilders and modifier chain instead")
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
        self._overline = overline
        self._headline = headline
        self._supportingText = supportingText
        self._metadata = metadata
        self._showDivider = showDivider
        self._action = action

        if let leadingIcon {
            self._leading = AnyView(
                Image(systemName: leadingIcon)
                    .font(.system(size: ListItemComponentTokens.shared.leadingIconSize))
                    .frame(width: ListItemComponentTokens.shared.leadingIconSize, height: ListItemComponentTokens.shared.leadingIconSize)
                    .padding(ListItemComponentTokens.shared.iconPadding)
            )
        } else {
            self._leading = AnyView(EmptyView())
        }

        if showTrailingArrow {
            self._trailing = AnyView(
                Image(systemName: "arrow.right")
                    .font(.system(size: ListItemComponentTokens.shared.trailingIconSize))
                    .padding(.horizontal, ListItemComponentTokens.shared.metadataVerticalPadding)
                    .padding(.vertical, ListItemComponentTokens.shared.iconPadding)
            )
        } else {
            self._trailing = AnyView(EmptyView())
        }
    }
}
