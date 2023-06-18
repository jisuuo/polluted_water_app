import 'package:json_annotation/json_annotation.dart';

part 'notice_model.g.dart';

@JsonSerializable()
class NoticeModel {
  final String insertDate;
  final NoticeModel updateDate;
  final int noticeCode;
  final String noticeTitle;
  final String noticeContent;

  NoticeModel({
    required this.insertDate,
    required this.updateDate,
    required this.noticeCode,
    required this.noticeTitle,
    required this.noticeContent,
});

  factory NoticeModel.fromJson(Map<String, dynamic> json)
  => _$NoticeModelFromJson(json);
}