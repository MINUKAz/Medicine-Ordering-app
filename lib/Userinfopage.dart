import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'HomePage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:cloudinary/cloudinary.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:convert';


class UserInfoPage extends StatefulWidget {
  UserInfoPage({Key? key}) : super(key: key);
  String? _base64Image;
  XFile? _webImage;

  @override
  _UserInfoPageState createState() => _UserInfoPageState();
}

class _UserInfoPageState extends State<UserInfoPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _provinceController = TextEditingController();
  final TextEditingController _districtController = TextEditingController();
  final TextEditingController _nicController = TextEditingController();
  final TextEditingController _bloodTypeController = TextEditingController();
  bool _isLoading = false;
  final ImagePicker _picker = ImagePicker();
  File? _selectedImage;
  String? _imageUrl;

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        if (kIsWeb) {
          // Handle web platform
          setState(() => widget._webImage = image);
          final bytes = await image.readAsBytes();
          setState(() => widget._base64Image = base64Encode(bytes));
        } else {
          // Handle mobile platform
          setState(() => _selectedImage = File(image.path));
        }
      }
    } catch (e) {
      print('Error picking image: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking image: $e')),
      );
    }
  }

  final Cloudinary _cloudinary = Cloudinary.signedConfig(
    apiKey: '628515619397789',
    apiSecret: 'hrQRvjoMsIq_Jgxqo6PGJOwnCJA',
    cloudName: 'dwez9bgmh',
  );

  Future<void> _saveUserInfo() async {
    // Validate all fields are filled
    if (_nameController.text.isEmpty ||
        _phoneController.text.isEmpty ||
        _addressController.text.isEmpty ||
        _provinceController.text.isEmpty ||
        _districtController.text.isEmpty ||
        _nicController.text.isEmpty ||
        _bloodTypeController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }
      setState(() => _isLoading = true);

      try {
        final user = FirebaseAuth.instance.currentUser;
        if (user == null) throw Exception('No authenticated user found');

        String? cloudinaryUrl;
        
        // Handle image upload based on platform
        if (_selectedImage != null || widget._webImage != null) {
          if (kIsWeb && widget._webImage != null) {
            // Web platform - upload using bytes
            final bytes = await widget._webImage!.readAsBytes();
            final response = await _cloudinary.upload(
              fileBytes: bytes,
              resourceType: CloudinaryResourceType.image,
              folder: 'profile_pictures',
              fileName: 'profile_${user.uid}',
            );
            cloudinaryUrl = response.secureUrl;
          } else if (_selectedImage != null) {
            // Mobile platform - upload using file path
            final response = await _cloudinary.upload(
              file: _selectedImage!.path,
              resourceType: CloudinaryResourceType.image,
              folder: 'profile_pictures',
              fileName: 'profile_${user.uid}',
            );
            cloudinaryUrl = response.secureUrl;
          }
        }

        final userData = {
          'uid': user.uid,
          'email': user.email,
          'name': _nameController.text.trim(),
          'phone': _phoneController.text.trim(),
          'address': _addressController.text.trim(),
          'province': _provinceController.text.trim(),
          'district': _districtController.text.trim(),
          'nic': _nicController.text.trim(),
          'bloodType': _bloodTypeController.text.trim(),
          'profilePicture': cloudinaryUrl,
          'profileImageBase64': widget._base64Image,
          'createdAt': FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
      };


      await FirebaseFirestore.instance
      .collection('users')
      .doc(user.uid)
      .set(userData, SetOptions(merge: true));

      // Save to Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .set(userData, SetOptions(merge: true));

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile saved successfully')),
      );

      // Navigate to HomePage after saving user info
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    } catch (e) {
      print('Error saving user info: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save user info: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Complete Your Profile',
          style: TextStyle(
            color: Colors.black54,
            fontWeight: FontWeight.normal,
            fontSize: 16,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40),
                _buildProfilePicture(), // Add this line
                const SizedBox(height: 30),
                const Text(
                  'Please provide the following information:',
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 30),
                _buildTextField(_nameController, "Full Name"),
                const SizedBox(height: 20),
                _buildTextField(_phoneController, "Phone Number"),
                const SizedBox(height: 20),
                _buildTextField(_addressController, "Address"),
                const SizedBox(height: 20),
                _buildTextField(_provinceController, "Province"),
                const SizedBox(height: 20),
                _buildTextField(_districtController, "District"),
                const SizedBox(height: 20),
                _buildTextField(_nicController, "NIC No."),
                const SizedBox(height: 20),
                _buildTextField(_bloodTypeController, "Blood Type"),
                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _saveUserInfo,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28),
                      ),
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            'Save',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
    );
  }

  Widget _buildProfilePicture() {
    return Center(
      child: Stack(
        children: [
          CircleAvatar(
            radius: 60,
            backgroundColor: Colors.grey[200],
            backgroundImage: _getProfileImage(),
            child: (_selectedImage == null && widget._webImage == null)
                ? const Icon(Icons.person, size: 60, color: Colors.grey)
                : null,
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: GestureDetector(
              onTap: _pickImage,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.camera_alt,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  ImageProvider? _getProfileImage() {
    if (kIsWeb) {
      if (widget._webImage != null) {
        return NetworkImage(widget._webImage!.path);
      }
    } else if (_selectedImage != null) {
      return FileImage(_selectedImage!);
    }
    return null;
  }
  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _provinceController.dispose();
    _districtController.dispose();
    _nicController.dispose();
    _bloodTypeController.dispose();
    super.dispose();
  }
}

