import 'package:flutter/material.dart';
import '../widgets/bottom_navigation.dart'; 
import '../screens/dashboard/home_screen.dart' show HomeScreen;

class MainContainerScreen extends StatefulWidget {
  const MainContainerScreen({super.key});

  @override
  State<MainContainerScreen> createState() => _MainContainerScreenState();
}

class _MainContainerScreenState extends State<MainContainerScreen> {
  int _currentIndex = 0;
  final PageController _pageController = PageController();

  // Placeholder screens - replace with your actual screens
  final List<Widget> _screens = [
    const HomeScreen(),
    const Center(child: Text('User')),
    const Center(child: Text('Cart')),
    const Center(child: Text('Messages')),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onTabChanged(int index) {
    setState(() {
      _currentIndex = index;
      _pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigation(
        initialIndex: _currentIndex,
        onTabChanged: _onTabChanged,
      ),
      // extendBody: true,
    );
  }
}
