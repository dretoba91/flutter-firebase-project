// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';

class CreatePostPage extends StatefulWidget {
  const CreatePostPage({super.key});

  @override
  State<CreatePostPage> createState() => _CreatePostPageState();
}

class _CreatePostPageState extends State<CreatePostPage> {
  String imageUrl = '';

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
                              onPressed: () {},
                              child: Text("Gallery"),
                            ),
                            SizedBox(
                              width: 16,
                            ),
                            TextButton(
                              onPressed: () {},
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
              onPressed: (){}, 
              child: Text(
                'Post Picture'
              ),
            ),
          )
        ],
      ),
    );
  }
}
