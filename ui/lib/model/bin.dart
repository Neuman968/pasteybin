import 'package:json_annotation/json_annotation.dart';

part 'bin.g.dart';

@JsonSerializable()
class Bin {
  Bin({
    required this.id,
    required this.content,
    this.createdTime,
    this.lastUpdatedTime,
  });

  final String id;

  final String content;

  final String? createdTime;

  final String? lastUpdatedTime;

  factory Bin.fromJson(Map<String, dynamic> json) => _$BinFromJson(json);

  Map<String, dynamic> toJson() => _$BinToJson(this);
}
