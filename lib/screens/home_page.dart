import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_projects/authentication/login.dart';
import 'package:flutter_firebase_projects/model/post.dart';
import 'package:flutter_firebase_projects/screens/create_post_page.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

class HomePage extends StatefulWidget {
  final String title;
  const HomePage({super.key, required this.title});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late String userId;
  late Future<List<Post>> futurePosts;
  late List<Future<bool>> futureLikes;

  @override
  void initState() {
    super.initState();
    userId = FirebaseAuth.instance.currentUser!.uid;
    getAllPosts();
  }

  // Get all Post
  Future<void> getAllPosts() async {
    futurePosts = readPost();
    final posts = await futurePosts;

    futureLikes = posts.map((post) {
      return getLikeStatus(post.id);
    }).toList();
    log("future likes: $futureLikes");
    setState(() {});
  }

  ///    * Refactor the StreamBuilder widget to FutureBuilder widget
  ///
  ///    * Complete the like/unlike feature and the likes count feature.

  // Fetch all Posts

  ///    * Refactor the Stream type method to Future type method

  Future<List<Post>> readPost() async {
    final posts = await FirebaseFirestore.instance
        .collection('Post')
        .orderBy('createdAt', descending: true)
        .get();

    return posts.docs.map((doc) => Post.fromJson(doc.data())).toList();
  }

  /// Stream type method of fetching data.

  // Stream<List<Post>> readPost() => FirebaseFirestore.instance
  //     .collection('Post')
  //     .orderBy('createdAt', descending: true)
  //     .snapshots()
  //     .map((snapShot) =>
  //         snapShot.docs.map((doc) => Post.fromJson(doc.data())).toList());

  Future downloadFile(String url) async {
    // get directory from device
    final tempDir = await getTemporaryDirectory();
    // filter to get the file name
    final fileName = url.split('files%').last.split('?').first;
    // create a file path
    final path = '${tempDir.path}/$fileName';
    // download the file using the url and path
    await Dio().download(url, path);

    // saving to the device
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

  // log out

  Future logOut() async {
    // var message = '';
    try {
      await FirebaseAuth.instance.signOut();
      Future.delayed(const Duration(milliseconds: 3), () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const LoginPage(),
          ),
        );
      });
    } on FirebaseAuthException catch (e) {
      Fluttertoast.showToast(
        msg: e.toString(),
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.SNACKBAR,
        backgroundColor: Colors.black54,
        textColor: Colors.white,
        fontSize: 14.0,
      );
    }
  }

  // get created date

  String getCreatedDate(Timestamp createdAt) {
    final format = DateFormat('d MMM y');
    return format.format(createdAt.toDate());
  }

  // get created time
  String getCreatedTime(Timestamp createdAt) {
    final format = DateFormat('jm');
    return format.format(createdAt.toDate());
  }

  // Handle like and unlike posts

  Future<void> handleLikePost(Post post) async {
    try {
      final likeRef = FirebaseFirestore.instance
          .collection('Post')
          .doc(post.id)
          .collection('Likes')
          .doc(userId);

      final likeSnapshot = await likeRef.get();

      if (!likeSnapshot.exists) {
        likeRef.set({'userId': likeSnapshot.id});
      } else {
        likeRef.delete();
      }
    } on FirebaseAuthException catch (e) {
      Fluttertoast.showToast(
        msg: e.toString(),
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.SNACKBAR,
        backgroundColor: Colors.black54,
        textColor: Colors.white,
        fontSize: 14.0,
      );
    }
    getAllPosts();
  }

  Future<bool> getLikeStatus(String postId) async {
    Future<bool> postLiked = FirebaseFirestore.instance
        .collection('Post')
        .doc(postId)
        .collection('Likes')
        .doc(userId)
        .get()
        .then((snapShot) => snapShot.exists);
    return postLiked;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
        ),
        centerTitle: true,
        elevation: 0,
        actions: [
          GestureDetector(
            onTap: logOut,
            child: const Padding(
              padding: EdgeInsets.only(
                right: 20,
              ),
              child: Icon(
                Icons.logout_outlined,
              ),
            ),
          ),
        ],
      ),
      body: FutureBuilder<List<Post>>(
        future: futurePosts,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final posts = snapshot.data!;
            return ListView.separated(
              padding: const EdgeInsets.all(12),
              separatorBuilder: (context, index) => const SizedBox(
                height: 12,
              ),
              itemCount: posts.length,
              itemBuilder: (context, index) => InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CreatePostPage(
                        isEditMode: true,
                        post: posts[index],
                      ),
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(8),
                  color: Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            posts[index].createdBy,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.black54,
                            ),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                getCreatedDate(posts[index].createdAt),
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black54,
                                ),
                              ),
                              Text(
                                getCreatedTime(posts[index].createdAt),
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black54,
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
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
                        height: 50,
                        child: Text(
                          posts[index].content,
                          style: const TextStyle(
                            overflow: TextOverflow.fade,
                          ),
                          softWrap: true,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      GestureDetector(
                        onTap: () {
                          handleLikePost(posts[index]);
                        },
                        child: FutureBuilder(
                          future: futureLikes[index],
                          builder: (context, snapshot) => Icon(
                            snapshot.data == true
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          } else {
            return const Center(
              child: SizedBox(
                height: 200,
                child: Text(
                  'No posts yet!!! 🙇🏽‍♂️🙇🏽‍♀️',
                  style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.w600,
                    color: Colors.black54,
                  ),
                ),
              ),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const CreatePostPage(
                isEditMode: false,
              ),
            ),
          );
        },
        tooltip: 'Add Post',
        child: const Icon(Icons.add),
      ),
    );
  }
}


/// StreamBuilder widget
/// 
// StreamBuilder(
//         stream: readPost(),
//         builder: (context, snapshot) {
//           if (snapshot.hasData) {
//             final posts = snapshot.data!;
//             return ListView.separated(
//               padding: const EdgeInsets.all(12),
//               separatorBuilder: (context, index) => const SizedBox(
//                 height: 12,
//               ),
//               itemCount: posts.length,
//               itemBuilder: (context, index) => InkWell(
//                 onTap: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => CreatePostPage(
//                         isEditMode: true,
//                         post: posts[index],
//                       ),
//                     ),
//                   );
//                 },
//                 child: Container(
//                   padding: const EdgeInsets.all(8),
//                   color: Colors.white,
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         children: [
//                           Text(
//                             posts[index].createdBy,
//                             style: const TextStyle(
//                               fontSize: 16,
//                               fontWeight: FontWeight.w600,
//                               color: Colors.black54,
//                             ),
//                           ),
//                           Column(
//                             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                             crossAxisAlignment: CrossAxisAlignment.end,
//                             children: [
//                               Text(
//                                 getCreatedDate(posts[index].createdAt),
//                                 style: const TextStyle(
//                                   fontSize: 13,
//                                   fontWeight: FontWeight.w600,
//                                   color: Colors.black54,
//                                 ),
//                               ),
//                               Text(
//                                 getCreatedTime(posts[index].createdAt),
//                                 style: const TextStyle(
//                                   fontSize: 13,
//                                   fontWeight: FontWeight.w400,
//                                   color: Colors.black54,
//                                 ),
//                               ),
//                             ],
//                           )
//                         ],
//                       ),
//                       const SizedBox(
//                         height: 10,
//                       ),
//                       Stack(
//                         children: [
//                           Image.network(
//                             posts[index].imageUrl,
//                             height: 200,
//                             width: double.infinity,
//                             fit: BoxFit.cover,
//                           ),
//                           Align(
//                             alignment: Alignment.topRight,
//                             child: Container(
//                               color: Colors.pink[300],
//                               child: IconButton(
//                                 onPressed: () {
//                                   downloadFile(posts[index].imageUrl);
//                                 },
//                                 icon: const Icon(Icons.download),
//                               ),
//                             ),
//                           )
//                         ],
//                       ),
//                       const SizedBox(
//                         height: 12,
//                       ),
//                       SizedBox(
//                         height: 50,
//                         child: Text(
//                           posts[index].content,
//                           style: const TextStyle(
//                             overflow: TextOverflow.fade,
//                           ),
//                           softWrap: true,
//                           maxLines: 2,
//                           overflow: TextOverflow.ellipsis,
//                         ),
//                       ),
//                       const SizedBox(
//                         height: 20,
//                       ),
//                       GestureDetector(
//                         onTap: () {
//                           handleLikePost(posts[index]);
//                         },
//                         child: FutureBuilder(
//                           future: futureLikes[index],
//                           builder: (context, snapshot) => Icon(
//                             snapshot.data == true
//                                 ? Icons.favorite
//                                 : Icons.favorite_border,
//                             color: Colors.red,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             );
//           } else {
//             return const Center(
//               child: SizedBox(
//                 height: 200,
//                 child: Text(
//                   'No posts yet!!! 🙇🏽‍♂️🙇🏽‍♀️',
//                   style: TextStyle(
//                     fontSize: 19,
//                     fontWeight: FontWeight.w600,
//                     color: Colors.black54,
//                   ),
//                 ),
//               ),
//             );
//           }
//         },
//       ),
