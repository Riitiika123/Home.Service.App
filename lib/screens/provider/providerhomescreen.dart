import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:home_service_app/authentication/login.dart';
import 'package:home_service_app/screens/provider/providerbooking.dart';
import 'package:home_service_app/screens/provider/providerprofile.dart';
import 'package:home_service_app/utilities/ui.dart';

class ProviderHomeScreen extends StatefulWidget {
  const ProviderHomeScreen({super.key});

  @override
  _ProviderHomeScreenState createState() => _ProviderHomeScreenState();
}

class _ProviderHomeScreenState extends State<ProviderHomeScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      if(index<2){
      _selectedIndex = index;
      }
    });
  }

  void _logout() async {
    await FirebaseAuth.instance.signOut();
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    }
  }

  final List<Widget> _screens = [
     const Providerbooking(),
     const Providerprofile()
    
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.background,
        foregroundColor: Colors.white,
        centerTitle: true,
        title: const Text("Helpify", ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
      ),
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.book, color: AppColors.background),
            label: 'Bookings',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person , color: AppColors.background,),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor:AppColors.background,
        onTap: _onItemTapped,
      ),
    );
  }
}

