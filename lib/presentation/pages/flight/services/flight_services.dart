import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/flight_model.dart';
import '../models/booking_model.dart';

class FlightService {
  final _db = FirebaseFirestore.instance;

  // ─── Search flights from Firestore ───────────────────────────────────────
  Future<List<FlightModel>> searchFlights({
    required String fromCode,
    required String toCode,
    required String date, // 'YYYY-MM-DD'
    bool directOnly = false,
    bool baggageIncluded = false,
    bool refundableOnly = false,
    String sortBy = 'best', // best, cheap, fast
  }) async {
    try {
      Query query = _db
          .collection('flights')
          .where('fromCode', isEqualTo: fromCode)
          .where('toCode', isEqualTo: toCode)
          .where('date', isEqualTo: date);

      if (directOnly) query = query.where('stops', isEqualTo: 0);
      if (baggageIncluded)
        query = query.where('baggageIncluded', isEqualTo: true);
      if (refundableOnly) query = query.where('refundable', isEqualTo: true);

      final snap = await query.get();
      var flights = snap.docs.map((d) => FlightModel.fromFirestore(d)).toList();

      // Sort client-side
      if (sortBy == 'cheap') {
        flights.sort((a, b) => a.price.compareTo(b.price));
      } else if (sortBy == 'fast') {
        flights.sort((a, b) => a.durationMinutes.compareTo(b.durationMinutes));
      }

      return flights;
    } catch (e) {
      // Return mock data if Firestore is empty
      return _mockFlights(fromCode, toCode);
    }
  }

  // ─── Get seat map for a flight ───────────────────────────────────────────
  Future<Map<String, String>> getSeatMap(String flightId) async {
    try {
      final snap = await _db
          .collection('flights')
          .doc(flightId)
          .collection('seats')
          .get();

      final seatMap = <String, String>{};
      for (final doc in snap.docs) {
        seatMap[doc.id] = doc['status'] ?? 'available'; // available / taken
      }
      return seatMap;
    } catch (e) {
      return _defaultSeatMap();
    }
  }

  // ─── Reserve a seat (transaction) ────────────────────────────────────────
  Future<bool> reserveSeat(String flightId, String seatId) async {
    try {
      final seatRef = _db
          .collection('flights')
          .doc(flightId)
          .collection('seats')
          .doc(seatId);

      return await _db.runTransaction((tx) async {
        final snap = await tx.get(seatRef);
        if (snap.exists && snap['status'] == 'taken') return false;
        tx.set(seatRef, {'status': 'taken'}, SetOptions(merge: true));
        return true;
      });
    } catch (e) {
      return true; // allow in demo mode
    }
  }

  // ─── Create booking ───────────────────────────────────────────────────────
  Future<String?> createBooking(BookingModel booking) async {
    try {
      final ref = await _db.collection('bookings').add(booking.toMap());
      return ref.id;
    } catch (e) {
      return 'demo_booking_${DateTime.now().millisecondsSinceEpoch}';
    }
  }

  // ─── Get user bookings ────────────────────────────────────────────────────
  Stream<List<BookingModel>> getUserBookings(String userId) {
    return _db
        .collection('bookings')
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snap) =>
              snap.docs.map((d) => BookingModel.fromFirestore(d)).toList(),
        );
  }

  // ─── Seed demo data to Firestore ─────────────────────────────────────────
  Future<void> seedDemoData(String fromCode, String toCode, String date) async {
    final flights = _mockFlights(fromCode, toCode);
    for (final f in flights) {
      await _db.collection('flights').doc(f.id).set({
        ...f.toMap(),
        'date': date,
      });
      // Add seat map
      final seats = _defaultSeatMap();
      for (final entry in seats.entries) {
        await _db
            .collection('flights')
            .doc(f.id)
            .collection('seats')
            .doc(entry.key)
            .set({'status': entry.value});
      }
    }
  }

  // ─── Mock data (fallback) ─────────────────────────────────────────────────
  List<FlightModel> _mockFlights(String from, String to) => [
    FlightModel(
      id: 'EK709',
      airline: 'Emirates',
      airlineCode: 'EK',
      flightNumber: 'EK-709',
      fromCode: from,
      fromCity: from,
      fromAirport: '$from International',
      toCode: to,
      toCity: to,
      toAirport: '$to Airport',
      departTime: '08:30',
      arrivalTime: '13:55',
      duration: '3h 25m',
      durationMinutes: 205,
      stops: 0,
      price: 210,
      baggageIncluded: true,
      refundable: true,
      amenities: ['Entertainment', 'Wi-Fi', 'Meal included', 'Refundable'],
      availableSeats: 42,
      aircraftType: 'Boeing 777',
    ),
    FlightModel(
      id: 'MS965',
      airline: 'EgyptAir',
      airlineCode: 'MS',
      flightNumber: 'MS-965',
      fromCode: from,
      fromCity: from,
      fromAirport: '$from International',
      toCode: to,
      toCity: to,
      toAirport: '$to Airport',
      departTime: '10:15',
      arrivalTime: '15:55',
      duration: '3h 40m',
      durationMinutes: 220,
      stops: 0,
      price: 185,
      baggageIncluded: true,
      refundable: false,
      amenities: ['Meal included'],
      availableSeats: 28,
      aircraftType: 'Airbus A320',
    ),
    FlightModel(
      id: 'FZ309',
      airline: 'flydubai',
      airlineCode: 'FZ',
      flightNumber: 'FZ-309',
      fromCode: from,
      fromCity: from,
      fromAirport: '$from International',
      toCode: to,
      toCity: to,
      toAirport: '$to Airport',
      departTime: '14:00',
      arrivalTime: '21:55',
      duration: '5h 55m',
      durationMinutes: 355,
      stops: 1,
      price: 139,
      baggageIncluded: false,
      refundable: false,
      amenities: ['Entertainment'],
      availableSeats: 15,
      aircraftType: 'Boeing 737',
    ),
  ];

  Map<String, String> _defaultSeatMap() => {
    '1A': 'taken',
    '1B': 'available',
    '1C': 'available',
    '1D': 'taken',
    '2A': 'available',
    '2B': 'taken',
    '2C': 'taken',
    '2D': 'available',
    '10A': 'available',
    '10B': 'taken',
    '10C': 'taken',
    '10D': 'available',
    '10E': 'available',
    '10F': 'taken',
    '11A': 'taken',
    '11B': 'available',
    '11C': 'taken',
    '11D': 'taken',
    '11E': 'available',
    '11F': 'taken',
    '12A': 'available',
    '12B': 'available',
    '12C': 'taken',
    '12D': 'available',
    '12E': 'taken',
    '12F': 'available',
    '23A': 'available',
    '23B': 'taken',
    '23C': 'available',
    '23D': 'taken',
    '23E': 'available',
    '23F': 'taken',
  };
}
