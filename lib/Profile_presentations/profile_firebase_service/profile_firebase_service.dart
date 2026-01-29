import 'package:cloud_firestore/cloud_firestore.dart';

import '../Constants/constant.dart';

class UserRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'students';

  Future<User?> getUser(String userId, String role) async {
    final String collection = (role =='student') ? 'students': 'teachers';
    try {
      Future<String?> getDocIdById(String userId) async {
        final query = await FirebaseFirestore.instance
            .collection(collection)
            .where('generatedId', isEqualTo: userId)
            .limit(1)
            .get();

        if (query.docs.isNotEmpty) {
          return query.docs.first.id;
        }
        return null;
      }

      final docId = await getDocIdById(userId);

      final doc = await _firestore.collection(collection).doc(docId).get();
      if (doc.exists) {
        return User.fromMap(doc.data()!);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get user: $e');
    }
  }

  Future<void> updateUser(User user) async {
    try {
      await _firestore.collection(_collection).doc(user.generatedId).update(
            user.copyWith(updatedAt: DateTime.now()).toMap(),
          );
    } catch (e) {
      throw Exception('Failed to update user: $e');
    }
  }

  Future<void> createUser(User user) async {
    try {
      await _firestore
          .collection(_collection)
          .doc(user.generatedId)
          .set(user.toMap());
    } catch (e) {
      throw Exception('Failed to create user: $e');
    }
  }
}



