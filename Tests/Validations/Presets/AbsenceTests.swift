import XCTest
@testable import Validations

final class AbsenceTests: XCTestCase {
    func testNotCollection() {
        XCTAssertNoThrow(try Absence(Int?.none).validate())
        XCTAssertThrowsError(try Absence(2).validate())
    }

    func testString() {
        XCTAssertThrowsError(try Absence("123").validate())
        XCTAssertNoThrow(try Absence("").validate())
        XCTAssertNoThrow(try Absence(String?.none).validate())
        XCTAssertThrowsError(try Absence(String?("123")).validate())
        XCTAssertNoThrow(try Absence(String?("")).validate())
    }

    func testArray() {
        XCTAssertNoThrow(try Absence([Int]?.none).validate())
        XCTAssertNoThrow(try Absence([Int]()).validate())
        XCTAssertNoThrow(try Absence([Int?]()).validate())
        XCTAssertNoThrow(try Absence([Int]?([])).validate())
        XCTAssertThrowsError(try Absence([1, 2, 3]).validate())
        XCTAssertThrowsError(try Absence([Int?]([1, nil, 3])).validate())
        XCTAssertThrowsError(try Absence([Int?]([1, 2, 3])).validate())
        XCTAssertThrowsError(try Absence([Int?]([nil, nil, nil])).validate())
    }
}
