import SwiftUI

// MARK: - DSAlertDialog

/// A modal dialog overlay with dimming background and centered alert card.
///
/// Usage (modifier-based):
/// ```swift
/// DSAlertDialog(
///     isPresented: $showDialog,
///     title: "Access to Your Contacts",
///     severity: .info
/// ) {
///     // optional extra content
/// } actions: {
///     DSButton("Allow") {}.buttonStyle(.filledA).buttonSize(.small).fullWidth()
///     DSButton("Don't Allow") {}.buttonStyle(.neutral).buttonSize(.small).fullWidth()
/// }
/// .message("HaHo wants to explore your contacts.")
/// .assetIcon("group_icon")
/// ```
public struct DSAlertDialog<Content: View, Actions: View>: View {
    @Environment(\.theme) private var theme

    // Core params (init)
    @Binding private var _isPresented: Bool
    private let _title: LocalizedStringKey
    private let _severity: DSAlertSeverity
    private let _content: Content
    private let _actions: Actions

    // Modifier params
    private var _message: LocalizedStringKey?
    private var _icon: DSIcon?
    private var _assetIcon: String?
    private var _systemIcon: String?

    /// Creates a dialog with core parameters. Use modifiers for optional configuration.
    public init(
        isPresented: Binding<Bool>,
        title: LocalizedStringKey,
        severity: DSAlertSeverity,
        @ViewBuilder content: () -> Content = { EmptyView() },
        @ViewBuilder actions: () -> Actions
    ) {
        self.__isPresented = isPresented
        self._title = title
        self._severity = severity
        self._content = content()
        self._actions = actions()
    }

    // MARK: - Deprecated Inits

    /// Deprecated: Use the modifier-based API instead.
    @available(*, deprecated, message: "Use init(isPresented:title:severity:content:actions:) with .message(), .icon(), .assetIcon(), .systemIcon() modifiers")
    public init(
        isPresented: Binding<Bool>,
        title: LocalizedStringKey,
        message: LocalizedStringKey? = nil,
        severity: DSAlertSeverity,
        icon: DSIcon,
        @ViewBuilder content: () -> Content = { EmptyView() },
        @ViewBuilder actions: () -> Actions
    ) {
        self.__isPresented = isPresented
        self._title = title
        self._severity = severity
        self._content = content()
        self._actions = actions()
        self._message = message
        self._icon = icon
    }

    /// Deprecated: Use the modifier-based API instead.
    @available(*, deprecated, message: "Use init(isPresented:title:severity:content:actions:) with .message(), .assetIcon(), .systemIcon() modifiers")
    public init(
        isPresented: Binding<Bool>,
        title: LocalizedStringKey,
        message: LocalizedStringKey? = nil,
        severity: DSAlertSeverity,
        assetIcon: String? = nil,
        systemIcon: String? = nil,
        @ViewBuilder content: () -> Content = { EmptyView() },
        @ViewBuilder actions: () -> Actions
    ) {
        self.__isPresented = isPresented
        self._title = title
        self._severity = severity
        self._content = content()
        self._actions = actions()
        self._message = message
        self._assetIcon = assetIcon
        self._systemIcon = systemIcon
    }

    // MARK: - Modifiers

    /// Sets the dialog message text displayed below the title.
    public func message(_ message: LocalizedStringKey) -> Self {
        var copy = self
        copy._message = message
        return copy
    }

    /// Sets a type-safe DSIcon for the dialog header.
    public func icon(_ icon: DSIcon) -> Self {
        var copy = self
        copy._icon = icon
        copy._assetIcon = nil
        copy._systemIcon = nil
        return copy
    }

    /// Sets a custom asset image icon for the dialog header.
    public func assetIcon(_ name: String) -> Self {
        var copy = self
        copy._assetIcon = name
        copy._icon = nil
        copy._systemIcon = nil
        return copy
    }

    /// Sets an SF Symbol icon for the dialog header.
    public func systemIcon(_ name: String) -> Self {
        var copy = self
        copy._systemIcon = name
        copy._icon = nil
        copy._assetIcon = nil
        return copy
    }

    // MARK: - Body

    public var body: some View {
        ZStack {
            if _isPresented {
                // Dimming overlay
                theme.colors.surfaceNeutral05
                    .opacity(0.5)
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                            _isPresented = false
                        }
                    }
                    .transition(.opacity)

                // Dialog card
                VStack(alignment: .leading, spacing: theme.spacing.md) {
                    // Icon
                    if let _icon {
                        Image(dsIcon: _icon)
                            .resizable()
                            .renderingMode(.template)
                            .scaledToFit()
                            .frame(width: 24, height: 24)
                            .foregroundStyle(iconForeground)
                    } else if let _assetIcon {
                        Image(_assetIcon, bundle: .main)
                            .resizable()
                            .renderingMode(.template)
                            .scaledToFit()
                            .frame(width: 24, height: 24)
                            .foregroundStyle(iconForeground)
                    } else if let _systemIcon {
                        Image(systemName: _systemIcon)
                            .font(.system(size: 20, weight: .medium))
                            .frame(width: 24, height: 24)
                            .foregroundStyle(iconForeground)
                    }

                    // Title
                    Text(_title)
                        .font(theme.typography.h5.font)
                        .tracking(theme.typography.h5.tracking)
                        .lineSpacing(theme.typography.h5.lineSpacing)
                        .foregroundStyle(textForeground)

                    // Message
                    if let _message {
                        Text(_message)
                            .font(theme.typography.caption.font)
                            .tracking(theme.typography.caption.tracking)
                            .foregroundStyle(textForeground)
                    }

                    // Extra content
                    _content

                    // Actions
                    VStack(spacing: theme.spacing.sm) {
                        _actions
                    }
                }
                .padding(theme.spacing.xl)
                .frame(width: 305)
                .background(dialogBackground)
                .clipShape(RoundedRectangle(cornerRadius: theme.radius.xl))
                .shadow(color: .black.opacity(0.02), radius: 4, x: 0, y: 4)
                .shadow(color: .black.opacity(0.18), radius: 24, x: 0, y: 24)
                .transition(.scale(scale: 0.85).combined(with: .opacity))
            }
        }
        .animation(.spring(response: 0.4, dampingFraction: 0.8), value: _isPresented)
    }

    private var dialogBackground: Color {
        // Figma: neutral dialogs use surfacePrimary120 (dark), not surfaceNeutral2
        _severity == .neutral ? theme.colors.surfacePrimary120 : _severity.color(from: theme.colors)
    }

    private var isDarkBackground: Bool {
        _severity == .neutral
    }

    private var textForeground: Color {
        isDarkBackground ? theme.colors.textNeutral05 : theme.colors.textNeutral9
    }

    private var iconForeground: Color {
        isDarkBackground ? theme.colors.textNeutral05 : theme.colors.textNeutral9
    }
}
