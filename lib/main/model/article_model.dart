import 'package:json_annotation/json_annotation.dart';

part 'article_model.g.dart';

@JsonSerializable()
class ArticleModel {
  final String title;
  final String orginallink;
  final String link;
  final String description;
  final DateTime pubDate;

  ArticleModel({
    required this.title,
    required this.orginallink,
    required this.link,
    required this.description,
    required this.pubDate,
  });

  factory ArticleModel.fromJson(Map<String, dynamic> json) =>
      _$ArticleModelFromJson(json);
}
