import 'package:cloud_firestore/cloud_firestore.dart';
 
class BookingModel {
  final String id;
  final String flightId;
  final String userId;
  final String passengerName;
  final String fromCode;
  final String fromCity;
  final String toCode;
  final String toCity;
  final String departDate;
  final String departTime;
  final String arrivalTime;
  final String flightNumber;
  final String airline;
  final String seatNumber;
  final String cabinClass;
  final int adults;
  final int children;
  final int infants;
  final double totalPrice;
  final String gate;
  final String terminal;
  final String boardingTime;
  final String status; // confirmed, cancelled
  final DateTime createdAt;
 
  BookingModel({
    required this.id,
    required this.flightId,
    required this.userId,
    required this.passengerName,
    required this.fromCode,
    required this.fromCity,
    required this.toCode,
    required this.toCity,
    required this.departDate,
    required this.departTime,
    required this.arrivalTime,
    required this.flightNumber,
    required this.airline,
    required this.seatNumber,
    required this.cabinClass,
    required this.adults,
    required this.children,
    required this.infants,
    required this.totalPrice,
    required this.gate,
    required this.terminal,
    required this.boardingTime,
    required this.status,
    required this.createdAt,
  });
 
  factory BookingModel.fromFirestore(DocumentSnapshot doc) {
    final d = doc.data() as Map<String, dynamic>;
    return BookingModel(
      id: doc.id,
      flightId: d['flightId'] ?? '',
      userId: d['userId'] ?? '',
      passengerName: d['passengerName'] ?? '',
      fromCode: d['fromCode'] ?? '',
      fromCity: d['fromCity'] ?? '',
      toCode: d['toCode'] ?? '',
      toCity: d['toCity'] ?? '',
      departDate: d['departDate'] ?? '',
      departTime: d['departTime'] ?? '',
      arrivalTime: d['arrivalTime'] ?? '',
      flightNumber: d['flightNumber'] ?? '',
      airline: d['airline'] ?? '',
      seatNumber: d['seatNumber'] ?? '',
      cabinClass: d['cabinClass'] ?? '',
      adults: d['adults'] ?? 1,
      children: d['children'] ?? 0,
      infants: d['infants'] ?? 0,
      totalPrice: (d['totalPrice'] ?? 0).toDouble(),
      gate: d['gate'] ?? 'B14',
      terminal: d['terminal'] ?? '2',
      boardingTime: d['boardingTime'] ?? '',
      status: d['status'] ?? 'confirmed',
      createdAt: (d['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }
 
  Map<String, dynamic> toMap() => {
    'flightId': flightId,
    'userId': userId,
    'passengerName': passengerName,
    'fromCode': fromCode,
    'fromCity': fromCity,
    'toCode': toCode,
    'toCity': toCity,
    'departDate': departDate,
    'departTime': departTime,
    'arrivalTime': arrivalTime,
    'flightNumber': flightNumber,
    'airline': airline,
    'seatNumber': seatNumber,
    'cabinClass': cabinClass,
    'adults': adults,
    'children': children,
    'infants': infants,
    'totalPrice': totalPrice,
    'gate': gate,
    'terminal': terminal,
    'boardingTime': boardingTime,
    'status': status,
    'createdAt': FieldValue.serverTimestamp(),
  };
}
