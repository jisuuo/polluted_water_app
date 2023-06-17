// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'article_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ArticleModel _$ArticleModelFromJson(Map<String, dynamic> json) => ArticleModel(
      title: json['title'] as String,
      orginallink: json['orginallink'] as String,
      link: json['link'] as String,
      description: json['description'] as String,
      pubDate: DateTime.parse(json['pubDate'] as String),
    );

Map<String, dynamic> _$ArticleModelToJson(ArticleModel instance) =>
    <String, dynamic>{
      'title': instance.title,
      'orginallink': instance.orginallink,
      'link': instance.link,
      'description': instance.description,
      'pubDate': instance.pubDate.toIso8601String(),
    };
