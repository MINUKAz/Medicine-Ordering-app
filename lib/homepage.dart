import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'aboutuspage.dart';
import 'contactus.dart';
import 'profile.dart';
import 'prescriptionuploadpage.dart';
import 'productpage.dart';
import 'Deliverymap.dart';
import 'dart:convert';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 1) {
      // About Us
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const AboutUsScreen()),
      );
    } else if (index == 2) {
      // Contact Us
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const ContactUsScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("MediCare", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.blue[800],
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome back,',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 4),
                      // In HomePage's build method
                     FutureBuilder<DocumentSnapshot>(
                      future: FirebaseFirestore.instance
                          .collection('users')
                          .doc(FirebaseAuth.instance.currentUser?.uid)
                          .get(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Text('Loading...', style: TextStyle(fontSize: 16));
                        }
                        if (snapshot.hasError) {
                          return const Text('Error loading user data', style: TextStyle(fontSize: 16, color: Colors.red));
                        }
                        if (!snapshot.hasData || snapshot.data?.data() == null) {
                          return const Text('User data not found', style: TextStyle(fontSize: 16, color: Colors.grey));
                        }

                        final userData = snapshot.data!.data() as Map<String, dynamic>;
                        return Text(
                          userData['username'] ?? 'User',
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        );
                      },
                    ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ProfilePage()),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.blue,
                          width: 2,
                        ),
                      ),
                      child: StreamBuilder<DocumentSnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('users')
                            .doc(FirebaseAuth.instance.currentUser?.uid)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.hasError || !snapshot.hasData) {
                            return const CircleAvatar(
                              radius: 24,
                              backgroundColor: Colors.grey,
                              child: Icon(Icons.person, color: Colors.white),
                            );
                          }

                          final userData = snapshot.data!.data() as Map<String, dynamic>?;
                          if (userData == null) {
                            return const CircleAvatar(
                              radius: 24,
                              backgroundColor: Colors.grey,
                              child: Icon(Icons.person, color: Colors.white),
                            );
                          }

                          // Try to load image in order: base64 -> cloudinary URL -> default
                          if (userData['profileImageBase64'] != null) {
                            return CircleAvatar(
                              radius: 24,
                              backgroundImage: MemoryImage(
                                base64Decode(userData['profileImageBase64']),
                              ),
                            );
                          } else if (userData['profilePicture'] != null) {
                            return CircleAvatar(
                              radius: 24,
                              backgroundImage: NetworkImage(userData['profilePicture']),
                            );
                          }

                          return const CircleAvatar(
                            radius: 24,
                            backgroundColor: Colors.grey,
                            child: Icon(Icons.person, color: Colors.white),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Search Bar
              TextField(
                decoration: InputDecoration(
                  hintText: "Search medicines, doctors...",
                  prefixIcon: const Icon(Icons.search, color: Colors.grey),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
              const SizedBox(height: 24),

              // Medicine Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Your Medicines",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text(
                      "View all",
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  _buildMedicineCard(
                    "Prescribed",
                    Colors.blue,
                    Icons.medical_services,
                  ),
                  const SizedBox(width: 12),
                  _buildMedicineCard(
                    "Non-Prescribed",
                    Colors.orange,
                    Icons.medication,
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Highlights Section
              const Text(
                "Quick Actions",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                childAspectRatio: 1.5,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                children: [
                  _buildQuickActionCard(
                    "Medicine Plan",
                    Icons.calendar_today,
                    Colors.blue,
                  ),
                  _buildQuickActionCard(
                    "Delivery",
                    Icons.delivery_dining,
                    Colors.green,
                  ),
                  _buildQuickActionCard(
                    "History",
                    Icons.history,
                    Colors.purple,
                  ),
                  _buildQuickActionCard(
                    "Settings",
                    Icons.settings,
                    Colors.orange,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.blue[800],
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.info),
            label: "About Us",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.contact_mail),
            label: "Contact Us",
          ),
        ],
      ),
    );
  }

  Widget _buildMedicineCard(String title, Color color, IconData icon) {
    return Expanded(
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: InkWell(
          onTap: () {
            if (title == "Prescribed") {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PrescriptionScreen()),
              );
            } else if (title == "Non-Prescribed") {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProductPage()),
              );
            }
          },
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Icon(icon, color: color),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "5 items", // This should be dynamic in the future
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
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

  Widget _buildQuickActionCard(String title, IconData icon, Color color) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          if (title == "Delivery") {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Deliverymap()),
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 28),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
