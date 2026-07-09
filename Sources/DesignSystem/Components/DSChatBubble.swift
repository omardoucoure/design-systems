import SwiftUI

public enum DSChatSide {
    case incoming
    case outgoing
}

public struct DSChatBubble: View {
    @Environment(\.theme) private var theme

    private let text: LocalizedStringKey
    private let side: DSChatSide
    private var _time: LocalizedStringKey?

    public init(_ text: LocalizedStringKey, side: DSChatSide) {
        self.text = text
        self.side = side
    }

    public func time(_ time: LocalizedStringKey?) -> DSChatBubble {
        var copy = self
        copy._time = time
        return copy
    }

    public var body: some View {
        HStack {
            if side == .outgoing { Spacer(minLength: 48) }

            VStack(alignment: .leading, spacing: theme.spacing.xxs) {
                Text(text)
                    .font(theme.typography.body.font)
                    .tracking(theme.typography.body.tracking)
                    .foregroundStyle(foreground)

                if let _time {
                    Text(_time)
                        .font(theme.typography.tiny.font)
                        .foregroundStyle(foreground.opacity(0.7))
                }
            }
            .padding(.vertical, 10)
            .padding(.horizontal, 14)
            .background(background)
            .clipShape(bubbleShape)

            if side == .incoming { Spacer(minLength: 48) }
        }
    }

    private var foreground: Color {
        side == .incoming ? theme.colors.textNeutral9 : theme.colors.textNeutral05
    }

    private var background: Color {
        side == .incoming ? theme.colors.surfaceNeutral2 : theme.colors.surfacePrimary100
    }

    private var bubbleShape: some Shape {
        let big = theme.radius.lg
        let tail = theme.radius.xs
        return UnevenRoundedRectangle(
            topLeadingRadius: big,
            bottomLeadingRadius: side == .incoming ? tail : big,
            bottomTrailingRadius: side == .outgoing ? tail : big,
            topTrailingRadius: big
        )
    }
}

public struct DSTypingIndicator: View {
    @Environment(\.theme) private var theme
    @State private var phase = 0

    private let timer = Timer.publish(every: 0.3, on: .main, in: .common).autoconnect()

    public init() {}

    public var body: some View {
        HStack(spacing: 3) {
            ForEach(0..<3, id: \.self) { index in
                Circle()
                    .fill(theme.colors.textNeutral8)
                    .frame(width: 6, height: 6)
                    .opacity(phase == index ? 1 : 0.3)
                    .offset(y: phase == index ? -3 : 0)
            }
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 14)
        .background(theme.colors.surfaceNeutral2)
        .clipShape(UnevenRoundedRectangle(
            topLeadingRadius: theme.radius.lg,
            bottomLeadingRadius: theme.radius.xs,
            bottomTrailingRadius: theme.radius.lg,
            topTrailingRadius: theme.radius.lg
        ))
        .onReceive(timer) { _ in
            withAnimation(.easeInOut(duration: 0.25)) {
                phase = (phase + 1) % 3
            }
        }
    }
}
