// RUN: %target-typecheck-verify-swift -requirement-machine-protocol-signatures=on -requirement-machine-inferred-signatures=on

func testInvalidConformance() {
  // expected-error@+1 {{type 'T' constrained to non-protocol, non-class type 'Int'}}
  func invalidIntConformance<T>(_: T) where T: Int {}

  // expected-error@+1 {{type 'T' constrained to non-protocol, non-class type 'Int'}}
  struct InvalidIntConformance<T: Int> {}

  struct S<T> {
    // expected-error@+2 {{type 'T' constrained to non-protocol, non-class type 'Int'}}
    // expected-note@+1 {{use 'T == Int' to require 'T' to be 'Int'}}
    func method() where T: Int {}
  }
}

// Check directly-concrete same-type constraints
typealias NotAnInt = Double

protocol X {}

// expected-error@+1{{generic signature requires types 'Double' and 'Int' to be the same}}
extension X where NotAnInt == Int {}

protocol EqualComparable {
  func isEqual(_ other: Self) -> Bool
}

func badTypeConformance1<T>(_: T) where Int : EqualComparable {} // expected-error{{type 'Int' in conformance requirement does not refer to a generic parameter or associated type}}

func badTypeConformance2<T>(_: T) where T.Blarg : EqualComparable { } // expected-error{{'Blarg' is not a member type of type 'T'}}

func badTypeConformance3<T>(_: T) where (T) -> () : EqualComparable { }
// expected-error@-1{{type '(T) -> ()' in conformance requirement does not refer to a generic parameter or associated type}}

func badTypeConformance4<T>(_: T) where @escaping (inout T) throws -> () : EqualComparable { }
// expected-error@-1{{type '(inout T) throws -> ()' in conformance requirement does not refer to a generic parameter or associated type}}
// expected-error@-2 2 {{@escaping attribute may only be used in function parameter position}}

func badTypeConformance5<T>(_: T) where T & Sequence : EqualComparable { }
// expected-error@-1 2 {{non-protocol, non-class type 'T' cannot be used within a protocol-constrained type}}
// expected-error@-2{{type 'Sequence' in conformance requirement does not refer to a generic parameter or associated type}}
