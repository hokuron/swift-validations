import XCTest
@testable import Validations

final class CountTests: XCTestCase {
    func testBoundary() throws {
        let value = "12345"
        try XCTContext.runActivity(named: "lower") { _ in
            XCTAssertThrowsError(try Count(value, within: 6...).validate())
            XCTAssertNoThrow(try Count(value, within: 5...).validate())
        }

        try XCTContext.runActivity(named: "upper") { _ in
            XCTAssertThrowsError(try Count(value, within: ...4).validate())
            XCTAssertNoThrow(try Count(value, within: ...5).validate())
        }

        try XCTContext.runActivity(named: "exact") { _ in
            XCTAssertThrowsError(try Count(value, exact: 6).validate())
            XCTAssertNoThrow(try Count(value, exact: 5).validate())
        }
    }

    func testNil() throws {
        try XCTContext.runActivity(named: "disallowed") { _ in
            XCTAssertThrowsError(try Count(String?.none, within: 0...).validate())
            XCTAssertThrowsError(try Count(String?.none, exact: 0).validate())
            XCTAssertThrowsError(try Count([Int]?.none, within: 0...).validate())
            XCTAssertThrowsError(try Count([Int]?.none, within: 0...).validate())
            XCTAssertThrowsError(try Count([Int?]?.none, exact: 0).validate())
            XCTAssertThrowsError(try Count([Int?]?.none, exact: 0).validate())
        }

        try XCTContext.runActivity(named: "allowed") { _ in
            XCTAssertNoThrow(try Count(String?.none, within: 0...).allowsNil().validate())
            XCTAssertNoThrow(try Count(String?.none, exact: 0).allowsNil().validate())
            XCTAssertNoThrow(try Count([Int]?.none, within: 0...).allowsNil().validate())
            XCTAssertNoThrow(try Count([Int]?.none, within: 0...).allowsNil().validate())
            XCTAssertNoThrow(try Count([Int?]?.none, exact: 0).allowsNil().validate())
            XCTAssertNoThrow(try Count([Int?]?.none, exact: 0).allowsNil().validate())
        }
    }

    func testEmpty() {
        XCTAssertNoThrow(try Count("", within: 0...).validate())
        XCTAssertNoThrow(try Count("", exact: 0).validate())
        XCTAssertNoThrow(try Count([Int](), within: 0...).validate())
        XCTAssertNoThrow(try Count([Int](), exact: 0).validate())
        XCTAssertNoThrow(try Count([Int?](), within: 0...).validate())
        XCTAssertNoThrow(try Count([Int?](), exact: 0).validate())
        XCTAssertNoThrow(try Count([Int]?([]), within: 0...).validate())
        XCTAssertNoThrow(try Count([Int]?([]), exact: 0).validate())
        XCTAssertNoThrow(try Count([Int?]?([]), within: 0...).validate())
        XCTAssertNoThrow(try Count([Int?]?([]), exact: 0).validate())
    }
}
