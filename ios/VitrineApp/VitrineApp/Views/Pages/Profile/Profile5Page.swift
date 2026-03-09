import SwiftUI
import DesignSystem

// MARK: - Profile5Page

/// Figma: [Profile] 5 (node 332:7525)
///
/// Dark info card + stacked carousel with icon tabs and photo grid.
struct Profile5Page: View {
    @Environment(\.theme) private var theme
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(spacing: theme.spacing.sm) {
            DSTopAppBar(title: "Profile", style: .small, onBack: { dismiss() }) {
                HStack(spacing: 0) {
                    DSButton(style: .text, size: .medium, icon: .plusCircle) {}
                    DSButton(style: .text, size: .medium, icon: .moreVert) {}
                }
            }

            ScrollView {
                VStack(spacing: theme.spacing.lg) {
                    infoCard
//                    carouselCard
                }
                .padding(.bottom, theme.spacing.sm)
            }
            .padding(.horizontal, theme.spacing.sm)
        }
        .background(theme.colors.surfaceNeutral0_5)
        .navigationBarBackButtonHidden(true)
        .dsTabBarHidden()
    }

    // MARK: - Info Card

    private var infoCard: some View {
        DSCard(background: theme.colors.surfacePrimary120, radius: theme.radius.xl, padding: theme.spacing.xl) {
            VStack(alignment: .leading, spacing: theme.spacing.lg) {
                HStack(alignment: .top, spacing: theme.spacing.lg) {
                    VStack(alignment: .leading, spacing: theme.spacing.sm) {
                        DSText("Hristo Hristov", style: theme.typography.h4, color: theme.colors.textNeutral0_5)
                        (Text("Sports superhero. Training for the office chair Olympics... ")
                            .font(theme.typography.bodyRegular.font)
                            .foregroundColor(theme.colors.textNeutral0_5)
                         + Text("read more")
                            .font(theme.typography.label.font)
                            .foregroundColor(theme.colors.textNeutral0_5))
                    }
                    Image("p5_avatar")
                        .resizable().scaledToFill()
                        .frame(width: 61, height: 64)
                        .clipShape(RoundedRectangle(cornerRadius: theme.radius.md))
                }

                DSDivider(style: .fullBleed, color: theme.colors.textNeutral0_5.opacity(0.2))

                HStack(spacing: 0) {
                    statCol("1,200", label: "photos")
                    statCol("2,980", label: "followers")
                    statCol("1,600", label: "following")
                    DSButton(style: .filledA, size: .medium, icon: .editPencil) {}
                }
            }
        }
    }

    private func statCol(_ value: String, label: String) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            DSText(value, style: theme.typography.largeSemiBold, color: theme.colors.textNeutral0_5)
            DSText(label, style: theme.typography.smallRegular, color: theme.colors.textNeutral0_5).opacity(0.75)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    // MARK: - Carousel Card (stacked depth effect)

    private var carouselCard: some View {
        ZStack(alignment: .top) {
            // Back card (deepest)
            RoundedRectangle(cornerRadius: theme.radius.xl)
                .fill(theme.colors.surfaceNeutral3)
                .frame(height: 419)
                .padding(.horizontal, theme.spacing.xxl)

            // Middle card
            RoundedRectangle(cornerRadius: theme.radius.xl)
                .fill(theme.colors.surfaceNeutral3)
                .frame(height: 419)
                .padding(.horizontal, theme.spacing.sm)
                .padding(.top, 20)

            // Front card — full width with tabs + photo grid
            DSCard(background: theme.colors.surfaceNeutral2, radius: theme.radius.xl, padding: theme.spacing.xl) {
                VStack(alignment: .leading, spacing: theme.spacing.lg) {
                    iconTabsRow
                    photoGrid
                }
            }
            .padding(.top, 39)
        }
    }

    private var iconTabsRow: some View {
        HStack(spacing: 0) {
            // Active tab — underline indicator
            VStack(spacing: 0) {
                DSIconImage(.table2Columns, size: 24, color: theme.colors.textNeutral9)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, theme.spacing.xs)
                Rectangle().fill(theme.colors.textNeutral9).frame(height: 1)
            }
            .frame(width: 47)

            ForEach([DSIcon.movie, .play, .sparks, .hashtag], id: \.rawValue) { icon in
                DSIconImage(icon, size: 24, color: theme.colors.textNeutral9)
                    .opacity(0.5)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, theme.spacing.xs)
            }
        }
    }

    private var photoGrid: some View {
        VStack(spacing: theme.spacing.sm) {
            // Row 1: 3 equal photos, h=88
            HStack(spacing: theme.spacing.sm) {
                ForEach(["p5_photo1", "p5_photo2", "p5_photo3"], id: \.self) { photo(name: $0, height: 88) }
            }
            // Row 2: 2 equal photos, h=96
            HStack(spacing: theme.spacing.sm) {
                ForEach(["p5_photo4", "p5_photo5"], id: \.self) { photo(name: $0, height: 96) }
            }
            // Row 3: 3 equal photos, h=88
            HStack(spacing: theme.spacing.sm) {
                ForEach(["p5_photo6", "p5_photo7", "p5_photo8"], id: \.self) { photo(name: $0, height: 88) }
            }
        }
    }

    private func photo(name: String, height: CGFloat) -> some View {
        Image(name)
            .resizable().scaledToFill()
            .frame(maxWidth: .infinity)
            .frame(height: height)
            .clipShape(RoundedRectangle(cornerRadius: theme.radius.md))
    }
}

#Preview {
    Profile5Page()
        .previewThemed()
}
