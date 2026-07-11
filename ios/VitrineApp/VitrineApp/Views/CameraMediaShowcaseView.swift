import SwiftUI
import DesignSystem

struct CameraPhotoDetailView: View {
    @Environment(\.theme) private var theme

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 32) {
                DSDivider().dividerStyle(.subheader("Camera Controls Bar"))
                DSCameraControlsBar(
                    settings: [
                        DSCameraSetting(icon: .sunLight, label: "Auto", isAccented: true),
                        DSCameraSetting(icon: .halfMoon, label: "Night"),
                        DSCameraSetting(icon: .droplet, label: "Vivid")
                    ]
                )

                DSDivider().dividerStyle(.subheader("Photo Edit Toolbar"))
                DSPhotoEditToolbar(style: .adjustments, value: "-12")
                DSPhotoEditToolbar(style: .cropRatios)

                DSDivider().dividerStyle(.subheader("Tick Scale"))
                DSTickScale()
            }
            .padding(theme.spacing.lg)
        }
        .navigationTitle("Camera & Photo")
    }
}

struct TimelinePlayerDetailView: View {
    @Environment(\.theme) private var theme

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 32) {
                DSDivider().dividerStyle(.subheader("Day Timeline"))
                DSDayTimeline(
                    hours: ["6 AM", "7 AM", "8 AM", "9 AM", "10 AM", "11 AM", "12 PM", "1 PM", "2 PM"],
                    activeHour: 4,
                    events: [
                        DSDayTimelineEvent(title: "Desk Research", time: "6.45 AM - 8.05 AM",
                                           icon: .eye, color: .neutral, startRow: 0, rowSpan: 2),
                        DSDayTimelineEvent(title: "Kickoff Agenda", time: "10.45 AM - 12.15 PM",
                                           icon: .pageFlip, color: .secondary, startRow: 4, rowSpan: 2),
                        DSDayTimelineEvent(title: "Font Fiesta", time: "1.45 PM - 3.15 PM",
                                           icon: .pageFlip, color: .primary, startRow: 7, rowSpan: 2)
                    ]
                )
            }
            .padding(theme.spacing.lg)
        }
        .navigationTitle("Day Timeline")
    }
}

struct MediaPlayerDetailView: View {
    @Environment(\.theme) private var theme
    @State private var playing = true

    var body: some View {
        DSMediaPlayer(title: "Spaghetti Supernova", artist: "Velvet Moonwalkers", isPlaying: playing)
            .onPlayPause { playing.toggle() }
            .navigationTitle("Media Player")
            .navigationBarTitleDisplayMode(.inline)
    }
}
