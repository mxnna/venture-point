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
    final rawImages = data['images'];
    final images = <String>[];
    if (rawImages is List) {
      for (final item in rawImages) {
        if (item is String && item.isNotEmpty) {
          images.add(item);
        } else if (item is Map<String, dynamic>) {
          final url = item['url'] ?? item['src'] ?? item['path'] ?? item['image'];
          if (url is String && url.isNotEmpty) {
            images.add(url);
          }
        } else if (item != null) {
          final value = item.toString();
          if (value.isNotEmpty) {
            images.add(value);
          }
        }
      }
    } else if (rawImages is String && rawImages.isNotEmpty) {
      images.addAll(rawImages
          .split(',')
          .map((part) => part.trim())
          .where((part) => part.isNotEmpty));
    }

    if (images.isEmpty && data['image'] is String && data['image'].toString().isNotEmpty) {
      images.add(data['image'].toString());
    }

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
      images: images,
    );
  }

}
