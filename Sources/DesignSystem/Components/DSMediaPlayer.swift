// figma-node: 87:107645
import SwiftUI

public struct DSMediaPlayer: View {
    @Environment(\.theme) private var theme

    private let _title: LocalizedStringKey
    private let _artist: LocalizedStringKey
    private let _isPlaying: Bool

    private var _onBack: (() -> Void)?
    private var _onMore: (() -> Void)?
    private var _onPrevious: (() -> Void)?
    private var _onPlayPause: (() -> Void)?
    private var _onNext: (() -> Void)?
    private var _onShuffle: (() -> Void)?
    private var _onRepeat: (() -> Void)?

    public init(
        title: LocalizedStringKey,
        artist: LocalizedStringKey,
        isPlaying: Bool = false
    ) {
        self._title = title
        self._artist = artist
        self._isPlaying = isPlaying
    }

    public func onBack(_ action: @escaping () -> Void) -> Self { copy { $0._onBack = action } }
    public func onMore(_ action: @escaping () -> Void) -> Self { copy { $0._onMore = action } }
    public func onPrevious(_ action: @escaping () -> Void) -> Self { copy { $0._onPrevious = action } }
    public func onPlayPause(_ action: @escaping () -> Void) -> Self { copy { $0._onPlayPause = action } }
    public func onNext(_ action: @escaping () -> Void) -> Self { copy { $0._onNext = action } }
    public func onShuffle(_ action: @escaping () -> Void) -> Self { copy { $0._onShuffle = action } }
    public func onRepeat(_ action: @escaping () -> Void) -> Self { copy { $0._onRepeat = action } }

    private func copy(_ mutate: (inout Self) -> Void) -> Self {
        var c = self
        mutate(&c)
        return c
    }

    private var metrics: MediaPlayerComponentTokens { theme.components.mediaPlayer }

    public var body: some View {
        VStack(spacing: theme.spacing.xl) {
            DSTopAppBar(title: _title) {
                DSButton(style: .neutral, size: .medium, icon: .moreVert) { _onMore?() }
            }
            .appBarStyle(.smallCentered)
            .onBack { _onBack?() }

            Spacer(minLength: 0)

            DSVinylDisc()

            trackInfo

            Spacer(minLength: 0)

            transportRow

            secondaryControls
        }
        .padding(.horizontal, theme.spacing.sm)
        .padding(.bottom, theme.spacing.xl)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(theme.colors.surfaceNeutral05)
    }

    private var trackInfo: some View {
        VStack(spacing: theme.spacing.xxs) {
            Text(_title)
                .font(theme.typography.h3.font)
                .tracking(theme.typography.h3.tracking)
                .foregroundStyle(theme.colors.textNeutral9)

            Text(_artist)
                .font(theme.typography.body.font)
                .tracking(theme.typography.body.tracking)
                .foregroundStyle(theme.colors.textNeutral9)
                .opacity(theme.opacity.lg)
        }
    }

    private var transportRow: some View {
        HStack(spacing: theme.spacing.xl) {
            circleControl(icon: .skipPrev, size: metrics.sideControlSize) { _onPrevious?() }

            Button { _onPlayPause?() } label: {
                Image(dsIcon: _isPlaying ? .pause : .play)
                    .resizable()
                    .renderingMode(.template)
                    .scaledToFit()
                    .frame(width: metrics.glyphSize, height: metrics.glyphSize)
                    .foregroundStyle(theme.colors.textNeutral05)
                    .frame(width: metrics.playSize, height: metrics.playSize)
                    .background(theme.colors.surfaceSecondary100)
                    .clipShape(Circle())
            }
            .buttonStyle(.plain)

            circleControl(icon: .skipNext, size: metrics.sideControlSize) { _onNext?() }
        }
    }

    private var secondaryControls: some View {
        HStack(spacing: theme.spacing.xl) {
            circleControl(icon: .shuffle, size: metrics.sideControlSize) { _onShuffle?() }
            circleControl(icon: .refreshDouble, size: metrics.sideControlSize) { _onRepeat?() }
        }
    }

    private func circleControl(icon: DSIcon, size: CGFloat, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(dsIcon: icon)
                .resizable()
                .renderingMode(.template)
                .scaledToFit()
                .frame(width: metrics.glyphSize, height: metrics.glyphSize)
                .foregroundStyle(theme.colors.textNeutral9)
                .frame(width: size, height: size)
                .background(theme.colors.surfaceNeutral2)
                .clipShape(Circle())
        }
        .buttonStyle(.plain)
    }
}

struct DSVinylDisc: View {
    @Environment(\.theme) private var theme

    private var metrics: MediaPlayerComponentTokens { theme.components.mediaPlayer }

    var body: some View {
        ZStack {
            ForEach(0..<metrics.grooveCount, id: \.self) { index in
                Circle()
                    .stroke(grooveColor(index), lineWidth: theme.borders.widthSm)
                    .frame(
                        width: metrics.discSize - CGFloat(index) * metrics.grooveSpacing,
                        height: metrics.discSize - CGFloat(index) * metrics.grooveSpacing
                    )
            }

            Circle()
                .fill(theme.colors.surfaceSecondary100)
                .frame(width: metrics.discHubSize, height: metrics.discHubSize)
        }
        .frame(width: metrics.discSize, height: metrics.discSize)
    }

    private func grooveColor(_ index: Int) -> Color {
        index.isMultiple(of: 2)
            ? theme.colors.surfaceSecondary120
            : theme.colors.borderNeutral8
    }
}
