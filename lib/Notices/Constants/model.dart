// lib/Models/notice_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class Notice {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final String sentBy;
  final String sentToRole;
  final DateTime timestamp;
  final List<String> seenBy;

  Notice({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.sentBy,
    required this.sentToRole,
    required this.timestamp,
    required this.seenBy,
  });

  factory Notice.fromMap(Map<String, dynamic> data, String documentId) {
    return Notice(
      id: documentId,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      sentBy: data['sentBy'] ?? '',
      sentToRole: data['sentToRole'] ?? '',
      timestamp: data['timestamp'] != null
          ? (data['timestamp'] as Timestamp).toDate()
          : DateTime.now(),
      seenBy: List<String>.from(data['seenBy'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
      'sentBy': sentBy,
      'sentToRole': sentToRole,
      'timestamp': timestamp,
      'seenBy': seenBy,
    };
  }

  factory Notice.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Notice(
      id: doc.id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      sentBy: data['sentBy'] ?? '',
      sentToRole: data['sentToRole'] ?? '',
      timestamp: (data['timestamp'] as Timestamp).toDate(),
      seenBy: List<String>.from(data['seenBy'] ?? []),
    );
  }
}
