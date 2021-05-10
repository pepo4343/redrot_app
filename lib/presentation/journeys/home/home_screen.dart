import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:redrotapp/di/get_it.dart';
import 'package:redrotapp/presentation/journeys/home/pageview/home_page_view.dart';
import 'package:redrotapp/presentation/logic/cubit/all/all_cubit.dart';
import 'package:redrotapp/presentation/logic/cubit/completed/completed_cubit.dart';
import 'package:redrotapp/presentation/logic/cubit/verify_needed/verify_needed_cubit.dart';
import 'package:redrotapp/presentation/widgets/animated_card.dart';
import 'package:redrotapp/presentation/widgets/loading_indicator.dart';
import 'package:redrotapp/presentation/widgets/redrot_app_bar.dart';
import 'package:sizer/sizer.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late VerifyNeededCubit verifyNeededCubit;
  late CompletedCubit completedCubit;
  late AllCubit allCubit;
  @override
  void initState() {
    verifyNeededCubit = getItInstance<VerifyNeededCubit>();
    completedCubit = getItInstance<CompletedCubit>();
    allCubit = getItInstance<AllCubit>();
    super.initState();
  }

  @override
  void dispose() {
    verifyNeededCubit.close();
    completedCubit.close();
    allCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => verifyNeededCubit),
        BlocProvider(create: (_) => completedCubit),
        BlocProvider(create: (_) => allCubit),
      ],
      child: Scaffold(
        appBar: RedrotAppBar(
          title: "หน้าหลัก",
        ),
        body: PageView.builder(
          itemBuilder: (context, index) => HomePageView(index),
          itemCount: 3,
        ),
      ),
    );
  }
}
