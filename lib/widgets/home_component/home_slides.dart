import 'dart:async';

import 'package:flutter/material.dart';

class HomeSlides extends StatefulWidget {
  const HomeSlides({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomeSlidesState createState() => _HomeSlidesState();
}

class _HomeSlidesState extends State<HomeSlides> {
  final PageController _pageController = PageController();
  int _currentPageIndex = 0;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _startAutoSlide();
  }

  @override
  void dispose() {
    _stopAutoSlide();
    _pageController.dispose();
    super.dispose();
  }

  void _startAutoSlide() {
    _timer = Timer.periodic(Duration(seconds: 3), (timer) {
      if (_currentPageIndex < 2) {
        _currentPageIndex++;
      } else {
        _currentPageIndex = 0;
      }
      _pageController.animateToPage(
        _currentPageIndex,
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  void _stopAutoSlide() {
    _timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentPageIndex = index;
          });
        },
        children: [
          Container(
            color: Color.fromARGB(255, 198, 218, 235),
            child: Center(
              child: Image.asset('assets/images/page_1.jpg', fit: BoxFit.cover,),
            ),
          ),
          Container(
            color: Colors.orange,
            child: Center(
                       child: Image.asset('assets/images/page_2.jpg', fit: BoxFit.cover,),
            ),
          ),
          Container(
            color: const Color.fromARGB(255, 224, 107, 99),
            child: Center(
             child: Image.asset('assets/images/page_3.jpg', fit: BoxFit.cover,),
            ),
          ),
        ],
      ),
    );
  }
}
