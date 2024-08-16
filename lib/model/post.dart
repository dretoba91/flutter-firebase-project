// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final Timestamp createdAt;
  final String imageUrl;
  final String id;
  final String content;
  final String userId;
  final String createdBy;
  final int likes;

  Post({
    required this.createdAt,
    required this.imageUrl,
    required this.id,
    required this.content,
    required this.userId,
    required this.createdBy,
    required this.likes,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'createdAt': createdAt,
        'imageUrl': imageUrl,
        'content': content,
        'userId': userId,
        'createdBy': createdBy,
        'likes': likes,
      };

  static Post fromJson(Map<String, dynamic> json) => Post(
        id: json['id'],
        createdAt: json['createdAt'],
        imageUrl: json['imageUrl'],
        content: json['content'],
        userId: json['userId'],
        createdBy: json['createdBy'],
        likes: json['likes'],
      );
}
