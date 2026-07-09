import SwiftUI

public enum DSPaymentBrand {
    case visa
    case mastercard
    case amex
    case paypal
    case generic(LocalizedStringKey)

    var label: LocalizedStringKey {
        switch self {
        case .visa: return "VISA"
        case .mastercard: return "MC"
        case .amex: return "AMEX"
        case .paypal: return "Pay"
        case .generic(let text): return text
        }
    }

    var background: Color {
        switch self {
        case .visa: return Color(red: 0.102, green: 0.122, blue: 0.443)
        case .mastercard: return .white
        case .amex: return Color(red: 0.0, green: 0.435, blue: 0.812)
        case .paypal: return Color(red: 0.0, green: 0.188, blue: 0.529)
        case .generic: return Color(red: 0.161, green: 0.161, blue: 0.153)
        }
    }

    var foreground: Color {
        switch self {
        case .visa: return Color(red: 0.969, green: 0.714, blue: 0.0)
        case .mastercard: return Color(red: 0.922, green: 0.0, blue: 0.106)
        case .amex, .paypal, .generic: return .white
        }
    }
}

public struct DSPaymentMethod: View {
    @Environment(\.theme) private var theme

    private let brand: DSPaymentBrand
    private let title: LocalizedStringKey
    private let subtitle: LocalizedStringKey
    private let isSelected: Bool
    private let onTap: () -> Void

    public init(
        brand: DSPaymentBrand,
        title: LocalizedStringKey,
        subtitle: LocalizedStringKey,
        isSelected: Bool,
        onTap: @escaping () -> Void
    ) {
        self.brand = brand
        self.title = title
        self.subtitle = subtitle
        self.isSelected = isSelected
        self.onTap = onTap
    }

    public var body: some View {
        Button(action: onTap) {
            HStack(spacing: theme.spacing.sm) {
                brandBadge

                VStack(alignment: .leading, spacing: theme.spacing.xxs) {
                    Text(title)
                        .font(theme.typography.bodySemiBold.font)
                        .tracking(theme.typography.bodySemiBold.tracking)
                        .foregroundStyle(theme.colors.textNeutral9)
                    Text(subtitle)
                        .font(theme.typography.small.font)
                        .tracking(theme.typography.small.tracking)
                        .foregroundStyle(theme.colors.textNeutral8)
                }

                Spacer(minLength: theme.spacing.sm)

                radio
            }
            .padding(.horizontal, theme.spacing.md)
            .frame(height: 64)
            .background(theme.colors.surfaceNeutral2)
            .clipShape(RoundedRectangle(cornerRadius: theme.radius.md))
            .overlay(
                RoundedRectangle(cornerRadius: theme.radius.md)
                    .strokeBorder(isSelected ? theme.colors.surfacePrimary100 : Color.clear, lineWidth: 2)
            )
        }
        .buttonStyle(.plain)
    }

    private var brandBadge: some View {
        Text(brand.label)
            .font(.system(size: 10, weight: .bold))
            .foregroundStyle(brand.foreground)
            .frame(width: 40, height: 28)
            .background(brand.background)
            .clipShape(RoundedRectangle(cornerRadius: theme.radius.xs))
    }

    private var radio: some View {
        ZStack {
            Circle()
                .strokeBorder(isSelected ? theme.colors.surfacePrimary100 : theme.colors.borderNeutral3, lineWidth: 2)
                .frame(width: 24, height: 24)
            if isSelected {
                Circle()
                    .fill(theme.colors.surfacePrimary100)
                    .frame(width: 10, height: 10)
            }
        }
    }
}
