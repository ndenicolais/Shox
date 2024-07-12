import 'package:flutter/material.dart';
import 'package:ming_cute_icons/ming_cute_icons.dart';

class WipPage extends StatefulWidget {
  const WipPage({super.key});

  @override
  WipPageState createState() => WipPageState();
}

class WipPageState extends State<WipPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            MingCuteIcons.mgc_large_arrow_left_fill,
            color: Theme.of(context).colorScheme.secondary,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.secondary,
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                MingCuteIcons.mgc_traffic_cone_fill,
                size: 120,
                color: Theme.of(context).colorScheme.secondary,
              ),
              Text(
                'Work\nIn\nProgress',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.secondary,
                  fontSize: 70,
                  fontFamily: 'CustomFontBold',
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
