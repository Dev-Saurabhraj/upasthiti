import 'package:equatable/equatable.dart';

abstract class NoticeEvent extends Equatable {
  const NoticeEvent();

  @override
  List<Object> get props => [];
}

class FetchNotices extends NoticeEvent {}

class MarkNoticeSeen extends NoticeEvent {
  final String noticeId;
  final String userId;

  const MarkNoticeSeen({required this.noticeId, required this.userId});

  @override
  List<Object> get props => [noticeId, userId];
}
