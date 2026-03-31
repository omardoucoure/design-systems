import XCTest

final class PalindromeTests: XCTestCase {

    func testEmptyString() {
        XCTAssertTrue(isPalindrome(""))
    }

    func testSingleCharacter() {
        XCTAssertTrue(isPalindrome("a"))
    }

    func testTwoCharsPalindrome() {
        XCTAssertTrue(isPalindrome("aa"))
    }

    func testTwoCharsNotPalindrome() {
        XCTAssertFalse(isPalindrome("ab"))
    }

    func testOddLengthPalindrome() {
        XCTAssertTrue(isPalindrome("racecar"))
    }

    func testEvenLengthPalindrome() {
        XCTAssertTrue(isPalindrome("abba"))
    }

    func testNotPalindrome() {
        XCTAssertFalse(isPalindrome("hello"))
    }

    func testWithSpaces() {
        XCTAssertTrue(isPalindrome("a b a"))
        XCTAssertFalse(isPalindrome("ab a"))
    }

    func testUnicodeEmoji() {
        XCTAssertTrue(isPalindrome("🎉a🎉"))
        XCTAssertFalse(isPalindrome("🎉ab🎉"))
    }

    func testAccentedCharacters() {
        XCTAssertTrue(isPalindrome("éàé"))
        XCTAssertFalse(isPalindrome("éàè"))
    }

    func testLongPalindrome() {
        let half = String(repeating: "abcdefghij", count: 1000)
        let palindrome = half + String(half.reversed())
        XCTAssertTrue(isPalindrome(palindrome))
    }
}
