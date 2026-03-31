import SwiftUI
import DesignSystem

// MARK: - ProfilePage

/// Profile screen (Figma node 338-8541).
struct ProfilePage: View {
    @Environment(\.theme) private var theme
    @Environment(\.dismiss) private var dismiss
    @State private var currentPage = 0

    private let photos = ["profile-photo-1", "profile-photo-2"]

    var body: some View {
        VStack(spacing: theme.spacing.sm) {
            DSTopAppBar(title: "Profile") {
                DSButton {}.buttonStyle(.text).buttonSize(.medium).systemIcon("plus.circle")
                DSButton {}.buttonStyle(.text).buttonSize(.medium).systemIcon("ellipsis")
            }.onBack { dismiss() }

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
        .background(theme.colors.surfaceNeutral05.ignoresSafeArea())
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .navigationBar)
        .dsTabBarHidden()
    }

    private var carousel: some View {
        DSCarousel(images: photos, currentIndex: $currentPage)
    }

    // MARK: - Profile Info Card

    private var profileInfoCard: some View {
        DSCard {
            VStack(alignment: .leading, spacing: theme.spacing.lg) {
                VStack(alignment: .leading, spacing: theme.spacing.sm) {
                    DSText("Hristo Hristov", style: theme.typography.h4, color: theme.colors.textNeutral05)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    DSText("Rockstar-in-training. Plays air guitar solos that even virtual fans cheer for.",
                           style: theme.typography.caption, color: theme.colors.textNeutral05)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }

                HStack(spacing: 0) {
                    statColumn(value: "1,200", label: "photos")
                    statColumn(value: "2,980", label: "followers")
                    statColumn(value: "1,600", label: "following")
                    Spacer()
                    DSButton {}.buttonStyle(.filledA).buttonSize(.medium).systemIcon("plus")
                }
            }
        }
        .cardBackground(theme.colors.surfacePrimary100)
    }

    // MARK: - Stat Column

    private func statColumn(value: String, label: String) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            DSText(value, style: theme.typography.largeSemiBold, color: theme.colors.textNeutral05)
            DSText(label, style: theme.typography.small, color: theme.colors.textNeutral05.opacity(0.75))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    ProfilePage()
        .previewThemed()
}
