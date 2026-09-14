import SwiftUI

public struct DSStepRailStep: Identifiable, Sendable {
    public let id: Int
    public let label: LocalizedStringKey

    public init(id: Int, label: LocalizedStringKey) {
        self.id = id
        self.label = label
    }
}

public struct DSStepRail: View {
    @Environment(\.theme) private var theme

    private let steps: [DSStepRailStep]
    private let currentIndex: Int
    private var _onSelect: ((Int) -> Void)?

    public init(steps: [DSStepRailStep], currentIndex: Int) {
        self.steps = steps
        self.currentIndex = currentIndex
    }

    public func onSelect(_ action: @escaping (Int) -> Void) -> Self {
        var copy = self
        copy._onSelect = action
        return copy
    }

    public enum Phase: Sendable {
        case done
        case active
        case upcoming
    }

    public enum Metrics {
        private static let spacing = SpacingTokens.shared

        public static let markerSize = spacing.md + spacing.xxxs
        public static let itemHeight = spacing.xl
        public static let itemGap = spacing.xs
        public static let itemHorizontalPadding = spacing.sm
        public static let markerToLabelGap = spacing.xs
    }

    public enum State {
        public static func clamped(current: Int, count: Int) -> Int {
            guard count > 0 else { return 0 }
            return min(max(current, 0), count - 1)
        }

        public static func phase(index: Int, current: Int) -> Phase {
            if index < current { return .done }
            if index == current { return .active }
            return .upcoming
        }

        public static func isReachable(index: Int, current: Int) -> Bool {
            index <= current
        }

        public static func ordinal(index: Int) -> String {
            String(index + 1)
        }

        public static func markerFill(_ phase: Phase, theme: ThemeConfiguration) -> Color {
            switch phase {
            case .done: return theme.colors.surfacePrimary100
            case .active: return theme.colors.surfaceSecondary100
            case .upcoming: return theme.colors.surfaceNeutral3
            }
        }

        public static func markerForeground(_ phase: Phase, theme: ThemeConfiguration) -> Color {
            switch phase {
            case .done, .active: return theme.colors.textNeutral05
            case .upcoming: return theme.colors.textNeutral6
            }
        }

        public static func labelStyle(_ phase: Phase, theme: ThemeConfiguration) -> TypographyStyle {
            switch phase {
            case .active: return theme.typography.smallSemiBold
            case .done, .upcoming: return theme.typography.small
            }
        }

        public static func labelColor(_ phase: Phase, theme: ThemeConfiguration) -> Color {
            switch phase {
            case .active: return theme.colors.textNeutral9
            case .done, .upcoming: return theme.colors.textNeutral6
            }
        }

        public static func trackFill(_ phase: Phase, theme: ThemeConfiguration) -> Color {
            phase == .active ? theme.colors.surfaceNeutral05 : .clear
        }
    }

    public var body: some View {
        HStack(spacing: Metrics.itemGap) {
            ForEach(Array(steps.enumerated()), id: \.element.id) { index, step in
                item(step, index: index)
            }
        }
    }

    private var current: Int {
        State.clamped(current: currentIndex, count: steps.count)
    }

    @ViewBuilder
    private func item(_ step: DSStepRailStep, index: Int) -> some View {
        let phase = State.phase(index: index, current: current)
        let reachable = State.isReachable(index: index, current: current)

        Button {
            if reachable { _onSelect?(index) }
        } label: {
            row(step, phase: phase)
        }
        .buttonStyle(.plain)
        .disabled(!reachable || _onSelect == nil)
        .accessibilityLabel(step.label)
        .accessibilityAddTraits(phase == .active ? [.isSelected] : [])
    }

    private func row(_ step: DSStepRailStep, phase: Phase) -> some View {
        HStack(spacing: Metrics.markerToLabelGap) {
            marker(step, phase: phase)
            Text(step.label)
                .font(State.labelStyle(phase, theme: theme).font)
                .tracking(State.labelStyle(phase, theme: theme).tracking)
                .foregroundStyle(State.labelColor(phase, theme: theme))
        }
        .padding(.horizontal, Metrics.itemHorizontalPadding)
        .frame(height: Metrics.itemHeight)
        .background(State.trackFill(phase, theme: theme))
        .clipShape(RoundedRectangle(cornerRadius: theme.radius.xs))
    }

    private func marker(_ step: DSStepRailStep, phase: Phase) -> some View {
        ZStack {
            Circle().fill(State.markerFill(phase, theme: theme))
            if phase == .done {
                Image(dsIcon: .check)
                    .resizable()
                    .renderingMode(.template)
                    .scaledToFit()
                    .padding(theme.spacing.xxxs)
                    .foregroundStyle(State.markerForeground(phase, theme: theme))
            } else {
                Text(verbatim: State.ordinal(index: step.id))
                    .font(theme.typography.tinySemiBold.font)
                    .foregroundStyle(State.markerForeground(phase, theme: theme))
            }
        }
        .frame(width: Metrics.markerSize, height: Metrics.markerSize)
    }
}
