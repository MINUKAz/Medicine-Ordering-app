import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:untitled3/loginpage.dart';
import 'edit_profile.dart';
import 'dart:convert';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text(
          "Profile",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 70, 156, 255),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
        body: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(FirebaseAuth.instance.currentUser?.uid)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            }

            if (!snapshot.hasData || !snapshot.data!.exists) {
              return const Center(
                child: Text('No user data found'),
              );
            }

            final userData = snapshot.data!.data() as Map<String, dynamic>;

            return SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    height: 200,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 70, 156, 255),
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30),
                      ),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            radius: 50,
                            backgroundColor: Colors.white,
                            child: CircleAvatar(
                              radius: 45,
                              backgroundImage: userData['profileImageBase64'] != null
                                  ? MemoryImage(base64Decode(userData['profileImageBase64']))
                                  : userData['profileImageUrl'] != null
                                      ? NetworkImage(userData['profileImageUrl']) as ImageProvider
                                      : const NetworkImage(
                                          'https://www.gravatar.com/avatar/00000000000000000000000000000000?d=mp&f=y',
                                        ),
                              onBackgroundImageError: (e, _) {
                                print('Error loading profile image: $e');
                              },
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            userData['name'] ?? 'No Name',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '${userData['district'] ?? 'No District'}, Sri Lanka',
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
            Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton.icon(
                        icon: Icon(Icons.edit, color: Colors.blue[800]),
                        label: Text(
                          "Edit Profile",
                          style: TextStyle(
                            color: Colors.blue[800],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const EditProfilePage()),
                          );
                        },
                      ),
                    ],
                  ),
                    _buildInfoCard("Personal Information", [
                        _buildInfoItem(Icons.person, "NIC No.", userData['nic'] ?? 'Not provided'),
                        _buildInfoItem(Icons.bloodtype, "Blood Type", userData['bloodType'] ?? 'Not provided'),
                        _buildInfoItem(Icons.phone, "Contact No.", userData['phone'] ?? 'Not provided'),
                      ]),
                      const SizedBox(height: 20),
                      _buildInfoCard("Address Information", [
                        _buildInfoItem(Icons.location_on, "Address", userData['address'] ?? 'Not provided'),
                        _buildInfoItem(Icons.map, "Province", userData['province'] ?? 'Not provided'),
                        _buildInfoItem(Icons.place, "District", userData['district'] ?? 'Not provided'),
                      ]),
                      const SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red[600],
                        padding: EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(builder: (context) => const LoginPage()),
                                  (route) => false, // This removes all previous routes
                                );
                              },
                      child: Text(
                        "LOG OUT",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
          },
        ),
      );  
  }

  Widget _buildInfoCard(String title, List<Widget> items) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.blue[800],
              ),
            ),
            Divider(color: Colors.grey[300]),
            Column(children: items),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: Colors.blue[600], size: 24),
          SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}