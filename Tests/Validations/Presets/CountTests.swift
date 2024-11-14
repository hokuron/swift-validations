import XCTest
@testable import Validations

final class CountTests: XCTestCase {
    @MainActor
    func testBoundary() throws {
        let value = "12345"
        try XCTContext.runActivity(named: "lower") { _ in
            XCTAssertThrowsError(try Count(of: value, within: 6...).validate())
            XCTAssertNoThrow(try Count(of: value, within: 5...).validate())
        }

        try XCTContext.runActivity(named: "upper") { _ in
            XCTAssertThrowsError(try Count(of: value, within: ...4).validate())
            XCTAssertNoThrow(try Count(of: value, within: ...5).validate())
        }

        try XCTContext.runActivity(named: "exact") { _ in
            XCTAssertThrowsError(try Count(of: value, exact: 6).validate())
            XCTAssertNoThrow(try Count(of: value, exact: 5).validate())
        }
    }

    @MainActor
    func testNil() throws {
        try XCTContext.runActivity(named: "disallowed") { _ in
            XCTAssertThrowsError(try Count(of: String?.none, within: 0...).validate())
            XCTAssertThrowsError(try Count(of: String?.none, exact: 0).validate())
            XCTAssertThrowsError(try Count(of: [Int]?.none, within: 0...).validate())
            XCTAssertThrowsError(try Count(of: [Int]?.none, within: 0...).validate())
            XCTAssertThrowsError(try Count(of: [Int?]?.none, exact: 0).validate())
            XCTAssertThrowsError(try Count(of: [Int?]?.none, exact: 0).validate())
        }

        try XCTContext.runActivity(named: "allowed") { _ in
            XCTAssertNoThrow(try Count(of: String?.none, within: 0...).allowsNil().validate())
            XCTAssertNoThrow(try Count(of: String?.none, exact: 0).allowsNil().validate())
            XCTAssertNoThrow(try Count(of: [Int]?.none, within: 0...).allowsNil().validate())
            XCTAssertNoThrow(try Count(of: [Int]?.none, within: 0...).allowsNil().validate())
            XCTAssertNoThrow(try Count(of: [Int?]?.none, exact: 0).allowsNil().validate())
            XCTAssertNoThrow(try Count(of: [Int?]?.none, exact: 0).allowsNil().validate())
        }
    }

    func testEmpty() {
        XCTAssertNoThrow(try Count(of: "", within: 0...).validate())
        XCTAssertNoThrow(try Count(of: "", exact: 0).validate())
        XCTAssertNoThrow(try Count(of: [Int](), within: 0...).validate())
        XCTAssertNoThrow(try Count(of: [Int](), exact: 0).validate())
        XCTAssertNoThrow(try Count(of: [Int?](), within: 0...).validate())
        XCTAssertNoThrow(try Count(of: [Int?](), exact: 0).validate())
        XCTAssertNoThrow(try Count(of: [Int]?([]), within: 0...).validate())
        XCTAssertNoThrow(try Count(of: [Int]?([]), exact: 0).validate())
        XCTAssertNoThrow(try Count(of: [Int?]?([]), within: 0...).validate())
        XCTAssertNoThrow(try Count(of: [Int?]?([]), exact: 0).validate())
    }
}
