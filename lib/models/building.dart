class Building {
  final int? id;
  final String name;
  final String number;
  final String complement;

  Building({
    this.id,
    required this.name,
    required this.number,
    required this.complement,
  });

  factory Building.fromJson(Map<String, dynamic> json) {
    return Building(
      id: json['id'],
      name: json['name'],
      number: json['number'],
      complement: json['complement'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'number': number,
      'complement': complement,
    };
  }
}
