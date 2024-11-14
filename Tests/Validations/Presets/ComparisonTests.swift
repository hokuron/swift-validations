import XCTest
@testable import Validations

final class ComparisonTests: XCTestCase {
    func testGreaterThan() {
        let now = Date.now
        XCTAssertNoThrow(try Comparison(of: now, .greaterThan(now - 1)).validate())
        XCTAssertThrowsError(try Comparison(of: now, .greaterThan(now)).validate())
        XCTAssertThrowsError(try Comparison(of: now, .greaterThan(now + 1)).validate())
        XCTAssertThrowsError(try Comparison(of: nil, .greaterThan(now - 1)).validate())
        XCTAssertNoThrow(try Comparison(of: nil, .greaterThan(now + 1)).allowsNil().validate())
        XCTAssertThrowsError(try Comparison(of: nil, .greaterThan(now - 1)).allowsNil(false).validate())
    }

    func testGreaterThanOrEqual() {
        let now = Date.now
        XCTAssertNoThrow(try Comparison(of: now, .greaterThanOrEqualTo(now - 1)).validate())
        XCTAssertNoThrow(try Comparison(of: now, .greaterThanOrEqualTo(now)).validate())
        XCTAssertThrowsError(try Comparison(of: now, .greaterThanOrEqualTo(now + 1)).validate())
        XCTAssertThrowsError(try Comparison(of: nil, .greaterThanOrEqualTo(now - 1)).validate())
        XCTAssertNoThrow(try Comparison(of: nil, .greaterThanOrEqualTo(now + 1)).allowsNil().validate())
        XCTAssertThrowsError(try Comparison(of: nil, .greaterThanOrEqualTo(now - 1)).allowsNil(false).validate())
    }

    func testLessThan() {
        let now = Date.now
        XCTAssertThrowsError(try Comparison(of: now, .lessThan(now - 1)).validate())
        XCTAssertThrowsError(try Comparison(of: now, .lessThan(now)).validate())
        XCTAssertNoThrow(try Comparison(of: now, .lessThan(now + 1)).validate())
        XCTAssertThrowsError(try Comparison(of: nil, .lessThan(now + 1)).validate())
        XCTAssertNoThrow(try Comparison(of: nil, .lessThan(now - 1)).allowsNil().validate())
        XCTAssertThrowsError(try Comparison(of: nil, .lessThan(now + 1)).allowsNil(false).validate())
    }

    func testLessThanOrEqual() {
        let now = Date.now
        XCTAssertThrowsError(try Comparison(of: now, .lessThanOrEqualTo(now - 1)).validate())
        XCTAssertNoThrow(try Comparison(of: now, .lessThanOrEqualTo(now)).validate())
        XCTAssertNoThrow(try Comparison(of: now, .lessThanOrEqualTo(now + 1)).validate())
        XCTAssertThrowsError(try Comparison(of: nil, .lessThanOrEqualTo(now + 1)).validate())
        XCTAssertNoThrow(try Comparison(of: nil, .lessThanOrEqualTo(now - 1)).allowsNil().validate())
        XCTAssertThrowsError(try Comparison(of: nil, .lessThanOrEqualTo(now + 1)).allowsNil(false).validate())
    }

    func testOtherThan() {
        let now = Date.now
        XCTAssertNoThrow(try Comparison(of: now, .otherThan(now - 1)).validate())
        XCTAssertThrowsError(try Comparison(of: now, .otherThan(now)).validate())
        XCTAssertNoThrow(try Comparison(of: now, .otherThan(now + 1)).validate())
        XCTAssertThrowsError(try Comparison(of: nil, .otherThan(now - 1)).validate())
        XCTAssertNoThrow(try Comparison(of: nil, .otherThan(now)).allowsNil().validate())
        XCTAssertThrowsError(try Comparison(of: nil, .otherThan(now + 1)).allowsNil(false).validate())
    }

    func testEquality() {
        let now = Date.now
        XCTAssertThrowsError(try Comparison(of: now, .equalTo(now - 1)).validate())
        XCTAssertNoThrow(try Comparison(of: now, .equalTo(now)).validate())
        XCTAssertThrowsError(try Comparison(of: now, .equalTo(now + 1)).validate())
        XCTAssertThrowsError(try Comparison(of: nil, .equalTo(now)).validate())
        XCTAssertNoThrow(try Comparison(of: nil, .equalTo(now - 1)).allowsNil().validate())
        XCTAssertThrowsError(try Comparison(of: nil, .equalTo(now)).allowsNil(false).validate())
    }

    @MainActor
    func testGreaterThanWithCollection() throws {
        XCTAssertNoThrow(try Comparison(of: [5, 10, 0], .greaterThan([5, 9, 2])).validate())
        XCTAssertThrowsError(try Comparison(of: [5, 10, 0], .greaterThan([5, 10, 0])).validate())
        XCTAssertThrowsError(try Comparison(of: [5, 10, 0], .greaterThan([6, 0, 0])).validate())

        try XCTContext.runActivity(named: "nil and empty allowed") { _ in
            XCTAssertNoThrow(try Comparison(of: nil, .greaterThan([5, 9, 2])).allowsNil().allowsEmpty().validate())
            XCTAssertNoThrow(try Comparison(of: [], .greaterThan([5, 10, 0])).allowsNil().allowsEmpty().validate())
        }
        try XCTContext.runActivity(named: "nil and empty disallowed") { _ in
            XCTAssertThrowsError(try Comparison(of: nil, .greaterThan([5, 9, 2])).validate())
            XCTAssertThrowsError(try Comparison(of: [], .greaterThan([5, 10, 0])).validate())
        }
        try XCTContext.runActivity(named: "nil allowed but empty disallowed") { _ in
            XCTAssertNoThrow(try Comparison(of: nil, .greaterThan([5, 9, 2])).allowsNil().validate())
            XCTAssertThrowsError(try Comparison(of: [], .greaterThan([5, 10, 0])).allowsNil().validate())
        }
        try XCTContext.runActivity(named: "empty allowed but nil disallowed") { _ in
            XCTAssertThrowsError(try Comparison(of: nil, .greaterThan([5, 9, 2])).allowsEmpty().validate())
            XCTAssertNoThrow(try Comparison(of: [], .greaterThan([5, 10, 0])).allowsEmpty().validate())
        }
    }

    @MainActor
    func testGreaterThanOrEqualWithCollection() throws {
        XCTAssertNoThrow(try Comparison(of: [5, 10, 0], .greaterThanOrEqualTo([5, 9, 2])).validate())
        XCTAssertNoThrow(try Comparison(of: [5, 10, 0], .greaterThanOrEqualTo([5, 10, 0])).validate())
        XCTAssertThrowsError(try Comparison(of: [5, 10, 0], .greaterThanOrEqualTo([6, 0, 0])).validate())

        try XCTContext.runActivity(named: "nil and empty allowed") { _ in
            XCTAssertNoThrow(try Comparison(of: nil, .greaterThanOrEqualTo([5, 9, 2])).allowsNil().allowsEmpty().validate())
            XCTAssertNoThrow(try Comparison(of: [], .greaterThanOrEqualTo([5, 10, 0])).allowsNil().allowsEmpty().validate())
        }
        try XCTContext.runActivity(named: "nil and empty disallowed") { _ in
            XCTAssertThrowsError(try Comparison(of: nil, .greaterThanOrEqualTo([5, 9, 2])).validate())
            XCTAssertThrowsError(try Comparison(of: [], .greaterThanOrEqualTo([5, 10, 0])).validate())
        }
        try XCTContext.runActivity(named: "nil allowed but empty disallowed") { _ in
            XCTAssertNoThrow(try Comparison(of: nil, .greaterThanOrEqualTo([5, 9, 2])).allowsNil().validate())
            XCTAssertThrowsError(try Comparison(of: [], .greaterThanOrEqualTo([5, 10, 0])).allowsNil().validate())
        }
        try XCTContext.runActivity(named: "empty allowed but nil disallowed") { _ in
            XCTAssertThrowsError(try Comparison(of: nil, .greaterThanOrEqualTo([5, 9, 2])).allowsEmpty().validate())
            XCTAssertNoThrow(try Comparison(of: [], .greaterThanOrEqualTo([5, 10, 0])).allowsEmpty().validate())
        }
    }

    @MainActor
    func testLessThanWithCollection() throws {
        XCTAssertThrowsError(try Comparison(of: [5, 10, 0], .lessThan([5, 9, 2])).validate())
        XCTAssertThrowsError(try Comparison(of: [5, 10, 0], .lessThan([5, 10, 0])).validate())
        XCTAssertNoThrow(try Comparison(of: [5, 10, 0], .lessThan([6, 0, 0])).validate())

        try XCTContext.runActivity(named: "nil and empty allowed") { _ in
            XCTAssertNoThrow(try Comparison(of: nil, .lessThan([5, 9, 2])).allowsNil().allowsEmpty().validate())
            XCTAssertNoThrow(try Comparison(of: [], .lessThan([5, 10, 0])).allowsNil().allowsEmpty().validate())
        }
        try XCTContext.runActivity(named: "nil and empty disallowed") { _ in
            XCTAssertThrowsError(try Comparison(of: nil, .lessThan([5, 9, 2])).validate())
            XCTAssertThrowsError(try Comparison(of: [], .lessThan([5, 10, 0])).validate())
        }
        try XCTContext.runActivity(named: "nil allowed but empty disallowed") { _ in
            XCTAssertNoThrow(try Comparison(of: nil, .lessThan([5, 9, 2])).allowsNil().validate())
            XCTAssertThrowsError(try Comparison(of: [], .lessThan([5, 10, 0])).allowsNil().validate())
        }
        try XCTContext.runActivity(named: "empty allowed but nil disallowed") { _ in
            XCTAssertThrowsError(try Comparison(of: nil, .lessThan([5, 9, 2])).allowsEmpty().validate())
            XCTAssertNoThrow(try Comparison(of: [], .lessThan([5, 10, 0])).allowsEmpty().validate())
        }
    }

    @MainActor
    func testLessThanOrEqualWithCollection() throws {
        XCTAssertThrowsError(try Comparison(of: [5, 10, 0], .lessThanOrEqualTo([5, 9, 2])).validate())
        XCTAssertNoThrow(try Comparison(of: [5, 10, 0], .lessThanOrEqualTo([5, 10, 0])).validate())
        XCTAssertNoThrow(try Comparison(of: [5, 10, 0], .lessThanOrEqualTo([6, 0, 0])).validate())

        try XCTContext.runActivity(named: "nil and empty allowed") { _ in
            XCTAssertNoThrow(try Comparison(of: nil, .lessThanOrEqualTo([5, 9, 2])).allowsNil().allowsEmpty().validate())
            XCTAssertNoThrow(try Comparison(of: [], .lessThanOrEqualTo([5, 10, 0])).allowsNil().allowsEmpty().validate())
        }
        try XCTContext.runActivity(named: "nil and empty disallowed") { _ in
            XCTAssertThrowsError(try Comparison(of: nil, .lessThanOrEqualTo([5, 9, 2])).validate())
            XCTAssertThrowsError(try Comparison(of: [], .lessThanOrEqualTo([5, 10, 0])).validate())
        }
        try XCTContext.runActivity(named: "nil allowed but empty disallowed") { _ in
            XCTAssertNoThrow(try Comparison(of: nil, .lessThanOrEqualTo([5, 9, 2])).allowsNil().validate())
            XCTAssertThrowsError(try Comparison(of: [], .lessThanOrEqualTo([5, 10, 0])).allowsNil().validate())
        }
        try XCTContext.runActivity(named: "empty allowed but nil disallowed") { _ in
            XCTAssertThrowsError(try Comparison(of: nil, .lessThanOrEqualTo([5, 9, 2])).allowsEmpty().validate())
            XCTAssertNoThrow(try Comparison(of: [], .lessThanOrEqualTo([5, 10, 0])).allowsEmpty().validate())
        }
    }

    @MainActor
    func testOtherThanWithCollection() throws {
        XCTAssertNoThrow(try Comparison(of: [5, 10, 0], .otherThan([5, 9, 2])).validate())
        XCTAssertThrowsError(try Comparison(of: [5, 10, 0], .otherThan([5, 10, 0])).validate())
        XCTAssertNoThrow(try Comparison(of: [5, 10, 0], .otherThan([6, 0, 0])).validate())

        try XCTContext.runActivity(named: "nil and empty allowed") { _ in
            XCTAssertNoThrow(try Comparison(of: nil, .otherThan([5, 9, 2])).allowsNil().allowsEmpty().validate())
            XCTAssertNoThrow(try Comparison(of: [], .otherThan([5, 10, 0])).allowsNil().allowsEmpty().validate())
        }
        try XCTContext.runActivity(named: "nil and empty disallowed") { _ in
            XCTAssertThrowsError(try Comparison(of: nil, .otherThan([5, 9, 2])).validate())
            XCTAssertThrowsError(try Comparison(of: [], .otherThan([5, 10, 0])).validate())
        }
        try XCTContext.runActivity(named: "nil allowed but empty disallowed") { _ in
            XCTAssertNoThrow(try Comparison(of: nil, .otherThan([5, 9, 2])).allowsNil().validate())
            XCTAssertThrowsError(try Comparison(of: [], .otherThan([5, 10, 0])).allowsNil().validate())
        }
        try XCTContext.runActivity(named: "empty allowed but nil disallowed") { _ in
            XCTAssertThrowsError(try Comparison(of: nil, .otherThan([5, 9, 2])).allowsEmpty().validate())
            XCTAssertNoThrow(try Comparison(of: [], .otherThan([5, 10, 0])).allowsEmpty().validate())
        }
    }

    @MainActor
    func testEqualityWithCollection() throws {
        XCTAssertThrowsError(try Comparison(of: [5, 10, 0], .equalTo([5, 9, 2])).validate())
        XCTAssertNoThrow(try Comparison(of: [5, 10, 0], .equalTo([5, 10, 0])).validate())
        XCTAssertThrowsError(try Comparison(of: [5, 10, 0], .equalTo([6, 0, 0])).validate())

        try XCTContext.runActivity(named: "nil and empty allowed") { _ in
            XCTAssertNoThrow(try Comparison(of: nil, .equalTo([5, 9, 2])).allowsNil().allowsEmpty().validate())
            XCTAssertNoThrow(try Comparison(of: [], .equalTo([5, 10, 0])).allowsNil().allowsEmpty().validate())
        }
        try XCTContext.runActivity(named: "nil and empty disallowed") { _ in
            XCTAssertThrowsError(try Comparison(of: nil, .equalTo([5, 9, 2])).validate())
            XCTAssertThrowsError(try Comparison(of: [], .equalTo([5, 10, 0])).validate())
        }
        try XCTContext.runActivity(named: "nil allowed but empty disallowed") { _ in
            XCTAssertNoThrow(try Comparison(of: nil, .equalTo([5, 9, 2])).allowsNil().validate())
            XCTAssertThrowsError(try Comparison(of: [], .equalTo([5, 10, 0])).allowsNil().validate())
        }
        try XCTContext.runActivity(named: "empty allowed but nil disallowed") { _ in
            XCTAssertThrowsError(try Comparison(of: nil, .equalTo([5, 9, 2])).allowsEmpty().validate())
            XCTAssertNoThrow(try Comparison(of: [], .equalTo([5, 10, 0])).allowsEmpty().validate())
        }
    }
}
