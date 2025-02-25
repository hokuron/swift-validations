import Testing
import XCTest
@testable import Validations

@Suite
struct InclusionTests {
    private enum Test {
        case a, b, c
    }

    @Test
    @MainActor
    func singleValue() throws {
        #expect(throws: Never.self) { try Inclusion(of: Test.a, in: [.a, .c]).validate() }
        #expect(throws: ValidationError.self) { try Inclusion(of: Test.a, in: [.b, .c]).validate() }

        XCTContext.runActivity(named: "nil value") { _ in
            #expect(throws: ValidationError.self) { try Inclusion(of: Test?.none, in: [.b, .c]).validate() }
            #expect(throws: Never.self) { try Inclusion(of: Test?.none, in: [.b, .c]).allowsNil().validate() }
        }
    }

    @Test
    @MainActor
    func multipleValues() throws {
        #expect(throws: Never.self) { try Inclusion(of: [Test.a, .b], in: [.a, .b, .c]).validate() }
        #expect(throws: ValidationError.self) { try Inclusion(of: [Test.a, .b], in: [.a, .c]).validate() }

        XCTContext.runActivity(named: "nil value") { _ in
            #expect(throws: ValidationError.self) { try Inclusion(of: [Test]?.none, in: [.a, .c]).validate() }
            #expect(throws: Never.self) { try Inclusion(of: [Test]?.none, in: [.a, .c]).allowsNil().validate() }
            #expect(throws: Never.self) { try Inclusion(of: [Test]?.none, in: [.a, .c]).allowsNil().allowsEmpty().validate() }
        }

        XCTContext.runActivity(named: "empty value") { _ in
            #expect(throws: ValidationError.self) { try Inclusion(of: [], in: [Test.a, .c]).validate() }
            #expect(throws: Never.self) { try Inclusion(of: [], in: [Test.a, .c]).allowsEmpty().validate() }
            #expect(throws: Never.self) { try Inclusion(of: [], in: [Test.a, .c]).allowsEmpty().allowsNil().validate() }
        }
    }

    @Test
    @MainActor
    func string() throws {
        #expect(throws: Never.self) { try Inclusion(of: "S", in: "Swift").validate() }
        #expect(throws: ValidationError.self) { try Inclusion(of: "s", in: "Swift").validate() }
        #expect(throws: Never.self) { try Inclusion(of: "if", in: "Swift").validate() }
        #expect(throws: ValidationError.self) { try Inclusion(of: "St", in: "Swift").validate() }
        #expect(throws: ValidationError.self) { try Inclusion(of: "ABC", in: "Swift").validate() }

        XCTContext.runActivity(named: "nil value") { _ in
            #expect(throws: ValidationError.self) { try Inclusion(of: nil, in: "Swift").validate() }
            #expect(throws: Never.self) { try Inclusion(of: nil, in: "Swift").allowsNil().validate() }
            #expect(throws: Never.self) { try Inclusion(of: String?.none, in: "Swift").allowsNil().allowsEmpty().validate() }
        }

        XCTContext.runActivity(named: "empty value") { _ in
            #expect(throws: ValidationError.self) { try Inclusion(of: "", in: "Swift").validate() }
            #expect(throws: Never.self) { try Inclusion(of: "", in: "Swift").allowsEmpty().validate() }
            #expect(throws: Never.self) { try Inclusion(of: "", in: "Swift").allowsEmpty().allowsNil().validate() }
        }
    }

    @Test
    @MainActor
    func singleValueInRange() throws {
        #expect(throws: Never.self) { try Inclusion(of: 5, in: 4...).validate() }
        #expect(throws: ValidationError.self) { try Inclusion(of: 5, in: ...4).validate() }

        XCTContext.runActivity(named: "nil value") { _ in
            #expect(throws: ValidationError.self) { try Inclusion(of: nil, in: ...4).validate() }
            #expect(throws: Never.self) { try Inclusion(of: nil, in: ...4).allowsNil().validate() }
        }
    }

    @Test
    @MainActor
    func multipleValueInRange() throws {
        #expect(throws: Never.self) { try Inclusion(of: [2, 5], in: 2...).validate() }
        #expect(throws: ValidationError.self) { try Inclusion(of: [2, 5], in: 3...).validate() }

        XCTContext.runActivity(named: "nil value") { _ in
            #expect(throws: ValidationError.self) { try Inclusion(of: [Int]?.none, in: 0...).validate() }
            #expect(throws: Never.self) { try Inclusion(of: [Int]?.none, in: 0...).allowsNil().validate() }
            #expect(throws: Never.self) { try Inclusion(of: [Int]?.none, in: 0...).allowsNil().allowsEmpty().validate() }
        }

        XCTContext.runActivity(named: "empty value") { _ in
            #expect(throws: ValidationError.self) { try Inclusion(of: [], in: 0...).validate() }
            #expect(throws: Never.self) { try Inclusion(of: [], in: 0...).allowsEmpty().validate() }
            #expect(throws: Never.self) { try Inclusion(of: [], in: 0...).allowsEmpty().allowsNil().validate() }
        }
    }
}
