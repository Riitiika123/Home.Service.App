import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:home_service_app/authentication/login.dart';
import 'package:home_service_app/screens/consumer/servicecategories.dart';
import 'package:home_service_app/utilities/ui.dart';

class ConsumerHomeScreen extends StatefulWidget {
  const ConsumerHomeScreen({super.key});

  @override
  State<ConsumerHomeScreen> createState() => _ConsumerHomeScreenState();
}

class _ConsumerHomeScreenState extends State<ConsumerHomeScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void _logout() async {
    await _auth.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

//search bar logic
  final TextEditingController _searchController = TextEditingController();
  List<String> _suggestions = [];
  bool _showSuggestions = false;

  void _onSearchChanged(String value) async {
    if (value.isEmpty) {
      setState(() {
        _suggestions.clear();
        _showSuggestions = false;
      });
      return;
    }

    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('providers')
        .where('service', isGreaterThanOrEqualTo: value)
        .where('service', isLessThan: value + 'z')
        .get();

    List<String> results =
        snapshot.docs.map((doc) => doc['service'].toString()).toSet().toList();

    setState(() {
      _suggestions = results;
      _showSuggestions = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        backgroundColor: Colors.white,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              child: Text(
                'Helpify',
                style: TextStyle(
                    color: AppColors.background,
                    fontSize: 35,
                    fontWeight: FontWeight.bold),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Profile'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.book_online),
              title: const Text('Bookings'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: _logout,
            ),
          ],
        ),
      ),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(150),
        child: AppBar(
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                opacity: 0.4,
                image: AssetImage("assets/images/background.png"),
                fit: BoxFit.cover,
              ),
            ),
            alignment: Alignment.topCenter,
            padding: const EdgeInsets.only(top: 60),
            child: const Text(
              'Helpify',
              style: TextStyle(
                  fontSize: 35,
                  color: AppColors.background,
                  fontWeight: FontWeight.bold),
            ),
          ),
          iconTheme: const IconThemeData(color: AppColors.background, size: 35),
          elevation: 0,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
        
            //  Search Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: "Search for services...",
                        hintStyle: const TextStyle(color: AppColors.background),
                        prefixIcon:
                            const Icon(Icons.search, color: AppColors.background),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.arrow_drop_down),
                          onPressed: () {
                            setState(() {
                              _showSuggestions = !_showSuggestions;
                            });
                          },
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(vertical: 15),
                      ),
                      onChanged: _onSearchChanged,
                    ),
                  ),
        
                  //  Suggestions Dropdown
                  if (_showSuggestions)
                    Container(
                      margin: const EdgeInsets.only(top: 5),
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: _suggestions.length,
                        itemBuilder: (context, index) {
                          final suggestion = _suggestions[index];
                          return ListTile(
                            title: Text(suggestion),
                            onTap: () {
                              _searchController.text = suggestion;
                              setState(() {
                                _showSuggestions = false;
                              });
                              // Do something with selected service like navigate or filter
                              print("User selected: $suggestion");
                            },
                          );
                        },
                      ),
                    ),
                ],
              ),
            ),
        
            const SizedBox(height: 30),
        
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 30),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    "Available Services",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                ServiceCategoriesGrid(),
              ],
            )
          ],
        ),
      ),
    );
  }
}
