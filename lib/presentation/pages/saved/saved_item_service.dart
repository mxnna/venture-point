import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'saved_item_model.dart';

class SavedItemService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _savedCollection {
    final user = _auth.currentUser;
    return _db
        .collection('users')
        .doc(user?.uid ?? 'guest')
        .collection('saved_items');
  }

  Stream<List<SavedItem>> getSavedItems() {
    final user = _auth.currentUser;
    if (user == null) {
      return Stream<List<SavedItem>>.value([]);
    }

    return _savedCollection
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map(SavedItem.fromFirestore).toList());
  }

  Stream<Set<String>> getSavedItemIds() {
    return getSavedItems().map((items) => items.map((item) => item.id).toSet());
  }

  Future<void> saveItem(SavedItem item) async {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception('You must be signed in to save items.');
    }
    await _savedCollection.doc(item.id).set(item.toMap());
  }

  Future<void> removeItem(String itemId) async {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception('You must be signed in to remove items.');
    }
    await _savedCollection.doc(itemId).delete();
  }

  Future<void> toggleSavedItem(SavedItem item, {required bool isSaved}) async {
    if (isSaved) {
      await removeItem(item.id);
    } else {
      await saveItem(item);
    }
  }
}
