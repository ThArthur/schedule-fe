class Room {
  final int? id;
  final String floor;
  final String number;
  final int buildingId;
  final String? imageUrl;

  Room({
    this.id,
    required this.floor,
    required this.number,
    required this.buildingId,
    this.imageUrl,
  });

  factory Room.fromJson(Map<String, dynamic> json) {
    return Room(
      id: json['id'],
      floor: json['floor'],
      number: json['number'],
      buildingId: json['buildingId'],
      imageUrl: json['imageUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'floor': floor,
      'number': number,
      'buildingId': buildingId,
    };
  }
}
