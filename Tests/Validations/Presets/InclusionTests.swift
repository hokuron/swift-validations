import XCTest
@testable import Validations

final class InclusionTests: XCTestCase {
    private enum Test {
        case a, b, c
    }

    func testSingleValue() throws {
        XCTAssertNoThrow(try Inclusion(Test.a, in: [.a, .c]).validate())
        XCTAssertThrowsError(try Inclusion(Test.a, in: [.b, .c]).validate())

        try XCTContext.runActivity(named: "nil value") { _ in
            XCTAssertThrowsError(try Inclusion(Test?.none, in: [.b, .c]).validate())
            XCTAssertNoThrow(try Inclusion(Test?.none, in: [.b, .c]).allowsNil().validate())
        }
    }

    func testMultipleValues() throws {
        XCTAssertNoThrow(try Inclusion([Test.a, .b], in: [.a, .b, .c]).validate())
        XCTAssertThrowsError(try Inclusion([Test.a, .b], in: [.a, .c]).validate())

        try XCTContext.runActivity(named: "nil value") { _ in
            XCTAssertThrowsError(try Inclusion([Test]?.none, in: [.a, .c]).validate())
            XCTAssertNoThrow(try Inclusion([Test]?.none, in: [.a, .c]).allowsNil().validate())
            XCTAssertNoThrow(try Inclusion([Test]?.none, in: [.a, .c]).allowsNil().allowsEmpty().validate())
        }

        try XCTContext.runActivity(named: "empty value") { _ in
            XCTAssertThrowsError(try Inclusion([], in: [Test.a, .c]).validate())
            XCTAssertNoThrow(try Inclusion([], in: [Test.a, .c]).allowsEmpty().validate())
            XCTAssertNoThrow(try Inclusion([], in: [Test.a, .c]).allowsEmpty().allowsNil().validate())
        }
    }

    func testString() throws {
        XCTAssertNoThrow(try Inclusion("S", in: "Swift").validate())
        XCTAssertThrowsError(try Inclusion("s", in: "Swift").validate())
        XCTAssertNoThrow(try Inclusion("if", in: "Swift").validate())
        XCTAssertThrowsError(try Inclusion("St", in: "Swift").validate())
        XCTAssertThrowsError(try Inclusion("ABC", in: "Swift").validate())
        
        try XCTContext.runActivity(named: "nil value") { _ in
            XCTAssertThrowsError(try Inclusion(nil, in: "Swift").validate())
            XCTAssertNoThrow(try Inclusion(nil, in: "Swift").allowsNil().validate())
            XCTAssertNoThrow(try Inclusion(String?.none, in: "Swift").allowsNil().allowsEmpty().validate())
        }

        try XCTContext.runActivity(named: "empty value") { _ in
            XCTAssertThrowsError(try Inclusion("", in: "Swift").validate())
            XCTAssertNoThrow(try Inclusion("", in: "Swift").allowsEmpty().validate())
            XCTAssertNoThrow(try Inclusion("", in: "Swift").allowsEmpty().allowsNil().validate())
        }
    }

    func testSingleValueInRange() throws {
        XCTAssertNoThrow(try Inclusion(5, in: 4...).validate())
        XCTAssertThrowsError(try Inclusion(5, in: ...4).validate())

        try XCTContext.runActivity(named: "nil value") { _ in
            XCTAssertThrowsError(try Inclusion(nil, in: ...4).validate())
            XCTAssertNoThrow(try Inclusion(nil, in: ...4).allowsNil().validate())
        }
    }

    func testMultipleValueInRange() throws {
        XCTAssertNoThrow(try Inclusion([2, 5], in: 2...).validate())
        XCTAssertThrowsError(try Inclusion([2, 5], in: 3...).validate())

        try XCTContext.runActivity(named: "nil value") { _ in
            XCTAssertThrowsError(try Inclusion([Int]?.none, in: 0...).validate())
            XCTAssertNoThrow(try Inclusion([Int]?.none, in: 0...).allowsNil().validate())
            XCTAssertNoThrow(try Inclusion([Int]?.none, in: 0...).allowsNil().allowsEmpty().validate())
        }

        try XCTContext.runActivity(named: "empty value") { _ in
            XCTAssertThrowsError(try Inclusion([], in: 0...).validate())
            XCTAssertNoThrow(try Inclusion([], in: 0...).allowsEmpty().validate())
            XCTAssertNoThrow(try Inclusion([], in: 0...).allowsEmpty().allowsNil().validate())
        }
    }
}
