import XCTest
import RegexBuilder
@testable import Validations

final class FormatTests: XCTestCase {
    func testWithPattern() {
        XCTAssertNoThrow(try Format(of: "aBc", with: #/\A[a-zA-Z]+\z/#).validate())
        XCTAssertThrowsError(try Format(of: "aBc123", with: #/\A[a-zA-Z]+\z/#).validate())
    }

    func testWithBuilder() {
        XCTAssertNoThrow(
            try Format(of: "aBc") {
                Anchor.startOfSubject
                OneOrMore {
                    CharacterClass(
                        ("a"..."z"),
                        ("A"..."Z")
                    )
                }
                Anchor.endOfSubject
            }
            .validate()
        )

        XCTAssertThrowsError(
            try Format(of: "aBc123") {
                Anchor.startOfSubject
                OneOrMore {
                    CharacterClass(
                        ("a"..."z"),
                        ("A"..."Z")
                    )
                }
                Anchor.endOfSubject
            }
            .validate()
        )
    }

    func testNilValue() {
        XCTAssertThrowsError(try Format(of: nil, with: #/\A[a-zA-Z]+\z/#).validate())
        XCTAssertNoThrow(try Format(of: nil, with: #/\A[a-zA-Z]+\z/#).allowsNil().validate())
        XCTAssertNoThrow(try Format(of: nil, with: #/\A[a-zA-Z]+\z/#).allowsNil().allowsEmpty().validate())
    }

    func testEmptyValue() {
        XCTAssertThrowsError(try Format(of: "", with: #/\A[a-zA-Z]+\z/#).validate())
        XCTAssertNoThrow(try Format(of: "", with: #/\A[a-zA-Z]+\z/#).allowsEmpty().validate())
        XCTAssertNoThrow(try Format(of: "", with: #/\A[a-zA-Z]+\z/#).allowsEmpty().allowsNil().validate())
    }
}
