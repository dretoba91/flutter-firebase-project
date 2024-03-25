import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_projects/model/post.dart';
import 'package:flutter_firebase_projects/screens/create_post_page.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:path_provider/path_provider.dart';

class HomePage extends StatefulWidget {
  final String title;
  const HomePage({super.key, required this.title});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Stream<List<Post>> readPost() => FirebaseFirestore.instance
      .collection('Post')
      .orderBy('createdAt', descending: true)
      .snapshots()
      .map((snapShot) =>
          snapShot.docs.map((doc) => Post.fromJson(doc.data())).toList());

  Future downloadFile(String url) async {
    log(" url => $url");
    final tempDir = await getTemporaryDirectory();
    log(" tempDir => $tempDir");
    final fileName = url.split('files%').last.split('?').first;
    log(" fileName => $fileName");
    final path = '${tempDir.path}/$fileName';
    log(" path => $path");
    await Dio().download(url, path);
    if (url.contains('.mp4')) {
      await GallerySaver.saveVideo(path, toDcim: true);
    } else if (url.contains('.jpg')) {
      await GallerySaver.saveImage(path, toDcim: true);
    }
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Downloaded $fileName')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
        ),
        centerTitle: true,
      ),
      body: StreamBuilder(
        stream: readPost(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final posts = snapshot.data!;
            return ListView.separated(
              padding: const EdgeInsets.all(12),
              separatorBuilder: (context, index) => const SizedBox(
                height: 12,
              ),
              itemCount: posts.length,
              itemBuilder: (context, index) => Container(
                padding: const EdgeInsets.all(8),
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      children: [
                        Image.network(
                          posts[index].imageUrl,
                          height: 200,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                        Align(
                          alignment: Alignment.topRight,
                          child: Container(
                            color: Colors.pink[300],
                            child: IconButton(
                              onPressed: () {
                                downloadFile(posts[index].imageUrl);
                              },
                              icon: const Icon(Icons.download),
                            ),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    SizedBox(
                      height: 100,
                      child: Text(
                        posts[index].content,
                        style: const TextStyle(overflow: TextOverflow.fade),
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else {
            return const SizedBox(height: 0);
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const CreatePostPage()));
        },
        tooltip: 'Add Post',
        child: const Icon(Icons.add),
      ),
    );
  }
}
