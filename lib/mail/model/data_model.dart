import 'package:json_annotation/json_annotation.dart';

part 'data_model.g.dart';

@JsonSerializable()
class DataModel {
  final String content;
  final String title;

  DataModel({
    required this.content,
    required this.title,
  });

  factory DataModel.fromJson(Map<String, dynamic> json)
  => _$DataModelFromJson(json);

  // 요청을 보낼 때는 toJson
  Map<String, dynamic> toJson() => _$DataModelToJson(this);
}