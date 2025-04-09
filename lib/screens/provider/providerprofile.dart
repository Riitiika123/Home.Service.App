import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Providerprofile extends StatefulWidget {
  const Providerprofile({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<Providerprofile> {
  final _formKey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  bool _isEditing = false;

  final List<String> serviceOptions = [
    'Plumbing',
    'Electrician',
    'Cleaning',
    'Carpenter',
    'Painter',
    'Gardening',
    'Vehicle Repair',
    'Laundry'
  ];

  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _serviceController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _chargesController = TextEditingController();
  final TextEditingController _aboutController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  void _loadProfile() async {
    final user = _auth.currentUser;
    if (user != null) {
      final doc = await _firestore.collection('providers').doc(user.uid).get();

      if (doc.exists) {
        final data = doc.data()!;
        _fullNameController.text = data['fullName'] ?? '';
        _serviceController.text = data['service'] ?? '';
        _phoneController.text = data['phone'] ?? '';
        _chargesController.text = data['charges'] ?? '';
        _aboutController.text = data['about'] ?? '';
      }
    }
  }

  void _saveProfile() async {
    final user = _auth.currentUser;
    if (user != null && _formKey.currentState!.validate()) {
      await _firestore.collection('providers').doc(user.uid).set({
        'fullName': _fullNameController.text,
        'service': _serviceController.text,
        'phone': _phoneController.text,
        'charges': _chargesController.text,
        'about': _aboutController.text,
        'uid': user.uid,
      });
      setState(() {
        _isEditing = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile saved successfully!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            const Text("My Profile",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            TextFormField(
              controller: _fullNameController,
              enabled: _isEditing,
              decoration: const InputDecoration(labelText: 'Full Name'),
              validator: (value) =>
                  value!.isEmpty ? 'Please enter your name' : null,
            ),
            DropdownButtonFormField<String>(
              value: _serviceController.text.isNotEmpty &&
                      serviceOptions.contains(_serviceController.text)
                  ? _serviceController.text
                  : null,
              items: serviceOptions.map((String service) {
                return DropdownMenuItem<String>(
                  value: service,
                  child: Text(service),
                );
              }).toList(),
              onChanged: _isEditing
                  ? (String? newValue) {
                      setState(() {
                        _serviceController.text = newValue!;
                      });
                    }
                  : null,
              decoration: const InputDecoration(labelText: 'Service'),
              validator: (value) => value == null || value.isEmpty
                  ? 'Please select your service'
                  : null,
            ),
            TextFormField(
              controller: _phoneController,
              enabled: _isEditing,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(labelText: 'Phone Number'),
              validator: (value) =>
                  value!.isEmpty ? 'Enter a valid phone number' : null,
            ),
            TextFormField(
              controller: _chargesController,
              enabled: _isEditing,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Per Hour Charges'),
              validator: (value) =>
                  value!.isEmpty ? 'Please enter charges' : null,
            ),
            TextFormField(
              controller: _aboutController,
              enabled: _isEditing,
              maxLines: 3,
              decoration: const InputDecoration(labelText: 'About Description'),
              validator: (value) =>
                  value!.isEmpty ? 'Please add a short description' : null,
            ),
            const SizedBox(height: 20),
            _isEditing
                ? ElevatedButton(
                    onPressed: _saveProfile,
                    child: const Text("Save Profile"),
                  )
                : ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _isEditing = true;
                      });
                    },
                    child: const Text("Edit Profile"),
                  ),
          ],
        ),
      ),
    );
  }
}
