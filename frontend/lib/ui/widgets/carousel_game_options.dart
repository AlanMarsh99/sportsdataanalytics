import 'package:flutter/material.dart';
import 'package:frontend/ui/responsive.dart';
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

  void _rotateWheel(double delta) {
    setState(() {
      _rotationAngle += delta;
    });
  }

  // It works
  void _handlePanUpdate(DragUpdateDetails details) {
    final screenWidth = MediaQuery.of(context).size.width;
    final touchPosition = details.localPosition.dx;

    // Redefine what counts as "left" and "right" sides:
    final double rightSideThreshold =
        screenWidth * 0.05; // 5% of the screen width is left side

    if (touchPosition < rightSideThreshold) {
      // Treat as left side (5% of the screen width)
      if (details.delta.dy < 0) {
        _rotateWheel(_delta); // Rotate to the right
        _goToNextPage();
        _hasChangedScreen = true;
      } else if (details.delta.dy > 0) {
        _rotateWheel(-1 * _delta); // Rotate to the left
        _goToPreviousPage();
        _hasChangedScreen = true;
      }
    } else {
      // Treat as right side (remaining 95% of the screen width)
      if (details.delta.dy < 0) {
        _rotateWheel(-1 * _delta); // Rotate to the left
        _goToPreviousPage();
        _hasChangedScreen = true;
      } else if (details.delta.dy > 0) {
        _rotateWheel(_delta); // Rotate to the right
        _goToNextPage();
        _hasChangedScreen = true;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isMobile = Responsive.isMobile(context);
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [darkGradient, lightGradient],
        ),
      ),
      child: Column(
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
          const SizedBox(height: 20),
          Container(
            alignment: Alignment.center,
            color: primary,
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 5.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Icon(Icons.arrow_back_ios, color: Colors.white, size: 18),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: CarouselSlider(
                      carouselController: carouselController,
                      options: Responsive.isMobile(context)
                          ? CarouselOptions(
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
                            )
                          : CarouselOptions(
                              viewportFraction: 0.2,
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
                const Icon(Icons.arrow_forward_ios,
                    color: Colors.white, size: 18),
              ],
            ),
          ),
          const SizedBox(height: 20),
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
    );
  }

  List<Widget> _buildCarouselItems() {
    return _tabs.map((tab) {
      return Builder(
        builder: (BuildContext context) {
          return Text(
            tab,
            style: TextStyle(
              fontSize: tab == _tabs[_currentIndex] ? 21.0 : 14,
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
        return const GamePredictScreen();
      case 'Leaderboard':
        return const GameLeaderboardScreen();
      case 'Leagues':
        return const GameLeaguesScreen();
      case 'My Stats':
        return const GameMyStatsScreen();
      default:
        return Container(
          color: Colors.white,
          child: Center(
            child: Text(
              text,
              style: const TextStyle(
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
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut);
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
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut);
      }
    });
  }
}
