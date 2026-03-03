import CoreGraphics
import CoreText
import Foundation

public enum FontRegistration {
    private static var isRegistered = false

    /// Registers the bundled DM Sans variable font from Bundle.module.
    /// Called once by ThemeProvider on first use.
    public static func registerFonts() {
        guard !isRegistered else { return }
        isRegistered = true

        let fontNames = ["DMSans-Variable"]
        for fontName in fontNames {
            guard let url = Bundle.module.url(forResource: fontName, withExtension: "ttf"),
                  let data = try? Data(contentsOf: url) as CFData,
                  let provider = CGDataProvider(data: data),
                  let font = CGFont(provider) else {
                print("[DesignSystem] Failed to load font: \(fontName)")
                continue
            }

            var error: Unmanaged<CFError>?
            if !CTFontManagerRegisterGraphicsFont(font, &error) {
                if let error = error?.takeRetainedValue() {
                    print("[DesignSystem] Failed to register font \(fontName): \(error)")
                }
            }
        }
    }
}
