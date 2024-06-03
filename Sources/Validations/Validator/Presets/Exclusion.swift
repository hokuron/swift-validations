public struct Exclusion<Value, Member: _Clusivity.Member>: Validator, PresenceValidatable {
    public var value: Value?

    @usableFromInline
    var member: Member

    public var presenceOption: PresenceOption = .required

    @inlinable
    public init<M: Collection<Value>>(of value: Value?, in member: M)
    where Member == _Clusivity.CollectionMember<M> {
        self.value = value
        self.member = _Clusivity.CollectionMember(base: member)
    }

    @inlinable
    public init<M: Collection<Value.Element>>(of value: Value?, in member: M)
    where Value: Collection, Member == _Clusivity.CollectionMember<M> {
        self.value = value
        self.member = _Clusivity.CollectionMember(base: member)
    }


    @inlinable
    public init<R: RangeExpression<Value>>(of element: Value?, in range: R)
    where Member == _Clusivity.RangeMember<R> {
        self.value = element
        self.member = _Clusivity.RangeMember(base: range)
    }

    @inlinable
    public init<R: RangeExpression<Value.Element>>(of value: Value?, in range: R) 
    where Value: Collection, Member == _Clusivity.RangeMember<R> {
        self.value = value
        self.member = _Clusivity.RangeMember(base: range)
    }

    @inlinable
    public func validate() throws {
        guard let presenceValue = try validatePresence(resolvingErrorWithReasons: .exclusion) else {
            return
        }

        let contains = if let collection = presenceValue as? any Collection<Member.Element> {
            member.contains(collection)
        } else if let element = presenceValue as? Member.Element {
            member.contains(element)
        } else {
            preconditionFailure()
        }

        if contains {
            throw ValidationError(reasons: .exclusion)
        }
    }
}

extension Exclusion: Sendable where Value: Sendable, Member: Sendable {}
extension Exclusion: Equatable where Value: Equatable, Member: Equatable {}
extension Exclusion: Hashable where Value: Hashable, Member: Hashable {}
