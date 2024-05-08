# Swift Validations

宣言的にルールを定義してバリデーションを構築するためのライブラリです。

## Overview

このライブラリーは、Ruby on RailsのActive Recordにインスパイアされたいくつかのバリデーターを用意しています。これらのバリデーターは、汎用的なバリデーションルールを提供します。  
もし、独自のバリデーターが必要になれば、`Validator` protocolに準拠することでカスタムバリデーターを作成することが可能です。  
これらのバリデーターの検証が失敗した際には、失敗理由やどこで失敗したかを表すエラーが投げられます。

ビルトインバリデーターや独自に実装したバリデーターは、宣言的な記述でモデルなどの型に組み込み、検証機能を提供することができます。

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
        Presence(name)
        Comparison(age, .greaterThan(16))

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

        Presence(bio)
            .allowsNil()
            .allowsEmpty()

        address

        Presence(password)
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

また、各バリデーターは個別に独立して利用することもできます。

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
- [`Validate`](#Validate)

### `Presence` / `Absence`

このバリデーターは、値が`nil`または、コレクションの場合は空かどうかを検証します。  
`Presence`は、`nil`または空の場合、検証に失敗します。`Absence`はその逆で、`nil`または空**でなければ**検証に失敗します。

```swift
Presence(name)
Presence(email)
Absence(cancellationDate)
```

### `Confirmation`

このバリデーターは、2つの値が完全一致するか検証します。メールアドレスやパスワードの確認フィールドの値が一致するかを検証することを想定しています。

```swift
Confirmation(of: confirmedPassword, matching: password)
```

この例では、`confirmedPassword`の型が`Optional<String>`とします。この値が空文字列または`nil`の場合、デフォルトでは検証はスキップされます。  
これらの値を検証の失敗として扱いたい場合は、`presence()` modifierに`.required`を指定します。

```swift
Confirmation(of: confirmedPassword, matching: password)
    .presence(.required)
```

`.required`には、空文字列の場合のみまたは、`nil`の場合のみスキップする、といったオプションを与えることもできます。

```swift
Confirmation(of: confirmedPassword, matching: password)
    .presence(.required(allowsNil: true))
    
// or

Confirmation(of: confirmedPassword, matching: password)
    .presence(.required(allowsEmpty: true))
```

> [!NOTE]  
> Active Modelをご存知の方は、検証の主体が`password`側ではなく、`confirmedPassword`側であることにご注意ください。    
> `presence(.required)` modifierを指定すれば、`confirmedPassword`の`Presence`の検証を別途宣言する必要はありません。

### `Format`

このバリデーターは、値が指定された正規表現と一致するか検証します。

```swift
Format(of: productCode, with: #/\A[a-zA-Z\d]+\z/#)
// or
Format(of: productCode, with: /\A[a-zA-Z\d]+\z/)
```

`RegexBuilder`にも対応しています。

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

このバリデーターは、2つの値の比較を検証します。

```swift
Comparison(statDate, .lessThanOrEqualTo(endDate))
```

第二引数に指定する値は、比較演算子と対応するものが用意されています。

検証する値は、基本的に`Comparable`に準拠する必要があります。  
ただし、`String`を除く`Array`などのコレクションは`Comparable`には準拠していませんが、要素が`Comparable`に準拠していれば検証することができます。  
この検証には、[`lexicographicallyPrecedes(_:)`](https://developer.apple.com/documentation/swift/array/lexicographicallyprecedes(_:))が用いられます。

```swift
let currentVersion = [5, 10, 0]
let requiredVersion = [6, 0, 0]
Comparison(currentVersion, .greaterThanOrEqualTo(requiredVersion)).isValid // => false
```

### `Inclusion` / `Exclusion`

このバリデーターは、値の包含関係を検証します。  
`Inclusion`では指定した値が含まれていなければ検証に失敗します。反対に`Exclusion`は、指定した値が含まれていれば検証に失敗します。

```swift
Inclusion(articleStatus, in: [.published, .secret])
Exclusion(permission, in: [.reader, .editor])
```

コレクションだけでなく範囲の検証も可能です。

```swift
Inclusion(age, in: 16...)
Exclusion(age, in: ..<16)
```

### `Count`

このバリデーターは、`String`を含むコレクションの数が指定した範囲内かどうかを検証します。

```swift
Count(interests, within: 3...)
Count(username, within: 1..<20)
Count(productCode, exact: 8)
```

### `Validate`

このバリデーターそのものは、何かを検証する機能は持っておらず、initに与えた検証を実行します。  
initは3種類用意されています。

- Errorを投げられるクロージャー (`() throws -> Void`)を受け取り
- `ValidatorBuilder`クロージャーを受け取る
- Type-erases a validator

このバリデーターは、基本的に[Overview](#Overview)で説明したモデルなどに組み込まない独立した利用が想定されます。  
既存のバリデーターを組み合わせて任意の新しいバリデーターを作ることもできます。

## Presence Modifiers

ほとんどのビルドインバリデーターには`allowsNil()` modifierと`allowsEmpty()` modifierを付与することができます。  

- `allowsNil`: 検証する値が`Optional`で`nil`の場合に検証をスキップする。
- `allowsEmpty`: 検証する値がコレクションで要素が空の場合に検証をスキップする。

引数として`Bool`を取るので、特定条件下では検証をスキップする、といった挙動にすることもできます。

```swift
Comparison(age, .greaterThan(16))
    .allowsNil(!isLoggedIn)
```

## Validation Errors

検証に失敗すると、`ValidationError`または`ValidationErrors`が投げられます。    
これらのエラーはそれぞれ、失敗した検証が単一か複数かに対応しています。  
例えば、`Validate`を除いてバリデーターを独立して利用した場合は、検証失敗時に`ValidationError`が投げられます。

### `ValidationError`

`ValidationError`は、検証に失敗したバリデーターとその理由に関する情報を持っています。  
検証に失敗したバリデーターの情報はデフォルトでは保持していないため、失敗したバリデーターを特定したい場合はerror keyを設定する必要があります。

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

この例では、error keyとして`KeyPath`を設定していますが、他にも`String`など`Hashable`に準拠した型を設定することができます。

> [!NOTE]  
> 現行バージョンでは、失敗した場所を特定したければ、error keyを各バリデーターに明示的に与える必要があります。  
> このerror keyは、将来のバージョンで自動で付与されるような実装を検討中です。

また、複数のバリデーターに同じerror keyをまとめて付与することもできます。  
この利用方法は、モデルなどに組み込む際にも有用です。

```swift
Validate {
    Presence(username)
    Count(bio, within: 0...1000)
}
.errorKey("Profile")
```


### `ValidationErrors`

`ValidationErrors`は、`ValidationError`を要素に持つコレクションです。  
`ValidationError`のイテレーションのほかに、指定したerror keyに該当する`ValidationError`の配列や失敗理由を取り出すことができます。

```swift
user.validationErrors?.reasons(for: \User.name)
```
