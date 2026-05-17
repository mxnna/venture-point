class Hotel {
  final String id;
  final String name;
  final String location;
  final double rating;
  final int reviews;
  final int pricePerNight;
  final int stars;
  final String badge;
  final String category;
  final List<String> images;

  const Hotel({
    required this.id,
    required this.name,
    required this.location,
    required this.rating,
    required this.reviews,
    required this.pricePerNight,
    required this.stars,
    required this.badge,
    required this.category,
    required this.images,
  });

  factory Hotel.fromFirestore(Map<String, dynamic> data, String id) {
    return Hotel(
      id: id,
      name: data['name'] ?? '',
      location: data['location'] ?? '',
      rating: (data['rating'] ?? 0).toDouble(),
      reviews: data['reviews'] ?? 0,
      pricePerNight: data['pricePerNight'] ?? 0,
      stars: data['stars'] ?? 0,
      badge: data['badge'] ?? '',
      category: data['category'] ?? 'all',
      images: List<String>.from (data['images'] ?? []),
    );
  }

}
