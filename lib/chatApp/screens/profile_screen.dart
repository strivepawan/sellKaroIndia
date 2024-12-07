import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io';
import 'dart:developer';
import '../../language/model/locale.dart';
import '../../pages/login.dart';
import '../api/apis.dart';
import '../helper/dialogs.dart';
import '../models/chat_user.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ProfileScreen extends StatefulWidget {
  final ChatUser user;

  const ProfileScreen({super.key, required this.user});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _image;
  String selectedLanguage = '';

  @override
  Widget build(BuildContext context) {
    final localeModel = Provider.of<LocaleModel>(context);
    final localizations = AppLocalizations.of(context);

    return GestureDetector(
      onTap: FocusScope.of(context).unfocus,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.arrow_back_rounded,
                color: Colors.white,
                size: 25,
              )),
          centerTitle: true,
          backgroundColor: Colors.green,
          title: Text(localizations!.profile_screen_title,
              style: GoogleFonts.roboto(
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  fontSize: 22)),
          actions: [
            PopupMenuButton<Locale>(
              icon: const Icon(Icons.language, color: Colors.white),
              onSelected: (Locale locale) {
                localeModel.setLocale(locale);
              },
              itemBuilder: (BuildContext context) => <PopupMenuEntry<Locale>>[
                PopupMenuItem<Locale>(
                  value: const Locale('en'),
                  child: Text(localizations.language_english),
                ),
                PopupMenuItem<Locale>(
                  value: const Locale('hi'),
                  child: Text(localizations.language_hindi),
                ),
              ],
            ),
          ],
        ),
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: FloatingActionButton.extended(
            backgroundColor: Colors.redAccent,
            onPressed: () async {
              try {
                Dialogs.showProgressBar(context);
                await APIs.updateActiveStatus(false);
                await APIs.auth.signOut().then((_) async {
                  await GoogleSignIn().signOut().then((_) {
                    Navigator.pop(context);
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => LoginPage(),
                      ),
                    );
                  }).catchError((error) {
                    Navigator.pop(context);
                    log('Google Sign-Out Error: $error');
                  });
                }).catchError((error) {
                  Navigator.pop(context);
                  log('Firebase Auth Sign-Out Error: $error');
                });
              } catch (error) {
                Navigator.pop(context);
                log('Logout Error: $error');
              }
            },
            icon: const Icon(
              Icons.logout,
              color: Colors.white,
            ),
            label: Text(
              localizations.logout,
              style:
                  const TextStyle(color: Colors.white, fontWeight: FontWeight.w800),
            ),
            elevation: 5,
          ),
        ),
        body: Form(
          key: _formKey,
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * .05),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * .02),
                  Stack(
                    children: [
                      _image != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(
                                  MediaQuery.of(context).size.height * .1),
                              child: Image.file(File(_image!),
                                  width:
                                      MediaQuery.of(context).size.height * .2,
                                  height:
                                      MediaQuery.of(context).size.height * .2,
                                  fit: BoxFit.cover))
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(
                                  MediaQuery.of(context).size.height * .2),
                              child: CachedNetworkImage(
                                width: MediaQuery.of(context).size.height * .15,
                                height:
                                    MediaQuery.of(context).size.height * .15,
                                fit: BoxFit.cover,
                                imageUrl: widget.user.image,
                                errorWidget: (context, url, error) =>
                                    const CircleAvatar(
                                        child: Icon(CupertinoIcons.person)),
                              ),
                            ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: MaterialButton(
                          elevation: 5,
                          onPressed: _showBottomSheet,
                          shape: const CircleBorder(),
                          color: Colors.white,
                          child: const Icon(Icons.edit, color: Colors.blue),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(widget.user.name,
                      style: GoogleFonts.roboto(
                          color: Colors.black54,
                          fontSize: 25,
                          fontWeight: FontWeight.w800)),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(widget.user.email,
                      style: GoogleFonts.roboto(
                          color: Colors.black54, fontSize: 20)),
                  SizedBox(height: MediaQuery.of(context).size.height * .05),
                  TextFormField(
                    initialValue: widget.user.name,
                    onSaved: (val) => APIs.me.name = val ?? '',
                    validator: (val) => val != null && val.isNotEmpty
                        ? null
                        : localizations.required_field,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 20),
                      prefixIcon: const Icon(Icons.person, color: Colors.blue),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: Colors.blue, width: 2),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: Colors.grey, width: 1),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      hintText: localizations.name_hint,
                      hintStyle: GoogleFonts.roboto(
                          color: Colors.black.withOpacity(0.5), fontSize: 14),
                      label: Text(localizations.name,
                          style: GoogleFonts.roboto(color: Colors.black)),
                      labelStyle: GoogleFonts.roboto(
                          fontSize: 16, fontWeight: FontWeight.w500),
                      floatingLabelBehavior: FloatingLabelBehavior.auto,
                      filled: true,
                      fillColor: Colors.grey[100],
                    ),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  TextFormField(
                    initialValue: widget.user.about,
                    onSaved: (val) => APIs.me.about = val ?? '',
                    validator: (val) => val != null && val.isNotEmpty
                        ? null
                        : localizations.required_field,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 20),
                      prefixIcon:
                          const Icon(Icons.info_outline, color: Colors.blue),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: Colors.blue, width: 2),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: Colors.grey, width: 1),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      hintText: localizations.about_hint,
                      hintStyle: GoogleFonts.roboto(
                          color: Colors.black.withOpacity(0.5), fontSize: 14),
                      label: Text(localizations.about,
                          style: GoogleFonts.roboto(color: Colors.black)),
                      labelStyle: GoogleFonts.roboto(
                          fontSize: 16, fontWeight: FontWeight.w500),
                      floatingLabelBehavior: FloatingLabelBehavior.auto,
                      filled: true,
                      fillColor: Colors.grey[100],
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * .05),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.blue,
                      shape: const StadiumBorder(),
                      minimumSize: Size(
                        MediaQuery.of(context).size.width * .2,
                        MediaQuery.of(context).size.height * .03,
                      ),
                      elevation:
                          10, // Icon and text color when button is pressed
                      shadowColor: Colors.blueAccent
                          .withOpacity(0.5), // Subtle shadow color
                      padding: const EdgeInsets.symmetric(
                          vertical: 16,
                          horizontal: 24), // More padding for a larger button
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        APIs.updateUserInfo().then((_) {
                          Dialogs.showSnackbar(
                              context, localizations.update_successful);
                        });
                      }
                    },
                    icon: const Icon(Icons.edit, size: 28),
                    label: Text(
                      localizations.update,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold, // Bold text for emphasis
                        fontFamily:
                            GoogleFonts.roboto().fontFamily, // Stylish font
                      ),
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * .02),
                  const SizedBox(
                    height: 10,
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      localizations.help_and_support,
                      style: GoogleFonts.roboto(
                          color: Colors.black87,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildSocialIcon(
                          icon: Icons.email,
                          color: Colors.blueAccent,
                          tooltip: localizations.email_icon_tooltip,
                          onTap: () =>
                              _launchURL('mailto:pawan.kumar@example.com'),
                        ),
                        _buildSocialIcon(
                          icon: FontAwesomeIcons.facebook,
                          color: Colors.blue,
                          tooltip: localizations.facebook_icon_tooltip,
                          onTap: () => _launchURL('https://facebook.com'),
                        ),
                        _buildSocialIcon(
                          icon: FontAwesomeIcons.instagram,
                          color: Colors.pinkAccent,
                          tooltip: localizations.instagram_icon_tooltip,
                          onTap: () => _launchURL('https://instagram.com'),
                        ),
                        _buildSocialIcon(
                          icon: FontAwesomeIcons.twitter,
                          color: Colors.lightBlueAccent,
                          tooltip: localizations.twitter_icon_tooltip,
                          onTap: () => _launchURL('https://twitter.com'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showBottomSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20), topRight: Radius.circular(20)),
      ),
      builder: (_) {
        return ListView(
          shrinkWrap: true,
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).size.height * .03,
            bottom: MediaQuery.of(context).size.height * .05,
          ),
          children: [
            Text(
              AppLocalizations.of(context)!.pick_profile_picture,
              textAlign: TextAlign.center,
              style:
                  GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.w500),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * .02),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: const CircleBorder(),
                    backgroundColor: Colors.white,
                    fixedSize: Size(MediaQuery.of(context).size.width * .3,
                        MediaQuery.of(context).size.height * .15),
                  ),
                  onPressed: () async {
                    final ImagePicker picker = ImagePicker();
                    final XFile? image = await picker.pickImage(
                        source: ImageSource.camera, imageQuality: 80);
                    if (image != null) {
                      setState(() => _image = image.path);
                      APIs.updateProfilePicture(File(_image!));
                      Navigator.pop(context);
                    }
                  },
                  child: Image.asset('assets/images/camera.png'),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: const CircleBorder(),
                    backgroundColor: Colors.white,
                    fixedSize: Size(MediaQuery.of(context).size.width * .3,
                        MediaQuery.of(context).size.height * .15),
                  ),
                  onPressed: () async {
                    final ImagePicker picker = ImagePicker();
                    final XFile? image = await picker.pickImage(
                        source: ImageSource.gallery, imageQuality: 80);
                    if (image != null) {
                      setState(() => _image = image.path);
                      APIs.updateProfilePicture(File(_image!));
                      Navigator.pop(context);
                    }
                  },
                  child: Image.asset('assets/images/gallery.png'),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _buildSocialIcon({
    required IconData icon,
    required Color color,
    required String tooltip,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Icon(
            icon,
            color: color,
            size: 30,
          ),
        ),
      ),
    );
  }

  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
