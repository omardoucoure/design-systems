import SwiftUI
import AVFoundation
#if canImport(UIKit)
import UIKit
#endif

// MARK: - DSMediaItem

/// A media item displayed in DSPhotoGrid — either a named image asset or a remote/local video URL.
public enum DSMediaItem: Hashable {
    case photo(String)       // Asset catalog name
    case video(String)       // Video URL string (remote or local file path)
}

// MARK: - DSPhotoGridStyle

/// Layout style for DSPhotoGrid.
public enum DSPhotoGridStyle {
    /// Alternating rows of 3 and 2 columns (default).
    case dynamic
    /// Fixed number of equal-size columns per row.
    case compact(columns: Int)
}

// MARK: - DSPhotoGrid

/// A media grid supporting both dynamic (alternating 3/2) and compact (fixed N-column) layouts.
///
/// Supports both image assets and video URLs. Video cells show an auto-generated
/// thumbnail with a play icon overlay.
///
/// Usage (modifier API):
/// ```swift
/// // Dynamic (alternating 3/2 columns)
/// DSPhotoGrid(items: [...], onTap: { item in ... })
///
/// // Compact 4-column uniform grid
/// DSPhotoGrid(items: [...], onTap: { item in ... })
///     .gridStyle(.compact(columns: 4))
///     .gridRowHeight3(100)
/// ```
public struct DSPhotoGrid: View {
    @Environment(\.theme) private var theme

    // Core (init-only)
    private let items: [DSMediaItem]
    private let onTap: ((DSMediaItem) -> Void)?

    // Modifier-based visual customization
    private var _style: DSPhotoGridStyle = .dynamic
    private var _rowHeight3: CGFloat = 88
    private var _rowHeight2: CGFloat = 96

    /// Primary init — media items with optional tap handler.
    public init(
        items: [DSMediaItem],
        onTap: ((DSMediaItem) -> Void)? = nil
    ) {
        self.items = items
        self.onTap = onTap
    }

    /// Convenience init for photo-only grids.
    public init(
        photos: [String],
        onTap: ((String) -> Void)? = nil
    ) {
        self.items = photos.map { .photo($0) }
        self.onTap = onTap.map { cb in { item in if case .photo(let name) = item { cb(name) } } }
    }

    // MARK: - Deprecated inits

    @available(*, deprecated, message: "Use DSPhotoGrid(items:onTap:) with .gridStyle(), .gridRowHeight3(), .gridRowHeight2() modifiers instead")
    public init(
        items: [DSMediaItem],
        style: DSPhotoGridStyle,
        rowHeight3: CGFloat = 88,
        rowHeight2: CGFloat = 96,
        onTap: ((DSMediaItem) -> Void)? = nil
    ) {
        self.items = items
        self._style = style
        self._rowHeight3 = rowHeight3
        self._rowHeight2 = rowHeight2
        self.onTap = onTap
    }

    @available(*, deprecated, message: "Use DSPhotoGrid(photos:onTap:) with .gridStyle(), .gridRowHeight3(), .gridRowHeight2() modifiers instead")
    public init(
        photos: [String],
        style: DSPhotoGridStyle,
        rowHeight3: CGFloat = 88,
        rowHeight2: CGFloat = 96,
        onTap: ((String) -> Void)? = nil
    ) {
        self.items = photos.map { .photo($0) }
        self._style = style
        self._rowHeight3 = rowHeight3
        self._rowHeight2 = rowHeight2
        self.onTap = onTap.map { cb in { item in if case .photo(let name) = item { cb(name) } } }
    }

    // MARK: - Modifiers

    public func gridStyle(_ style: DSPhotoGridStyle) -> Self {
        var copy = self
        copy._style = style
        return copy
    }

    public func gridRowHeight3(_ height: CGFloat) -> Self {
        var copy = self
        copy._rowHeight3 = height
        return copy
    }

    public func gridRowHeight2(_ height: CGFloat) -> Self {
        var copy = self
        copy._rowHeight2 = height
        return copy
    }

    // MARK: - Body

    public var body: some View {
        VStack(spacing: theme.spacing.sm) {
            ForEach(Array(rows.enumerated()), id: \.offset) { (_, row) in
                HStack(spacing: theme.spacing.sm) {
                    ForEach(row.items, id: \.self) { (item: DSMediaItem) in
                        mediaCell(item: item, height: row.height)
                            .onTapGesture { onTap?(item) }
                    }
                }
            }
        }
    }

    // MARK: - Layout

    private struct Row {
        let items: [DSMediaItem]
        let height: CGFloat
    }

    private var rows: [Row] {
        var result: [Row] = []
        var index = 0
        var rowIndex = 0
        switch _style {
        case .dynamic:
            while index < items.count {
                let count = rowIndex % 2 == 0 ? 3 : 2
                let height = rowIndex % 2 == 0 ? _rowHeight3 : _rowHeight2
                let slice = Array(items[index..<min(index + count, items.count)])
                result.append(Row(items: slice, height: height))
                index += count
                rowIndex += 1
            }
        case .compact(let columns):
            while index < items.count {
                let slice = Array(items[index..<min(index + columns, items.count)])
                result.append(Row(items: slice, height: _rowHeight3))
                index += columns
            }
        }
        return result
    }

    @ViewBuilder
    private func mediaCell(item: DSMediaItem, height: CGFloat) -> some View {
        switch item {
        case .photo(let name):
            Color.clear
                .frame(maxWidth: .infinity, minHeight: height, maxHeight: height)
                .overlay(Image(name, bundle: .main).resizable().scaledToFill())
                .clipShape(RoundedRectangle(cornerRadius: theme.radius.md))
        case .video(let urlString):
            DSVideoThumbnailCell(urlString: urlString, height: height, radius: theme.radius.md)
        }
    }
}

// MARK: - DSVideoThumbnailCell

/// Renders a thumbnail from a video URL with a play icon overlay.
struct DSVideoThumbnailCell: View {
    let urlString: String
    let height: CGFloat
    let radius: CGFloat

    @State private var thumbnail: UIImage? = nil

    var body: some View {
        Color.clear
            .frame(maxWidth: .infinity, minHeight: height, maxHeight: height)
            .overlay(
                Group {
                    if let img = thumbnail {
                        Image(uiImage: img)
                            .resizable()
                            .scaledToFill()
                    } else {
                        Color(uiColor: .systemGray5)
                    }
                }
            )
            .overlay(playIcon)
            .clipShape(RoundedRectangle(cornerRadius: radius))
            .onAppear { generateThumbnail() }
    }

    private var playIcon: some View {
        ZStack {
            Circle()
                .fill(Color.black.opacity(0.45))
                .frame(width: 28, height: 28)
            Image(systemName: "play.fill")
                .font(.system(size: 11, weight: .bold))
                .foregroundColor(.white)
                .offset(x: 1)
        }
    }

    private func generateThumbnail() {
        guard thumbnail == nil, let url = URL(string: urlString) else { return }
        DispatchQueue.global(qos: .userInitiated).async {
            let asset = AVURLAsset(url: url)
            let gen = AVAssetImageGenerator(asset: asset)
            gen.appliesPreferredTrackTransform = true
            gen.maximumSize = CGSize(width: 300, height: 300)
            if let cgImage = try? gen.copyCGImage(at: .zero, actualTime: nil) {
                let img = UIImage(cgImage: cgImage)
                DispatchQueue.main.async { thumbnail = img }
            }
        }
    }
}
