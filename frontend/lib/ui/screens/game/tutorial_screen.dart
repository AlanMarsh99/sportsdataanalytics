import 'package:flutter/material.dart';
import 'package:frontend/core/providers/navigation_provider.dart';
import 'package:frontend/ui/responsive.dart';
import 'package:frontend/ui/theme.dart';
import 'package:frontend/ui/widgets/app_bar.dart';
import 'package:frontend/ui/widgets/carousel_game_options.dart';
import 'package:frontend/ui/widgets/drawer.dart';
import 'package:frontend/ui/widgets/end_drawer.dart';
import 'package:provider/provider.dart';

class TutorialScreen extends StatefulWidget {
  @override
  _TutorialScreenState createState() => _TutorialScreenState();
}

class _TutorialScreenState extends State<TutorialScreen>
    with TickerProviderStateMixin {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  late AnimationController _controller;
  late Animation<double> _myAnimation;
  bool _flag = true;
  late List<NavigationRailDestination> _destinations;

  final List<Widget> _pages = [
    TutorialPage(
      title: "MAKE YOUR PREDICTIONS",
      description:
          "3 predictions for each race give you a chance to show your F1 knowledge.",
      content: Image.asset(
        'assets/tutorial/tutorial1.png',
        //fit: BoxFit.cover,
      ),
      index: 1,
    ),
    TutorialPage(
      title: "CREATE AND JOIN LEAGUES",
      description:
          "Show your skills and challenge your peers by creating or joining a league, and race to claim the top spot on the podium at every race.",
      content: Container(),
      index: 2,
    ),
    TutorialPage(
      title: "DRIVE TO THE DIFFERENT SCREENS USING THE STEERING WHEEL",
      description:
          "Use the steering wheel to navigate through the different game screens. Just turn it left or right as if you were an F1 driver!",
      content: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset('assets/tutorial/tutorial3.png', width: 400),
          const SizedBox(height: 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.arrow_upward_rounded,
                  color: Colors.white, size: 50),
              Image.asset('assets/images/wheel.png', width: 200),
              const Icon(Icons.arrow_downward_rounded,
                  color: Colors.white, size: 50),
            ],
          ),
        ],
      ),
      index: 3,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _myAnimation = CurvedAnimation(curve: Curves.linear, parent: _controller);
  }

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _endTour();
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _endTour() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => F1Carousel()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final nav = Provider.of<NavigationProvider>(context);
    _destinations = nav.destinations;
    bool isMobile = Responsive.isMobile(context);
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [darkGradient, lightGradient],
        ),
      ),
      child: isMobile
          ? Scaffold(
              appBar: MyAppBar(
                nav: nav,
                isMobile: isMobile,
              ),
              drawer: MyDrawer(
                nav: nav,
                isMobile: isMobile,
              ),
              endDrawer: const EndDrawer(),
              body: Column(
                children: [
                  Expanded(
                    child: PageView.builder(
                      controller: _pageController,
                      onPageChanged: (index) {
                        setState(() {
                          _currentPage = index;
                        });
                      },
                      itemCount: _pages.length,
                      itemBuilder: (context, index) => _pages[index],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 24.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          onPressed: _endTour,
                          child: const Text(
                            "SKIP",
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            if (_currentPage > 0)
                              TextButton(
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                ),
                                onPressed: _previousPage,
                                child: Container(
                                  width: 95,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(20),
                                    ),
                                    border:
                                        Border.all(color: primary, width: 2),
                                  ),
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 5),
                                  child: const Text(
                                    'BACK',
                                    style: TextStyle(
                                        color: primary,
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.w400),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            const SizedBox(width: 10),
                            TextButton(
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                              ),
                              onPressed: _nextPage,
                              child: Container(
                                width: 95,
                                decoration: BoxDecoration(
                                  color: secondary,
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(20),
                                  ),
                                  border:
                                      Border.all(color: secondary, width: 2),
                                ),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 5),
                                child: Text(
                                  _currentPage == _pages.length - 1
                                      ? "END TOUR "
                                      : "NEXT",
                                  style: const TextStyle(
                                      color: white,
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.w400),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            )
          : Scaffold(
              appBar: MyAppBar(
                nav: nav,
                isMobile: isMobile,
              ),
              endDrawer: const EndDrawer(),
              body: Row(
                children: [
                  NavigationRail(
                    selectedIconTheme: const IconThemeData(color: secondary),
                    unselectedIconTheme:
                        const IconThemeData(color: Colors.white, opacity: 1),
                    extended: nav.extended,
                    selectedIndex: nav.selectedIndex,
                    destinations: _destinations,
                    onDestinationSelected: (value) {
                      nav.updateIndex(value);
                      Navigator.pop(context);
                    },
                    leading: IconButton(
                      icon: AnimatedIcon(
                        icon: AnimatedIcons.menu_close,
                        color: Colors.white,
                        progress: _myAnimation,
                      ),
                      onPressed: () {
                        if (_flag) {
                          _controller.forward();
                        } else {
                          _controller.reverse();
                        }

                        _flag = !_flag;
                        if (nav.extended) {
                          nav.setExtended(false);
                        } else {
                          nav.setExtended(true);
                        }
                      },
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Expanded(
                          child: PageView.builder(
                            controller: _pageController,
                            onPageChanged: (index) {
                              setState(() {
                                _currentPage = index;
                              });
                            },
                            itemCount: _pages.length,
                            itemBuilder: (context, index) => _pages[index],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 24.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextButton(
                                onPressed: _endTour,
                                child: const Text(
                                  "SKIP",
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.white),
                                ),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  if (_currentPage > 0)
                                    TextButton(
                                      style: TextButton.styleFrom(
                                        padding: EdgeInsets.zero,
                                      ),
                                      onPressed: _previousPage,
                                      child: Container(
                                        width: 120,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: const BorderRadius.all(
                                            Radius.circular(20),
                                          ),
                                          border: Border.all(
                                              color: primary, width: 2),
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 5),
                                        child: const Text(
                                          'BACK',
                                          style: TextStyle(
                                              color: primary,
                                              fontSize: 14.0,
                                              fontWeight: FontWeight.w400),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                  const SizedBox(width: 10),
                                  TextButton(
                                    style: TextButton.styleFrom(
                                      padding: EdgeInsets.zero,
                                    ),
                                    onPressed: _nextPage,
                                    child: Container(
                                      width: 120,
                                      decoration: BoxDecoration(
                                        color: secondary,
                                        borderRadius: const BorderRadius.all(
                                          Radius.circular(20),
                                        ),
                                        border: Border.all(
                                            color: secondary, width: 2),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 5),
                                      child: Text(
                                        _currentPage == _pages.length - 1
                                            ? "END TOUR "
                                            : "NEXT",
                                        style: const TextStyle(
                                            color: white,
                                            fontSize: 14.0,
                                            fontWeight: FontWeight.w400),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

class TutorialPage extends StatelessWidget {
  final String title;
  final String description;
  final Widget content;
  final int index;

  const TutorialPage({
    required this.title,
    required this.description,
    required this.content,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    bool isMobile = Responsive.isMobile(context);
    return Padding(
      padding: EdgeInsets.all(isMobile ? 20.0 : 40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: isMobile ? 24 : 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            description,
            style: TextStyle(
              fontSize: isMobile ? 16 : 20,
              color: Colors.grey[300],
            ),
          ),
          const SizedBox(height: 35),
          Align(
            alignment: Alignment.center,
            child: Container(
                width: isMobile ? 340 : 450,
                height: isMobile ? 290 : 440,
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                //height: isMobile ? 350 : 487,
                decoration: BoxDecoration(
                  color: index < 3 ? primary : Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: content),
          ),
        ],
      ),
    );
  }
}
