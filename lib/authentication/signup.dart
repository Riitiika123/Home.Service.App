import 'package:flutter/material.dart';
import 'package:home_service_app/authentication/authentication.dart';
import 'package:home_service_app/authentication/login.dart';
import 'package:home_service_app/screens/consumer/consumerhomescreen.dart';
import 'package:home_service_app/screens/provider/providerhomescreen.dart';
import 'package:home_service_app/utilities/ui.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  String role = 'Consumer'; // Default selection
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _serviceCategoryController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _pricingController = TextEditingController();


 final AuthService _authService = AuthService();

  void _signUp() async {
    String? errorMessage = await _authService.signUpUser(
      username: _nameController.text.trim(),
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
      confirmPassword: _confirmPasswordController.text.trim(),
      role: role,
      serviceCategory: role == "Provider" ? _serviceCategoryController.text.trim() : null,
      phoneNumber: role == "Provider" ? _phoneNumberController.text.trim() : null,
      pricing: role == "Provider" ? _pricingController.text.trim() : null,
    );

    if (errorMessage != null) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(errorMessage)));
    } else {
      // ignore: use_build_context_synchronously
     if (role == 'Consumer') {
        // ignore: use_build_context_synchronously
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const ConsumerHomeScreen()));
      } else {
        // ignore: use_build_context_synchronously
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const ProviderHomeScreen()));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text("Homely", style: TextStyle(
          color: AppColors.textColor,
           fontWeight: FontWeight.bold,
            fontSize: 25,
            fontStyle: FontStyle.italic),)),
        backgroundColor: AppColors.background,
      ),
    
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          
          child: Column(
            
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Role Selection (Consumer or Provider)
              SizedBox(height: 80,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ChoiceChip(
                    label: const Text("User"),
                    selected : role == 'Consumer',
                    onSelected: (value) {
                      setState(() {
                        role = 'Consumer';
                      });
                    },
                    selectedColor: AppColors.background,
                    backgroundColor: Colors.white,
                    labelStyle: TextStyle(
                        color: role == 'Consumer' ? Colors.white : AppColors.primary),
                  ),
                  const SizedBox(width: 20),
                  ChoiceChip(
                    label: const Text("Provider"),
                    selected: role == 'Provider',
                    onSelected: (value) {
                      setState(() {
                        role = "Provider" ;
                      });
                    },
                    selectedColor: AppColors.background,
                    backgroundColor: Colors.white,
                    labelStyle: TextStyle(
                        color: role == 'Provider' ? Colors.white : AppColors.primary),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Common Fields
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: "Name",
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
              const SizedBox(height: 10),

              TextField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                        labelText: "Email",
                        filled: true,
                        fillColor: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 10),

              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: "Password",
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
              const SizedBox(height: 10),

              TextField(
                controller: _confirmPasswordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: "Confirm Password",
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
              const SizedBox(height: 20),

              // Signup Button
              ElevatedButton(
                onPressed: _signUp,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.buttonBackground,
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 50),
                ),
                child: const Text("Sign Up"),
              ),

              const SizedBox(
                height: 25,
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Already Have an Account?',
                    style: TextStyle(
                      fontSize: 23,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) =>  LoginScreen()));
                    },
                    child: const Text(
                      'Login',
                      style: TextStyle(fontSize: 23, color: AppColors.primary),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
