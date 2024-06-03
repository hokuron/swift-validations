import XCTest
@testable import Validations

final class AbsenceTests: XCTestCase {
    func testNotCollection() {
        XCTAssertNoThrow(try Absence(of: Int?.none).validate())
        XCTAssertThrowsError(try Absence(of: 2).validate())
    }

    func testString() {
        XCTAssertThrowsError(try Absence(of: "123").validate())
        XCTAssertNoThrow(try Absence(of: "").validate())
        XCTAssertNoThrow(try Absence(of: String?.none).validate())
        XCTAssertThrowsError(try Absence(of: String?("123")).validate())
        XCTAssertNoThrow(try Absence(of: String?("")).validate())
    }

    func testArray() {
        XCTAssertNoThrow(try Absence(of: [Int]?.none).validate())
        XCTAssertNoThrow(try Absence(of: [Int]()).validate())
        XCTAssertNoThrow(try Absence(of: [Int?]()).validate())
        XCTAssertNoThrow(try Absence(of: [Int]?([])).validate())
        XCTAssertThrowsError(try Absence(of: [1, 2, 3]).validate())
        XCTAssertThrowsError(try Absence(of: [Int?]([1, nil, 3])).validate())
        XCTAssertThrowsError(try Absence(of: [Int?]([1, 2, 3])).validate())
        XCTAssertThrowsError(try Absence(of: [Int?]([nil, nil, nil])).validate())
    }
}
