public struct Inclusion<Value, Member: _Clusivity.Member>: Validator, PresenceValidatable {
    public var value: Value?

    @usableFromInline
    var member: Member

    public var presenceOption: PresenceOption = .required

    @inlinable
    public init<M: Collection<Value>>(_ value: Value?, in member: M)
    where Member == _Clusivity.CollectionMember<M> {
        self.value = value
        self.member = _Clusivity.CollectionMember(base: member)
    }

    @inlinable
    public init<M: Collection<Value.Element>>(_ value: Value?, in member: M)
    where Value: Collection, Member == _Clusivity.CollectionMember<M> {
        self.value = value
        self.member = _Clusivity.CollectionMember(base: member)
    }


    @inlinable
    public init<R: RangeExpression<Value>>(_ element: Value?, in range: R)
    where Member == _Clusivity.RangeMember<R> {
        self.value = element
        self.member = _Clusivity.RangeMember(base: range)
    }

    @inlinable
    public init<R: RangeExpression<Value.Element>>(_ value: Value?, in range: R)
    where Value: Collection, Member == _Clusivity.RangeMember<R> {
        self.value = value
        self.member = _Clusivity.RangeMember(base: range)
    }

    @inlinable
    public func validate() throws {
        guard let presenceValue = try validatePresence(resolvingErrorWithReasons: .inclusion) else {
            return
        }

        let contains = if let collection = presenceValue as? any Collection<Member.Element> {
            member.contains(collection)
        } else if let element = presenceValue as? Member.Element {
            member.contains(element)
        } else {
            preconditionFailure()
        }

        if !contains {
            throw ValidationError(reasons: .inclusion)
        }
    }
}
