import 'package:cloud_firestore/cloud_firestore.dart';

enum SavedItemType { country, city, experience, hotel, flight, event }

extension SavedItemTypeExtension on SavedItemType {
  String get label {
    switch (this) {
      case SavedItemType.country:
        return 'Country';
      case SavedItemType.city:
        return 'City';
      case SavedItemType.experience:
        return 'Experience';
      case SavedItemType.hotel:
        return 'Hotel';
      case SavedItemType.flight:
        return 'Flight';
      case SavedItemType.event:
        return 'Event';
    }
  }

  String get slug => name.replaceAll(' ', '_').toLowerCase();
}

class SavedItem {
  final String id;
  final String title;
  final String subtitle;
  final String image;
  final SavedItemType type;
  final double? price;
  final String details;
  final Timestamp createdAt;

  SavedItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.image,
    required this.type,
    this.price,
    this.details = '',
    Timestamp? createdAt,
  }) : createdAt = createdAt ?? Timestamp.now();

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'subtitle': subtitle,
      'image': image,
      'type': type.name,
      'price': price,
      'details': details,
      'createdAt': createdAt,
    };
  }

  factory SavedItem.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? {};
    return SavedItem(
      id: doc.id,
      title: data['title'] as String? ?? '',
      subtitle: data['subtitle'] as String? ?? '',
      image: data['image'] as String? ?? '',
      type: _typeFromString(data['type'] as String? ?? ''),
      price: (data['price'] as num?)?.toDouble(),
      details: data['details'] as String? ?? '',
      createdAt: data['createdAt'] as Timestamp? ?? Timestamp.now(),
    );
  }

  static SavedItemType _typeFromString(String type) {
    return SavedItemType.values.firstWhere(
      (value) => value.name == type,
      orElse: () => SavedItemType.city,
    );
  }

  static String makeDocId(SavedItemType type, String title) {
    final slug = title
        .toLowerCase()
        .replaceAll(RegExp(r"[^a-z0-9]+"), '_')
        .replaceAll(RegExp(r'_+'), '_')
        .trim();
    return '${type.name}_$slug';
  }
}
