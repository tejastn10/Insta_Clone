import 'package:Insta_Clone/models/user.dart';
import 'package:Insta_Clone/services/database.dart';
import 'package:flutter/material.dart';

class EditProfile extends StatefulWidget {
  final User user;

  EditProfile({this.user});

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final _formkey = GlobalKey<FormState>();
  String _name, _bio = "";

  @override
  void initState() {
    super.initState();
    _name = widget.user.name;
    _bio = widget.user.bio;
  }

  _submit() {
    if (_formkey.currentState.validate()) {
      _formkey.currentState.save();

      // * Update user in database
      String _profileImageURL = "";
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
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Form(
              key: _formkey,
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 60.0,
                  ),
                  FlatButton(
                    onPressed: () => print("Change Profile image"),
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
        ),
      ),
    );
  }
}
