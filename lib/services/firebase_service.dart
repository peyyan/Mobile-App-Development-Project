import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/food_log.dart';
import '../models/user_model.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> saveFoodLog(FoodLog log) async {
    await _firestore.collection('food_logs').add(log.toMap());
  }

  Future<List<FoodLog>> fetchFoodLogs(String userId) async {
    final snapshot = await _firestore
        .collection('food_logs')
        .where('userId', isEqualTo: userId)
        .orderBy('timestamp', descending: true)
        .get();

    return snapshot.docs
        .map((doc) => FoodLog.fromMap(doc.id, doc.data()))
        .toList();
  }

  Stream<UserModel?> getUser(String uid) {
    return _firestore.collection('users').doc(uid).snapshots().map((doc) {
      if (doc.exists && doc.data() != null) {
        return UserModel.fromMap(doc.id, doc.data()!);
      }
      return null;
    });
  }

  Stream<List<FoodLog>> getFoodLogsStream(String userId) {
    return _firestore
        .collection('food_logs')
        .where('userId', isEqualTo: userId)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => FoodLog.fromMap(doc.id, doc.data()))
              .toList(),
        );
  }
}
