// figma-node: 87:100817
import SwiftUI

public enum DSPhotoEditToolbarStyle: Sendable, CaseIterable {
    case adjustments
    case cropRatios
}

public struct DSCropRatio: Identifiable, Sendable {
    public let id = UUID()
    public let label: LocalizedStringKey
    public let height: CGFloat
    public let isSelected: Bool

    public init(label: LocalizedStringKey, height: CGFloat, isSelected: Bool = false) {
        self.label = label
        self.height = height
        self.isSelected = isSelected
    }
}

public struct DSPhotoAdjustment: Identifiable, Sendable {
    public let id = UUID()
    public let icon: DSIcon

    public init(icon: DSIcon) {
        self.icon = icon
    }
}

public struct DSPhotoEditToolbar: View {
    @Environment(\.theme) private var theme

    private let _style: DSPhotoEditToolbarStyle
    private let _value: LocalizedStringKey
    private let _adjustments: [DSPhotoAdjustment]
    private let _ratios: [DSCropRatio]

    private var _onConfirm: (() -> Void)?

    public init(
        style: DSPhotoEditToolbarStyle = .adjustments,
        value: LocalizedStringKey = "-12",
        adjustments: [DSPhotoAdjustment] = [
            DSPhotoAdjustment(icon: .editPencil),
            DSPhotoAdjustment(icon: .halfMoon),
            DSPhotoAdjustment(icon: .droplet),
            DSPhotoAdjustment(icon: .sunLight)
        ],
        ratios: [DSCropRatio] = [
            DSCropRatio(label: "Custom", height: 50, isSelected: true),
            DSCropRatio(label: "3:2", height: 40),
            DSCropRatio(label: "3:4", height: 35),
            DSCropRatio(label: "5:4", height: 30),
            DSCropRatio(label: "1:1", height: 50)
        ]
    ) {
        self._style = style
        self._value = value
        self._adjustments = adjustments
        self._ratios = ratios
    }

    public func onConfirm(_ action: @escaping () -> Void) -> Self {
        var copy = self
        copy._onConfirm = action
        return copy
    }

    private var metrics: PhotoEditToolbarComponentTokens { theme.components.photoEditToolbar }

    public var body: some View {
        switch _style {
        case .adjustments: adjustmentsBody
        case .cropRatios: cropRatiosBody
        }
    }

    // MARK: - Adjustments

    private var adjustmentsBody: some View {
        VStack(spacing: -metrics.cardOverlap) {
            valueCard
            toolRowCard
        }
    }

    private var valueCard: some View {
        HStack(spacing: theme.spacing.sm) {
            glyph(.arrowLeft, size: metrics.glyphSize, color: theme.colors.textNeutral9)
            Text(_value)
                .font(theme.typography.label.font)
                .tracking(theme.typography.label.tracking)
                .foregroundStyle(theme.colors.textNeutral9)
            glyph(.mediaImageList, size: metrics.glyphSize, color: theme.colors.textNeutral9)
        }
        .padding(.horizontal, theme.spacing.md)
        .padding(.vertical, theme.spacing.xs)
        .frame(width: metrics.valuePillWidth, height: metrics.valuePillHeight)
        .background(theme.colors.surfaceSecondary100)
        .clipShape(RoundedRectangle(cornerRadius: theme.radius.full))
        .frame(maxWidth: .infinity)
        .padding(theme.spacing.xl)
        .background(theme.colors.surfaceNeutral2)
        .clipShape(RoundedRectangle(cornerRadius: theme.radius.xl))
        .zIndex(2)
    }

    private var toolRowCard: some View {
        HStack {
            ForEach(_adjustments) { adjustment in
                controlPill(icon: adjustment.icon)
                Spacer()
            }

            DSButton(style: .filledA, size: .big, icon: .check) {
                _onConfirm?()
            }
        }
        .padding(theme.spacing.xl)
        .padding(.top, metrics.cardOverlap)
        .frame(maxWidth: .infinity)
        .background(theme.colors.surfacePrimary100)
        .clipShape(RoundedRectangle(cornerRadius: theme.radius.xl))
        .zIndex(1)
    }

    private func controlPill(icon: DSIcon) -> some View {
        HStack(spacing: theme.spacing.xxs) {
            glyph(icon, size: metrics.glyphSize, color: theme.colors.textNeutral05)
            glyph(.infoCircle, size: metrics.glyphSize, color: theme.colors.textNeutral05)
        }
        .padding(.horizontal, theme.spacing.sm)
        .frame(height: metrics.controlPillSize)
        .background(theme.colors.surfacePrimary120)
        .clipShape(RoundedRectangle(cornerRadius: theme.radius.full))
    }

    // MARK: - CropRatios

    private var cropRatiosBody: some View {
        HStack(alignment: .bottom, spacing: theme.spacing.lg) {
            ForEach(_ratios) { ratio in
                VStack(spacing: theme.spacing.xs) {
                    RoundedRectangle(cornerRadius: theme.radius.xs)
                        .stroke(theme.colors.borderNeutral05, lineWidth: 1)
                        .frame(width: metrics.cropPreviewWidth, height: ratio.height)
                        .opacity(ratio.isSelected ? theme.opacity.full : theme.opacity.md)

                    Text(ratio.label)
                        .font(theme.typography.smallSemiBold.font)
                        .tracking(theme.typography.smallSemiBold.tracking)
                        .foregroundStyle(theme.colors.textNeutral05)
                        .opacity(ratio.isSelected ? theme.opacity.full : theme.opacity.md)
                }
            }
        }
        .frame(maxWidth: .infinity)
        .padding(theme.spacing.xl)
        .background(theme.colors.surfacePrimary120)
        .clipShape(RoundedRectangle(cornerRadius: theme.radius.xl))
    }

    // MARK: - Helpers

    private func glyph(_ icon: DSIcon, size: CGFloat, color: Color) -> some View {
        Image(dsIcon: icon)
            .resizable()
            .renderingMode(.template)
            .scaledToFit()
            .frame(width: size, height: size)
            .foregroundStyle(color)
    }
}
