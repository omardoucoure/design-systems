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

// MARK: - DSAvatar

/// A themed circular avatar with three style variants.
///
/// Usage:
/// ```swift
/// DSAvatar(style: .monogram("H"))
/// DSAvatar(style: .icon("person"), size: 48)
/// DSAvatar(style: .image(Image("photo")), size: 56)
/// ```
public struct DSAvatar: View {
    @Environment(\.theme) private var theme

    private let style: DSAvatarStyle
    private let size: CGFloat

    public init(style: DSAvatarStyle, size: CGFloat = 40) {
        self.style = style
        self.size = size
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
                    .font(.system(size: size * 0.45))
                    .foregroundStyle(theme.colors.textNeutral9)

            case .image(let image):
                image
                    .resizable()
                    .scaledToFill()
            }
        }
        .frame(width: size, height: size)
        .background(theme.colors.surfaceNeutral0_5)
        .clipShape(Circle())
    }
}
