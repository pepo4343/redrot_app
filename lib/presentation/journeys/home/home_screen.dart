import 'dart:math';

import 'package:after_layout/after_layout.dart';
import 'package:circular_clip_route/circular_clip_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:redrotapp/common/constants/size_constants.dart';
import 'package:redrotapp/di/get_it.dart';
import 'package:redrotapp/presentation/journeys/home/pageview/home_page_view.dart';
import 'package:redrotapp/presentation/journeys/home/qr_fab.dart';
import 'package:redrotapp/presentation/journeys/home/tab_bar/tab_bar.dart';
import 'package:redrotapp/presentation/journeys/qr/qr_screen.dart';
import 'package:redrotapp/presentation/logic/cubit/clone_list_view/clone_list_view_cubit.dart';
import 'package:redrotapp/presentation/logic/cubit/internet/internet_cubit.dart';
import 'package:redrotapp/presentation/widgets/app_fab.dart';
import 'package:redrotapp/presentation/widgets/internet_snackbar.dart';

import 'package:redrotapp/presentation/widgets/redrot_app_bar.dart';
import 'package:redrotapp/presentation/widgets/responsive.dart';

import 'package:universal_platform/universal_platform.dart';
import '../../themes/app_theme.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: RedrotAppBar(
          title: "หน้าหลัก",
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
          child: Responsive(
            desktop: Placeholder(),
            tablet: Placeholder(),
            mobile: Column(
              children: [
                TabBarApp(pageController: _pageController),
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    itemBuilder: (context, index) {
                      return BlocProvider(
                        create: (context) =>
                            getItInstance<CloneListViewCubit>(),
                        child: HomePageView(index),
                      );
                    },
                    itemCount: 3,
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
