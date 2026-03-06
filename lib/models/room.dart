class Room {
  final String id;
  final String name;
  final String description;
  final double pricePerHour;
  final String imageUrl;
  final bool isAvailable;

  Room({
    required this.id,
    required this.name,
    required this.description,
    required this.pricePerHour,
    required this.imageUrl,
    this.isAvailable = true,
  });
}
