// figma-node: 87:96325
import SwiftUI

public enum DSLikeCommentRowStyle: Sendable, CaseIterable {
    case badge
    case row
}

public struct DSLikeCommentRow: View {
    @Environment(\.theme) private var theme

    private let _style: DSLikeCommentRowStyle
    private let _likes: LocalizedStringKey
    private let _comments: LocalizedStringKey

    private var _onLike: (() -> Void)?
    private var _onComment: (() -> Void)?
    private var _onMore: (() -> Void)?

    public init(
        style: DSLikeCommentRowStyle = .badge,
        likes: LocalizedStringKey,
        comments: LocalizedStringKey
    ) {
        self._style = style
        self._likes = likes
        self._comments = comments
    }

    public func onLike(_ action: @escaping () -> Void) -> Self {
        var copy = self
        copy._onLike = action
        return copy
    }

    public func onComment(_ action: @escaping () -> Void) -> Self {
        var copy = self
        copy._onComment = action
        return copy
    }

    public func onMore(_ action: @escaping () -> Void) -> Self {
        var copy = self
        copy._onMore = action
        return copy
    }

    public var body: some View {
        switch _style {
        case .badge: badgeBody
        case .row: rowBody
        }
    }

    private var metrics: LikeCommentRowComponentTokens { theme.components.likeCommentRow }

    private var badgeBody: some View {
        HStack(spacing: theme.spacing.sm) {
            DSButton(_likes, style: .neutral, size: .small, icon: .heart, iconPosition: .right) {
                _onLike?()
            }

            statPill(
                background: theme.colors.surfaceNeutral2,
                horizontalPadding: theme.spacing.sm,
                verticalPadding: theme.spacing.xxs,
                glyphSize: metrics.badgeGlyphSize,
                leading: .reply,
                count: _comments,
                trailing: .messageText
            )
            .onTapGesture { _onComment?() }
        }
    }

    private var rowBody: some View {
        HStack(spacing: 0) {
            HStack(spacing: theme.spacing.sm) {
                statPill(
                    background: theme.colors.surfaceNeutral05,
                    horizontalPadding: theme.spacing.md,
                    verticalPadding: theme.spacing.xs,
                    glyphSize: metrics.rowGlyphSize,
                    leading: .reply,
                    count: _likes,
                    trailing: .heart
                )
                .onTapGesture { _onLike?() }

                statPill(
                    background: theme.colors.surfaceNeutral05,
                    horizontalPadding: theme.spacing.md,
                    verticalPadding: theme.spacing.xs,
                    glyphSize: metrics.rowGlyphSize,
                    leading: .reply,
                    count: _comments,
                    trailing: .messageText
                )
                .onTapGesture { _onComment?() }
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            DSButton(style: .text, size: .medium, icon: .moreVert) {
                _onMore?()
            }
        }
    }

    private func statPill(
        background: Color,
        horizontalPadding: CGFloat,
        verticalPadding: CGFloat,
        glyphSize: CGFloat,
        leading: DSIcon,
        count: LocalizedStringKey,
        trailing: DSIcon
    ) -> some View {
        HStack(spacing: theme.spacing.xs) {
            glyph(leading, size: glyphSize)
            Text(count)
                .font(theme.typography.label.font)
                .tracking(theme.typography.label.tracking)
                .foregroundStyle(theme.colors.textNeutral9)
            glyph(trailing, size: glyphSize)
        }
        .padding(.horizontal, horizontalPadding)
        .padding(.vertical, verticalPadding)
        .background(background)
        .clipShape(RoundedRectangle(cornerRadius: theme.radius.full))
    }

    private func glyph(_ icon: DSIcon, size: CGFloat) -> some View {
        Image(dsIcon: icon)
            .resizable()
            .renderingMode(.template)
            .scaledToFit()
            .frame(width: size, height: size)
            .foregroundStyle(theme.colors.textNeutral9)
    }
}
