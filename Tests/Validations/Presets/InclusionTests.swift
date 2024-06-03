import XCTest
@testable import Validations

final class InclusionTests: XCTestCase {
    private enum Test {
        case a, b, c
    }

    func testSingleValue() throws {
        XCTAssertNoThrow(try Inclusion(of: Test.a, in: [.a, .c]).validate())
        XCTAssertThrowsError(try Inclusion(of: Test.a, in: [.b, .c]).validate())

        try XCTContext.runActivity(named: "nil value") { _ in
            XCTAssertThrowsError(try Inclusion(of: Test?.none, in: [.b, .c]).validate())
            XCTAssertNoThrow(try Inclusion(of: Test?.none, in: [.b, .c]).allowsNil().validate())
        }
    }

    func testMultipleValues() throws {
        XCTAssertNoThrow(try Inclusion(of: [Test.a, .b], in: [.a, .b, .c]).validate())
        XCTAssertThrowsError(try Inclusion(of: [Test.a, .b], in: [.a, .c]).validate())

        try XCTContext.runActivity(named: "nil value") { _ in
            XCTAssertThrowsError(try Inclusion(of: [Test]?.none, in: [.a, .c]).validate())
            XCTAssertNoThrow(try Inclusion(of: [Test]?.none, in: [.a, .c]).allowsNil().validate())
            XCTAssertNoThrow(try Inclusion(of: [Test]?.none, in: [.a, .c]).allowsNil().allowsEmpty().validate())
        }

        try XCTContext.runActivity(named: "empty value") { _ in
            XCTAssertThrowsError(try Inclusion(of: [], in: [Test.a, .c]).validate())
            XCTAssertNoThrow(try Inclusion(of: [], in: [Test.a, .c]).allowsEmpty().validate())
            XCTAssertNoThrow(try Inclusion(of: [], in: [Test.a, .c]).allowsEmpty().allowsNil().validate())
        }
    }

    func testString() throws {
        XCTAssertNoThrow(try Inclusion(of: "S", in: "Swift").validate())
        XCTAssertThrowsError(try Inclusion(of: "s", in: "Swift").validate())
        XCTAssertNoThrow(try Inclusion(of: "if", in: "Swift").validate())
        XCTAssertThrowsError(try Inclusion(of: "St", in: "Swift").validate())
        XCTAssertThrowsError(try Inclusion(of: "ABC", in: "Swift").validate())
        
        try XCTContext.runActivity(named: "nil value") { _ in
            XCTAssertThrowsError(try Inclusion(of: nil, in: "Swift").validate())
            XCTAssertNoThrow(try Inclusion(of: nil, in: "Swift").allowsNil().validate())
            XCTAssertNoThrow(try Inclusion(of: String?.none, in: "Swift").allowsNil().allowsEmpty().validate())
        }

        try XCTContext.runActivity(named: "empty value") { _ in
            XCTAssertThrowsError(try Inclusion(of: "", in: "Swift").validate())
            XCTAssertNoThrow(try Inclusion(of: "", in: "Swift").allowsEmpty().validate())
            XCTAssertNoThrow(try Inclusion(of: "", in: "Swift").allowsEmpty().allowsNil().validate())
        }
    }

    func testSingleValueInRange() throws {
        XCTAssertNoThrow(try Inclusion(of: 5, in: 4...).validate())
        XCTAssertThrowsError(try Inclusion(of: 5, in: ...4).validate())

        try XCTContext.runActivity(named: "nil value") { _ in
            XCTAssertThrowsError(try Inclusion(of: nil, in: ...4).validate())
            XCTAssertNoThrow(try Inclusion(of: nil, in: ...4).allowsNil().validate())
        }
    }

    func testMultipleValueInRange() throws {
        XCTAssertNoThrow(try Inclusion(of: [2, 5], in: 2...).validate())
        XCTAssertThrowsError(try Inclusion(of: [2, 5], in: 3...).validate())

        try XCTContext.runActivity(named: "nil value") { _ in
            XCTAssertThrowsError(try Inclusion(of: [Int]?.none, in: 0...).validate())
            XCTAssertNoThrow(try Inclusion(of: [Int]?.none, in: 0...).allowsNil().validate())
            XCTAssertNoThrow(try Inclusion(of: [Int]?.none, in: 0...).allowsNil().allowsEmpty().validate())
        }

        try XCTContext.runActivity(named: "empty value") { _ in
            XCTAssertThrowsError(try Inclusion(of: [], in: 0...).validate())
            XCTAssertNoThrow(try Inclusion(of: [], in: 0...).allowsEmpty().validate())
            XCTAssertNoThrow(try Inclusion(of: [], in: 0...).allowsEmpty().allowsNil().validate())
        }
    }
}
