// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final Timestamp createdAt;
  final String imageUrl;
  Post({
    required this.createdAt,
    required this.imageUrl,
  });

  Map<String, dynamic> toJson() => {
        'createdAt': createdAt,
        'imageUrl': imageUrl,
      };

  static Post fromJson(Map<String, dynamic> json) => Post(
    createdAt: json['createdAt'], 
    imageUrl: json['imageUrl']
  );
}
