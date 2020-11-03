import 'dart:io';

import 'package:Insta_Clone/models/user.dart';
import 'package:Insta_Clone/services/database.dart';
import 'package:Insta_Clone/services/storage.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class EditProfile extends StatefulWidget {
  final User user;

  EditProfile({this.user});

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final _formkey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();
  File _profileImage;
  String _name, _bio = "";
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _name = widget.user.name;
    _bio = widget.user.bio;
  }

  Future _handleImageFromGallery() async {
    final imageFile = await _picker.getImage(source: ImageSource.gallery);

    if (imageFile != null) {
      setState(() {
        _profileImage = File(imageFile.path);
      });
    }
  }

  _displayProfileImage() {
    if (_profileImage == null) {
      if (widget.user.profileImageURL.isEmpty) {
        return AssetImage("assets/images/default_user_image.jpg");
      } else {
        return CachedNetworkImageProvider(widget.user.profileImageURL);
      }
    } else {
      return FileImage(_profileImage);
    }
  }

  _submit() async {
    if (_formkey.currentState.validate()) {
      _formkey.currentState.save();

      setState(() {
        _isLoading = true;
      });

      // * Update user in database
      String _profileImageURL = "";
      if (_profileImage == null) {
        _profileImageURL = widget.user.profileImageURL;
      } else {
        _profileImageURL = await Storage.uploadUserProfileImage(
          widget.user.profileImageURL,
          _profileImage,
        );
      }
      User user = User(
        id: widget.user.id,
        name: _name,
        profileImageURL: _profileImageURL,
        bio: _bio,
      );

      Database.updateUser(user);

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "Edit Profile",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: ListView(
          children: [
            _isLoading
                ? LinearProgressIndicator(
                    backgroundColor: Colors.blue[200],
                    valueColor: AlwaysStoppedAnimation(Colors.blue),
                  )
                : SizedBox.shrink(),
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: Form(
                key: _formkey,
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 60.0,
                      backgroundColor: Colors.grey,
                      backgroundImage: _displayProfileImage(),
                    ),
                    FlatButton(
                      onPressed: () => _handleImageFromGallery(),
                      child: Text(
                        "Change Profile Image",
                        style: TextStyle(
                          color: Theme.of(context).accentColor,
                          fontSize: 16.0,
                        ),
                      ),
                    ),
                    TextFormField(
                      initialValue: _name,
                      style: TextStyle(
                        fontSize: 18.0,
                      ),
                      decoration: InputDecoration(
                          icon: Icon(
                            Icons.person,
                            size: 30.0,
                          ),
                          labelText: "Name"),
                      validator: (input) => input.trim().length < 1
                          ? "Please enter valid name"
                          : null,
                      onSaved: (input) => _name = input,
                    ),
                    TextFormField(
                      initialValue: _bio,
                      style: TextStyle(
                        fontSize: 18.0,
                      ),
                      decoration: InputDecoration(
                          icon: Icon(
                            Icons.book,
                            size: 30.0,
                          ),
                          labelText: "Bio"),
                      validator: (input) => input.trim().length > 140
                          ? "Limit exceeded! Please keep upto 140 characters"
                          : null,
                      onSaved: (input) => _bio = input,
                    ),
                    Container(
                      margin: EdgeInsets.all(40.0),
                      height: 40.0,
                      width: 250.0,
                      child: FlatButton(
                        onPressed: _submit,
                        color: Colors.blue,
                        child: Text(
                          "Save Profile",
                          style: TextStyle(fontSize: 18.0, color: Colors.white),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
