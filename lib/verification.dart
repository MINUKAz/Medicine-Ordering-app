import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'Userinfopage.dart'; // Importing UserInfoPage

class VerificationPage extends StatefulWidget {
  const VerificationPage({Key? key}) : super(key: key);

  @override
  _VerificationPageState createState() => _VerificationPageState();
}

class _VerificationPageState extends State<VerificationPage> {
  bool _isEmailVerified = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _checkEmailVerification();
  }

Future<void> _checkEmailVerification() async {
  setState(() => _isLoading = true);
  final user = FirebaseAuth.instance.currentUser;
  await user?.reload(); // Reload user to get the latest verification status
  setState(() {
    _isEmailVerified = user?.emailVerified ?? false;
    _isLoading = false;
  });

  if (_isEmailVerified) {
    // Navigate to the HomePage if the email is verified
Navigator.pushReplacement(
  context,
  MaterialPageRoute(builder: (context) => UserInfoPage()),
);
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Email is not verified yet. Please check your inbox.")),
    );
  }
}

  Future<void> _resendVerificationEmail() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      await user?.sendEmailVerification();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Verification email sent!")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to send verification email: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Verify Your Email"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  Text(
                    "Email: ${FirebaseAuth.instance.currentUser?.email ?? 'No email'}",
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 20),
                  if (!_isEmailVerified)
                    const Text(
                      "Your email is not verified. Please check your inbox for the verification link.",
                      style: TextStyle(fontSize: 16, color: Colors.red),
                    ),
                  if (_isEmailVerified)
                    const Text(
                      "Your email is verified! You can now proceed.",
                      style: TextStyle(fontSize: 16, color: Colors.green),
                    ),
                  const SizedBox(height: 20),
                  if (!_isEmailVerified)
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _resendVerificationEmail,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(28),
                          ),
                        ),
                        child: const Text(
                          "Resend Verification Email",
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _checkEmailVerification,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(28),
                        ),
                      ),
                      child: const Text(
                        "Check Verification Status",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}