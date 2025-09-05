import Testing
import XCTest
@testable import Validations

@Suite
struct CountTests {
    @Test
    @MainActor
    func boundary() {
        let value = "12345"
        XCTContext.runActivity(named: "lower") { _ in
            #expect(throws: ValidationError.self) { try Count(of: value, within: 6...).validate() }
            #expect(throws: Never.self) { try Count(of: value, within: 5...).validate() }
        }

        XCTContext.runActivity(named: "upper") { _ in
            #expect(throws: ValidationError.self) { try Count(of: value, within: ...4).validate() }
            #expect(throws: Never.self) { try Count(of: value, within: ...5).validate() }
        }

        XCTContext.runActivity(named: "exact") { _ in
            #expect(throws: ValidationError.self) { try Count(of: value, exact: 6).validate() }
            #expect(throws: Never.self) { try Count(of: value, exact: 5).validate() }
        }
    }

    @Test
    @MainActor
    func `nil`() {
        XCTContext.runActivity(named: "disallowed") { _ in
            #expect(throws: ValidationError.self) { try Count(of: String?.none, within: 0...).validate() }
            #expect(throws: ValidationError.self) { try Count(of: String?.none, exact: 0).validate() }
            #expect(throws: ValidationError.self) { try Count(of: [Int]?.none, within: 0...).validate() }
            #expect(throws: ValidationError.self) { try Count(of: [Int]?.none, within: 0...).validate() }
            #expect(throws: ValidationError.self) { try Count(of: [Int?]?.none, exact: 0).validate() }
            #expect(throws: ValidationError.self) { try Count(of: [Int?]?.none, exact: 0).validate() }
        }

        XCTContext.runActivity(named: "allowed") { _ in
            #expect(throws: Never.self) { try Count(of: String?.none, within: 0...).allowsNil().validate() }
            #expect(throws: Never.self) { try Count(of: String?.none, exact: 0).allowsNil().validate() }
            #expect(throws: Never.self) { try Count(of: [Int]?.none, within: 0...).allowsNil().validate() }
            #expect(throws: Never.self) { try Count(of: [Int]?.none, within: 0...).allowsNil().validate() }
            #expect(throws: Never.self) { try Count(of: [Int?]?.none, exact: 0).allowsNil().validate() }
            #expect(throws: Never.self) { try Count(of: [Int?]?.none, exact: 0).allowsNil().validate() }
        }
    }

    @Test
    func empty_allowed() {
        #expect(throws: Never.self) { try Count(of: "", within: 3...).validate() }
        #expect(throws: Never.self) { try Count(of: "", exact: 3).validate() }
        #expect(throws: Never.self) { try Count(of: [Int](), within: 3...).validate() }
        #expect(throws: Never.self) { try Count(of: [Int](), exact: 3).validate() }
        #expect(throws: Never.self) { try Count(of: [Int?](), within: 3...).validate() }
        #expect(throws: Never.self) { try Count(of: [Int?](), exact: 3).validate() }
        #expect(throws: Never.self) { try Count(of: [Int]?([]), within: 3...).validate() }
        #expect(throws: Never.self) { try Count(of: [Int]?([]), exact: 3).validate() }
        #expect(throws: Never.self) { try Count(of: [Int?]?([]), within: 3...).validate() }
        #expect(throws: Never.self) { try Count(of: [Int?]?([]), exact: 3).validate() }
    }

    @Test
    func empty_disallowed() {
        #expect(throws: ValidationError.self) { try Count(of: "", within: 0...).allowsEmpty(false).validate() }
        #expect(throws: ValidationError.self) { try Count(of: "", exact: 0).allowsEmpty(false).validate() }
        #expect(throws: ValidationError.self) { try Count(of: [Int](), within: 0...).allowsEmpty(false).validate() }
        #expect(throws: ValidationError.self) { try Count(of: [Int](), exact: 0).allowsEmpty(false).validate() }
        #expect(throws: ValidationError.self) { try Count(of: [Int?](), within: 0...).allowsEmpty(false).validate() }
        #expect(throws: ValidationError.self) { try Count(of: [Int?](), exact: 0).allowsEmpty(false).validate() }
        #expect(throws: ValidationError.self) { try Count(of: [Int]?([]), within: 0...).allowsEmpty(false).validate() }
        #expect(throws: ValidationError.self) { try Count(of: [Int]?([]), exact: 0).allowsEmpty(false).validate() }
        #expect(throws: ValidationError.self) { try Count(of: [Int?]?([]), within: 0...).allowsEmpty(false).validate() }
        #expect(throws: ValidationError.self) { try Count(of: [Int?]?([]), exact: 0).allowsEmpty(false).validate() }
    }
}
