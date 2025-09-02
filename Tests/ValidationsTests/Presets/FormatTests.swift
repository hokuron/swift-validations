import Testing
import RegexBuilder
@testable import Validations

@Suite
struct FormatTests {
    @Test
    func withPattern() {
        #expect(throws: Never.self) { try Format(of: "aBc", with: /\A[a-zA-Z]+\z/).validate() }
        #expect(throws: ValidationError.self) { try Format(of: "aBc123", with: /\A[a-zA-Z]+\z/).validate() }
    }

    @Test
    func withBuilder() {
        #expect(throws: Never.self) {
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
            .validate() }
        #expect(throws: ValidationError.self) {
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
            .validate() }
    }

    @Test
    func nilValue() {
        #expect(throws: ValidationError.self) { try Format(of: nil, with: /\A[a-zA-Z]+\z/).validate() }
        #expect(throws: Never.self) { try Format(of: nil, with: /\A[a-zA-Z]+\z/).allowsNil().validate() }
        #expect(throws: Never.self) { try Format(of: nil, with: /\A[a-zA-Z]+\z/).allowsNil().allowsEmpty().validate() }
    }

    @Test
    func emptyValue() {
        #expect(throws: ValidationError.self) { try Format(of: "", with: /\A[a-zA-Z]+\z/).validate() }
        #expect(throws: Never.self) { try Format(of: "", with: /\A[a-zA-Z]+\z/).allowsEmpty().validate() }
        #expect(throws: Never.self) { try Format(of: "", with: /\A[a-zA-Z]+\z/).allowsEmpty().allowsNil().validate() }
    }
}
