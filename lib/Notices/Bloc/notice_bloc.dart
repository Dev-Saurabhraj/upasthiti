
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../Constants/model.dart';
import 'notice_event.dart';
import 'notice_state.dart';

class NoticeBloc extends Bloc<NoticeEvent, NoticeState> {
  final FirebaseFirestore firestore;

  NoticeBloc({required this.firestore}) : super(NoticeInitial()) {
    on<FetchNotices>(_onFetchNotices);
    on<MarkNoticeSeen>(_onMarkNoticeSeen);
  }

  Future<void> _onFetchNotices(
      FetchNotices event, Emitter<NoticeState> emit) async {
    emit(NoticeLoading());
    try {
      final querySnapshot = await firestore
          .collection('notices')
          .orderBy('timestamp', descending: true)
          .get();

      final notices = querySnapshot.docs
          .map((doc) => Notice.fromMap(doc.data(), doc.id))
          .toList();

      emit(NoticeLoaded(notices));
    } catch (e) {
      emit(NoticeError("Failed to fetch notices."));
    }
  }

  Future<void> _onMarkNoticeSeen(
      MarkNoticeSeen event, Emitter<NoticeState> emit) async {
    try {
      final noticeRef = firestore.collection('notices').doc(event.noticeId);
      await noticeRef.update({
        'seenBy': FieldValue.arrayUnion([event.userId])
      });
    } catch (e) {
      emit(NoticeError("Failed to mark notice as seen."));
    }
  }

  Future<void> deleteNotices(String noticeId)async {
    try {
      await firestore.collection('notices').doc(noticeId).delete();
    } catch (e) {
      emit(NoticeError("Failed to delete notice."));
    }
  }
}
