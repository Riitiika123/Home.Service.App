import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Sign Up Method
  Future<String?> signUpUser({
    required String username,
    required String email,
    required String password,
    required String confirmPassword,
    required String role,
    String? serviceCategory,
    String? phoneNumber,
    String? pricing,
  }) async {
    if (username.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty) {
      return "Please fill all fields.";
    }
    if (password != confirmPassword) {
      return "Passwords do not match.";
    }
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        String uid = userCredential.user!.uid;
        await _firestore.collection("users").doc(uid).set({
          "uid": uid,
          "username": username,
          "email": email,
          "role": role,
          "createdAt": FieldValue.serverTimestamp(), // 🔹 Store Timestamp
        });
        return null; // Success
      }
    } on FirebaseAuthException catch (ex) {
      if (ex.code == "weak-password") {
        return "Password is too weak. Use a stronger password.";
      } else if (ex.code == "email-already-in-use") {
        return "This email is already in use.";
      } else {
        return "An error occurred: ${ex.message}";
      }
    }
    return "Signup failed. Please try again.";
  }

  // Login Method
  Future<String?> loginUser(
      {required String email, required String password}) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      DocumentSnapshot userDoc = await _firestore
          .collection("users")
          .doc(userCredential.user!.uid)
          .get();

      if (userDoc.exists) {
        Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;

        if (userData != null && userData.containsKey("role")) {
        String role = userData["role"] ?? "consumer"; // Default to "consumer" if missing
        print("Retrieved role from Firestore: $role");
        return role.toLowerCase(); // Ensure consistency (consumer/provider)
      } else {
        print("User role field missing in Firestore.");
        return "Role not found";
      }
    } else {
      print("User data not found in Firestore.");
      return "User data not found";
    }
    } on FirebaseAuthException catch (ex) {
      return "Login failed: ${ex.message}";
    }
  }
}
