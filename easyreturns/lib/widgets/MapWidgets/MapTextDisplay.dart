import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../ChangeNotifiers/requestMapDetailsNotifier.dart';
import '../../mainGlobal/Global.dart';

class MapTextDisplay extends StatelessWidget {
  const MapTextDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    String fullAddress =
        Provider.of<RequestMapDetailsNotifier>(context, listen: true)
            .fullAddress;
    String nameOfCustomer =
        Provider.of<RequestMapDetailsNotifier>(context, listen: true)
            .nameOfCustomer;
    String dayAndTimeOfPickup =
        Provider.of<RequestMapDetailsNotifier>(context, listen: true)
            .dayAndTimeOfPickup;
    String packages =
        Provider.of<RequestMapDetailsNotifier>(context, listen: true).packages;

    TextStyle style = TextStyle(
      color: Theme.of(context).textTheme.displaySmall?.color,
      fontSize: (Global.screenHeight < 600) ? 14 : 20,
    );

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          nameOfCustomer,
          style: style,
          textAlign: TextAlign.center,
        ),
        Text(
          fullAddress,
          style: style,
          textAlign: TextAlign.center,
        ),
        Text(
          packages,
          style: style,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
