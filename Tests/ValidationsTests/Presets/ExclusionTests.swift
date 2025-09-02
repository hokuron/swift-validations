import Testing
import XCTest
@testable import Validations

@Suite
struct ExclusionTests {
    private enum Test {
        case a, b, c
    }

    @Test
    @MainActor
    func singleValue() throws {
        #expect(throws: ValidationError.self) { try Exclusion(of: Test.a, from: [.a, .c]).validate() }
        #expect(throws: Never.self) { try Exclusion(of: Test.a, from: [.b, .c]).validate() }

        XCTContext.runActivity(named: "nil value") { _ in
            #expect(throws: ValidationError.self) { try Exclusion(of: Test?.none, from: [.b, .c]).validate() }
            #expect(throws: Never.self) { try Exclusion(of: Test?.none, from: [.b, .c]).allowsNil().validate() }
        }
    }

    @Test
    @MainActor
    func multipleValues() throws {
        #expect(throws: ValidationError.self) { try Exclusion(of: [Test.a, .b], from: [.a, .b, .c]).validate() }
        #expect(throws: Never.self) { try Exclusion(of: [Test.a, .b], from: [.a, .c]).validate() }

        XCTContext.runActivity(named: "nil value") { _ in
            #expect(throws: ValidationError.self) { try Exclusion(of: [Test]?.none, from: [.a, .c]).validate() }
            #expect(throws: Never.self) { try Exclusion(of: [Test]?.none, from: [.a, .c]).allowsNil().validate() }
            #expect(throws: Never.self) { try Exclusion(of: [Test]?.none, from: [.a, .c]).allowsNil().allowsEmpty().validate() }
        }

        XCTContext.runActivity(named: "empty value") { _ in
            #expect(throws: ValidationError.self) { try Exclusion(of: [], from: [Test.a, .c]).validate() }
            #expect(throws: Never.self) { try Exclusion(of: [], from: [Test.a, .c]).allowsEmpty().validate() }
            #expect(throws: Never.self) { try Exclusion(of: [], from: [Test.a, .c]).allowsEmpty().allowsNil().validate() }
        }
    }

    @Test
    @MainActor
    func string() throws {
        #expect(throws: ValidationError.self) { try Exclusion(of: "S", from: "Swift").validate() }
        #expect(throws: Never.self) { try Exclusion(of: "s", from: "Swift").validate() }
        #expect(throws: ValidationError.self) { try Exclusion(of: "if", from: "Swift").validate() }
        #expect(throws: Never.self) { try Exclusion(of: "St", from: "Swift").validate() }
        #expect(throws: Never.self) { try Exclusion(of: "ABC", from: "Swift").validate() }

        XCTContext.runActivity(named: "nil value") { _ in
            #expect(throws: ValidationError.self) { try Exclusion(of: nil, from: "Swift").validate() }
            #expect(throws: Never.self) { try Exclusion(of: nil, from: "Swift").allowsNil().validate() }
            #expect(throws: Never.self) { try Exclusion(of: String?.none, from: "Swift").allowsNil().allowsEmpty().validate() }
        }

        XCTContext.runActivity(named: "empty value") { _ in
            #expect(throws: ValidationError.self) { try Exclusion(of: "", from: "Swift").validate() }
            #expect(throws: Never.self) { try Exclusion(of: "", from: "Swift").allowsEmpty().validate() }
            #expect(throws: Never.self) { try Exclusion(of: "", from: "Swift").allowsEmpty().allowsNil().validate() }
        }
    }

    @Test
    @MainActor
    func singleValueInRange() throws {
        #expect(throws: ValidationError.self) { try Exclusion(of: 5, from: 4...).validate() }
        #expect(throws: ValidationError.self) { try Exclusion(of: 5, from: 4...5).validate() }
        #expect(throws: Never.self) { try Exclusion(of: 5, from: ...4).validate() }
        #expect(throws: Never.self) { try Exclusion(of: 5, from: 0..<5).validate() }

        XCTContext.runActivity(named: "nil value") { _ in
            #expect(throws: ValidationError.self) { try Exclusion(of: nil, from: ...4).validate() }
            #expect(throws: ValidationError.self) { try Exclusion(of: nil, from: 0...4).validate() }
            #expect(throws: Never.self) { try Exclusion(of: nil, from: ...4).allowsNil().validate() }
            #expect(throws: Never.self) { try Exclusion(of: nil, from: 0..<5).allowsNil().validate() }
        }
    }

    @Test
    @MainActor
    func multipleValueInRange() throws {
        #expect(throws: ValidationError.self) { try Exclusion(of: [2, 5], from: 2...).validate() }
        #expect(throws: ValidationError.self) { try Exclusion(of: [2, 5], from: 2...5).validate() }
        #expect(throws: Never.self) { try Exclusion(of: [2, 5], from: 3...).validate() }
        #expect(throws: Never.self) { try Exclusion(of: [2, 5], from: 2..<5).validate() }

        XCTContext.runActivity(named: "nil value") { _ in
            #expect(throws: ValidationError.self) { try Exclusion(of: [Int]?.none, from: 0...).validate() }
            #expect(throws: ValidationError.self) { try Exclusion(of: [Int]?.none, from: 0...10).validate() }
            #expect(throws: Never.self) { try Exclusion(of: [Int]?.none, from: ..<10).allowsNil().validate() }
            #expect(throws: Never.self) { try Exclusion(of: [Int]?.none, from: 0..<10).allowsNil().validate() }
            #expect(throws: Never.self) { try Exclusion(of: [Int]?.none, from: ...4).allowsNil().allowsEmpty().validate() }
            #expect(throws: Never.self) { try Exclusion(of: [Int]?.none, from: 0...4).allowsNil().allowsEmpty().validate() }
        }

        XCTContext.runActivity(named: "empty value") { _ in
            #expect(throws: ValidationError.self) { try Exclusion(of: [], from: 0...).validate() }
            #expect(throws: ValidationError.self) { try Exclusion(of: [], from: 0...10).validate() }
            #expect(throws: Never.self) { try Exclusion(of: [], from: 0...).allowsEmpty().validate() }
            #expect(throws: Never.self) { try Exclusion(of: [], from: 0...10).allowsEmpty().validate() }
            #expect(throws: Never.self) { try Exclusion(of: [], from: 0...).allowsEmpty().allowsNil().validate() }
            #expect(throws: Never.self) { try Exclusion(of: [], from: 0..<11).allowsEmpty().allowsNil().validate() }
        }
    }
}
