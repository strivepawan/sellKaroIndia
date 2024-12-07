import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../components/my_button.dart';
import '../components/my_textfield.dart';
import '../components/square_tile.dart';
import '../services/auth_ervices.dart';

class RegisterOrLogin extends StatefulWidget {
  final Function()? onTap;
  RegisterOrLogin({Key? key, this.onTap}) : super(key: key);

  @override
  _RegisterOrLoginState createState() => _RegisterOrLoginState();
}

class _RegisterOrLoginState extends State<RegisterOrLogin> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  bool isPrivacyPolicyChecked = false;

  // Sign up user method
  Future<void> signUserUp(BuildContext context) async {
    if (!isPrivacyPolicyChecked) {
      showErrorMessage(context, "You must agree to the privacy policy.");
      return;
    }

    // Show loading indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    try {
      if (passwordController.text == confirmPasswordController.text) {
        // Create a new user
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        );

        // Check if user exists in the database
        if (await AuthServices().userExists()) {
          debugPrint('User exists. Navigating to HomeScreen.');
        } else {
          debugPrint('User does not exist. Creating new user.');
          await AuthServices().createUser();
        }

        // Dismiss loading indicator
        Navigator.pop(context);

        // Navigate to home screen or any other screen
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        // Show error message if passwords don't match
        Navigator.pop(context);
        showErrorMessage(context, "Passwords don't match!");
      }
    } on FirebaseAuthException catch (e) {
      // Dismiss loading indicator and show error message
      Navigator.pop(context);
      showErrorMessage(context, e.message ?? 'An error occurred.');
    } catch (e) {
      // Catch any other exceptions and dismiss the loading indicator
      Navigator.pop(context);
      showErrorMessage(context, 'An unknown error occurred.');
    }
  }

  // Show error message
  void showErrorMessage(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.deepPurple,
          title: Center(
            child: Text(
              message,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        );
      },
    );
  }

  // Launch URL
  void _launchPrivacyPolicy() async {
    const url = 'https://sites.google.com/view/sellkaroindia-com/home';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo
                SizedBox(
                  height: 150,
                  width: 300,
                  child: Image.asset('assets/images/logo.png'),
                ),
                const SizedBox(height: 8),
                // Register text
                Text(
                  "Let's create an account",
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 25),
                // Email text field
                MyTextField(
                  controller: emailController,
                  hintText: "Enter your email",
                  obscureText: false,
                ),
                const SizedBox(height: 16),
                // Password text field
                MyTextField(
                  controller: passwordController,
                  hintText: 'Enter your password',
                  obscureText: true,
                ),
                const SizedBox(height: 16),
                // Confirm password text field
                MyTextField(
                  controller: confirmPasswordController,
                  hintText: 'Confirm password',
                  obscureText: true,
                ),
                const SizedBox(height: 8),
                // Privacy Policy checkbox
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Checkbox(
                      value: isPrivacyPolicyChecked,
                      onChanged: (bool? newValue) {
                        setState(() {
                          isPrivacyPolicyChecked = newValue!;
                        });
                      },
                    ),
                    GestureDetector(
                      onTap: _launchPrivacyPolicy,
                      child:const  Text(
                        'I agree to the Privacy Policy',
                        style: TextStyle(
                          color: Colors.blue,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                // Sign Up button
                MyButton(
                  onTap: () => signUserUp(context),
                  text: 'Sign Up',
                ),
                const SizedBox(height: 12),
                // Or continue with
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: Colors.grey.shade400,
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.0),
                        child: Text("or Continue With"),
                      ),
                      Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: Colors.grey.shade400,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                // Google + Apple sign in buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SquareTile(
                      imagePath: 'assets/images/google_logo.png',
                      onTap: () async {
                        // Call the signInWithGoogle method
                        final userCredential = await AuthServices().signInWithGoogle(context);
                        if (userCredential != null) {
                          // Handle successful sign-in
                          print("Google sign-in successful");
                          // Navigate to home screen or any other screen
                          Navigator.pushReplacementNamed(context, '/home');
                        }
                      },
                    ),
                    const SizedBox(width: 10),
                    SquareTile(
                      imagePath: 'assets/images/apple_logo.png',
                      onTap: () {},
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                // Already have an account? Login now
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already have an account?',
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: const Text(
                        'Login Now',
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    
                  ],
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
