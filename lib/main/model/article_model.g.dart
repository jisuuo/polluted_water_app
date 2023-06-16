// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'article_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ArticleModel _$ArticleModelFromJson(Map<String, dynamic> json) => ArticleModel(
      dateTime: json['dateTime'] == null
          ? null
          : DateTime.parse(json['dateTime'] as String),
      lastBuildDate: json['lastBuildDate'] as int?,
      start: json['start'] as int?,
      display: json['display'] as int?,
      title: json['title'] as String?,
      originallink: json['originallink'] as String?,
      link: json['link'] as String?,
      description: json['description'] as String?,
      pubDate: json['pubDate'] == null
          ? null
          : DateTime.parse(json['pubDate'] as String),
    );

Map<String, dynamic> _$ArticleModelToJson(ArticleModel instance) =>
    <String, dynamic>{
      'dateTime': instance.dateTime?.toIso8601String(),
      'lastBuildDate': instance.lastBuildDate,
      'start': instance.start,
      'display': instance.display,
      'title': instance.title,
      'originallink': instance.originallink,
      'link': instance.link,
      'description': instance.description,
      'pubDate': instance.pubDate?.toIso8601String(),
    };
