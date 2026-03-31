import SwiftUI

// MARK: - DSAvatarStyle

public enum DSAvatarStyle {
    /// Displays initials (monogram).
    case monogram(String)
    /// Displays an SF Symbol icon.
    case icon(String)
    /// Displays an image.
    case image(Image)
}

// MARK: - DSAvatarShape

public enum DSAvatarShape {
    case circle
    case roundedRect(CGFloat)
}

// MARK: - DSAvatar

/// A themed avatar with three style variants and configurable shape.
///
/// Usage (modifier-based):
/// ```swift
/// DSAvatar(style: .monogram("H"))
/// DSAvatar(style: .icon("person")).avatarSize(48)
/// DSAvatar(style: .image(Image("photo"))).avatarSize(width: 56, height: 40).shape(.roundedRect(8))
/// ```
public struct DSAvatar: View {
    @Environment(\.theme) private var theme

    private let _style: DSAvatarStyle
    private var _width: CGFloat = 40
    private var _height: CGFloat = 40
    private var _shape: DSAvatarShape = .circle

    // MARK: - Minimal init

    public init(style: DSAvatarStyle) {
        self._style = style
    }

    // MARK: - Deprecated inits

    @available(*, deprecated, message: "Use DSAvatar(style:) with .avatarSize() and .shape() modifiers instead")
    public init(style: DSAvatarStyle, size: CGFloat, shape: DSAvatarShape = .circle) {
        self._style = style
        self._width = size
        self._height = size
        self._shape = shape
    }

    @available(*, deprecated, message: "Use DSAvatar(style:) with .avatarSize(width:height:) and .shape() modifiers instead")
    public init(style: DSAvatarStyle, size: CGSize, shape: DSAvatarShape = .circle) {
        self._style = style
        self._width = size.width
        self._height = size.height
        self._shape = shape
    }

    // MARK: - Modifiers

    /// Sets a uniform avatar size (width = height).
    public func avatarSize(_ size: CGFloat) -> DSAvatar {
        var copy = self
        copy._width = size
        copy._height = size
        return copy
    }

    /// Sets independent width and height for the avatar.
    public func avatarSize(width: CGFloat, height: CGFloat) -> DSAvatar {
        var copy = self
        copy._width = width
        copy._height = height
        return copy
    }

    /// Sets the clipping shape of the avatar.
    public func shape(_ shape: DSAvatarShape) -> DSAvatar {
        var copy = self
        copy._shape = shape
        return copy
    }

    // MARK: - Body

    public var body: some View {
        Group {
            switch _style {
            case .monogram(let initials):
                Text(initials)
                    .font(theme.typography.body.font)
                    .tracking(theme.typography.body.tracking)
                    .foregroundStyle(theme.colors.textNeutral9)

            case .icon(let systemName):
                Image(systemName: systemName)
                    .font(.system(size: min(_width, _height) * 0.45))
                    .foregroundStyle(theme.colors.textNeutral9)

            case .image(let image):
                image
                    .resizable()
                    .scaledToFill()
            }
        }
        .frame(width: _width, height: _height)
        .background(theme.colors.surfaceNeutral05)
        .clipShape(clipShape)
    }

    private var clipShape: AnyShape {
        switch _shape {
        case .circle:
            AnyShape(Circle())
        case .roundedRect(let radius):
            AnyShape(RoundedRectangle(cornerRadius: radius))
        }
    }
}
