import 'dart:io';

import 'package:Insta_Clone/models/post.dart';
import 'package:Insta_Clone/models/user_data.dart';
import 'package:Insta_Clone/services/database.dart';
import 'package:Insta_Clone/services/storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class CreatePost extends StatefulWidget {
  @override
  _CreatePostState createState() => _CreatePostState();
}

class _CreatePostState extends State<CreatePost> {
  final ImagePicker _picker = ImagePicker();
  File _postImage;
  TextEditingController _captionController = TextEditingController();
  String _caption = "";
  bool _isLoading = false;

  _showSelectImageDialog() {
    return Platform.isIOS ? _iosBottomSheet() : _androidDialog();
  }

  _iosBottomSheet() {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoActionSheet(
          title: Text("Add Photo"),
          actions: [
            CupertinoActionSheetAction(
              onPressed: () => _handleImage(ImageSource.camera),
              child: Text("Take Photo"),
            ),
            CupertinoActionSheetAction(
              onPressed: () => _handleImage(ImageSource.gallery),
              child: Text("Choose from Gallery"),
            ),
          ],
          cancelButton: CupertinoActionSheetAction(
            child: Text("Cancel"),
            onPressed: () => Navigator.pop(context),
          ),
        );
      },
    );
  }

  _androidDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: Text("Add Photo"),
          children: [
            SimpleDialogOption(
              child: Text("Take Photo"),
              onPressed: () => _handleImage(ImageSource.camera),
            ),
            SimpleDialogOption(
              child: Text("Choose from Gallery"),
              onPressed: () => _handleImage(ImageSource.gallery),
            ),
            SimpleDialogOption(
              child: Text(
                "Cancel",
                style: TextStyle(color: Colors.redAccent),
              ),
              onPressed: () => Navigator.pop(context),
            )
          ],
        );
      },
    );
  }

  _handleImage(ImageSource source) async {
    Navigator.pop(context);
    PickedFile imageFile = await _picker.getImage(source: source);

    if (imageFile != null) {
      File image = await _cropImage(imageFile);
      setState(() {
        _postImage = File(image.path);
      });
    }
  }

  _cropImage(PickedFile imageFile) async {
    File croppedImage = await ImageCropper.cropImage(
      sourcePath: imageFile.path,
      aspectRatio: CropAspectRatio(ratioX: 1.0, ratioY: 1.0),
    );
    return croppedImage;
  }

  _submit() async {
    if (!_isLoading && _postImage != null && _caption.isNotEmpty) {
      setState(() {
        _isLoading = true;
      });

      String imageUrl = await Storage.uploadPost(_postImage);
      Post post = Post(
        imageUrl: imageUrl,
        caption: _caption,
        likeCount: 0,
        authorId: Provider.of<UserData>(context, listen: false).currentUserId,
        timestamp: Timestamp.fromDate(DateTime.now()),
      );
      Database.createPost(post);

      _captionController.clear();

      setState(() {
        _caption = "";
        _postImage = null;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "Create Post",
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: _submit,
          )
        ],
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          child: Container(
            height: height,
            child: Column(
              children: [
                _isLoading
                    ? Padding(
                        padding: EdgeInsets.only(
                          bottom: 10.0,
                        ),
                        child: LinearProgressIndicator(
                          backgroundColor: Colors.blue[200],
                          valueColor: AlwaysStoppedAnimation(Colors.blue),
                        ),
                      )
                    : SizedBox.shrink(),
                GestureDetector(
                  onTap: _showSelectImageDialog,
                  child: Container(
                    height: width,
                    width: width,
                    color: Colors.grey[300],
                    child: _postImage == null
                        ? Icon(
                            Icons.add_a_photo,
                            color: Colors.white70,
                            size: 150.0,
                          )
                        : Image(
                            image: FileImage(_postImage),
                            fit: BoxFit.cover,
                          ),
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30.0,
                  ),
                  child: TextField(
                    controller: _captionController,
                    style: TextStyle(
                      fontSize: 18.0,
                    ),
                    decoration: InputDecoration(
                      labelText: "Caption",
                    ),
                    onChanged: (input) => _caption = input,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
