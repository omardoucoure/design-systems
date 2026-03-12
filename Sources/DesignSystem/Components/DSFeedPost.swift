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
/// Usage:
/// ```swift
/// DSFeedPost(
///     avatar: "avatar_image",
///     avatarSize: CGSize(width: 56, height: 40),
///     name: "Hristo Hristov",
///     time: "2h ago",
///     likeCount: "2K",
///     commentCount: "26",
///     images: [
///         DSFeedPostImage(image: "photo1", isMain: true),
///         DSFeedPostImage(image: "photo2"),
///     ]
/// )
/// ```
public struct DSFeedPost: View {
    @Environment(\.theme) private var theme

    private let avatar: String
    private let avatarSize: CGSize
    private let name: String
    private let time: String
    private let likeCount: String
    private let commentCount: String
    private let images: [DSFeedPostImage]
    private let horizontalPadding: CGFloat
    private let onFollow: (() -> Void)?
    private let onLike: (() -> Void)?
    private let onComment: (() -> Void)?
    private let onAdd: (() -> Void)?

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
        self.avatar = avatar
        self.avatarSize = avatarSize
        self.name = name
        self.time = time
        self.likeCount = likeCount
        self.commentCount = commentCount
        self.images = images
        self.horizontalPadding = horizontalPadding
        self.onFollow = onFollow
        self.onLike = onLike
        self.onComment = onComment
        self.onAdd = onAdd
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
                    style: .image(Image(avatar)),
                    size: avatarSize,
                    shape: .roundedRect(theme.radius.sm)
                )

                VStack(alignment: .leading, spacing: 0) {
                    Text(name)
                        .font(theme.typography.h6.font)
                        .tracking(theme.typography.h6.tracking)
                        .foregroundStyle(theme.colors.textNeutral9)

                    Text(time)
                        .font(theme.typography.small.font)
                        .tracking(theme.typography.small.tracking)
                        .foregroundStyle(theme.colors.textNeutral9.opacity(0.5))
                }
            }

            Spacer()

            // Follow button
            DSButton("Follow", style: .outlined, size: .medium) {
                onFollow?()
            }
        }
        .padding(.top, theme.spacing.sm)
        .padding(.horizontal, horizontalPadding)
    }

    // MARK: - Image Row

    private var imageRow: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: theme.spacing.sm) {
                ForEach(images) { item in
                    if item.isMain {
                        mainImageCard(item.image)
                    } else {
                        plainImageCard(item.image)
                    }
                }
            }
            .padding(.horizontal, horizontalPadding)
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
                Button { onLike?() } label: {
                    HStack(spacing: theme.spacing.xs) {
                        Text(likeCount)
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
                Button { onComment?() } label: {
                    HStack(spacing: theme.spacing.xs) {
                        Text(commentCount)
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
            DSButton(style: .filledA, size: .medium, icon: .plus) {
                onAdd?()
            }
        }
    }
}
