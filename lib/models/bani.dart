class Bani {
  final int id;
  final String bani;
  final String arth;
  final String roman;

  Bani({
    required this.id,
    required this.bani,
    required this.arth,
    required this.roman,
  });

  factory Bani.fromJson(Map<String, dynamic> json) {
    return Bani(
      id: json['id'],
      bani: json['bani'] ?? '',
      arth: json['arth'] ?? '',
      roman: json['roman'] ?? '',
    );
  }
}