import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:payment_tracking/services/auth_service.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:payment_tracking/services/data_service.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _AuthScreenState();
  }
}

class _AuthScreenState extends State<AuthScreen> {
  final _form = GlobalKey<FormState>();
  final _authService = AuthService();
  final _dataService = DataService();
  var _isLogin = true;
  var _enteredEmail = '';
  var _enteredPassword = '';

  void _submit() async {
    final isValid = _form.currentState!.validate();

    if (!isValid) {
      return;
    }
      
    _form.currentState!.save();

    try {
      if (_isLogin) {
        await _authService.signInWithEmail(_enteredEmail, _enteredPassword);
      } else {
        await _authService.signUpWithEmail(_enteredEmail, _enteredPassword);
      }
    } on FirebaseAuthException catch (error) {
      /*
        Scaffold Messenger -> "manages snackbars and materialbanners (bottom and top of screen, 
        respectively) for descendant scaffolds"
      */
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.message ?? 'Authentication failed.'),
        )
      );
    } catch (error) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('User could not be added to database.'),
        )
      );
    }
  }

  Future<void> _handleGoogleSignIn() async {
    final GoogleSignIn _googleSignIn = GoogleSignIn(
      clientId: '558149320953-5su65ak0ur496ihfpg1vephflgthsoip.apps.googleusercontent.com',
      scopes: [
        'email',
        'https://www.googleapis.com/auth/contacts.readonly',
      ],
    );
    try {
      GoogleSignInAccount? googleAccount = await _googleSignIn.signIn();

      _authService.signInWithGoogle(googleAccount);

    } catch (error) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('User could not be added to database.'),
        )
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Card(
                margin: const EdgeInsets.all(20),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Form(
                      key: _form,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextFormField(
                            decoration: const InputDecoration(
                              labelText: 'Email Address',
                            ),
                            keyboardType: TextInputType.emailAddress,
                            autocorrect: false,
                            textCapitalization: TextCapitalization.none,
                            validator: (value) {
                              if (value == null || 
                              value.trim().isEmpty || 
                              !value.contains('@')
                              ) {
                                return 'Please entor valid email address.';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _enteredEmail = value!;
                            },
                          ),
                          TextFormField(
                            decoration: const InputDecoration(
                              labelText: 'Password',
                            ),
                            obscureText: true,
                            validator: (value) {
                              if (
                                value == null || 
                                value.trim().length < 6
                              ) {
                                return 'Pass must be at least 6 characters.';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _enteredPassword = value!;
                            },
                          ),
                          const SizedBox(height: 12),
                          SignInButton(
                            Buttons.Google,
                            onPressed: _handleGoogleSignIn,
                          ),
                          Row( 
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(20),
                                child: ElevatedButton(
                                  onPressed: _submit, 
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Theme.of(context).colorScheme.primaryContainer
                                  ),
                                  child: Text(_isLogin ? 'Login' : 'Signup')
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(16),
                                child: ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      _isLogin = !_isLogin;
                                    });
                                  }, 
                                  child: Text(_isLogin 
                                    ? 'Create an account' 
                                    : 'I already have an account.'
                                  )
                                )
                              )
                            ],
                          )
                        ]
                      ),
                    ),
                  )
                )
              ),
            ]
          ),
        ),
      ),
    );

  }
}