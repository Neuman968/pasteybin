// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bin.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Bin _$BinFromJson(Map<String, dynamic> json) => Bin(
      id: json['id'] as String,
      content: json['content'] as String,
      createdTime: json['createdTime'] as String?,
      lastUpdatedTime: json['lastUpdatedTime'] as String?,
    );

Map<String, dynamic> _$BinToJson(Bin instance) => <String, dynamic>{
      'id': instance.id,
      'content': instance.content,
      'createdTime': instance.createdTime,
      'lastUpdatedTime': instance.lastUpdatedTime,
    };
