import XCTest
@testable import Validations

final class ExclusionTests: XCTestCase {
    private enum Test {
        case a, b, c
    }

    func testSingleValue() throws {
        XCTAssertThrowsError(try Exclusion(of: Test.a, in: [.a, .c]).validate())
        XCTAssertNoThrow(try Exclusion(of: Test.a, in: [.b, .c]).validate())

        try XCTContext.runActivity(named: "nil value") { _ in
            XCTAssertThrowsError(try Exclusion(of: Test?.none, in: [.b, .c]).validate())
            XCTAssertNoThrow(try Exclusion(of: Test?.none, in: [.b, .c]).allowsNil().validate())
        }
    }

    func testMultipleValues() throws {
        XCTAssertThrowsError(try Exclusion(of: [Test.a, .b], in: [.a, .b, .c]).validate())
        XCTAssertNoThrow(try Exclusion(of: [Test.a, .b], in: [.a, .c]).validate())

        try XCTContext.runActivity(named: "nil value") { _ in
            XCTAssertThrowsError(try Exclusion(of: [Test]?.none, in: [.a, .c]).validate())
            XCTAssertNoThrow(try Exclusion(of: [Test]?.none, in: [.a, .c]).allowsNil().validate())
            XCTAssertNoThrow(try Exclusion(of: [Test]?.none, in: [.a, .c]).allowsNil().allowsEmpty().validate())
        }

        try XCTContext.runActivity(named: "empty value") { _ in
            XCTAssertThrowsError(try Exclusion(of: [], in: [Test.a, .c]).validate())
            XCTAssertNoThrow(try Exclusion(of: [], in: [Test.a, .c]).allowsEmpty().validate())
            XCTAssertNoThrow(try Exclusion(of: [], in: [Test.a, .c]).allowsEmpty().allowsNil().validate())
        }
    }

    func testString() throws {
        XCTAssertThrowsError(try Exclusion(of: "S", in: "Swift").validate())
        XCTAssertNoThrow(try Exclusion(of: "s", in: "Swift").validate())
        XCTAssertThrowsError(try Exclusion(of: "if", in: "Swift").validate())
        XCTAssertNoThrow(try Exclusion(of: "St", in: "Swift").validate())
        XCTAssertNoThrow(try Exclusion(of: "ABC", in: "Swift").validate())

        try XCTContext.runActivity(named: "nil value") { _ in
            XCTAssertThrowsError(try Exclusion(of: nil, in: "Swift").validate())
            XCTAssertNoThrow(try Exclusion(of: nil, in: "Swift").allowsNil().validate())
            XCTAssertNoThrow(try Exclusion(of: String?.none, in: "Swift").allowsNil().allowsEmpty().validate())
        }

        try XCTContext.runActivity(named: "empty value") { _ in
            XCTAssertThrowsError(try Exclusion(of: "", in: "Swift").validate())
            XCTAssertNoThrow(try Exclusion(of: "", in: "Swift").allowsEmpty().validate())
            XCTAssertNoThrow(try Exclusion(of: "", in: "Swift").allowsEmpty().allowsNil().validate())
        }
    }

    func testSingleValueInRange() throws {
        XCTAssertThrowsError(try Exclusion(of: 5, in: 4...).validate())
        XCTAssertNoThrow(try Exclusion(of: 5, in: ...4).validate())

        try XCTContext.runActivity(named: "nil value") { _ in
            XCTAssertThrowsError(try Exclusion(of: nil, in: ...4).validate())
            XCTAssertNoThrow(try Exclusion(of: nil, in: ...4).allowsNil().validate())
        }
    }

    func testMultipleValueInRange() throws {
        XCTAssertThrowsError(try Exclusion(of: [2, 5], in: 2...).validate())
        XCTAssertNoThrow(try Exclusion(of: [2, 5], in: 3...).validate())
        XCTAssertNoThrow(try Exclusion(of: [2, 5], in: 3...).validate())

        try XCTContext.runActivity(named: "nil value") { _ in
            XCTAssertThrowsError(try Exclusion(of: [Int]?.none, in: 0...).validate())
            XCTAssertNoThrow(try Exclusion(of: [Int]?.none, in: 0...).allowsNil().validate())
            XCTAssertNoThrow(try Exclusion(of: [Int]?.none, in: 0...).allowsNil().allowsEmpty().validate())
        }

        try XCTContext.runActivity(named: "empty value") { _ in
            XCTAssertThrowsError(try Exclusion(of: [], in: 0...).validate())
            XCTAssertNoThrow(try Exclusion(of: [], in: 0...).allowsEmpty().validate())
            XCTAssertNoThrow(try Exclusion(of: [], in: 0...).allowsEmpty().allowsNil().validate())
        }
    }
}
