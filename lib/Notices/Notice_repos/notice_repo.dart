import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../Constants/model.dart';


class NoticeRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  Future<List<Notice>> getNotices() async {
    final querySnapshot = await _firestore.collection('notices').orderBy('createdAt', descending: true).get();
    return querySnapshot.docs.map((doc) => Notice.fromFirestore(doc)).toList();
  }

  Future<void> sendNotice(Notice notice) async {
    final docRef = _firestore.collection('notices').doc();
    await docRef.set(notice.toMap());
    await _messaging.sendMessage(
      to: 'notices',
      data: {
        'title': notice.title,
        'body': notice.description,
        'image': notice.imageUrl ?? '',
      },
    );
  }

  Future<void> markAsRead(String noticeId, String userId) async {
    await _firestore.collection('notices').doc(noticeId).update({
      'readBy': FieldValue.arrayUnion([userId]),
    });
  }

  Future<String?> uploadImage(dynamic imageFile) async {
    if (imageFile == null) return null;
    final ref = _storage.ref().child('notice_images/${DateTime.now().millisecondsSinceEpoch}');
    await ref.putFile(imageFile);
    return await ref.getDownloadURL();
  }
}