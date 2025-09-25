import Testing
import SwiftUI
@testable import Validations

@Suite
struct ValidatorBuilderTests {
    @Test
    func mergeValidations() {
        struct SUT: Validator {
            var name: String?
            var email: String?
            var confirmedEmail: String?
            var age: String?
            var agreed: Bool
            
            var validation: some Validator {
                Presence(of: name)
                Presence(of: email)
                if let email {
                    Confirmation(of: confirmedEmail, matching: email)
                } else {
                    Inclusion(of: agreed, in: [false])
                }
                
                Inclusion(of: agreed, in: [true])
                
                for str in [name, email] {
                    Count(of: str, within: 1...)
                }
            }
        }
        #expect(throws: Never.self) { try SUT(name: "A B", email: "mail@example.com", agreed: true).validate() }
        #expect(SUT(name: "", email: "mail@example.com", agreed: false).validationErrors?.reasons == [.empty, .inclusion, .count])
    }
    
    // MARK: - Compile time tests.
    
    enum Test {
        struct Empty: Validator {
            var validation: some Validator {
                Validate {}
            }
        }
        
        @available(iOS, introduced: 9999)
        @available(macOS, introduced: 9999)
        @available(tvOS, introduced: 9999)
        @available(visionOS, introduced: 9999)
        @available(watchOS, introduced: 9999)
        struct Unavailable: Validator {
            var validation: some Validator {
                Empty()
            }
        }
    }
    
    @Test
    func singleBlock() {
        struct SUT: Validator {
            var validation: some Validator {
                Test.Empty()
            }
        }
        #expect(throws: Never.self) { try SUT().validate() }
    }
    
    @Test
    func limitedAvailability() {
        struct SUT: Validator {
            var validation: some Validator {
                Test.Empty()
                if #available(iOS 9999, macOS 9999, tvOS 9999, visionOS 9999, watchOS 9999, *) {
                    Test.Unavailable()
                } else if #available(iOS 8888, macOS 8888, tvOS 8888, visionOS 8888, watchOS 8888, *) {
                    Test.Empty()
                }
                Test.Empty()
            }
        }
        #expect(throws: Never.self) { try SUT().validate() }
    }
    
    @Test
    func either() {
        struct SUT: Validator {
            var validation: some Validator {
                if Bool.random() {
                    Test.Empty()
                } else {
                    Test.Empty()
                }
            }
        }
        #expect(throws: Never.self) { try SUT().validate() }
    }
    
    @Test
    func optional() {
        struct SUT: Validator {
            var validation: some Validator {
                if Bool.random() {
                    Test.Empty()
                }
            }
        }
        #expect(throws: Never.self) { try SUT().validate() }
    }
    
    @Test
    func array() {
        struct SUT: Validator {
            var validation: some Validator {
                for n in [1, 2, 3] {
                    Presence(of: n)
                }
            }
        }
        #expect(throws: Never.self) { try SUT().validate() }
    }
}
