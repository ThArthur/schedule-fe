class Building {
  final int? id;
  final String name;
  final String number;
  final String complement;
  final String? imageUrl;

  Building({
    this.id,
    required this.name,
    required this.number,
    required this.complement,
    this.imageUrl,
  });

  factory Building.fromJson(Map<String, dynamic> json) {
    return Building(
      id: json['id'],
      name: json['name'],
      number: json['number'],
      complement: json['complement'],
      imageUrl: json['imageUrl'],
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
