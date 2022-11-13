import 'package:easyreturns/ChangeNotifiers/GetPickupRequestNotifier.dart';
import 'package:easyreturns/DAOS/pickupRequestDao.dart';
import 'package:easyreturns/models/PickupRequest.dart';
import 'package:easyreturns/screens/HomeScreen.dart';
import 'package:easyreturns/screens/NewPickupScreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../screens/SplashScreen.dart';

/// @nodoc
class AppRouter extends StatelessWidget {
  const AppRouter({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    PickupRequestDao pickupRequestDao = PickupRequestDao();
    return MultiProvider(
      providers: [
        StreamProvider<List<PickupRequest>>(
          create: (_) => pickupRequestDao.streamPickupRequestsList(),
          initialData: const [],
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: '',
        builder: (context, widget) => Navigator(
          onGenerateRoute: (RouteSettings settings) => MaterialPageRoute(
            builder: (ctx) {
              return Container(
                child: widget,
              );
            },
          ),
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => const SplashScreen(),
          '/home': (context) => HomeScreen(),
          '/new-pickup': ((context) => NewPickupScreen()),
        },
      ),
    );
  }
}
