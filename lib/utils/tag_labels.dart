class TagLabels {
  static const map = <int, String>{
    1: 'Daily Life',
    2: 'Campus Life',
    3: 'Jobs',
    4: 'Food Spots',
    5: 'SNU',
    6: 'KU',
    7: 'YU',
    8: 'Transportation',
    9: 'Convenience Store',
    10: 'Fraud Alert',
  };

  static String of(int id) => map[id] ?? 'Tag$id';
}
