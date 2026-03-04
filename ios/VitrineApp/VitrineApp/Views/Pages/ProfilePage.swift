import SwiftUI
import DesignSystem

// MARK: - ProfilePage

/// Profile screen (Figma node 338-8541).
struct ProfilePage: View {
    @Environment(\.theme) private var theme
    @State private var currentPage = 0

    private let photos = ["profile-photo-1", "profile-photo-2"]

    var body: some View {
        VStack(spacing: theme.spacing.sm) {
            DSTopAppBar(title: "Profile", style: .small, onBack: {}) {
                DSButton(style: .text, size: .medium, systemIcon: "plus.circle") {}
                DSButton(style: .text, size: .medium, systemIcon: "ellipsis") {}
            }

            VStack(spacing: theme.spacing.sm) {
                carousel
                    .frame(maxHeight: .infinity)
                DSPageControl(count: 5, currentIndex: $currentPage)
            }
            .frame(maxHeight: .infinity)

            profileInfoCard
        }
        .padding(.horizontal, theme.spacing.sm)
        .padding(.bottom, theme.spacing.sm)
        .background(theme.colors.surfaceNeutral0_5)
        .toolbar(.hidden, for: .navigationBar)
    }

    private var carousel: some View {
        DSCarousel(images: photos, currentIndex: $currentPage)
    }

    // MARK: - Profile Info Card

    private var profileInfoCard: some View {
        DSCard(background: theme.colors.surfacePrimary100) {
            VStack(alignment: .leading, spacing: theme.spacing.lg) {
                VStack(alignment: .leading, spacing: theme.spacing.sm) {
                    Text("Hristo Hristov")
                        .font(theme.typography.h4.font)
                        .tracking(theme.typography.h4.tracking)
                        .foregroundStyle(theme.colors.textNeutral0_5)
                        .frame(maxWidth: .infinity, alignment: .leading)

                    Text("Rockstar-in-training. Plays air guitar solos that even virtual fans cheer for.")
                        .font(theme.typography.caption.font)
                        .tracking(theme.typography.caption.tracking)
                        .foregroundStyle(theme.colors.textNeutral0_5)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }

                HStack(spacing: 0) {
                    statColumn(value: "1,200", label: "photos")
                    statColumn(value: "2,980", label: "followers")
                    statColumn(value: "1,600", label: "following")
                    Spacer()
                    DSButton(style: .filledA, size: .medium, systemIcon: "plus") {}
                }
            }
        }
    }

    // MARK: - Stat Column

    private func statColumn(value: String, label: String) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(value)
                .font(theme.typography.largeSemiBold.font)
                .tracking(theme.typography.largeSemiBold.tracking)
                .foregroundStyle(theme.colors.textNeutral0_5)

            Text(label)
                .font(theme.typography.small.font)
                .tracking(theme.typography.small.tracking)
                .foregroundStyle(theme.colors.textNeutral0_5.opacity(0.75))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    ProfilePage()
        .previewThemed()
}
