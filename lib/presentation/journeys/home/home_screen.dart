import 'package:circular_clip_route/circular_clip_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:redrotapp/common/constants/size_constants.dart';
import 'package:redrotapp/di/get_it.dart';
import 'package:redrotapp/presentation/journeys/home/pageview/home_page_view.dart';

import 'package:redrotapp/presentation/journeys/home/tab_bar/tab_bar.dart';
import 'package:redrotapp/presentation/journeys/qr/qr_screen.dart';
import 'package:redrotapp/presentation/logic/cubit/clone_list_view/clone_list_view_cubit.dart';
import 'package:redrotapp/presentation/logic/cubit/delete_all/delete_all_cubit.dart';
import 'package:redrotapp/presentation/logic/cubit/delete_clone/delete_clone_cubit.dart';
import 'package:redrotapp/presentation/logic/cubit/internet/internet_cubit.dart';
import 'package:redrotapp/presentation/widgets/app_fab.dart';
import 'package:redrotapp/presentation/widgets/image_uploader_indicator.dart';
import 'package:redrotapp/presentation/widgets/internet_snackbar.dart';

import 'package:redrotapp/presentation/widgets/redrot_app_bar.dart';
import 'package:redrotapp/presentation/widgets/responsive.dart';
import 'package:redrotapp/presentation/widgets/tap_detector.dart';

import 'package:universal_platform/universal_platform.dart';
import '../../themes/app_theme.dart';
import 'menu.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isMenuOpened = false;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (isMenuOpened) {
          setState(() {
            isMenuOpened = !isMenuOpened;
          });
          return false;
        }
        return true;
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.cardColor,
        body: BlocProvider(
          create: (context) => getItInstance<DeleteAllCubit>(),
          child: Stack(
            children: [
              if (isMenuOpened) Menu(),
              AnimatedContent(
                isMenuOpened: isMenuOpened,
                child: Stack(
                  children: [
                    HomeContent(
                      onMenuPressed: () {
                        setState(() {
                          isMenuOpened = !isMenuOpened;
                        });
                      },
                    ),
                    if (isMenuOpened)
                      GestureDetector(
                        onPanUpdate: (details) {
                          if (details.delta.dx < -10) {
                            setState(() {
                              isMenuOpened = !isMenuOpened;
                            });
                          }
                        },
                        onTap: () {
                          setState(() {
                            isMenuOpened = !isMenuOpened;
                          });
                        },
                        child: Container(
                          color: Colors.transparent,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HomeContent extends StatelessWidget {
  final PageController _pageController = PageController();
  HomeContent({
    Key? key,
    required this.onMenuPressed,
  }) : super(key: key);
  final Function() onMenuPressed;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: TapDetector(
          onPressed: onMenuPressed,
          child: Icon(Icons.menu),
        ),
        title: Text(
          "หน้าหลัก",
          style: Theme.of(context).textTheme.headline5!,
        ),
        iconTheme: IconThemeData(
            color: Theme.of(context).colorScheme.secondaryTextColor),
        backgroundColor: Theme.of(context).colorScheme.background,
        actions: [ImageUploaderIndicator()],
        elevation: 0.0,
        centerTitle: true,
      ),
      floatingActionButton: UniversalPlatform.isWeb
          ? null
          : Builder(
              builder: (context) {
                return AppFab(
                  child: Icon(
                    Icons.qr_code,
                    color: Theme.of(context).colorScheme.onSecondary,
                    size: Sizes.dimen_24,
                  ),
                  onPressed: () async {
                    await Navigator.push(
                      context,
                      CircularClipRoute<void>(
                        builder: (_) => QrScreen(),
                        expandFrom: context,
                        border: Border.all(
                          width: Sizes.dimen_0,
                        ),
                      ),
                    );
                    await Future.delayed(Duration(milliseconds: 300));
                    Navigator.of(context).pushReplacementNamed("/home");
                  },
                );
              },
            ),
      body: InternetSnackBar(
        child: Column(
          children: [
            TabBarApp(pageController: _pageController),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemBuilder: (context, index) {
                  return MultiBlocProvider(
                    providers: [
                      BlocProvider(
                        create: (context) =>
                            getItInstance<CloneListViewCubit>(),
                      ),
                      BlocProvider(
                        create: (context) => getItInstance<DeleteCloneCubit>(),
                      )
                    ],
                    child: HomePageView(index),
                  );
                },
                itemCount: 3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AnimatedContent extends StatefulWidget {
  final Widget child;
  final bool isMenuOpened;
  const AnimatedContent({
    Key? key,
    required this.child,
    required this.isMenuOpened,
  }) : super(key: key);

  @override
  _AnimatedContentState createState() => _AnimatedContentState();
}

class _AnimatedContentState extends State<AnimatedContent>
    with SingleTickerProviderStateMixin {
  final animationDuration = Duration(milliseconds: 300);

  late AnimationController _controller = AnimationController(
    vsync: this,
    duration: animationDuration,
  );
  late Animation<double> _scaleAnimation =
      Tween<double>(begin: 1, end: 0.8).animate(
    CurvedAnimation(parent: _controller, curve: Curves.ease),
  )..addListener(() {
          setState(() {});
        });
  late Animation<double> _radiusAnimation =
      Tween<double>(begin: 0, end: 40).animate(
    CurvedAnimation(parent: _controller, curve: Curves.ease),
  );
  late Animation<double> _radiusWidthAnimation =
      Tween<double>(begin: 0, end: 2).animate(
    CurvedAnimation(parent: _controller, curve: Curves.ease),
  );
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  BoxBorder get _border {
    var brightness = MediaQuery.of(context).platformBrightness;
    bool isDarkMode = brightness == Brightness.dark;
    final theme = Theme.of(context);

    if (!isDarkMode) {
      return Border.all(width: 0.0, color: Colors.transparent);
    }
    return Border.all(
      width: widget.isMenuOpened ? 2 : 0,
      color: widget.isMenuOpened
          ? theme.colorScheme.onSecondary
          : Colors.transparent,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (widget.isMenuOpened) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
    final screenWidth = MediaQuery.of(context).size.width;
    return AnimatedPositioned(
      duration: animationDuration,
      curve: Curves.ease,
      top: 0,
      bottom: 0,
      left: widget.isMenuOpened ? 0.6 * screenWidth : 0,
      right: widget.isMenuOpened ? -0.6 * screenWidth : 0,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: AnimatedContainer(
          duration: animationDuration,
          decoration: BoxDecoration(
            boxShadow: theme.primaryBoxShadows,
            borderRadius:
                BorderRadius.all(Radius.circular(_radiusAnimation.value)),
          ),
          child: ClipRRect(
            borderRadius:
                BorderRadius.all(Radius.circular(_radiusAnimation.value)),
            child: widget.child,
          ),
        ),
      ),
    );
  }
}
