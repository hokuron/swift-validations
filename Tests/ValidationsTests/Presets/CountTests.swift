import Testing
@testable import Validations

@Suite
struct CountTests {
    @Test
    func boundaryLower() {
        let value = "12345"
        #expect(throws: ValidationError.self) { try Count(of: value, within: 6...).validate() }
        #expect(throws: Never.self) { try Count(of: value, within: 5...).validate() }
    }

    @Test
    func boundaryUpper() {
        let value = "12345"
        #expect(throws: ValidationError.self) { try Count(of: value, within: ...4).validate() }
        #expect(throws: Never.self) { try Count(of: value, within: ...5).validate() }
    }

    @Test
    func boundaryExact() {
        let value = "12345"
        #expect(throws: ValidationError.self) { try Count(of: value, exact: 6).validate() }
        #expect(throws: Never.self) { try Count(of: value, exact: 5).validate() }
    }

    @Test
    func nilDisallowed() {
        #expect(throws: ValidationError.self) { try Count(of: String?.none, within: 0...).validate() }
        #expect(throws: ValidationError.self) { try Count(of: String?.none, exact: 0).validate() }
        #expect(throws: ValidationError.self) { try Count(of: [Int]?.none, within: 0...).validate() }
        #expect(throws: ValidationError.self) { try Count(of: [Int]?.none, within: 0...).validate() }
        #expect(throws: ValidationError.self) { try Count(of: [Int?]?.none, exact: 0).validate() }
        #expect(throws: ValidationError.self) { try Count(of: [Int?]?.none, exact: 0).validate() }
    }

    @Test
    func nilAllowed() {
        #expect(throws: Never.self) { try Count(of: String?.none, within: 0...).allowsNil().validate() }
        #expect(throws: Never.self) { try Count(of: String?.none, exact: 0).allowsNil().validate() }
        #expect(throws: Never.self) { try Count(of: [Int]?.none, within: 0...).allowsNil().validate() }
        #expect(throws: Never.self) { try Count(of: [Int]?.none, within: 0...).allowsNil().validate() }
        #expect(throws: Never.self) { try Count(of: [Int?]?.none, exact: 0).allowsNil().validate() }
        #expect(throws: Never.self) { try Count(of: [Int?]?.none, exact: 0).allowsNil().validate() }
    }

    @Test
    func empty() {
        #expect(throws: Never.self) { try Count(of: "", within: 0...).validate() }
        #expect(throws: Never.self) { try Count(of: "", exact: 0).validate() }
        #expect(throws: Never.self) { try Count(of: [Int](), within: 0...).validate() }
        #expect(throws: Never.self) { try Count(of: [Int](), exact: 0).validate() }
        #expect(throws: Never.self) { try Count(of: [Int?](), within: 0...).validate() }
        #expect(throws: Never.self) { try Count(of: [Int?](), exact: 0).validate() }
        #expect(throws: Never.self) { try Count(of: [Int]?([]), within: 0...).validate() }
        #expect(throws: Never.self) { try Count(of: [Int]?([]), exact: 0).validate() }
        #expect(throws: Never.self) { try Count(of: [Int?]?([]), within: 0...).validate() }
        #expect(throws: Never.self) { try Count(of: [Int?]?([]), exact: 0).validate() }
    }
}
