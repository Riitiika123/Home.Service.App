import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:home_service_app/authentication/authentication.dart';
import 'package:home_service_app/screens/consumer/consumerhomescreen.dart';
import 'package:home_service_app/screens/provider/providerhomescreen.dart';
import 'package:home_service_app/utilities/ui.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthService _authService = AuthService();
  bool _isLoading = false; // Loading indicator

  Future<void> _login() async {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter email and password")),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = userCredential.user;
      if (user == null) {
        throw Exception("Login failed. No user found.");
      }

      // Fetch user role from Firestore
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection("users")
          .doc(user.uid)
          .get();

      if (!userDoc.exists) {
        throw Exception("User data not found in Firestore.");
      }

      Map<String, dynamic>? userData =
          userDoc.data() as Map<String, dynamic>?;

      if (userData == null || !userData.containsKey('role')) {
        throw Exception("User role not found.");
      }

      String role = userData['role'] ?? 'Consumer';
      print("User Role: $role");

      // Navigate to the appropriate screen
      if (mounted) {
        setState(() {
          _isLoading = false;
        });

        if (role == "Consumer") {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const ConsumerHomeScreen()),
          );
        } else if (role == "Provider") {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const ProviderHomeScreen()),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Invalid role detected!")),
          );
        }
      }
    } on FirebaseAuthException catch (ex) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Login failed: ${ex.message}")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: ${e.toString()}")),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Login",
        style: TextStyle(fontSize: 25,
        fontWeight: FontWeight.bold),),
        backgroundColor: AppColors.background,
        foregroundColor: Colors.white,
      
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 130),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                hintText: "Email",
                filled: true,
                fillColor: Colors.white,
                hintStyle: TextStyle(color: Colors.black54),
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                hintText: "Password",
                filled: true,
                fillColor: Colors.white,
                hintStyle: TextStyle(color: Colors.black54),
              ),
            ),
            const SizedBox(height: 25),
            _isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.buttonBackground),
                    onPressed: _login,
                    child: const Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Text("Login",
                          style: TextStyle(color: Colors.white, fontSize: 18)),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
