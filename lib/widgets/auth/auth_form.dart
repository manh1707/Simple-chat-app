import 'dart:io';

import 'package:chat_app/widgets/pickers/user_image_picker.dart';
import 'package:flutter/material.dart';

class AuthForm extends StatefulWidget {
  AuthForm(this.sumitFn, this.isLoading);
  final bool isLoading;
  final void Function(String email, String password, String username,
      File? image, bool isLogin, BuildContext ctx) sumitFn;
  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  var _isLogin = true;

  String? _userEmail;
  String? _userName;
  String? _userPassword;
  File? _userImageFile;
  void _pickImage(File image) {
    _userImageFile = image;
  }

  void _trySubmit() {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();

    if (!_isLogin && _userImageFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text('Please pick image '),
        backgroundColor: Theme.of(context).errorColor,
      ));
      return;
    }
    if (isValid) {
      _formKey.currentState!.save();
      widget.sumitFn(_userEmail.toString().trim(), _userName.toString().trim(),
          _userPassword.toString().trim(), _userImageFile, _isLogin, context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Center(
        child: Card(
          elevation: 5,
          margin: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (!_isLogin) UserImagePicker(_pickImage),
                    TextFormField(
                      autocorrect: false,
                      textCapitalization: TextCapitalization.none,
                      enableSuggestions: false,
                      key: const ValueKey('email'),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                      keyboardType: TextInputType.emailAddress,
                      decoration:
                          const InputDecoration(labelText: 'Email address'),
                      onSaved: (value) {
                        _userEmail = value!;
                      },
                    ),
                    if (!_isLogin)
                      TextFormField(
                        autocorrect: true,
                        textCapitalization: TextCapitalization.words,
                        enableSuggestions: false,
                        key: const ValueKey('name'),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'user name must be at least 4 charactor';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _userName = value!;
                        },
                        decoration:
                            const InputDecoration(labelText: 'User name'),
                      ),
                    TextFormField(
                      key: const ValueKey('password'),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Password must be at least 7 charactor';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(labelText: 'Pasword'),
                      obscureText: true,
                      onSaved: (value) {
                        _userPassword = value!;
                      },
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    if (widget.isLoading) CircularProgressIndicator(),
                    if (!widget.isLoading)
                      ElevatedButton(
                          onPressed: () {
                            _trySubmit();
                          },
                          child: Text(_isLogin ? 'Login' : 'SignUp')),
                    if (!widget.isLoading)
                      TextButton(
                          onPressed: () {
                            setState(() {
                              _isLogin = !_isLogin;
                            });
                          },
                          child: Text(_isLogin
                              ? 'Create acount'
                              : 'Have acount? Try to login'))
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
