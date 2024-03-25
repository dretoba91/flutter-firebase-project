// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final Timestamp createdAt;
  final String imageUrl;
  final String id;
  final String content;

  Post({
    required this.createdAt,
    required this.imageUrl,
    required this.id,
    required this.content,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'createdAt': createdAt,
        'imageUrl': imageUrl,
        'content': content,
      };

  static Post fromJson(Map<String, dynamic> json) => Post(
        id: json['id'],
        createdAt: json['createdAt'],
        imageUrl: json['imageUrl'],
        content: json['content'],
      );
}
