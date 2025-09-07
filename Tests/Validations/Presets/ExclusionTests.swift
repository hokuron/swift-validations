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
        #expect(throws: ValidationError.self) { try Exclusion(of: Test.a, in: [.a, .c]).validate() }
        #expect(throws: Never.self) { try Exclusion(of: Test.a, in: [.b, .c]).validate() }

        XCTContext.runActivity(named: "nil value") { _ in
            #expect(throws: ValidationError.self) { try Exclusion(of: Test?.none, in: [.b, .c]).validate() }
            #expect(throws: Never.self) { try Exclusion(of: Test?.none, in: [.b, .c]).allowsNil().validate() }
        }
    }

    @Test
    @MainActor
    func multipleValues() throws {
        #expect(throws: ValidationError.self) { try Exclusion(of: [Test.a, .b], in: [.a, .b, .c]).validate() }
        #expect(throws: Never.self) { try Exclusion(of: [Test.a, .b], in: [.a, .c]).validate() }

        XCTContext.runActivity(named: "nil value") { _ in
            #expect(throws: ValidationError.self) { try Exclusion(of: [Test]?.none, in: [.a, .c]).validate() }
            #expect(throws: Never.self) { try Exclusion(of: [Test]?.none, in: [.a, .c]).allowsNil().validate() }
            #expect(throws: Never.self) { try Exclusion(of: [Test]?.none, in: [.a, .c]).allowsNil().allowsEmpty().validate() }
        }

        XCTContext.runActivity(named: "empty value") { _ in
            #expect(throws: ValidationError.self) { try Exclusion(of: [], in: [Test.a, .c]).validate() }
            #expect(throws: Never.self) { try Exclusion(of: [], in: [Test.a, .c]).allowsEmpty().validate() }
            #expect(throws: Never.self) { try Exclusion(of: [], in: [Test.a, .c]).allowsEmpty().allowsNil().validate() }
        }
    }

    @Test
    @MainActor
    func string() throws {
        #expect(throws: ValidationError.self) { try Exclusion(of: "S", in: "Swift").validate() }
        #expect(throws: Never.self) { try Exclusion(of: "s", in: "Swift").validate() }
        #expect(throws: ValidationError.self) { try Exclusion(of: "if", in: "Swift").validate() }
        #expect(throws: Never.self) { try Exclusion(of: "St", in: "Swift").validate() }
        #expect(throws: Never.self) { try Exclusion(of: "ABC", in: "Swift").validate() }

        XCTContext.runActivity(named: "nil value") { _ in
            #expect(throws: ValidationError.self) { try Exclusion(of: nil, in: "Swift").validate() }
            #expect(throws: Never.self) { try Exclusion(of: nil, in: "Swift").allowsNil().validate() }
            #expect(throws: Never.self) { try Exclusion(of: String?.none, in: "Swift").allowsNil().allowsEmpty().validate() }
        }

        XCTContext.runActivity(named: "empty value") { _ in
            #expect(throws: ValidationError.self) { try Exclusion(of: "", in: "Swift").validate() }
            #expect(throws: Never.self) { try Exclusion(of: "", in: "Swift").allowsEmpty().validate() }
            #expect(throws: Never.self) { try Exclusion(of: "", in: "Swift").allowsEmpty().allowsNil().validate() }
        }
    }

    @Test
    @MainActor
    func singleValueInRange() throws {
        #expect(throws: ValidationError.self) { try Exclusion(of: 5, in: 4...).validate() }
        #expect(throws: ValidationError.self) { try Exclusion(of: 5, in: 4...5).validate() }
        #expect(throws: Never.self) { try Exclusion(of: 5, in: ...4).validate() }
        #expect(throws: Never.self) { try Exclusion(of: 5, in: 0..<5).validate() }

        XCTContext.runActivity(named: "nil value") { _ in
            #expect(throws: ValidationError.self) { try Exclusion(of: nil, in: ...4).validate() }
            #expect(throws: ValidationError.self) { try Exclusion(of: nil, in: 0...4).validate() }
            #expect(throws: Never.self) { try Exclusion(of: nil, in: ...4).allowsNil().validate() }
            #expect(throws: Never.self) { try Exclusion(of: nil, in: 0..<5).allowsNil().validate() }
        }
    }

    @Test
    @MainActor
    func multipleValueInRange() throws {
        #expect(throws: ValidationError.self) { try Exclusion(of: [2, 5], in: 2...).validate() }
        #expect(throws: ValidationError.self) { try Exclusion(of: [2, 5], in: 2...5).validate() }
        #expect(throws: Never.self) { try Exclusion(of: [2, 5], in: 3...).validate() }
        #expect(throws: Never.self) { try Exclusion(of: [2, 5], in: 2..<5).validate() }

        XCTContext.runActivity(named: "nil value") { _ in
            #expect(throws: ValidationError.self) { try Exclusion(of: [Int]?.none, in: 0...).validate() }
            #expect(throws: ValidationError.self) { try Exclusion(of: [Int]?.none, in: 0...10).validate() }
            #expect(throws: Never.self) { try Exclusion(of: [Int]?.none, in: ..<10).allowsNil().validate() }
            #expect(throws: Never.self) { try Exclusion(of: [Int]?.none, in: 0..<10).allowsNil().validate() }
            #expect(throws: Never.self) { try Exclusion(of: [Int]?.none, in: ...4).allowsNil().allowsEmpty().validate() }
            #expect(throws: Never.self) { try Exclusion(of: [Int]?.none, in: 0...4).allowsNil().allowsEmpty().validate() }
        }

        XCTContext.runActivity(named: "empty value") { _ in
            #expect(throws: ValidationError.self) { try Exclusion(of: [], in: 0...).validate() }
            #expect(throws: ValidationError.self) { try Exclusion(of: [], in: 0...10).validate() }
            #expect(throws: Never.self) { try Exclusion(of: [], in: 0...).allowsEmpty().validate() }
            #expect(throws: Never.self) { try Exclusion(of: [], in: 0...10).allowsEmpty().validate() }
            #expect(throws: Never.self) { try Exclusion(of: [], in: 0...).allowsEmpty().allowsNil().validate() }
            #expect(throws: Never.self) { try Exclusion(of: [], in: 0..<11).allowsEmpty().allowsNil().validate() }
        }
    }
}
