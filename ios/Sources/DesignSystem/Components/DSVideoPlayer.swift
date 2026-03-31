import SwiftUI
import AVKit

// MARK: - DSVideoPlayer

/// Full-screen video player overlay with dismiss button.
///
/// Both `urlString` and `onDismiss` are core — this component is minimal
/// and does not need modifier methods.
///
/// Usage:
/// ```swift
/// DSVideoPlayer(urlString: "https://example.com/video.mp4") {
///     dismiss()
/// }
/// ```
public struct DSVideoPlayer: View {
    private let _urlString: String
    private let _onDismiss: () -> Void

    public init(urlString: String, onDismiss: @escaping () -> Void) {
        self._urlString = urlString
        self._onDismiss = onDismiss
    }

    public var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            #if canImport(UIKit)
            if let url = URL(string: _urlString) {
                AVPlayerView(url: url)
                    .ignoresSafeArea()
            }
            #endif
            VStack {
                HStack {
                    Spacer()
                    Button(action: _onDismiss) {
                        ZStack {
                            Circle().fill(Color.black.opacity(0.5)).frame(width: 36, height: 36)
                            Image(systemName: "xmark")
                                .font(.system(size: 14, weight: .bold))
                                .foregroundColor(.white)
                        }
                    }
                    .padding(.trailing, 16)
                    .padding(.top, 56)
                }
                Spacer()
            }
        }
        .transition(.opacity)
    }
}

// MARK: - AVPlayerView

#if canImport(UIKit)
import UIKit

private struct AVPlayerView: UIViewControllerRepresentable {
    let url: URL

    func makeUIViewController(context: Context) -> AVPlayerViewController {
        let player = AVPlayer(url: url)
        let vc = AVPlayerViewController()
        vc.player = player
        vc.showsPlaybackControls = true
        player.play()
        return vc
    }

    func updateUIViewController(_ uiViewController: AVPlayerViewController, context: Context) {}
}
#endif
