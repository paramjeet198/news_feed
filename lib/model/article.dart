import 'package:cloud_firestore/cloud_firestore.dart';

class Article {
  final String title;
  final String description;
  final String imageUrl;
  final Timestamp timeStamp;

  const Article({
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.timeStamp,
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      title: json['title'] as String,
      description: json['description'] as String,
      imageUrl: json['imageUrl'] as String,
      timeStamp: json['timeStamp'] as Timestamp,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
      'timeStamp': timeStamp,
    };
  }

  Article copyWith({
    String? title,
    String? description,
    String? imageUrl,
    Timestamp? timeStamp,
  }) {
    return Article(
      title: title ?? this.title,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      timeStamp: timeStamp ?? this.timeStamp,
    );
  }
}
