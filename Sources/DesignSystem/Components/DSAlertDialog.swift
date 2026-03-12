import SwiftUI

// MARK: - DSAlertDialog

/// A modal dialog overlay with dimming background and centered alert card.
///
/// Usage:
/// ```swift
/// DSAlertDialog(
///     isPresented: $showDialog,
///     title: "Access to Your Contacts",
///     message: "HaHo wants to explore your contacts.",
///     severity: .info,
///     assetIcon: "group_icon"
/// ) {
///     DSButton("Allow", style: .filledA, size: .small, isFullWidth: true) {}
///     DSButton("Don't Allow", style: .neutral, size: .small, isFullWidth: true) {}
/// }
/// ```
public struct DSAlertDialog<Content: View, Actions: View>: View {
    @Environment(\.theme) private var theme

    @Binding private var isPresented: Bool
    private let title: LocalizedStringKey
    private let message: LocalizedStringKey?
    private let severity: DSAlertSeverity
    private let icon: DSIcon?
    private let assetIcon: String?
    private let systemIcon: String?
    private let content: Content
    private let actions: Actions

    /// Dialog with type-safe DSIcon.
    public init(
        isPresented: Binding<Bool>,
        title: LocalizedStringKey,
        message: LocalizedStringKey? = nil,
        severity: DSAlertSeverity,
        icon: DSIcon,
        @ViewBuilder content: () -> Content = { EmptyView() },
        @ViewBuilder actions: () -> Actions
    ) {
        self._isPresented = isPresented
        self.title = title
        self.message = message
        self.severity = severity
        self.icon = icon
        self.assetIcon = nil
        self.systemIcon = nil
        self.content = content()
        self.actions = actions()
    }

    /// Dialog with optional extra content between message and actions.
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
        self._isPresented = isPresented
        self.title = title
        self.message = message
        self.severity = severity
        self.icon = nil
        self.assetIcon = assetIcon
        self.systemIcon = systemIcon
        self.content = content()
        self.actions = actions()
    }

    public var body: some View {
        ZStack {
            if isPresented {
                // Dimming overlay
                theme.colors.surfaceNeutral0_5
                    .opacity(0.5)
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                            isPresented = false
                        }
                    }
                    .transition(.opacity)

                // Dialog card
                VStack(alignment: .leading, spacing: theme.spacing.md) {
                    // Icon
                    if let icon {
                        Image(dsIcon: icon)
                            .resizable()
                            .renderingMode(.template)
                            .scaledToFit()
                            .frame(width: 24, height: 24)
                            .foregroundStyle(iconForeground)
                    } else if let assetIcon {
                        Image(assetIcon, bundle: .main)
                            .resizable()
                            .renderingMode(.template)
                            .scaledToFit()
                            .frame(width: 24, height: 24)
                            .foregroundStyle(iconForeground)
                    } else if let systemIcon {
                        Image(systemName: systemIcon)
                            .font(.system(size: 20, weight: .medium))
                            .frame(width: 24, height: 24)
                            .foregroundStyle(iconForeground)
                    }

                    // Title
                    Text(title)
                        .font(theme.typography.h5.font)
                        .tracking(theme.typography.h5.tracking)
                        .lineSpacing(theme.typography.h5.lineSpacing)
                        .foregroundStyle(textForeground)

                    // Message
                    if let message {
                        Text(message)
                            .font(theme.typography.caption.font)
                            .tracking(theme.typography.caption.tracking)
                            .foregroundStyle(textForeground)
                    }

                    // Extra content
                    content

                    // Actions
                    VStack(spacing: theme.spacing.sm) {
                        actions
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
        .animation(.spring(response: 0.4, dampingFraction: 0.8), value: isPresented)
    }

    private var dialogBackground: Color {
        // Figma: neutral dialogs use surfacePrimary120 (dark), not surfaceNeutral2
        severity == .neutral ? theme.colors.surfacePrimary120 : severity.color(from: theme.colors)
    }

    private var isDarkBackground: Bool {
        severity == .neutral
    }

    private var textForeground: Color {
        isDarkBackground ? theme.colors.textNeutral0_5 : theme.colors.textNeutral9
    }

    private var iconForeground: Color {
        isDarkBackground ? theme.colors.textNeutral0_5 : theme.colors.textNeutral9
    }
}
