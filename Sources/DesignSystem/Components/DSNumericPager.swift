import SwiftUI

public enum DSPagerEntry: Equatable {
    case page(Int)
    case ellipsis
}

public struct DSNumericPager: View {
    @Environment(\.theme) private var theme

    @Binding private var current: Int
    private let total: Int

    public init(current: Binding<Int>, total: Int) {
        self._current = current
        self.total = total
    }

    public var body: some View {
        HStack(spacing: theme.spacing.xxs) {
            arrow(icon: .navArrowLeft, enabled: current > 1) {
                current = max(1, current - 1)
            }

            ForEach(Array(entries.enumerated()), id: \.offset) { _, entry in
                switch entry {
                case .page(let page):
                    pageButton(page)
                case .ellipsis:
                    Text("…")
                        .font(theme.typography.caption.font)
                        .foregroundStyle(theme.colors.textNeutral8)
                        .frame(minWidth: 36, minHeight: 36)
                }
            }

            arrow(icon: .navArrowRight, enabled: current < total) {
                current = min(total, current + 1)
            }
        }
    }

    private var entries: [DSPagerEntry] {
        guard total > 7 else {
            return (1...total).map { .page($0) }
        }
        var pages: [DSPagerEntry] = [.page(1)]
        let lower = max(2, current - 1)
        let upper = min(total - 1, current + 1)
        if lower > 2 { pages.append(.ellipsis) }
        for page in lower...upper { pages.append(.page(page)) }
        if upper < total - 1 { pages.append(.ellipsis) }
        pages.append(.page(total))
        return pages
    }

    private func pageButton(_ page: Int) -> some View {
        let isActive = page == current
        return Button {
            current = page
        } label: {
            Text("\(page)")
                .font(theme.typography.caption.font)
                .tracking(theme.typography.caption.tracking)
                .foregroundStyle(isActive ? theme.colors.textNeutral05 : theme.colors.textNeutral9)
                .frame(minWidth: 36, minHeight: 36)
                .background(isActive ? theme.colors.surfacePrimary100 : Color.clear)
                .clipShape(RoundedRectangle(cornerRadius: theme.radius.md))
        }
        .buttonStyle(.plain)
    }

    private func arrow(icon: DSIcon, enabled: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(dsIcon: icon)
                .resizable()
                .renderingMode(.template)
                .scaledToFit()
                .frame(width: theme.spacing.md, height: theme.spacing.md)
                .foregroundStyle(enabled ? theme.colors.textNeutral9 : theme.colors.textNeutral3)
                .frame(width: 36, height: 36)
                .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .disabled(!enabled)
    }
}
