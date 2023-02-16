import 'package:bloc_communication/bloc/cubit/counter_cubit.dart';
import 'package:bloc_communication/bloc/internet/internet_cubit.dart';
import 'package:bloc_communication/view/router/app_router.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(MyApp(
    appRouter: AppRouter(),
    connectivity: Connectivity(),
  ));
}

class MyApp extends StatelessWidget {
  final AppRouter appRouter;
  final Connectivity connectivity;

  const MyApp({
    super.key,
    required this.appRouter,
    required this.connectivity,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocProvider<InternetCubit>(
            create: (context) => InternetCubit(connectivity: connectivity)),
        BlocProvider<CounterCubit>(
          create: (context) => CounterCubit(),
        )
        // If use Subscription
        /* BlocProvider<CounterCubit>(
          create: (context) =>
              CounterCubit(internetCubit: context.read<InternetCubit>()),
              /*create: (context) =>
              CounterCubit(internetCubit: BlocProvider.of<InternetCubit>(context)),*/
        )*/
      ],
      child: MaterialApp(
        title: 'Flutter Bloc Communication',
        theme: ThemeData(
          primarySwatch: Colors.purple,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        onGenerateRoute: appRouter.onGenerateRoute,
      ),
    );
  }
}
