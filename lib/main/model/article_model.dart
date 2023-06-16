import 'package:json_annotation/json_annotation.dart';

part 'article_model.g.dart';

@JsonSerializable()
class ArticleModel {
  // 검색 결과를 생성한 시간
  final DateTime? dateTime;
  // 총 검색 결과 개수
  final int? lastBuildDate;
  // 검색 시작 위치
  final int? start;
  // 한 번에 표시할 검색 결과 개수
  final int? display;
  // 뉴스 기사의 제목. 제목에서 검색어와 일치하는 부분
  final String? title;
  // 뉴스 기사 원문의 URL
  final String? originallink;
  // 뉴스 기사의 네이버 뉴스 URL. 네이버에 제공되지 않은 기사라면 기사 원문의 URL을 반환
  final String? link;
  // 뉴스 기사의 내용을 요약한 패시지 정보. 패시지 정보에서 검색어와 일치하는 부분
  final String? description;
  // 뉴스 기사가 네이버에 제공된 시간. 네이버에 제공되지 않은 기사라면 기사 원문이 제공된 시간
  final DateTime? pubDate;

  ArticleModel({
    this.dateTime,
    this.lastBuildDate,
    this.start,
    this.display,
    this.title,
    this.originallink,
    this.link,
    this.description,
    this.pubDate,
  });
  
  factory ArticleModel.fromJson(Map<String, dynamic> json)
  => _$ArticleModelFromJson(json);
}
