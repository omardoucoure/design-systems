// figma-node: 87:100709
import SwiftUI

public enum DSCameraControlsBarStyle: Sendable, CaseIterable {
    case exposure
    case gridGallery
}

public struct DSCameraSetting: Identifiable, Sendable {
    public let id = UUID()
    public let icon: DSIcon
    public let label: LocalizedStringKey
    public let isAccented: Bool

    public init(icon: DSIcon, label: LocalizedStringKey, isAccented: Bool = false) {
        self.icon = icon
        self.label = label
        self.isAccented = isAccented
    }
}

public struct DSCameraControlsBar: View {
    @Environment(\.theme) private var theme

    private let _style: DSCameraControlsBarStyle
    private let _settings: [DSCameraSetting]
    private let _evLabels: [LocalizedStringKey]

    private var _onShutter: (() -> Void)?
    private var _onGrid: (() -> Void)?
    private var _onFlip: (() -> Void)?

    public init(
        style: DSCameraControlsBarStyle = .exposure,
        settings: [DSCameraSetting],
        evLabels: [LocalizedStringKey] = ["-2", "-1", "0", "+1", "+2", "+3"]
    ) {
        self._style = style
        self._settings = settings
        self._evLabels = evLabels
    }

    public func onShutter(_ action: @escaping () -> Void) -> Self {
        var copy = self
        copy._onShutter = action
        return copy
    }

    public func onGrid(_ action: @escaping () -> Void) -> Self {
        var copy = self
        copy._onGrid = action
        return copy
    }

    public func onFlip(_ action: @escaping () -> Void) -> Self {
        var copy = self
        copy._onFlip = action
        return copy
    }

    private var metrics: CameraControlsBarComponentTokens { theme.components.cameraControlsBar }

    public var body: some View {
        VStack(spacing: -metrics.cardOverlap) {
            topCard
            bottomCard
        }
    }

    private var topCard: some View {
        VStack(spacing: theme.spacing.lg) {
            HStack(spacing: theme.spacing.xxl) {
                ForEach(Array(_evLabels.enumerated()), id: \.offset) { _, label in
                    Text(label)
                        .font(theme.typography.smallSemiBold.font)
                        .tracking(theme.typography.smallSemiBold.tracking)
                        .foregroundStyle(theme.colors.textNeutral9)
                }
            }

            DSTickScale()

            HStack(spacing: theme.spacing.sm) {
                ForEach(_settings) { setting in
                    settingChip(setting)
                }
            }
        }
        .padding(theme.spacing.xl)
        .frame(maxWidth: .infinity)
        .background(theme.colors.surfaceNeutral2)
        .clipShape(RoundedRectangle(cornerRadius: theme.radius.xl))
        .zIndex(2)
    }

    private var bottomCard: some View {
        HStack {
            controlPill(icon: _style == .gridGallery ? .mediaImageList : .viewGrid) {
                _onGrid?()
            }

            Spacer()

            shutterButton

            Spacer()

            controlPill(icon: .refreshDouble) {
                _onFlip?()
            }
        }
        .padding(theme.spacing.xl)
        .padding(.top, metrics.cardOverlap)
        .frame(maxWidth: .infinity)
        .background(theme.colors.surfacePrimary100)
        .clipShape(RoundedRectangle(cornerRadius: theme.radius.xl))
        .zIndex(1)
    }

    private var shutterButton: some View {
        Button { _onShutter?() } label: {
            Circle()
                .fill(theme.colors.surfacePrimary100)
                .frame(width: metrics.shutterInnerSize, height: metrics.shutterInnerSize)
                .frame(width: metrics.shutterOuterSize, height: metrics.shutterOuterSize)
                .background(theme.colors.surfaceSecondary100)
                .clipShape(Circle())
        }
        .buttonStyle(.plain)
    }

    private func settingChip(_ setting: DSCameraSetting) -> some View {
        HStack(spacing: theme.spacing.xs) {
            glyph(setting.icon)
            Text(setting.label)
                .font(theme.typography.label.font)
                .tracking(theme.typography.label.tracking)
                .foregroundStyle(theme.colors.textNeutral9)
            glyph(.arrowSeparateVertical)
        }
        .padding(.horizontal, theme.spacing.sm)
        .padding(.vertical, theme.spacing.xxs)
        .frame(height: metrics.chipHeight)
        .background(setting.isAccented ? theme.colors.surfaceSecondary100 : Color.clear)
        .clipShape(RoundedRectangle(cornerRadius: theme.radius.full))
    }

    private func controlPill(icon: DSIcon, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            glyph(icon, color: theme.colors.textNeutral05)
                .frame(width: metrics.chipHeight, height: metrics.chipHeight)
                .background(theme.colors.surfacePrimary120)
                .clipShape(Circle())
        }
        .buttonStyle(.plain)
    }

    private func glyph(_ icon: DSIcon, color: Color? = nil) -> some View {
        Image(dsIcon: icon)
            .resizable()
            .renderingMode(.template)
            .scaledToFit()
            .frame(width: metrics.glyphSize, height: metrics.glyphSize)
            .foregroundStyle(color ?? theme.colors.textNeutral9)
    }
}
