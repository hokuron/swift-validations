import XCTest
@testable import Validations

final class PresenceTests: XCTestCase {
    func testNotCollectionValue() {
        XCTAssertNoThrow(try Presence(2).validate())
        XCTAssertThrowsError(try Presence(Int?.none).validate())
    }

    func testNilNotCollectionValue() {
        XCTAssertNoThrow(try Presence(Int?.none).allowsNil().validate())
        XCTAssertThrowsError(try Presence(Int?.none).allowsNil(false).validate())
    }

    func testString() {
        XCTAssertNoThrow(try Presence("123").validate())
        XCTAssertThrowsError(try Presence(String?.none).validate())
        XCTAssertThrowsError(try Presence(String?("")).validate())
    }

    func testNilString() {
        XCTAssertNoThrow(try Presence(String?.none).allowsNil().validate())
        XCTAssertNoThrow(try Presence(String?.none).allowsNil().allowsEmpty().validate())
        XCTAssertNoThrow(try Presence(String?.none).allowsNil().allowsEmpty(false).validate())
        XCTAssertThrowsError(try Presence(String?.none).allowsNil(false).validate())
        XCTAssertThrowsError(try Presence(String?.none).allowsNil(false).allowsEmpty().validate())
        XCTAssertThrowsError(try Presence(String?.none).allowsNil(false).allowsEmpty(false).validate())
    }

    func testEmptyString() {
        XCTAssertNoThrow(try Presence("").allowsEmpty().validate())
        XCTAssertNoThrow(try Presence("").allowsEmpty().allowsNil().validate())
        XCTAssertNoThrow(try Presence("").allowsEmpty().allowsNil(false).validate())
        XCTAssertNoThrow(try Presence(String?("")).allowsEmpty().validate())
        XCTAssertNoThrow(try Presence(String?("")).allowsEmpty().allowsNil().validate())
        XCTAssertNoThrow(try Presence(String?("")).allowsEmpty().allowsNil(false).validate())
        XCTAssertThrowsError(try Presence("").allowsEmpty(false).validate())
        XCTAssertThrowsError(try Presence("").allowsEmpty(false).allowsNil().validate())
        XCTAssertThrowsError(try Presence("").allowsEmpty(false).allowsNil(false).validate())
        XCTAssertThrowsError(try Presence(String?("")).allowsEmpty(false).validate())
        XCTAssertThrowsError(try Presence(String?("")).allowsEmpty(false).allowsNil().validate())
        XCTAssertThrowsError(try Presence(String?("")).allowsEmpty(false).allowsNil(false).validate())
    }

    func testArray() {
        XCTAssertNoThrow(try Presence([1, 2, 3]).validate())
        XCTAssertNoThrow(try Presence([1, nil, 3]).validate())
        XCTAssertThrowsError(try Presence([Int]?.none).validate())
        XCTAssertThrowsError(try Presence([Int]?([])).validate())
    }

    func testArrayWithNilElements() {
        XCTAssertNoThrow(try Presence([Int?]([nil, nil, nil])).validate())
        XCTAssertNoThrow(try Presence([Int?]([nil, nil, nil])).allowsNil().allowsEmpty().validate())
        XCTAssertNoThrow(try Presence([Int?]([nil, nil, nil])).allowsNil(false).allowsEmpty().validate())
        XCTAssertNoThrow(try Presence([Int?]([nil, nil, nil])).allowsNil().allowsEmpty(false).validate())
        XCTAssertNoThrow(try Presence([Int?]([nil, nil, nil])).allowsNil(false).allowsEmpty(false).validate())
    }

    func testNilArray() {
        XCTAssertNoThrow(try Presence([Int]?.none).allowsNil().validate())
        XCTAssertNoThrow(try Presence([Int]?.none).allowsNil().allowsEmpty().validate())
        XCTAssertNoThrow(try Presence([Int]?.none).allowsNil().allowsEmpty(false).validate())
        XCTAssertThrowsError(try Presence([Int]?.none).allowsNil(false).validate())
        XCTAssertThrowsError(try Presence([Int]?.none).allowsNil(false).allowsEmpty().validate())
        XCTAssertThrowsError(try Presence([Int]?.none).allowsNil(false).allowsEmpty(false).validate())
    }

    func testEmptyArray() {
        XCTAssertNoThrow(try Presence([Int]([])).allowsEmpty().validate())
        XCTAssertNoThrow(try Presence([Int]([])).allowsEmpty().allowsNil().validate())
        XCTAssertNoThrow(try Presence([Int]([])).allowsEmpty().allowsNil(false).validate())
        XCTAssertNoThrow(try Presence([Int?]([])).allowsEmpty().validate())
        XCTAssertNoThrow(try Presence([Int?]([])).allowsEmpty().allowsNil().validate())
        XCTAssertNoThrow(try Presence([Int?]([])).allowsEmpty().allowsNil(false).validate())
        XCTAssertThrowsError(try Presence([Int]([])).allowsEmpty(false).validate())
        XCTAssertThrowsError(try Presence([Int]([])).allowsEmpty(false).allowsNil().validate())
        XCTAssertThrowsError(try Presence([Int]([])).allowsEmpty(false).allowsNil(false).validate())
        XCTAssertThrowsError(try Presence([Int?]([])).allowsEmpty(false).validate())
        XCTAssertThrowsError(try Presence([Int?]([])).allowsEmpty(false).allowsNil().validate())
        XCTAssertThrowsError(try Presence([Int?]([])).allowsEmpty(false).allowsNil(false).validate())
    }
}
