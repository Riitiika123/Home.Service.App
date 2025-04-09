import 'package:flutter/material.dart';
import 'package:home_service_app/authentication/signup.dart';
import 'package:home_service_app/utilities/ui.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              children: const [
                OnboardingPage(
                  image: 'assets/images/onboarding1.png',
                  title: 'Choose Your Role — Consumer or Provider',
                  description: 'Sign up as a Consumer to book home services in seconds, or become a Provider and grow your local business. One app, two powerful roles — tailored just for you!',
                ),
                OnboardingPage(
                  image: 'assets/images/onboarding2.png',
                  title: 'Get Trusted Services at Your Doorstep',
                  description: 'Book reliable professionals for cleaning, repairs, electrical work, plumbing, and more — anytime, anywhere! We bring verified service providers right to your location.',
                ),
                OnboardingPage(
                  image: 'assets/images/onboarding3.png',
                  title: 'Book, Connect & Manage with Ease',
                  description: 'Consumers can book services, track progress, and securely pay & Providers can view bookings, manage their profile, and receive requests from local users.',
                ),
              ],
            ),
          ),

          // Dots Indicator
          SmoothPageIndicator(
            controller: _pageController,
            count: 3,
            effect: const ExpandingDotsEffect(
              dotHeight: 8,
              dotWidth: 8,
              activeDotColor: AppColors.primary,
            ),
          ),

          const SizedBox(height: 20),

          // Buttons
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const Signup()),
                    );
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: AppColors.background,
                    padding: const EdgeInsets.symmetric(horizontal: 30,vertical:12 )
                  ),
                  child: const Text(
                    "Skip",
                    style: TextStyle( color: AppColors.textColor,fontSize: 18),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (_currentIndex < 2) {
                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.ease,
                      );
                    } else {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const Signup()),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.background,
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                  ),
                  child: Text(
                    _currentIndex == 2 ? "Get Started" : "Next",
                    style: const TextStyle( color: AppColors.textColor,fontSize: 18),
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

// Onboarding Page Widget
class OnboardingPage extends StatelessWidget {
  final String image;
  final String title;
  final String description;

  const OnboardingPage({
    super.key,
    required this.image,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(image, height: 250), 
        const SizedBox(height: 40),
        Text(
          title,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,      
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Text(
            description,
            style: const TextStyle(
              fontSize: 16,   
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
