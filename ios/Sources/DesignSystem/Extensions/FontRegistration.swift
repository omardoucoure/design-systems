import CoreGraphics
import CoreText
import Foundation

public enum FontRegistration {
    private static var isRegistered = false

    public static func registerFonts() {
        guard !isRegistered else { return }
        isRegistered = true

        let fontNames = ["DMSans-Regular", "DMSans-Medium", "DMSans-SemiBold"]
        for fontName in fontNames {
            guard let url = Bundle.module.url(forResource: fontName, withExtension: "ttf") else {
                continue
            }
            guard let data = try? Data(contentsOf: url) as CFData,
                  let provider = CGDataProvider(data: data),
                  let font = CGFont(provider) else {
                continue
            }

            var error: Unmanaged<CFError>?
            CTFontManagerRegisterGraphicsFont(font, &error)
        }
    }
}
