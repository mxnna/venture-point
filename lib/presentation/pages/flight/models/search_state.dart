import 'package:cloud_firestore/cloud_firestore.dart';

// ─── City model ───────────────────────────────────────────────────────────
class CityModel {
  final String city;
  final String code;
  final String airport;
  final String country;

  const CityModel({
    required this.city,
    required this.code,
    required this.airport,
    required this.country,
  });

  /// من Firestore document
  factory CityModel.fromFirestore(DocumentSnapshot doc) {
    final d = doc.data() as Map<String, dynamic>;
    return CityModel(
      city:    d['city']    ?? doc.id,
      code:    d['code']    ?? doc.id,
      airport: d['airport'] ?? '',
      country: d['country'] ?? '',
    );
  }
}

// ─── Cities service ────────────────────────────────────────────────────────
class CitiesService {
  static final _db = FirebaseFirestore.instance;

  /// جيب كل المدن من Firestore
  static Future<List<CityModel>> getCities() async {
    try {
      final snap = await _db.collection('cities').get();
      final cities = snap.docs.map((d) => CityModel.fromFirestore(d)).toList();
      cities.sort((a, b) => a.city.compareTo(b.city));
      return cities;
    } catch (e) {
      return [];
    }
  }
}

// ─── Search state ─────────────────────────────────────────────────────────
class SearchState {
  final String tripType;
  final CityModel from;
  final CityModel to;
  final DateTime departDate;
  final DateTime? returnDate;
  final int adults;
  final int children;
  final int infants;
  final String cabinClass;
  final bool directOnly;
  final bool baggageIncluded;
  final bool flexibleDates;
  final bool refundableOnly;

  SearchState({
    this.tripType = 'round',
    required this.from,
    required this.to,
    required this.departDate,
    this.returnDate,
    this.adults = 1,
    this.children = 0,
    this.infants = 0,
    this.cabinClass = 'Economy',
    this.directOnly = false,
    this.baggageIncluded = false,
    this.flexibleDates = false,
    this.refundableOnly = false,
  });

  SearchState copyWith({
    String? tripType,
    CityModel? from,
    CityModel? to,
    DateTime? departDate,
    DateTime? returnDate,
    int? adults,
    int? children,
    int? infants,
    String? cabinClass,
    bool? directOnly,
    bool? baggageIncluded,
    bool? flexibleDates,
    bool? refundableOnly,
  }) {
    return SearchState(
      tripType:        tripType        ?? this.tripType,
      from:            from            ?? this.from,
      to:              to              ?? this.to,
      departDate:      departDate      ?? this.departDate,
      returnDate:      returnDate      ?? this.returnDate,
      adults:          adults          ?? this.adults,
      children:        children        ?? this.children,
      infants:         infants         ?? this.infants,
      cabinClass:      cabinClass      ?? this.cabinClass,
      directOnly:      directOnly      ?? this.directOnly,
      baggageIncluded: baggageIncluded ?? this.baggageIncluded,
      flexibleDates:   flexibleDates   ?? this.flexibleDates,
      refundableOnly:  refundableOnly  ?? this.refundableOnly,
    );
  }

  String get passengerLabel {
    final parts = <String>[];
    if (adults > 0)   parts.add('$adults Adult${adults > 1 ? 's' : ''}');
    if (children > 0) parts.add('$children Child${children > 1 ? 'ren' : ''}');
    if (infants > 0)  parts.add('$infants Infant${infants > 1 ? 's' : ''}');
    return parts.join(', ');
  }

  int get totalPassengers => adults + children;
}
