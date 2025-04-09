import 'package:flutter/material.dart';
import 'package:home_service_app/screens/onboarding_screen.dart';
import 'package:home_service_app/utilities/ui.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState(){
    super.initState();
    _navigateToHome();
  }

 _navigateToHome() async{
    await Future.delayed(const Duration(seconds: 5),(){});
    // ignore: use_build_context_synchronously
    Navigator.pushReplacement(context, 
    MaterialPageRoute(builder: (context)=>const OnboardingScreen()));

  }
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
       backgroundColor: AppColors.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Helpify',
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: AppColors.textColor,
            ),),
            SizedBox(height: 20,),
            Icon(Icons.home,
            size: 80,
            color:AppColors.textColor,
            ),
          ],),
      ),
    );
  }
}