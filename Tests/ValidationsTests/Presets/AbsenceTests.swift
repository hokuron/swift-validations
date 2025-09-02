import Testing
@testable import Validations

@Suite
struct AbsenceTests {
    @Test
    func notCollection() {
        #expect(throws: Never.self) { try Absence(of: Int?.none).validate() }
        #expect(throws: ValidationError.self) { try Absence(of: 2).validate() }
    }

    @Test
    func string() {
        #expect(throws: ValidationError.self) { try Absence(of: "123").validate() }
        #expect(throws: Never.self) { try Absence(of: "").validate() }
        #expect(throws: Never.self) { try Absence(of: String?.none).validate() }
        #expect(throws: ValidationError.self) { try Absence(of: String?("123")).validate() }
        #expect(throws: Never.self) { try Absence(of: String?("")).validate() }
    }

    @Test
    func array() {
        #expect(throws: Never.self) { try Absence(of: [Int]?.none).validate() }
        #expect(throws: Never.self) { try Absence(of: [Int]()).validate() }
        #expect(throws: Never.self) { try Absence(of: [Int?]()).validate() }
        #expect(throws: Never.self) { try Absence(of: [Int]?([])).validate() }
        #expect(throws: ValidationError.self) { try Absence(of: [1, 2, 3]).validate() }
        #expect(throws: ValidationError.self) { try Absence(of: [Int?]([1, nil, 3])).validate() }
        #expect(throws: ValidationError.self) { try Absence(of: [Int?]([1, 2, 3])).validate() }
        #expect(throws: ValidationError.self) { try Absence(of: [Int?]([nil, nil, nil])).validate() }
    }
}
