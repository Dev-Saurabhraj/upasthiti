import 'package:cloud_firestore/cloud_firestore.dart';

import '../Constants/model.dart';


class FirebaseNoticeService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addNotice(Notice notice) async {
    await _firestore.collection('notices').add(notice.toMap());
  }

  Future<List<Notice>> getAllNotices() async {
    final snapshot = await _firestore
        .collection('notices')
        .orderBy('timestamp', descending: true)
        .get();

    final validNotices = <Notice>[];

    for (var doc in snapshot.docs) {
      try {
        final data = doc.data();
        if (data == null ||
            data['title'] == null ||
            data['timestamp'] == null ||
            data['description'] == null ||
            data['sentBy'] == null ||
            data['sentToRole'] == null) {
          continue;
        }
        final notice = Notice.fromMap(data, doc.id);
        validNotices.add(notice);
      } catch (e) {
        continue;
      }
    }

    return validNotices;
  }

  Future<void> markAsSeen(String noticeId, String userId) async {
    final docRef = _firestore.collection('notices').doc(noticeId);
    await docRef.update({
      'seenBy': FieldValue.arrayUnion([userId])
    });
  }
  Future<void> deleteNotice(String noticeId) async {
    await _firestore.collection('notices').doc(noticeId).delete();
  }
}
