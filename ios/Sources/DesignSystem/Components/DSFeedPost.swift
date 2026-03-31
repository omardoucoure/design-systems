import SwiftUI

// MARK: - DSFeedPostImage

/// A single image in a feed post's horizontal image row.
public struct DSFeedPostImage: Identifiable {
    public let id = UUID()
    public let image: String
    public let isMain: Bool

    /// Main image (first, with CTA overlay).
    public init(image: String, isMain: Bool = false) {
        self.image = image
        self.isMain = isMain
    }
}

// MARK: - DSFeedPost

/// A social feed post with avatar, name, time, follow button, and horizontally scrolling images.
///
/// Figma: [Feed] 1 (node 399:10796)
///
/// The first image shows a CTA overlay at the bottom with like count, comment count,
/// and a plus FAB button.
///
/// Usage (modifier-based):
/// ```swift
/// DSFeedPost(
///     avatar: "avatar_image",
///     name: "Hristo Hristov",
///     time: "2h ago",
///     likeCount: "2K",
///     commentCount: "26",
///     images: [
///         DSFeedPostImage(image: "photo1", isMain: true),
///         DSFeedPostImage(image: "photo2"),
///     ]
/// )
/// .avatarSize(CGSize(width: 56, height: 40))
/// .horizontalPadding(16)
/// .onFollow { }
/// .onLike { }
/// ```
public struct DSFeedPost: View {
    @Environment(\.theme) private var theme

    // Core params (init)
    private let _avatar: String
    private let _name: String
    private let _time: String
    private let _likeCount: String
    private let _commentCount: String
    private let _images: [DSFeedPostImage]

    // Modifier params
    private var _avatarSize: CGSize = CGSize(width: 56, height: 40)
    private var _horizontalPadding: CGFloat = 0
    private var _onFollow: (() -> Void)?
    private var _onLike: (() -> Void)?
    private var _onComment: (() -> Void)?
    private var _onAdd: (() -> Void)?

    /// Creates a feed post with core data. Use modifiers for sizing and callbacks.
    public init(
        avatar: String,
        name: String,
        time: String,
        likeCount: String,
        commentCount: String,
        images: [DSFeedPostImage]
    ) {
        self._avatar = avatar
        self._name = name
        self._time = time
        self._likeCount = likeCount
        self._commentCount = commentCount
        self._images = images
    }

    // MARK: - Deprecated Init

    @available(*, deprecated, message: "Use init(avatar:name:time:likeCount:commentCount:images:) with modifiers")
    public init(
        avatar: String,
        avatarSize: CGSize = CGSize(width: 56, height: 40),
        name: String,
        time: String,
        likeCount: String,
        commentCount: String,
        images: [DSFeedPostImage],
        horizontalPadding: CGFloat = 0,
        onFollow: (() -> Void)? = nil,
        onLike: (() -> Void)? = nil,
        onComment: (() -> Void)? = nil,
        onAdd: (() -> Void)? = nil
    ) {
        self._avatar = avatar
        self._avatarSize = avatarSize
        self._name = name
        self._time = time
        self._likeCount = likeCount
        self._commentCount = commentCount
        self._images = images
        self._horizontalPadding = horizontalPadding
        self._onFollow = onFollow
        self._onLike = onLike
        self._onComment = onComment
        self._onAdd = onAdd
    }

    // MARK: - Modifiers

    /// Sets the avatar image size. Default is 56x40.
    public func avatarSize(_ size: CGSize) -> Self {
        var copy = self
        copy._avatarSize = size
        return copy
    }

    /// Sets the horizontal padding for the info row and image scroll. Default is 0.
    public func horizontalPadding(_ padding: CGFloat) -> Self {
        var copy = self
        copy._horizontalPadding = padding
        return copy
    }

    /// Sets the callback invoked when the Follow button is tapped.
    public func onFollow(_ handler: @escaping () -> Void) -> Self {
        var copy = self
        copy._onFollow = handler
        return copy
    }

    /// Sets the callback invoked when the Like pill is tapped.
    public func onLike(_ handler: @escaping () -> Void) -> Self {
        var copy = self
        copy._onLike = handler
        return copy
    }

    /// Sets the callback invoked when the Comment pill is tapped.
    public func onComment(_ handler: @escaping () -> Void) -> Self {
        var copy = self
        copy._onComment = handler
        return copy
    }

    /// Sets the callback invoked when the Add/Plus FAB is tapped.
    public func onAdd(_ handler: @escaping () -> Void) -> Self {
        var copy = self
        copy._onAdd = handler
        return copy
    }

    public var body: some View {
        VStack(spacing: theme.spacing.sm) {
            infoRow
            imageRow
        }
    }

    // MARK: - Info Row

    private var infoRow: some View {
        HStack {
            // Avatar + Name & Time
            HStack(spacing: theme.spacing.md) {
                DSAvatar(
                    style: .image(Image(_avatar)),
                    size: _avatarSize,
                    shape: .roundedRect(theme.radius.sm)
                )

                VStack(alignment: .leading, spacing: 0) {
                    Text(_name)
                        .font(theme.typography.h6.font)
                        .tracking(theme.typography.h6.tracking)
                        .foregroundStyle(theme.colors.textNeutral9)

                    Text(_time)
                        .font(theme.typography.small.font)
                        .tracking(theme.typography.small.tracking)
                        .foregroundStyle(theme.colors.textNeutral9.opacity(0.5))
                }
            }

            Spacer()

            // Follow button
            DSButton("Follow") {
                _onFollow?()
            }.buttonStyle(.outlined).buttonSize(.medium)
        }
        .padding(.top, theme.spacing.sm)
        .padding(.horizontal, _horizontalPadding)
    }

    // MARK: - Image Row

    private var imageRow: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: theme.spacing.sm) {
                ForEach(_images) { item in
                    if item.isMain {
                        mainImageCard(item.image)
                    } else {
                        plainImageCard(item.image)
                    }
                }
            }
            .padding(.horizontal, _horizontalPadding)
        }
    }

    // MARK: - Main Image Card (with CTAs)

    private func mainImageCard(_ imageName: String) -> some View {
        Image(imageName)
            .resizable()
            .scaledToFill()
            .frame(width: 317, height: 325)
            .clipShape(RoundedRectangle(cornerRadius: theme.radius.xl))
            .overlay(alignment: .bottom) {
                ctaOverlay
                    .padding(theme.spacing.xl)
            }
    }

    // MARK: - Plain Image Card

    private func plainImageCard(_ imageName: String) -> some View {
        Image(imageName)
            .resizable()
            .scaledToFill()
            .frame(width: 317, height: 325)
            .clipShape(RoundedRectangle(cornerRadius: theme.radius.xl))
    }

    // MARK: - CTA Overlay

    private var ctaOverlay: some View {
        HStack {
            // Like & Comment pills
            HStack(spacing: theme.spacing.sm) {
                // Like pill
                Button { _onLike?() } label: {
                    HStack(spacing: theme.spacing.xs) {
                        Text(_likeCount)
                            .font(theme.typography.label.font)
                            .tracking(theme.typography.label.tracking)
                            .foregroundStyle(theme.colors.textNeutral9)
                        Image(dsIcon: .heart)
                            .resizable()
                            .renderingMode(.template)
                            .scaledToFit()
                            .frame(width: 20, height: 20)
                            .foregroundStyle(theme.colors.textNeutral9)
                    }
                    .padding(.horizontal, theme.spacing.sm)
                    .padding(.vertical, theme.spacing.xxs)
                    .frame(height: 32)
                    .background(theme.colors.surfaceNeutral2)
                    .clipShape(Capsule())
                }
                .buttonStyle(.plain)

                // Comment pill
                Button { _onComment?() } label: {
                    HStack(spacing: theme.spacing.xs) {
                        Text(_commentCount)
                            .font(theme.typography.label.font)
                            .tracking(theme.typography.label.tracking)
                            .foregroundStyle(theme.colors.textNeutral9)
                        Image(dsIcon: .messageText)
                            .resizable()
                            .renderingMode(.template)
                            .scaledToFit()
                            .frame(width: 20, height: 20)
                            .foregroundStyle(theme.colors.textNeutral9)
                    }
                    .padding(.horizontal, theme.spacing.sm)
                    .padding(.vertical, theme.spacing.xxs)
                    .frame(height: 32)
                    .background(theme.colors.surfaceNeutral2)
                    .clipShape(Capsule())
                }
                .buttonStyle(.plain)
            }

            Spacer()

            // Plus FAB
            DSButton {
                _onAdd?()
            }.buttonStyle(.filledA).buttonSize(.medium).icon(.plus)
        }
    }
}
