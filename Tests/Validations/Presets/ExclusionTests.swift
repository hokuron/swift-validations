import XCTest
@testable import Validations

final class ExclusionTests: XCTestCase {
    private enum Test {
        case a, b, c
    }

    func testSingleValue() throws {
        XCTAssertThrowsError(try Exclusion(Test.a, in: [.a, .c]).validate())
        XCTAssertNoThrow(try Exclusion(Test.a, in: [.b, .c]).validate())

        try XCTContext.runActivity(named: "nil value") { _ in
            XCTAssertThrowsError(try Exclusion(Test?.none, in: [.b, .c]).validate())
            XCTAssertNoThrow(try Exclusion(Test?.none, in: [.b, .c]).allowsNil().validate())
        }
    }

    func testMultipleValues() throws {
        XCTAssertThrowsError(try Exclusion([Test.a, .b], in: [.a, .b, .c]).validate())
        XCTAssertNoThrow(try Exclusion([Test.a, .b], in: [.a, .c]).validate())

        try XCTContext.runActivity(named: "nil value") { _ in
            XCTAssertThrowsError(try Exclusion([Test]?.none, in: [.a, .c]).validate())
            XCTAssertNoThrow(try Exclusion([Test]?.none, in: [.a, .c]).allowsNil().validate())
            XCTAssertNoThrow(try Exclusion([Test]?.none, in: [.a, .c]).allowsNil().allowsEmpty().validate())
        }

        try XCTContext.runActivity(named: "empty value") { _ in
            XCTAssertThrowsError(try Exclusion([], in: [Test.a, .c]).validate())
            XCTAssertNoThrow(try Exclusion([], in: [Test.a, .c]).allowsEmpty().validate())
            XCTAssertNoThrow(try Exclusion([], in: [Test.a, .c]).allowsEmpty().allowsNil().validate())
        }
    }

    func testString() throws {
        XCTAssertThrowsError(try Exclusion("S", in: "Swift").validate())
        XCTAssertNoThrow(try Exclusion("s", in: "Swift").validate())
        XCTAssertThrowsError(try Exclusion("if", in: "Swift").validate())
        XCTAssertNoThrow(try Exclusion("St", in: "Swift").validate())
        XCTAssertNoThrow(try Exclusion("ABC", in: "Swift").validate())

        try XCTContext.runActivity(named: "nil value") { _ in
            XCTAssertThrowsError(try Exclusion(nil, in: "Swift").validate())
            XCTAssertNoThrow(try Exclusion(nil, in: "Swift").allowsNil().validate())
            XCTAssertNoThrow(try Exclusion(String?.none, in: "Swift").allowsNil().allowsEmpty().validate())
        }

        try XCTContext.runActivity(named: "empty value") { _ in
            XCTAssertThrowsError(try Exclusion("", in: "Swift").validate())
            XCTAssertNoThrow(try Exclusion("", in: "Swift").allowsEmpty().validate())
            XCTAssertNoThrow(try Exclusion("", in: "Swift").allowsEmpty().allowsNil().validate())
        }
    }

    func testSingleValueInRange() throws {
        XCTAssertThrowsError(try Exclusion(5, in: 4...).validate())
        XCTAssertNoThrow(try Exclusion(5, in: ...4).validate())

        try XCTContext.runActivity(named: "nil value") { _ in
            XCTAssertThrowsError(try Exclusion(nil, in: ...4).validate())
            XCTAssertNoThrow(try Exclusion(nil, in: ...4).allowsNil().validate())
        }
    }

    func testMultipleValueInRange() throws {
        XCTAssertThrowsError(try Exclusion([2, 5], in: 2...).validate())
        XCTAssertNoThrow(try Exclusion([2, 5], in: 3...).validate())
        XCTAssertNoThrow(try Exclusion([2, 5], in: 3...).validate())

        try XCTContext.runActivity(named: "nil value") { _ in
            XCTAssertThrowsError(try Exclusion([Int]?.none, in: 0...).validate())
            XCTAssertNoThrow(try Exclusion([Int]?.none, in: 0...).allowsNil().validate())
            XCTAssertNoThrow(try Exclusion([Int]?.none, in: 0...).allowsNil().allowsEmpty().validate())
        }

        try XCTContext.runActivity(named: "empty value") { _ in
            XCTAssertThrowsError(try Exclusion([], in: 0...).validate())
            XCTAssertNoThrow(try Exclusion([], in: 0...).allowsEmpty().validate())
            XCTAssertNoThrow(try Exclusion([], in: 0...).allowsEmpty().allowsNil().validate())
        }
    }
}
