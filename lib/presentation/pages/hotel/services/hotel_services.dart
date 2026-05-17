import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/hotel.dart';

class HotelService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  Stream<List<Hotel>> getHotels() {
    return _db.collection('hotel').snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => Hotel.fromFirestore(doc.data(), doc.id))
          .toList();
    });
  }
}
