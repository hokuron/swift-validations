import XCTest
@testable import Validations

final class ConfirmationTests: XCTestCase {
    func testNotCollection() {
        XCTAssertNoThrow(try Confirmation(of: nil, matching: 1).validate())
        XCTAssertThrowsError(try Confirmation(of: nil, matching: 1).presence(.required).validate())
    }

    func testStringWithoutPresenceOptions() {
        XCTAssertNoThrow(try Confirmation(of: nil, matching: "123").validate())
        XCTAssertNoThrow(try Confirmation(of: "", matching: "123").validate())
        XCTAssertNoThrow(try Confirmation(of: "123", matching: "123").validate())
    }

    @MainActor
    func testStringWithPresenceOptions() throws {
        try XCTContext.runActivity(named: "nil disallowed") { _ in
            XCTAssertThrowsError(try Confirmation(of: nil, matching: "123").presence(.required(allowsEmpty: true)).validate())
            XCTAssertThrowsError(try Confirmation(of: nil, matching: "").presence(.required(allowsEmpty: true)).validate())
            XCTAssertNoThrow(try Confirmation(of: "", matching: "123").presence(.required(allowsEmpty: true)).validate())
            XCTAssertNoThrow(try Confirmation(of: "", matching: "").presence(.required(allowsEmpty: true)).validate())
            XCTAssertNoThrow(try Confirmation(of: "123", matching: "123").presence(.required(allowsEmpty: true)).validate())
        }

        try XCTContext.runActivity(named: "empty disallowed") { _ in
            XCTAssertNoThrow(try Confirmation(of: nil, matching: "123").presence(.required(allowsNil: true)).validate())
            XCTAssertNoThrow(try Confirmation(of: nil, matching: "").presence(.required(allowsNil: true)).validate())
            XCTAssertThrowsError(try Confirmation(of: "", matching: "123").presence(.required(allowsNil: true)).validate())
            XCTAssertThrowsError(try Confirmation(of: "", matching: "").presence(.required(allowsNil: true)).validate())
            XCTAssertNoThrow(try Confirmation(of: "123", matching: "123").presence(.required(allowsNil: true)).validate())
        }

        try XCTContext.runActivity(named: "nil and empty disallowed") { _ in
            XCTAssertThrowsError(try Confirmation(of: nil, matching: "123").presence(.required).validate())
            XCTAssertThrowsError(try Confirmation(of: nil, matching: "").presence(.required).validate())
            XCTAssertThrowsError(try Confirmation(of: "", matching: "123").presence(.required).validate())
            XCTAssertThrowsError(try Confirmation(of: "", matching: "").presence(.required).validate())
            XCTAssertNoThrow(try Confirmation(of: "123", matching: "123").presence(.required).validate())
        }
    }

    func testArrayWithoutPresenceOptions() {
        XCTAssertNoThrow(try Confirmation(of: nil, matching: [1, 2, 3]).validate())
        XCTAssertNoThrow(try Confirmation(of: [], matching: [1, 2, 3]).validate())
        XCTAssertThrowsError(try Confirmation(of: [1, nil, 3], matching: [1, 2, 3]).validate())
        XCTAssertNoThrow(try Confirmation(of: [1, 2, 3], matching: [1, 2, 3]).validate())
        XCTAssertNoThrow(try Confirmation(of: [Int](), matching: []).validate())
    }

    @MainActor
    func testArrayWithPresenceOptions() throws {
        try XCTContext.runActivity(named: "nil disallowed") { _ in
            XCTAssertThrowsError(try Confirmation(of: nil, matching: [1, 2, 3]).presence(.required(allowsEmpty: true)).validate())
            XCTAssertNoThrow(try Confirmation(of: [], matching: [1, 2, 3]).presence(.required(allowsEmpty: true)).validate())
            XCTAssertThrowsError(try Confirmation(of: [1, nil, 3], matching: [1, 2, 3]).presence(.required(allowsEmpty: true)).validate())
            XCTAssertNoThrow(try Confirmation(of: [1, 2, 3], matching: [1, 2, 3]).presence(.required(allowsEmpty: true)).validate())
            XCTAssertNoThrow(try Confirmation(of: [Int](), matching: []).presence(.required(allowsEmpty: true)).validate())
        }

        try XCTContext.runActivity(named: "empty disallowed") { _ in
            XCTAssertNoThrow(try Confirmation(of: nil, matching: [1, 2, 3]).presence(.required(allowsNil: true)).validate())
            XCTAssertThrowsError(try Confirmation(of: [], matching: [1, 2, 3]).presence(.required(allowsNil: true)).validate())
            XCTAssertThrowsError(try Confirmation(of: [1, nil, 3], matching: [1, 2, 3]).presence(.required(allowsNil: true)).validate())
            XCTAssertNoThrow(try Confirmation(of: [1, 2, 3], matching: [1, 2, 3]).presence(.required(allowsNil: true)).validate())
            XCTAssertThrowsError(try Confirmation(of: [Int](), matching: []).presence(.required(allowsNil: true)).validate())
        }

        try XCTContext.runActivity(named: "nil and empty disallowed") { _ in
            XCTAssertThrowsError(try Confirmation(of: nil, matching: [1, 2, 3]).presence(.required).validate())
            XCTAssertThrowsError(try Confirmation(of: [], matching: [1, 2, 3]).presence(.required).validate())
            XCTAssertThrowsError(try Confirmation(of: [1, nil, 3], matching: [1, 2, 3]).presence(.required).validate())
            XCTAssertNoThrow(try Confirmation(of: [1, 2, 3], matching: [1, 2, 3]).presence(.required).validate())
            XCTAssertThrowsError(try Confirmation(of: [Int](), matching: []).presence(.required).validate())
        }
    }

    func testSourceValueAbsence() {
        XCTAssertThrowsError(try Confirmation(of: 1, matching: nil).validate())
        XCTAssertThrowsError(try Confirmation(of: "123", matching: "").validate())
        XCTAssertNoThrow(try Confirmation(of: "", matching: "").validate())
        XCTAssertNoThrow(try Confirmation(of: Int?.none, matching: Int?.none).validate())
        XCTAssertThrowsError(try Confirmation(of: "", matching: "").presence(.required).validate())
        XCTAssertThrowsError(try Confirmation(of: Int?.none, matching: Int?.none).presence(.required).validate())
    }
}
