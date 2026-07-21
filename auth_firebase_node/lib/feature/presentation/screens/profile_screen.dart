import 'dart:io';
import 'package:auth_firebase_node/feature/presentation/bloc/auth_bloc.dart';
import 'package:auth_firebase_node/feature/presentation/widgets/my_button.dart';
import 'package:auth_firebase_node/feature/presentation/widgets/my_textfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController nameController = TextEditingController();
  File? selectedImage;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
        maxWidth: 1920,
        maxHeight: 1920,
        preferredCameraDevice: CameraDevice.rear,
      );

      if (pickedFile != null) {
        final file = File(pickedFile.path);

        if (!await file.exists()) {
          throw Exception('Selected file does not exist');
        }

        final fileSize = await file.length();
        final fileName = pickedFile.path.split('/').last;
        final extension = fileName.split('.').last.toLowerCase();

        final validExtensions = [
          'jpg',
          'jpeg',
          'png',
          'gif',
          'webp',
          'heic',
          'heif',
        ];
        if (!validExtensions.contains(extension)) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.red,
              content: Text(
                'Invalid file type. Please select JPG, PNG, or GIF',
              ),
            ),
          );

          return;
        }

        if (fileSize > 10 * 1024 * 1024) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.red,
              content: Text('Image too large. Maximum size is 10MB'),
            ),
          );

          return;
        }

        setState(() {
          selectedImage = file;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text('Failed to pick image: $e'),
        ),
      );
    }
  }

  void _completeProfile() {
    final name = nameController.text.trim();

    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text('Please enter your name'),
        ),
      );
      return;
    }

    if (selectedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text('Please select a profile image'),
        ),
      );
      return;
    }

    context.read<AuthBloc>().add(CompleteProfileEvent(name, selectedImage!));
  }

  void _retryLoadUser() {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      context.read<AuthBloc>().add(LoadCurrentUserEvent(uid));
    }
  }

  Future<void> _handleLogout() async {
    context.read<AuthBloc>().add(LogoutEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile Screen'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: _handleLogout,
            tooltip: 'Logout',
          ),
        ],
      ),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state.authStatus == AuthStatus.failure) {
            ScaffoldMessenger.of(context)
              ..clearSnackBars()
              ..showSnackBar(
                SnackBar(
                  backgroundColor: Colors.red,
                  content: Text(state.message ?? 'Error occurred'),
                  duration: Duration(seconds: 5),
                  action: SnackBarAction(
                    label: 'RETRY',
                    textColor: Colors.white,
                    onPressed: _retryLoadUser,
                  ),
                ),
              );
          }
          if (state.authStatus == AuthStatus.loaded) {
            if (state.message == 'Profile completed successfully!') {
              ScaffoldMessenger.of(context)
                ..clearSnackBars()
                ..showSnackBar(
                  SnackBar(
                    backgroundColor: Colors.green,
                    content: Text('Profile completed successfully!'),
                  ),
                );
            }
          }
        },
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            if (state.authStatus == AuthStatus.loading ||
                state.authStatus == AuthStatus.initial) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text('Loading profile...'),
                  ],
                ),
              );
            }

            if (state.authStatus == AuthStatus.failure) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, size: 64, color: Colors.red),
                    SizedBox(height: 16),
                    Text(
                      'Failed to load profile',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 40),
                      child: Text(
                        state.message ?? 'Unknown error',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                    SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: _retryLoadUser,
                      icon: Icon(Icons.refresh),
                      label: Text('Retry'),
                    ),
                    SizedBox(height: 8),
                    TextButton(onPressed: _handleLogout, child: Text('Logout')),
                  ],
                ),
              );
            }

            if (state.authStatus == AuthStatus.loaded && state.user != null) {
              final user = state.user!;

              // Profile not completed
              if (!user.profileCompleted) {
                return SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: 40),
                      Text(
                        'Complete Your Profile',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 20),
                      GestureDetector(
                        onTap: _pickImage,
                        child: CircleAvatar(
                          radius: 60,
                          backgroundImage: selectedImage != null
                              ? FileImage(selectedImage!)
                              : null,
                          child: selectedImage == null
                              ? Icon(Icons.add_a_photo, size: 40)
                              : null,
                        ),
                      ),
                      if (selectedImage != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            'Image selected ✓',
                            style: TextStyle(color: Colors.green),
                          ),
                        ),
                      SizedBox(height: 20),
                      MyTextfield(
                        textController: nameController,
                        hintText: 'Enter Name',
                        prefixIcon: Icon(Icons.person),
                      ),
                      SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: MyButton(
                          btnText: 'Complete Profile',
                          onPressed: _completeProfile,
                          isLoging: state.authStatus == AuthStatus.loading,
                        ),
                      ),
                    ],
                  ),
                );
              }

              // Profile completed
              return Padding(
                padding: const EdgeInsets.all(20),
                child: ListView(
                  children: [
                    SizedBox(height: 20),
                    Center(
                      child: CircleAvatar(
                        radius: 50,
                        backgroundImage: user.imageBytes != null
                            ? MemoryImage(user.imageBytes!)
                            : null,
                        child: user.imageBytes == null
                            ? Icon(Icons.person, size: 40)
                            : null,
                      ),
                    ),
                    SizedBox(height: 20),
                    Card(
                      child: ListTile(
                        leading: Icon(Icons.person),
                        title: Text('Name'),
                        subtitle: Text(
                          user.name,
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ),
                    Card(
                      child: ListTile(
                        leading: Icon(Icons.email),
                        title: Text('Email'),
                        subtitle: Text(
                          user.email,
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    MyButton(btnText: "Logout", onPressed: _handleLogout),
                  ],
                ),
              );
            }

            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('No user data'),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _retryLoadUser,
                    child: Text('Load Profile'),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
