import SwiftUI

public struct DSRating: View {
    @Environment(\.theme) private var theme

    private let value: Double
    private let total: Int
    private var _label: LocalizedStringKey?

    public init(value: Double, outOf total: Int = 5) {
        self.value = value
        self.total = total
    }

    public func label(_ label: LocalizedStringKey?) -> DSRating {
        var copy = self
        copy._label = label
        return copy
    }

    public var body: some View {
        HStack(spacing: theme.spacing.xxs) {
            HStack(spacing: theme.spacing.xxs) {
                ForEach(0..<total, id: \.self) { index in
                    Image(systemName: "star.fill")
                        .font(.system(size: 16))
                        .foregroundStyle(Double(index) < value ? theme.colors.warning : theme.colors.borderNeutral3)
                }
            }

            if let _label {
                Text(_label)
                    .font(theme.typography.small.font)
                    .tracking(theme.typography.small.tracking)
                    .foregroundStyle(theme.colors.textNeutral8)
                    .padding(.leading, theme.spacing.xxs)
            }
        }
    }
}
