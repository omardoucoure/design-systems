import SwiftUI
import DesignSystem

// MARK: - Profile10Page

/// Figma: [Profile] 10 (node 338:8523)
///
/// Portrait photo with CTAs, then name card (front), followers card and following card
/// each peeking 50pt below the card above it.
struct Profile10Page: View {
    @Environment(\.theme) private var theme
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(spacing: theme.spacing.sm) {
            DSTopAppBar(title: "Profile", style: .small, onBack: { dismiss() })
            ScrollView {
                VStack(spacing: theme.spacing.sm) {
                    photoCTA
                        .padding(.horizontal, theme.spacing.sm)
                    cascadeCards
                }
                .padding(.bottom, theme.spacing.sm)
            }
        }
        .background(theme.colors.surfaceNeutral0_5)
        .navigationBarBackButtonHidden(true)
        .dsTabBarHidden()
    }

    // MARK: - Photo + CTAs

    private var photoCTA: some View {
        Color.clear
            .frame(maxWidth: .infinity)
            .frame(height: 480)
            .overlay(
                Image("p10_photo")
                    .resizable()
                    .scaledToFill()
            )
            .clipShape(RoundedRectangle(cornerRadius: theme.radius.xl))
            .overlay(alignment: .top) {
                HStack {
                    DSButton("Message", style: .neutral, size: .medium, assetIcon: "icon_message_text", iconPosition: .right) {}
                        .fixedSize()
                    Spacer()
                    DSButton("Follow", style: .filledA, size: .medium, icon: .plus, iconPosition: .right) {}
                        .fixedSize()
                }
                .padding(.horizontal, theme.spacing.xl)
                .padding(.top, theme.spacing.xl)
            }
    }

    // MARK: - Cascade Cards

    private var cascadeCards: some View {
        VStack(spacing: 0) {
            nameCard
                .zIndex(3)
            statCard(value: "1,780", label: "followers", background: theme.colors.surfaceNeutral3)
                .padding(.top, -50)
                .zIndex(2)
            statCard(value: "560", label: "following", background: theme.colors.surfaceNeutral2)
                .padding(.top, -50)
                .zIndex(1)
        }
        .padding(.horizontal, theme.spacing.sm)
    }

    // MARK: - Name Card

    private var nameCard: some View {
        DSCard(background: theme.colors.surfacePrimary120, radius: theme.radius.xl, padding: 0) {
            VStack(alignment: .leading, spacing: theme.spacing.md) {
                DSText("Mila Valentino",
                       style: theme.typography.h3,
                       color: theme.colors.textNeutral0_5)
                (Text("Sports superhero. Training for the office chair Olympics... ")
                    .font(theme.typography.captionRegular.font)
                    .foregroundColor(theme.colors.textNeutral0_5)
                 + Text("read more")
                    .font(theme.typography.label.font)
                    .foregroundColor(theme.colors.textNeutral0_5))
            }
            .padding(theme.spacing.xl)
        }
    }

    // MARK: - Stat Card

    private func statCard(value: String, label: String, background: Color) -> some View {
        DSCard(background: background, radius: theme.radius.xl, padding: 0) {
            HStack(alignment: .bottom) {
                VStack(alignment: .leading, spacing: 0) {
                    DSText(value,
                           style: theme.typography.largeSemiBold,
                           color: theme.colors.textNeutral9)
                    DSText(label,
                           style: theme.typography.captionRegular,
                           color: theme.colors.textNeutral9)
                }
                Spacer()
                avatarStack
            }
            .padding(.horizontal, theme.spacing.xl)
            .padding(.bottom, theme.spacing.lg)
            .padding(.top, theme.spacing.xxxxl)
        }
        .frame(height: 140)
    }

    // MARK: - Avatar Stack

    private var avatarStack: some View {
        HStack(spacing: -theme.spacing.xs) {
            ForEach(["p10_avatar1", "p10_avatar2", "p10_avatar3", "p10_avatar4"], id: \.self) { name in
                DSAvatar(style: .image(Image(name)), size: 40)
                    .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 4)
                    .shadow(color: Color.black.opacity(0.06), radius: 2, x: 0, y: 2)
            }
        }
    }
}

#Preview {
    Profile10Page()
        .previewThemed()
}
