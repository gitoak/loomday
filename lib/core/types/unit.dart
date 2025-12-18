// ignore_for_file: public_member_api_docs

/// Represents absence of a meaningful value.
class Unit {
  const Unit();

  @override
  String toString() => 'Unit';
}

/// Shared singleton instance for convenience.
const Unit unit = Unit();