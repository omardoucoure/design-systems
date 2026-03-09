import SwiftUI
import DesignSystem

// MARK: - Profile5Page

/// Figma: [Profile] 5 (node 332:7525)
///
/// Dark info card + stacked carousel with icon tab pager and photo grid.
/// Tap any photo to zoom it full-screen with a smooth scale transition.
struct Profile5Page: View {
    @Environment(\.theme) private var theme
    @Environment(\.dismiss) private var dismiss
    @State private var selectedTab = 0
    @State private var zoomedPhoto: String? = nil
    @State private var playingVideoURL: String? = nil

    private let tabs: [DSIcon] = [.table2Columns, .movie, .play, .sparks, .hashtag]

    var body: some View {
        ZStack {
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
                        carouselCard
                    }
                    .padding(.horizontal, theme.spacing.sm)
                    .padding(.bottom, theme.spacing.sm)
                }
            }
            .background(theme.colors.surfaceNeutral0_5)

            if let videoURL = playingVideoURL {
                DSVideoPlayer(urlString: videoURL) {
                    withAnimation(.easeInOut(duration: 0.25)) { playingVideoURL = nil }
                }
                .ignoresSafeArea()
            } else if let photo = zoomedPhoto {
                Color.black.opacity(0.85)
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) { zoomedPhoto = nil }
                    }
                Image(photo)
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity)
                    .padding(theme.spacing.lg)
                    .transition(.scale(scale: 0.85).combined(with: .opacity))
                    .onTapGesture {
                        withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) { zoomedPhoto = nil }
                    }
            }
        }
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

    // MARK: - Carousel Card

    private var carouselCard: some View {
        // Figma stacking (from node 332:7549):
        // Card 3 (back):   w=258, h=419.5, rendered first
        // Card 2 (middle): w=308, h=419.5, mb=[-400] → top offset = 419.5-400 = 19.5pt
        // Card 1 (front):  w=full, h=400,  mb=[-400] → top offset = 19.5+19.5 ≈ 39pt from back
        DSStackedCard(
            levels: [
                // Middle: 308pt wide on 393pt screen → inset = (393-308)/2 = 42.5pt, peek = 19.5pt
                DSStackedCardLevel(horizontalInset: 42, darkOverlay: 0.00, peekOffset: 20),
                // Back: 258pt wide → inset = (393-258)/2 = 67.5pt, peek = 0pt (at very top)
                DSStackedCardLevel(horizontalInset: 67, darkOverlay: 0.10, peekOffset: 0),
            ],
            alignment: .top,
            frontOffset: 39
        ) {
            VStack(alignment: .leading, spacing: theme.spacing.lg) {
                iconTabBar
                tabContent
            }
        }
    }

    // MARK: - Icon Tab Bar

    private var iconTabBar: some View {
        HStack(spacing: 0) {
            ForEach(tabs.indices, id: \.self) { i in
                VStack(spacing: 0) {
                    DSIconImage(tabs[i], size: 24, color: theme.colors.textNeutral9)
                        .opacity(selectedTab == i ? 1.0 : 0.5)
                        .padding(.vertical, 4) // Figma: py=4pt
                    Rectangle()
                        .fill(selectedTab == i ? theme.colors.textNeutral9 : Color.clear)
                        .frame(height: 1)
                }
                .frame(maxWidth: .infinity)
                .contentShape(Rectangle())
                .onTapGesture { withAnimation(.easeInOut(duration: 0.2)) { selectedTab = i } }
            }
        }
    }

    // MARK: - Paged Content

    @ViewBuilder
    private var tabContent: some View {
        switch selectedTab {
        case 0:
            DSPhotoGrid(
                items: [.photo("p5_photo1"), .photo("p5_photo2"), .photo("p5_photo3"),
                        .photo("p5_photo4"), .photo("p5_photo5"),
                        .photo("p5_photo6"), .photo("p5_photo7"), .photo("p5_photo8")],
                onTap: { item in
                    if case .photo(let name) = item {
                        withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) { zoomedPhoto = name }
                    }
                }
            )
        case 1:
            DSPhotoGrid(
                items: [
                    .video("https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4"),
                    .video("https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerEscapes.mp4"),
                    .video("https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerJoyrides.mp4"),
                    .video("https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerMeltdowns.mp4"),
                    .video("https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/SubaruOutbackOnStreetAndDirt.mp4")
                ],
                onTap: { item in
                    if case .video(let url) = item {
                        withAnimation(.easeInOut(duration: 0.25)) { playingVideoURL = url }
                    }
                }
            )
        default:
            VStack {
                Spacer().frame(height: theme.spacing.xxl)
                DSIconImage(tabs[selectedTab], size: 40, color: theme.colors.textNeutral9)
                    .opacity(0.3)
                    .frame(maxWidth: .infinity)
                Spacer().frame(height: theme.spacing.xxl)
            }
        }
    }
}

#Preview {
    Profile5Page()
        .previewThemed()
}
