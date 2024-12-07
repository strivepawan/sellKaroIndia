// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:ski/services/location_service.dart';

// class UserProfile extends StatefulWidget {
//   const UserProfile({Key? key}) : super(key: key);

//   @override
//   _UserProfileState createState() => _UserProfileState();
// }

// class _UserProfileState extends State<UserProfile> {
//   User? _user;
//   String _photoUrl = '';
//   String currentCity = 'Loading...';
//   String _phoneNumber = '';
//   String _email = '';

//   @override
//   void initState() {
//     super.initState();
//     _getUser();
//     _fetchCity();
//   }

//   Future<void> _fetchCity() async {
//     final city = await LocationService.getCurrentCity();
//     setState(() {
//       currentCity = city;
//     });
//   }

//   Future<void> _getUser() async {
//     User? user = FirebaseAuth.instance.currentUser;
//     if (user != null) {
//       setState(() {
//         _user = user;
//         _photoUrl = user.photoURL ?? '';
//         _phoneNumber = user.phoneNumber ?? '';
//         _email = user.email ?? '';
//       });
//     }
//   }



//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Profile'),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.edit),
//             onPressed: _editProfile,
//           ),
//         ],
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Container(
//                 decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(12),
//                     border: Border.all(color: const Color(0xFFDADDE5))),
//                 padding: const EdgeInsets.all(12.0),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   children: [
//                     Container(
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Container(
//                             height: 150,
//                             width: 150,
//                             decoration: BoxDecoration(
//                               shape: BoxShape.circle,
//                               image: DecorationImage(
//                                 image: _photoUrl.isNotEmpty
//                                     ? NetworkImage(_photoUrl)
//                                     : _user?.photoURL != null
//                                         ? NetworkImage(_user!.photoURL!)
//                                         : const AssetImage(
//                                                 'assets/images/empty.jpg')
//                                             as ImageProvider<Object>,
//                                 fit: BoxFit.cover,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     const SizedBox(height: 12),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Text(
//                           '     ${_user?.displayName ?? "No Name"}',
//                           style: const TextStyle(
//                               fontSize: 16, fontWeight: FontWeight.bold),
//                         ),
//                         Image.asset('assets/images/check.png'),
//                       ],
//                     ),
//                     const Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Icon(Icons.star, color: Colors.yellow),
//                         Text('4.5 Star Rating'),
//                       ],
//                     ),
//                     const SizedBox(height: 16),
//                     const Padding(
//                       padding: EdgeInsets.all(8.0),
//                       child: Divider(
//                         thickness: 1,
//                         color: Color(0xFFDADDE5),
//                       ),
//                     ),
//                     const SizedBox(height: 8),
//                     const Padding(
//                       padding: EdgeInsets.all(8.0),
//                       child: Divider(
//                         thickness: 1,
//                         color: Color(0xFFDADDE5),
//                       ),
//                     ),
//                     const SizedBox(height: 8),
//                     const Padding(
//                       padding: EdgeInsets.all(8.0),
//                       child: Divider(
//                         thickness: 1,
//                         color: Color(0xFFDADDE5),
//                       ),
//                     ),
//                     const Row(
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       children: [
//                         Text('CONTACT INFORMATION',
//                             style: TextStyle(color: Color(0xFFDADDE5))),
//                       ],
//                     ),
//                     const SizedBox(height: 8),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       children: [
//                         Image.asset('assets/images/PhoneCall.png'),
//                         Padding(
//                           padding: const EdgeInsets.only(left: 8),
//                           child: Text(
//                             _phoneNumber.isNotEmpty
//                                 ? 'Phone: $_phoneNumber'
//                                 : 'Phone: Not Available',
//                           ),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 8),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       children: [
//                         Image.asset('assets/images/Envelope.png'),
//                         Padding(
//                           padding: const EdgeInsets.only(left: 8),
//                           child: Text(
//                             _email.isNotEmpty ? _email : 'Email: Not Available',
//                           ),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 8),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       children: [
//                         Image.asset('assets/images/MapPinLine.png'),
//                         Padding(
//                           padding: const EdgeInsets.only(left: 8),
//                           child: Text(
//                             currentCity.isNotEmpty
//                                 ? currentCity
//                                 : 'Address: Not Available',
//                           ),
//                         ),
//                       ],
//                     ),
//                     const Padding(
//                       padding: EdgeInsets.all(8.0),
//                       child: Divider(
//                         thickness: 1,
//                         color: Color(0xFFDADDE5),
//                       ),
//                     ),
//                     const SizedBox(height: 8),
//                     const Padding(
//                       padding: EdgeInsets.all(8.0),
//                       child: Divider(
//                         thickness: 1,
//                         color: Color(0xFFDADDE5),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
            
//           ],
//         ),
//       ),
//     );
//   }

//   void _editProfile() {
//     String newName = _user?.displayName ?? '';
//     String newPhoneNumber = _phoneNumber;
//     String newEmail = _email;
//     String newCity = currentCity;

//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text('Edit Profile'),
//           content: SingleChildScrollView(
//             child: Column(
//               children: [
//                 TextFormField(
//                   initialValue: newName,
//                   decoration: const InputDecoration(
//                     labelText: 'Name',
//                   ),
//                   onChanged: (value) {
//                     newName = value;
//                   },
//                 ),
//                 TextFormField(
//                   initialValue: newPhoneNumber,
//                   decoration: const InputDecoration(
//                     labelText: 'Phone Number',
//                   ),
//                   onChanged: (value) {
//                     newPhoneNumber = value;
//                   },
//                 ),
//                 TextFormField(
//                   initialValue: newEmail,
//                   decoration: const InputDecoration(
//                     labelText: 'Email',
//                   ),
//                   onChanged: (value) {
//                     newEmail = value;
//                   },
//                 ),
//                 TextFormField(
//                   initialValue: newCity,
//                   decoration: const InputDecoration(
//                     labelText: 'Location',
//                   ),
//                   onChanged: (value) {
//                     newCity = value;
//                   },
//                 ),
//               ],
//             ),
//           ),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//               child: const Text('Cancel'),
//             ),
//             TextButton(
//               onPressed: () {
//                 _updateProfile(newName, newPhoneNumber, newEmail, newCity);
//                 Navigator.of(context).pop();
//               },
//               child: const Text('Save'),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   Future<void> _updateProfile(
//       String newName, String newPhoneNumber, String newEmail, String newCity) async {
//     try {
//       User? user = FirebaseAuth.instance.currentUser;
//       if (user != null) {
//         await user.updateDisplayName(newName);
//         await user.updateEmail(newEmail);

//         // Update the user's phone number and re-authenticate if needed
//         // Skipping phone number verification here, assuming it is already verified.

//         // Update the city in Firestore
//         await FirebaseFirestore.instance
//             .collection('users')
//             .doc(user.uid)
//             .update({
//           'city': newCity,
//           'phoneNumber': newPhoneNumber,
//         });

//         // Update local state after successful profile update
//         setState(() {
//           _user = FirebaseAuth.instance.currentUser;
//           _phoneNumber = newPhoneNumber;
//           _email = newEmail;
//           currentCity = newCity;
//         });
//       }
//     } catch (error) {
//       print('Failed to update profile: $error');
//       // Handle error
//     }
//   }
 
// }
import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import '../chatApp/api/apis.dart';
import '../chatApp/helper/dialogs.dart';
import '../chatApp/models/chat_user.dart';


//profile screen -- to show signed in user info
class ProfileScreen extends StatefulWidget {
  final ChatUser user;

  const ProfileScreen({super.key, required this.user});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _image;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // for hiding keyboard
      onTap: FocusScope.of(context).unfocus,
      child: Scaffold(
          //app bar
          appBar: AppBar(title: const Text('Profile Screen')),

          //floating button to log out
          floatingActionButton: Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: FloatingActionButton.extended(
                backgroundColor: Colors.redAccent,
                onPressed: () async {
                  //for showing progress dialog
                  Dialogs.showProgressBar(context);

                  await APIs.updateActiveStatus(false);

                  //sign out from app
                  await APIs.auth.signOut().then((value) async {
                    await GoogleSignIn().signOut().then((value) {
                      //for hiding progress dialog
                      Navigator.pop(context);

                      //for moving to home screen
                      Navigator.pop(context);

                      // APIs.auth = FirebaseAuth.instance;

                      //replacing home screen with login screen
                      // Navigator.pushReplacement(
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: (_) => const LoginScreen()));
                    });
                  });
                },
                icon: const Icon(Icons.logout),
                label: const Text('Logout')),
          ),

          //body
          body: Form(
            key: _formKey,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * .05),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // for adding some space
                    SizedBox(width: MediaQuery.of(context).size.width, height: MediaQuery.of(context).size.height * .03),

                    //user profile picture
                    Stack(
                      children: [
                        //profile picture
                        _image != null
                            ?

                            //local image
                            ClipRRect(
                                borderRadius:
                                    BorderRadius.circular(MediaQuery.of(context).size.height * .1),
                                child: Image.file(File(_image!),
                                    width: MediaQuery.of(context).size.height * .2,
                                    height: MediaQuery.of(context).size.height * .2,
                                    fit: BoxFit.cover))
                            :

                            //image from server
                            ClipRRect(
                                borderRadius:
                                    BorderRadius.circular(MediaQuery.of(context).size.height * .1),
                                child: CachedNetworkImage(
                                  width: MediaQuery.of(context).size.height * .2,
                                  height: MediaQuery.of(context).size.height * .2,
                                  fit: BoxFit.cover,
                                  imageUrl: widget.user.image,
                                  errorWidget: (context, url, error) =>
                                      const CircleAvatar(
                                          child: Icon(CupertinoIcons.person)),
                                ),
                              ),

                        //edit image button
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: MaterialButton(
                            elevation: 1,
                            onPressed: () {
                              _showBottomSheet();
                            },
                            shape: const CircleBorder(),
                            color: Colors.white,
                            child: const Icon(Icons.edit, color: Colors.blue),
                          ),
                        )
                      ],
                    ),

                    // for adding some space
                    SizedBox(height: MediaQuery.of(context).size.height * .03),

                    // user email label
                    Text(widget.user.email,
                        style: const TextStyle(
                            color: Colors.black54, fontSize: 16)),

                    // for adding some space
                    SizedBox(height: MediaQuery.of(context).size.height * .05),

                    // name input field
                    TextFormField(
                      initialValue: widget.user.name,
                      onSaved: (val) => APIs.me.name = val ?? '',
                      validator: (val) => val != null && val.isNotEmpty
                          ? null
                          : 'Required Field',
                      decoration: InputDecoration(
                          prefixIcon:
                              const Icon(Icons.person, color: Colors.blue),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12)),
                          hintText: 'eg. Pawan Kumar',
                          label: const Text('Name')),
                    ),

                    // for adding some space
                    SizedBox(height: MediaQuery.of(context).size.height * .02),

                    // about input field
                    TextFormField(
                      initialValue: widget.user.about,
                      onSaved: (val) => APIs.me.about = val ?? '',
                      validator: (val) => val != null && val.isNotEmpty
                          ? null
                          : 'Required Field',
                      decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.info_outline,
                              color: Colors.blue),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12)),
                          hintText: 'eg. Feeling Happy',
                          label: const Text('About')),
                    ),

                    // for adding some space
                    SizedBox(height: MediaQuery.of(context).size.height * .05),

                    // update profile button
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                          shape: const StadiumBorder(),
                          minimumSize: Size(MediaQuery.of(context).size.width * .5, MediaQuery.of(context).size.height * .06)),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          APIs.updateUserInfo().then((value) {
                            Dialogs.showSnackbar(
                                context, 'Profile Updated Successfully!');
                          });
                        }
                      },
                      icon: const Icon(Icons.edit, size: 28),
                      label:
                          const Text('UPDATE', style: TextStyle(fontSize: 16)),
                    )
                  ],
                ),
              ),
            ),
          )),
    );
  }

  // bottom sheet for picking a profile picture for user
  void _showBottomSheet() {
    showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        builder: (_) {
          return ListView(
            shrinkWrap: true,
            padding:
                EdgeInsets.only(top: MediaQuery.of(context).size.height * .03, bottom: MediaQuery.of(context).size.height * .05),
            children: [
              //pick profile picture label
              const Text('Pick Profile Picture',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),

              //for adding some space
              SizedBox(height: MediaQuery.of(context).size.height * .02),

              //buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  //pick from gallery button
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: const CircleBorder(),
                          fixedSize: Size(MediaQuery.of(context).size.width * .3, MediaQuery.of(context).size.height * .15)),
                      onPressed: () async {
                        final ImagePicker picker = ImagePicker();

                        // Pick an image
                        final XFile? image = await picker.pickImage(
                            source: ImageSource.gallery, imageQuality: 80);
                        if (image != null) {
                          log('Image Path: ${image.path}');
                          setState(() {
                            _image = image.path;
                          });

                          APIs.updateProfilePicture(File(_image!));

                          // for hiding bottom sheet
                          if (mounted) Navigator.pop(context);
                        }
                      },
                      child: const Icon(Icons.file_copy_rounded,size: 60,)
                      // Image.asset('images/add_image.png')
                      ),

                  //take picture from camera button
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: const CircleBorder(),
                          fixedSize: Size(MediaQuery.of(context).size.width * .3, MediaQuery.of(context).size.height * .15)),
                      onPressed: () async {
                        final ImagePicker picker = ImagePicker();

                        // Pick an image
                        final XFile? image = await picker.pickImage(
                            source: ImageSource.camera, imageQuality: 80);
                        if (image != null) {
                          log('Image Path: ${image.path}');
                          setState(() {
                            _image = image.path;
                          });

                          APIs.updateProfilePicture(File(_image!));

                          // for hiding bottom sheet
                          if (mounted) Navigator.pop(context);
                        }
                      },
                      child: const Icon(Icons.camera_alt_rounded,size: 60,)
                      // Image.asset('images/camera.png')
                      ),
                ],
              )
            ],
          );
        });
  }
}

