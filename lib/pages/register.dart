import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../components/my_textfield.dart';
import '../services/auth_ervices.dart';
import 'DetailsFormPage.dart';

class RegisterOrLogin extends StatefulWidget {
  final Function()? onTap;
  const RegisterOrLogin({Key? key, this.onTap}) : super(key: key);

  @override
  _RegisterOrLoginState createState() => _RegisterOrLoginState();
}

class _RegisterOrLoginState extends State<RegisterOrLogin> {
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final nameController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  bool isPrivacyPolicyChecked = false;

  Future<void> signUserUp(BuildContext context) async {
    if (!isPrivacyPolicyChecked) {
      _showMessage(context, "You must agree to the privacy policy.");
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      if (passwordController.text == confirmPasswordController.text) {
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        );

        // Create user document in Firestore
        FirebaseFirestore.instance.collection('users').doc(userCredential.user?.uid).set({
          'name': nameController.text.trim(),
          'phone': phoneController.text.trim(),
          'email': emailController.text.trim(),
          'createdAt': FieldValue.serverTimestamp(),
        });

        Navigator.pop(context);

        // Navigate to UserForm screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => UserForm(),
          ),
        );

      } else {
        Navigator.pop(context);
        _showMessage(context, "Passwords don't match!");
      }
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      _showMessage(context, e.message ?? 'An error occurred.');
    } catch (_) {
      Navigator.pop(context);
      _showMessage(context, 'An unknown error occurred.');
    }
  }


  void _showMessage(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.deepPurple,
        title: Center(child: Text(message, style: const TextStyle(color: Colors.white))),
      ),
    );
  }

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
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/images/logo.png', height: 150),
                const SizedBox(height: 16),
                Text(
                  "Let's create an account",
                  style: TextStyle(
                    color: Colors.grey[800],
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                MyTextField(controller: emailController, hintText: "Enter Your Email", obscureText:false,),
                const SizedBox(height: 16),
                MyTextField(controller: passwordController, hintText: 'Enter Your Password', obscureText: true),
                const SizedBox(height: 16),
                MyTextField(controller: confirmPasswordController, hintText: 'Confirm Password', obscureText: true),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Checkbox(
                      value: isPrivacyPolicyChecked,
                      onChanged: (newValue) => setState(() => isPrivacyPolicyChecked = newValue!),
                    ),
                    GestureDetector(
                      onTap: _launchPrivacyPolicy,
                      child: const Text(
                        'I agree to the Privacy Policy',
                        style: TextStyle(color: Colors.blue, decoration: TextDecoration.underline),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => signUserUp(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 16),
                  ),
                  child: const Text('Sign Up', style: TextStyle(fontSize: 16, color: Colors.white)),
                ),
                const SizedBox(height: 24),
                Row(children: [
                  Expanded(child: Divider(thickness: 0.5, color: Colors.grey.shade400)),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Text("or Continue With"),
                  ),
                  Expanded(child: Divider(thickness: 0.5, color: Colors.grey.shade400)),
                ]),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: () async {
                    final userCredential = await AuthServices().signInWithGoogle(context);
                    if (userCredential != null) {
                      Navigator.pushReplacementNamed(context, '/home');
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    side: BorderSide(color: Colors.grey.shade300),
                    padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 12),
                  ),
                  icon: Image.asset('assets/images/google_logo.png', height: 20),
                  label: const Text('Continue with Google', style: TextStyle(fontSize: 16)),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Already have an account?', style: TextStyle(color: Colors.grey[700])),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: const Text(
                        'Login Now',
                        style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
