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
/// Usage:
/// ```swift
/// DSAvatar(style: .monogram("H"))
/// DSAvatar(style: .icon("person"), size: 48)
/// DSAvatar(style: .image(Image("photo")), size: .init(width: 56, height: 40), shape: .roundedRect(8))
/// ```
public struct DSAvatar: View {
    @Environment(\.theme) private var theme

    private let style: DSAvatarStyle
    private let width: CGFloat
    private let height: CGFloat
    private let shape: DSAvatarShape

    public init(style: DSAvatarStyle, size: CGFloat = 40, shape: DSAvatarShape = .circle) {
        self.style = style
        self.width = size
        self.height = size
        self.shape = shape
    }

    public init(style: DSAvatarStyle, size: CGSize, shape: DSAvatarShape = .circle) {
        self.style = style
        self.width = size.width
        self.height = size.height
        self.shape = shape
    }

    public var body: some View {
        Group {
            switch style {
            case .monogram(let initials):
                Text(initials)
                    .font(theme.typography.body.font)
                    .tracking(theme.typography.body.tracking)
                    .foregroundStyle(theme.colors.textNeutral9)

            case .icon(let systemName):
                Image(systemName: systemName)
                    .font(.system(size: min(width, height) * 0.45))
                    .foregroundStyle(theme.colors.textNeutral9)

            case .image(let image):
                image
                    .resizable()
                    .scaledToFill()
            }
        }
        .frame(width: width, height: height)
        .background(theme.colors.surfaceNeutral0_5)
        .clipShape(clipShape)
    }

    private var clipShape: AnyShape {
        switch shape {
        case .circle:
            AnyShape(Circle())
        case .roundedRect(let radius):
            AnyShape(RoundedRectangle(cornerRadius: radius))
        }
    }
}
