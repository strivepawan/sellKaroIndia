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
        appBar: AppBar(
          title: Text(localizations!.profile_screen_title),
          actions: [
            PopupMenuButton<Locale>(
              icon:const  Icon(Icons.language, color: Colors.black),
              onSelected: (Locale locale) {
                localeModel.setLocale(locale);
              },
              itemBuilder: (BuildContext context) => <PopupMenuEntry<Locale>>[
                PopupMenuItem<Locale>(
                  value: Locale('en'),
                  child: Text(localizations.language_english),
                ),
                PopupMenuItem<Locale>(
                  value: Locale('hi'),
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
            icon: const Icon(Icons.logout),
            label: Text(localizations.logout),
          ),
        ),
        body: Form(
          key: _formKey,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * .05),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(width: MediaQuery.of(context).size.width, height: MediaQuery.of(context).size.height * .03),
                  Stack(
                    children: [
                      _image != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(MediaQuery.of(context).size.height * .1),
                              child: Image.file(File(_image!),
                                  width: MediaQuery.of(context).size.height * .2,
                                  height: MediaQuery.of(context).size.height * .2,
                                  fit: BoxFit.cover))
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(MediaQuery.of(context).size.height * .1),
                              child: CachedNetworkImage(
                                width: MediaQuery.of(context).size.height * .2,
                                height: MediaQuery.of(context).size.height * .2,
                                fit: BoxFit.cover,
                                imageUrl: widget.user.image,
                                errorWidget: (context, url, error) =>
                                    const CircleAvatar(child: Icon(CupertinoIcons.person)),
                              ),
                            ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: MaterialButton(
                          elevation: 1,
                          onPressed: _showBottomSheet,
                          shape: const CircleBorder(),
                          color: Colors.white,
                          child: const Icon(Icons.edit, color: Colors.blue),
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * .03),
                  Text(widget.user.email, style: const TextStyle(color: Colors.black54, fontSize: 16)),
                  SizedBox(height: MediaQuery.of(context).size.height * .05),
                  TextFormField(
                    initialValue: widget.user.name,
                    onSaved: (val) => APIs.me.name = val ?? '',
                    validator: (val) => val != null && val.isNotEmpty ? null : localizations.required_field,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.person, color: Colors.blue),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      hintText: localizations.name_hint,
                      label: Text(localizations.name),
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * .02),
                  TextFormField(
                    initialValue: widget.user.about,
                    onSaved: (val) => APIs.me.about = val ?? '',
                    validator: (val) => val != null && val.isNotEmpty ? null : localizations.required_field,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.info_outline, color: Colors.blue),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      hintText: localizations.about_hint,
                      label: Text(localizations.about),
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * .05),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      shape: const StadiumBorder(),
                      minimumSize: Size(MediaQuery.of(context).size.width * .5, MediaQuery.of(context).size.height * .06),
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        APIs.updateUserInfo().then((_) {
                          Dialogs.showSnackbar(context, localizations.update_successful);
                        });
                      }
                    },
                    icon: const Icon(Icons.edit, size: 28),
                    label: Text(localizations.update, style: const TextStyle(fontSize: 16)),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * .02),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      localizations.help_and_support,
                      style: const TextStyle(color: Colors.black54, fontSize: 16),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      IconButton(
                        onPressed: () => _launchURL('mailto:pawan.kumar@example.com'),
                        icon: const Icon(Icons.email),
                        color: Colors.blue,
                        tooltip: localizations.email_icon_tooltip,
                      ),
                      IconButton(
                        onPressed: () => _launchURL('https://facebook.com'),
                        icon: const FaIcon(FontAwesomeIcons.facebook),
                        color: Colors.blue,
                        tooltip: localizations.facebook_icon_tooltip,
                      ),
                      IconButton(
                        onPressed: () => _launchURL('https://instagram.com'),
                        icon: const FaIcon(FontAwesomeIcons.instagram),
                        color: Colors.blue,
                        tooltip: localizations.instagram_icon_tooltip,
                      ),
                      IconButton(
                        onPressed: () => _launchURL('https://twitter.com'),
                        icon: const FaIcon(FontAwesomeIcons.twitter),
                        color: Colors.blue,
                        tooltip: localizations.twitter_icon_tooltip,
                      ),
                    ],
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
        borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
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
              style: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.w500),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * .02),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: const CircleBorder(),
                    backgroundColor: Colors.white,
                    fixedSize: Size(MediaQuery.of(context).size.width * .3, MediaQuery.of(context).size.height * .15),
                  ),
                  onPressed: () async {
                    final ImagePicker picker = ImagePicker();
                    final XFile? image = await picker.pickImage(source: ImageSource.camera, imageQuality: 80);
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
                    fixedSize: Size(MediaQuery.of(context).size.width * .3, MediaQuery.of(context).size.height * .15),
                  ),
                  onPressed: () async {
                    final ImagePicker picker = ImagePicker();
                    final XFile? image = await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
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

  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
