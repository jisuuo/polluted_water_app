// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notice_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NoticeModel _$NoticeModelFromJson(Map<String, dynamic> json) => NoticeModel(
      insertDate: json['insertDate'] as String,
      updateDate:
          NoticeModel.fromJson(json['updateDate'] as Map<String, dynamic>),
      noticeCode: json['noticeCode'] as int,
      noticeTitle: json['noticeTitle'] as String,
      noticeContent: json['noticeContent'] as String,
    );

Map<String, dynamic> _$NoticeModelToJson(NoticeModel instance) =>
    <String, dynamic>{
      'insertDate': instance.insertDate,
      'updateDate': instance.updateDate,
      'noticeCode': instance.noticeCode,
      'noticeTitle': instance.noticeTitle,
      'noticeContent': instance.noticeContent,
    };
