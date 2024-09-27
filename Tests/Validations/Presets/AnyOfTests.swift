import XCTest
@testable import Validations

final class AnyOfTests: XCTestCase {
    func testSuccess() {
        XCTAssertNoThrow(
            try AnyOf(["123", "456789"]) {
                Presence(of: $0)
                Count(of: $0, within: 3...)
            }
            .validate()
        )
        XCTAssertNoThrow(
            try AnyOf(["", "456789"]) {
                Presence(of: $0)
                Count(of: $0, within: 3...)
            }
            .validate()
        )
        XCTAssertNoThrow(
            try AnyOf(["123", ""]) {
                Presence(of: $0)
                Count(of: $0, within: 3...)
            }
            .validate()
        )
    }    

    func testFailure() {
        XCTAssertThrowsError(
            try AnyOf(["123", "456789"]) {
                Presence(of: $0)
                Count(of: $0, exact: 2)
            }
            .validate()
        )
        XCTAssertThrowsError(
            try AnyOf(["", "456789"]) {
                Presence(of: $0)
                Count(of: $0, exact: 2)
            }
            .validate()
        )
        XCTAssertThrowsError(
            try AnyOf(["123", ""]) {
                Presence(of: $0)
                Count(of: $0, exact: 2)
            }
            .validate()
        )
    }

    func testOuterErrorKey() {
        let errorKey = "ErrorKey"
        let sut = AnyOf(["", ""]) {
            Presence(of: $0)
            Count(of: $0, exact: 2)
        }
        .errorKey(errorKey)

        XCTAssertEqual(sut.validationErrors?.errors, sut.validationErrors?[errorKey])
        XCTAssertEqual(sut.validationErrors?.reasons(for: errorKey), [.empty, .count, .empty, .count])
    }

    func testInnerErrorKey() {
        let errorKey1 = "ErrorKey1"
        let errorKey2 = "ErrorKey2"
        let sut = AnyOf(["", ""]) {
            Presence(of: $0)
                .errorKey(errorKey1)
            Count(of: $0, exact: 2)
                .errorKey(errorKey2)
        }

        XCTAssertEqual(sut.validationErrors?.count, 4)
        XCTAssertEqual(sut.validationErrors?.errors.map(\.reasons), [.empty, .count, .empty, .count])

        XCTAssertEqual(sut.validationErrors?[errorKey1].count, 2)
        XCTAssertEqual(sut.validationErrors?.reasons(for: errorKey1), [.empty])

        XCTAssertEqual(sut.validationErrors?[errorKey2].count, 2)
        XCTAssertEqual(sut.validationErrors?.reasons(for: errorKey2), [.count])
    }

    func testOuterAndInnerErrorKey() {
        let outerErrorKey = "OuterErrorKey"
        let innerErrorKey1 = "InnerErrorKey1"
        let innerErrorKey2 = "InnerErrorKey2"
        let sut = AnyOf(["", ""]) {
            Presence(of: $0)
                .errorKey(innerErrorKey1)
            Count(of: $0, exact: 2)
                .errorKey(innerErrorKey2)
        }
        .errorKey(outerErrorKey)

        // The appropriateness of this behavior is open to discussion.
        XCTAssertEqual(sut.validationErrors?[outerErrorKey].count, 0)

        XCTAssertEqual(sut.validationErrors?[innerErrorKey1].count, 2)
        XCTAssertEqual(sut.validationErrors?.reasons(for: innerErrorKey1), [.empty])

        XCTAssertEqual(sut.validationErrors?[innerErrorKey2].count, 2)
        XCTAssertEqual(sut.validationErrors?.reasons(for: innerErrorKey2), [.count])
    }

}
