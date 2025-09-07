# Swift Validations

A library for building validations by defining rules in a declarative manner.

## Overview

This library offers several validators inspired by Ruby on Rails' Active Record. These validators provide general validation rules. If you need custom validators, you can create them by conforming to the `Validator` protocol.  
When these validators fail, they throw errors that describe why and where the failure occurred.

Built-in and custom validators can be incorporated into types like models using a declarative syntax to provide validation capabilities.


```swift
import Validations
import RegexBuilder

struct User: Validator {
    var name: String
    var age: UInt
    var email: String?
    var bio: String?
    var address: Address // Conforming Validator protocol.
    var password: String
    var confirmedPassword: String

    var validation: some Validator {
        Presence(of: name)
        Comparison(of: age, .greaterThan(16))

        Format(of: email) {
            ZeroOrMore {
                OneOrMore(.word)
                "."
            }
            OneOrMore(.word)
            "@"
            OneOrMore(.word)
            OneOrMore {
                "."
                OneOrMore(.word)
            }
        }
        .allowsNil()

        Presence(of: bio)
            .allowsNil()
            .allowsEmpty()

        address

        Presence(of: password)
            .allowsEmpty()

        Confirmation(of: confirmedPassword, matching: password)
    }
}

let user = User(...)
do {
    try user.validate()
} catch {
    //...
}
```

Additionally, each validator can be used independently.

```swift
import Validations

do {
    try Count(interests, within: 3...).validate()
} catch {
    //...
}
```

## Built-in Validators

- [`Presence` / `Absence`](#presence--absence)
- [`Confirmation`](#Confirmation)
- [`Format`](#Format)
- [`Comparison`](#Comparison)
- [`Exclusion` / `Inclusion`](#inclusion--exclusion)
- [`Count`](#Count)
- [`AnyOf`](#AnyOf)
- [`Validate`](#Validate)

### `Presence` / `Absence`

These validators check if a value is `nil` or, in the case of collections, empty.  
`Presence` fails if the value is `nil` or empty. `Absence` fails if the value is **not** `nil` or **not** empty.

```swift
Presence(of: name)
Presence(of: email)
Absence(of: cancellationDate)
```

### `Confirmation`

This validator checks if two values match exactly. It's typically used for fields like email confirmation and password confirmation.

```swift
Confirmation(of: confirmedPassword, matching: password)
```

In this example, if the `confirmedPassword` is an `Optional<String>` and its value is an empty string or `nil`, the validation is skipped by default.  
To treat these cases as validation failures, use the `presence()` modifier with `.required`.

```swift
Confirmation(of: confirmedPassword, matching: password)
    .presence(.required)
```

The `.required` modifier can be configured to skip validation only if the value is `nil` and/or only if it is an empty string.

```swift
Confirmation(of: confirmedPassword, matching: password)
    .presence(.required(allowsNil: true))
    
// or

Confirmation(of: confirmedPassword, matching: password)
    .presence(.required(allowsEmpty: true))
```

> [!NOTE]  
> For those familiar with Active Model, note that the validation target here is `confirmedPassword`, not `password`.   
> The `presence(.required)` modifier eliminates the need to separately declare the `Presence` validation for `confirmedPassword`.    

### `Format`

This validator checks if a value matches a specified regular expression.

```swift
Format(of: productCode, with: #/\A[a-zA-Z\d]+\z/#)
// or
Format(of: productCode, with: /\A[a-zA-Z\d]+\z/)
```

It also supports `RegexBuilder`.

```swift
import RegexBuilder

Format(of: productCode) {
    Anchor.startOfSubject
    OneOrMore {
        CharacterClass(
            ("a"..."z"),
            ("A"..."Z"),
            .digit
        )
    }
    Anchor.endOfSubject
}

let predefinedRegex = Regex {
    Anchor.startOfSubject
    OneOrMore {
        CharacterClass(
            ("a"..."z"),
            ("A"..."Z"),
            .digit
        )
    }
    Anchor.endOfSubject
}
Format(of: productCode, with: predefinedRegex)
```

### `Comparison`

This validator checks the comparison between two values.

```swift
Comparison(of: startDate, .lessThanOrEqualTo(endDate))
```

The second argument specifies the comparison operator. 

The value to be validated generally needs to conform to Comparable.  
Although collections like Array do not conform to Comparable, if their elements do, they can be validated using this validator via the [`lexicographicallyPrecedes(_:)`](https://developer.apple.com/documentation/swift/sequence/lexicographicallyprecedes(_:)) method.

```swift
let currentVersion = [5, 10, 0]
let requiredVersion = [6, 0, 0]
Comparison(of: currentVersion, .greaterThanOrEqualTo(requiredVersion)).isValid // => false
```

### `Inclusion` / `Exclusion`

These validators check for inclusion or exclusion within a set of values.  
`Inclusion` fails if the value is not included in the specified set, while `Exclusion` fails if it is included.

```swift
Inclusion(of: articleStatus, in: [.published, .secret])
Exclusion(of: permission, from: [.reader, .editor])
```

They also support range validations.

```swift
Inclusion(of: age, in: 16...)
Exclusion(of: age, from: ..<16)
```

### `Count`

This validator checks if the count of a collection, including `String`, falls within a specified range.

```swift
Count(of: interests, within: 3...)
Count(of: username, within: 1..<20)
Count(of: productCode, exact: 8)
```

### `AnyOf`

This validator checks if any of the values provided in the first argument pass the validation specified in the second argument.

```swift
import RegexBuilder
AnyOf([email1, email2, email3]) {
    Format(of: $0) {
        ZeroOrMore {
            OneOrMore(.word)
            "."
        }
        OneOrMore(.word)
        "@"
        OneOrMore(.word)
        OneOrMore {
            "."
            OneOrMore(.word)
        }
    }
}

AnyOf([givenName, middleName, familyName], pass: Presence.init)
```

### `Validate`

This validator itself does not perform any validation but executes the validation provided in the initializer.
There are three initializers:

- Accepts a closure that throws an error (`() throws -> Void`).
- Accepts a `ValidatorBuilder` closure.
- Type-erases a validator.

Using this validator, you can build custom validators by combining existing ones without implementing a new validator conforming to the `Validator` protocol.

## Presence Modifiers

Most built-in validators can be modified with `allowsNil()` and `allowsEmpty()` modifiers.

- `allowsNil`: Skips validation if the value is `Optional` and `nil`.
- `allowsEmpty`: Skips validation if the value is a collection and empty.

These modifiers take a `Bool` argument, allowing for conditional skipping of validations.

```swift
Comparison(of: age, .greaterThan(16))
    .allowsNil(!isLoggedIn)
```

You can provide similar functionality to custom validators conforming to the `Validator` protocol by conforming to the `PresenceValidatable` protocol.

```swift
struct CustomValidator<Value>: Validator, PresenceValidatable {
    var value: Value?
    var presenceOption: PresenceOption = .required

    func validate() throws {
        guard let presenceValue = try validatePresence() else {
            return
        }

        // Validate with `presenceValue`
    }
}
```

## Validation Errors

When validation fails, either a `ValidationError` or `ValidationErrors` is thrown. These errors correspond to whether the validation failure is singular or multiple, respectively.   
For example, when using a validator independently (excluding `Validate`), a `ValidationError` is thrown upon validation failure.

### `ValidationError`

`ValidationError` contains information about the validator that failed and the reason for the failure.   
By default, information about the validator that failed is not retained, so if you want to identify the failed validator, you need to set the error key.

```swift
struct User: Validator {
    var name: String
    // ...

    var validation: some Validator {
        Presence(name)
            .errorKey(\Self.name)
        // ...
    }
}
```

In this example, the error key is set as a `KeyPath`, but any `Hashable` type, such as `String`, can be used.

> [!NOTE]  
> In the current version, you need to explicitly set error keys for each validator to identify the failure location. Future versions may automatically set these error keys.  

You can also set the same error key for multiple validators. This is useful when incorporating validators into models.

```swift
Validate {
    Presence(username)
    Count(bio, within: 0...1000)
}
.errorKey("Profile")
```

### `ValidationErrors`

`ValidationErrors` is a collection of `ValidationError` elements.  
Besides iterating over `ValidationError`, you can retrieve arrays of `ValidationError` or failure reasons corresponding to a specific error key.

```swift
user.validationErrors?.reasons(for: \User.name)
```
