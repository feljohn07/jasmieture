// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:hive/hive.dart';

part 'choice.g.dart';

@HiveType(typeId: 5)
class Choice extends HiveObject {
  @HiveField(0)
  String choiceId;

  @HiveField(1)
  String choice;

  @HiveField(2)
  String imagePath;

  @HiveField(3)
  String audio;

  Choice({
    required this.choiceId,
    required this.choice,
    required this.imagePath,
    required this.audio,
  });

  Choice copyWith({
    String? choiceId,
    String? choice,
    String? imagePath,
    String? audio,
  }) {
    return Choice(
      choiceId: choiceId ?? this.choiceId,
      choice: choice ?? this.choice,
      imagePath: imagePath ?? this.imagePath,
      audio: audio ?? this.audio,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'choiceId': choiceId,
      'choice': choice,
      'imagePath': imagePath,
      'audio': audio,
    };
  }

  factory Choice.fromMap(Map<String, dynamic> map) {
    return Choice(
      choiceId: map['choiceId'] as String,
      choice: map['choice'] as String,
      imagePath: map['imagePath'] as String,
      audio: map['audio'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Choice.fromJson(String source) => Choice.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Choice(choiceId: $choiceId, choice: $choice, imagePath: $imagePath, audio: $audio)';
  }

  @override
  bool operator ==(covariant Choice other) {
    if (identical(this, other)) return true;
  
    return 
      other.choiceId == choiceId &&
      other.choice == choice &&
      other.imagePath == imagePath &&
      other.audio == audio;
  }

  @override
  int get hashCode {
    return choiceId.hashCode ^
      choice.hashCode ^
      imagePath.hashCode ^
      audio.hashCode;
  }
}
