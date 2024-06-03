import XCTest
@testable import Validations

final class PresenceTests: XCTestCase {
    func testNotCollectionValue() {
        XCTAssertNoThrow(try Presence(of: 2).validate())
        XCTAssertThrowsError(try Presence(of: Int?.none).validate())
    }

    func testNilNotCollectionValue() {
        XCTAssertNoThrow(try Presence(of: Int?.none).allowsNil().validate())
        XCTAssertThrowsError(try Presence(of: Int?.none).allowsNil(false).validate())
    }

    func testString() {
        XCTAssertNoThrow(try Presence(of: "123").validate())
        XCTAssertThrowsError(try Presence(of: String?.none).validate())
        XCTAssertThrowsError(try Presence(of: String?("")).validate())
    }

    func testNilString() {
        XCTAssertNoThrow(try Presence(of: String?.none).allowsNil().validate())
        XCTAssertNoThrow(try Presence(of: String?.none).allowsNil().allowsEmpty().validate())
        XCTAssertNoThrow(try Presence(of: String?.none).allowsNil().allowsEmpty(false).validate())
        XCTAssertThrowsError(try Presence(of: String?.none).allowsNil(false).validate())
        XCTAssertThrowsError(try Presence(of: String?.none).allowsNil(false).allowsEmpty().validate())
        XCTAssertThrowsError(try Presence(of: String?.none).allowsNil(false).allowsEmpty(false).validate())
    }

    func testEmptyString() {
        XCTAssertNoThrow(try Presence(of: "").allowsEmpty().validate())
        XCTAssertNoThrow(try Presence(of: "").allowsEmpty().allowsNil().validate())
        XCTAssertNoThrow(try Presence(of: "").allowsEmpty().allowsNil(false).validate())
        XCTAssertNoThrow(try Presence(of: String?("")).allowsEmpty().validate())
        XCTAssertNoThrow(try Presence(of: String?("")).allowsEmpty().allowsNil().validate())
        XCTAssertNoThrow(try Presence(of: String?("")).allowsEmpty().allowsNil(false).validate())
        XCTAssertThrowsError(try Presence(of: "").allowsEmpty(false).validate())
        XCTAssertThrowsError(try Presence(of: "").allowsEmpty(false).allowsNil().validate())
        XCTAssertThrowsError(try Presence(of: "").allowsEmpty(false).allowsNil(false).validate())
        XCTAssertThrowsError(try Presence(of: String?("")).allowsEmpty(false).validate())
        XCTAssertThrowsError(try Presence(of: String?("")).allowsEmpty(false).allowsNil().validate())
        XCTAssertThrowsError(try Presence(of: String?("")).allowsEmpty(false).allowsNil(false).validate())
    }

    func testArray() {
        XCTAssertNoThrow(try Presence(of: [1, 2, 3]).validate())
        XCTAssertNoThrow(try Presence(of: [1, nil, 3]).validate())
        XCTAssertThrowsError(try Presence(of: [Int]?.none).validate())
        XCTAssertThrowsError(try Presence(of: [Int]?([])).validate())
    }

    func testArrayWithNilElements() {
        XCTAssertNoThrow(try Presence(of: [Int?]([nil, nil, nil])).validate())
        XCTAssertNoThrow(try Presence(of: [Int?]([nil, nil, nil])).allowsNil().allowsEmpty().validate())
        XCTAssertNoThrow(try Presence(of: [Int?]([nil, nil, nil])).allowsNil(false).allowsEmpty().validate())
        XCTAssertNoThrow(try Presence(of: [Int?]([nil, nil, nil])).allowsNil().allowsEmpty(false).validate())
        XCTAssertNoThrow(try Presence(of: [Int?]([nil, nil, nil])).allowsNil(false).allowsEmpty(false).validate())
    }

    func testNilArray() {
        XCTAssertNoThrow(try Presence(of: [Int]?.none).allowsNil().validate())
        XCTAssertNoThrow(try Presence(of: [Int]?.none).allowsNil().allowsEmpty().validate())
        XCTAssertNoThrow(try Presence(of: [Int]?.none).allowsNil().allowsEmpty(false).validate())
        XCTAssertThrowsError(try Presence(of: [Int]?.none).allowsNil(false).validate())
        XCTAssertThrowsError(try Presence(of: [Int]?.none).allowsNil(false).allowsEmpty().validate())
        XCTAssertThrowsError(try Presence(of: [Int]?.none).allowsNil(false).allowsEmpty(false).validate())
    }

    func testEmptyArray() {
        XCTAssertNoThrow(try Presence(of: [Int]([])).allowsEmpty().validate())
        XCTAssertNoThrow(try Presence(of: [Int]([])).allowsEmpty().allowsNil().validate())
        XCTAssertNoThrow(try Presence(of: [Int]([])).allowsEmpty().allowsNil(false).validate())
        XCTAssertNoThrow(try Presence(of: [Int?]([])).allowsEmpty().validate())
        XCTAssertNoThrow(try Presence(of: [Int?]([])).allowsEmpty().allowsNil().validate())
        XCTAssertNoThrow(try Presence(of: [Int?]([])).allowsEmpty().allowsNil(false).validate())
        XCTAssertThrowsError(try Presence(of: [Int]([])).allowsEmpty(false).validate())
        XCTAssertThrowsError(try Presence(of: [Int]([])).allowsEmpty(false).allowsNil().validate())
        XCTAssertThrowsError(try Presence(of: [Int]([])).allowsEmpty(false).allowsNil(false).validate())
        XCTAssertThrowsError(try Presence(of: [Int?]([])).allowsEmpty(false).validate())
        XCTAssertThrowsError(try Presence(of: [Int?]([])).allowsEmpty(false).allowsNil().validate())
        XCTAssertThrowsError(try Presence(of: [Int?]([])).allowsEmpty(false).allowsNil(false).validate())
    }
}
