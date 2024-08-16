// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import 'package:flutter_firebase_projects/model/post.dart';

class CreatePostPage extends StatefulWidget {
  final bool isEditMode;
  final Post? post;
  const CreatePostPage({
    super.key,
    required this.isEditMode,
    this.post,
  });

  @override
  State<CreatePostPage> createState() => _CreatePostPageState();
}

class _CreatePostPageState extends State<CreatePostPage> {
  final _bodyTextController = TextEditingController();

  String imageUrl = '';
  File? imageFile;
  UploadTask? uploadTask;

  @override
  void initState() {
    super.initState();
    if (widget.isEditMode) {
      setState(() {
        _bodyTextController.text = widget.post!.content;
        imageUrl = widget.post!.imageUrl;
      });
    }
  }

  Future _getFromCamera() async {
    XFile? result = await ImagePicker().pickImage(
      source: ImageSource.camera,
      maxHeight: 400,
      maxWidth: 400,
    );
    if (result == null) return;
    setState(() {
      imageFile = File(result.path);
    });
    uploadFile();
  }

  Future _getFromGallery() async {
    final result = await FilePicker.platform.pickFiles();
    if (result == null) return;
    setState(() {
      imageFile = File(result.files.single.path.toString());
    });
    uploadFile();
  }

  Future uploadFile() async {
    final imageFileName = imageFile!.path.split('/').last;
    final path = 'files/$imageFileName';
    final ref = FirebaseStorage.instance.ref().child(path);

    setState(() {
      uploadTask = ref.putFile(imageFile!);
    });

    final snapshot = await uploadTask!.whenComplete(() {});
    final imageUrl = await snapshot.ref.getDownloadURL();

    setState(() {
      this.imageUrl = imageUrl;
    });
  }

  Widget buildProgress() => StreamBuilder<TaskSnapshot>(
        stream: uploadTask?.snapshotEvents,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final data = snapshot.data!;

            double progress = data.bytesTransferred / data.totalBytes;
            return SizedBox(
              height: 50,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  LinearProgressIndicator(
                    value: progress,
                    backgroundColor: Colors.grey,
                    color: Colors.green,
                  ),
                  Center(
                    child: Text(
                      '${(100 * progress).roundToDouble()}%',
                      style: const TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ),
                ],
              ),
            );
          } else {
            return const SizedBox(height: 0);
          }
        },
      );

  Future createPost() async {
    if (_bodyTextController.text.isEmpty ||
        _bodyTextController.text.length > 80) {
      return;
    }
    if (imageUrl == '') return;
    final postId = widget.isEditMode ? widget.post!.id : getId();
    final postRef = FirebaseFirestore.instance.collection('Post').doc(postId);
    final user = FirebaseAuth.instance.currentUser!;

    final post = Post(
      createdAt: Timestamp.now(),
      imageUrl: imageUrl,
      id: postId,
      content: _bodyTextController.text,
      userId: user.uid,
      createdBy: user.displayName!,
      likes: 0,
    );

    final json = post.toJson();

    if (widget.isEditMode) {
      await postRef.update(json).whenComplete(() {
        const snackBar = SnackBar(content: Text('🎉🎈 UPDATED successfully!'));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      });
      Navigator.pop(context);
    } else {
      await postRef.set(json).whenComplete(() {
        const snackBar = SnackBar(content: Text('🎉🎈 Post Created!'));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      });

      Navigator.pop(context);
    }
  }

  String getId() {
    DateTime now = DateTime.now();
    String timestamp = DateFormat('yyyyMMddHHmmss').format(now);

    return timestamp;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(
          'Create Post',
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: TextFormField(
              controller: _bodyTextController,
              maxLines: 5,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                hintText: 'Write something here....',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Center(
            child: Container(
              height: 200,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(5),
                border: Border.all(),
              ),
              child: Material(
                child: InkWell(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title:
                            Text('From where do you want to take the image?'),
                        content: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextButton(
                              onPressed: () {
                                _getFromGallery();
                                Navigator.pop(context);
                              },
                              child: Text("Gallery"),
                            ),
                            SizedBox(
                              width: 16,
                            ),
                            TextButton(
                              onPressed: () {
                                _getFromCamera();
                                Navigator.pop(context);
                              },
                              child: Text("Camera"),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  child: imageUrl == ''
                      ? Padding(
                          padding: EdgeInsets.all(20),
                          child: Icon(
                            Icons.camera_alt,
                            color: Colors.grey,
                            size: 150.0,
                          ),
                        )
                      : Image.network(
                          imageUrl,
                          fit: BoxFit.cover,
                          height: 200,
                          width: 200,
                        ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 40,
          ),
          SizedBox(
            height: 48,
            width: 200,
            child: ElevatedButton(
              onPressed: () {
                createPost();
              },
              child: widget.isEditMode ? Text('Update') : Text('Post'),
            ),
          )
        ],
      ),
      bottomNavigationBar:
          uploadTask != null ? buildProgress() : const SizedBox(),
    );
  }
}
