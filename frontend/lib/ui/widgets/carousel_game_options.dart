import 'package:flutter/material.dart';
import 'package:frontend/ui/screens/game/game_leaderboard_screen.dart';
import 'package:frontend/ui/screens/game/game_leagues_screen.dart';
import 'package:frontend/ui/screens/game/game_myStats_screen.dart';
import 'package:frontend/ui/screens/game/game_predict_screen.dart';
import 'package:frontend/ui/theme.dart';
import 'package:carousel_slider/carousel_slider.dart';

class F1Carousel extends StatefulWidget {
  @override
  _F1CarouselState createState() => _F1CarouselState();
}

class _F1CarouselState extends State<F1Carousel> {
  final PageController _pageController = PageController(initialPage: 0);
  int _currentIndex = 0;
  List<String> _tabs = ["Predict", "Leaderboard", "Leagues", "My Stats"];

  final CarouselSliderController carouselController =
      CarouselSliderController();

  double _rotationAngle = 0.0;
  bool _hasChangedScreen = false;
  final double _delta = 0.5;

  void _rotateWheel(double delta) {
    setState(() {
      _rotationAngle += delta;
    });
  }

  @override
  void initState() {
    super.initState();
    // Callback to sincronize UI after everything is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _pageController.jumpToPage(_currentIndex);
      });
    });
  }

  void _handlePanUpdate(DragUpdateDetails details) {
    final screenWidth = MediaQuery.of(context).size.width;
    final touchPosition = details.localPosition.dx;

    // Check if the swipe is on the left or right side of the image
    if (touchPosition < screenWidth / 2) {
      // Left side of the image
      if (details.delta.dy < 0) {
        // Swiping up on the left side (rotate to the right)
        _rotateWheel(_delta);
        _goToNextPage();
        _hasChangedScreen = true;
      } else if (details.delta.dy > 0) {
        // Swiping down on the left side (rotate to the left)
        _rotateWheel(-1 * _delta);
        _goToPreviousPage();
        _hasChangedScreen = true;
      }
    } else {
      // Right side of the image
      if (details.delta.dy < 0) {
        // Swiping up on the right side (rotate to the left)
        _rotateWheel(-1 * _delta);
        _goToPreviousPage();
        _hasChangedScreen = true;
      } else if (details.delta.dy > 0) {
        // Swiping down on the right side (rotate to the right)
        _rotateWheel(_delta);
        _goToNextPage();
        _hasChangedScreen = true;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [darkGradient, lightGradient],
        ),
      ),
      child: Scaffold(
        body: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
                itemCount: _tabs.length,
                itemBuilder: (context, index) {
                  return _buildPage(_tabs[index]);
                },
              ),
            ),
            SizedBox(height: 20),
            Container(
              alignment: Alignment.center,
              color: primary,
              width: double.infinity,
              padding: const EdgeInsets.only(top: 10.0),
              child: Align(
                alignment: Alignment.center,
                child: CarouselSlider(
                  carouselController: carouselController,
                  options: CarouselOptions(
                    viewportFraction: 0.4,
                    height: 45.0,
                    enableInfiniteScroll: true,
                    initialPage: _currentIndex,
                    enlargeCenterPage: true,
                    scrollDirection: Axis.horizontal,
                    onPageChanged: (index, reason) {
                      setState(() {
                        _currentIndex = index;
                        _pageController.jumpToPage(index);
                      });
                    },
                  ),
                  items: _buildCarouselItems(),
                ),
              ),
            ),
            SizedBox(height: 20),
            GestureDetector(
              onPanUpdate: (details) {
                if (!_hasChangedScreen) {
                  _handlePanUpdate(details);
                }
              },
              onPanEnd: (_) {
                setState(() {
                  _rotationAngle = 0.0;
                  _hasChangedScreen = false;
                });
              },
              child: Transform.rotate(
                angle: _rotationAngle,
                child: Image.asset('assets/images/wheel.png', width: 200),
              ),
            )
          ],
        ),
      ),
    );
  }

  List<Widget> _buildCarouselItems() {
    return _tabs.map((tab) {
      return Builder(
        builder: (BuildContext context) {
          return Text(
            tab,
            style: TextStyle(
              fontSize: tab == _tabs[_currentIndex] ? 24.0 : 14,
              fontWeight: FontWeight.bold,
              color:
                  tab == _tabs[_currentIndex] ? Colors.redAccent : Colors.white,
            ),
          );
        },
      );
    }).toList();
  }

  Widget _buildPage(String text) {
    switch (text) {
      case 'Predict':
        return GamePredictScreen();
      case 'Leaderboard':
        return GameLeaderboardScreen();
      case 'Leagues':
        return GameLeaguesScreen();
      case 'My Stats':
        return GameMyStatsScreen();
      default:
        return Container(
          color: Colors.white,
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
    }
  }

  void _goToNextPage() {
    setState(() {
      if (_currentIndex == _tabs.length - 1) {
        _currentIndex = 0;
        carouselController.jumpToPage(0);
        _pageController.jumpToPage(0);
      } else {
        _currentIndex++;
        carouselController.jumpToPage(_currentIndex);
        _pageController.nextPage(
            duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
      }
    });
  }

  void _goToPreviousPage() {
    setState(() {
      if (_currentIndex == 0) {
        _currentIndex = _tabs.length - 1;
        carouselController.jumpToPage(_tabs.length - 1);
        _pageController.jumpToPage(_tabs.length - 1);
      } else {
        _currentIndex--;
        carouselController.jumpToPage(_currentIndex);
        _pageController.previousPage(
            duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
      }
    });
  }
}
