import 'package:cloud_firestore/cloud_firestore.dart';
 
class FlightModel {
  final String id;
  final String airline;
  final String airlineCode;
  final String flightNumber;
  final String fromCode;
  final String fromCity;
  final String fromAirport;
  final String toCode;
  final String toCity;
  final String toAirport;
  final String departTime;
  final String arrivalTime;
  final String duration;
  final int durationMinutes;
  final int stops;
  final double price;
  final bool baggageIncluded;
  final bool refundable;
  final List<String> amenities;
  final int availableSeats;
  final String aircraftType;
 
  FlightModel({
    required this.id,
    required this.airline,
    required this.airlineCode,
    required this.flightNumber,
    required this.fromCode,
    required this.fromCity,
    required this.fromAirport,
    required this.toCode,
    required this.toCity,
    required this.toAirport,
    required this.departTime,
    required this.arrivalTime,
    required this.duration,
    required this.durationMinutes,
    required this.stops,
    required this.price,
    required this.baggageIncluded,
    required this.refundable,
    required this.amenities,
    required this.availableSeats,
    required this.aircraftType,
  });
 
  factory FlightModel.fromFirestore(DocumentSnapshot doc) {
    final d = doc.data() as Map<String, dynamic>;
    return FlightModel(
      id: doc.id,
      airline: d['airline'] ?? '',
      airlineCode: d['airlineCode'] ?? '',
      flightNumber: d['flightNumber'] ?? '',
      fromCode: d['fromCode'] ?? '',
      fromCity: d['fromCity'] ?? '',
      fromAirport: d['fromAirport'] ?? '',
      toCode: d['toCode'] ?? '',
      toCity: d['toCity'] ?? '',
      toAirport: d['toAirport'] ?? '',
      departTime: d['departTime'] ?? '',
      arrivalTime: d['arrivalTime'] ?? '',
      duration: d['duration'] ?? '',
      durationMinutes: d['durationMinutes'] ?? 0,
      stops: d['stops'] ?? 0,
      price: (d['price'] ?? 0).toDouble(),
      baggageIncluded: d['baggageIncluded'] ?? false,
      refundable: d['refundable'] ?? false,
      amenities: List<String>.from(d['amenities'] ?? []),
      availableSeats: d['availableSeats'] ?? 0,
      aircraftType: d['aircraftType'] ?? '',
    );
  }
 
  Map<String, dynamic> toMap() => {
    'airline': airline,
    'airlineCode': airlineCode,
    'flightNumber': flightNumber,
    'fromCode': fromCode,
    'fromCity': fromCity,
    'fromAirport': fromAirport,
    'toCode': toCode,
    'toCity': toCity,
    'toAirport': toAirport,
    'departTime': departTime,
    'arrivalTime': arrivalTime,
    'duration': duration,
    'durationMinutes': durationMinutes,
    'stops': stops,
    'price': price,
    'baggageIncluded': baggageIncluded,
    'refundable': refundable,
    'amenities': amenities,
    'availableSeats': availableSeats,
    'aircraftType': aircraftType,
  };
}
