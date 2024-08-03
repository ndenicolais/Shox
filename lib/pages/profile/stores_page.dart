import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ming_cute_icons/ming_cute_icons.dart';
import 'package:shox/generated/l10n.dart';
import 'package:shox/widgets/store_card.dart';

class StoresPage extends StatefulWidget {
  const StoresPage({super.key});

  @override
  StoresPageState createState() => StoresPageState();
}

class StoresPageState extends State<StoresPage> {
  @override
  Widget build(BuildContext context) {
    final List<String> titles = [
      'Alcott',
      'Bershka',
      'Calliope',
      'David',
      'H&M',
      'Kiabi',
      'Kik',
      'Piazza Italia',
      'Primark',
      'Pull & Bear',
      'Sinsay',
      'Terranova',
      'Zara',
      'Zuiki',
    ];

    final List<String> mapUrls = [
      'https://www.google.com/maps/search/?api=1&query=Alcott',
      'https://www.google.com/maps/search/?api=1&query=Bershka',
      'https://www.google.com/maps/search/?api=1&query=Calliope',
      'https://www.google.com/maps/search/?api=1&query=David',
      'https://www.google.com/maps/search/?api=1&query=H&M',
      'https://www.google.com/maps/search/?api=1&query=Kiabi',
      'https://www.google.com/maps/search/?api=1&query=Kik',
      'https://www.google.com/maps/search/?api=1&query=Piazza+Italia',
      'https://www.google.com/maps/search/?api=1&query=Primark',
      'https://www.google.com/maps/search/?api=1&query=Pull+%26+Bear',
      'https://www.google.com/maps/search/?api=1&query=Sinsay',
      'https://www.google.com/maps/search/?api=1&query=Terranova',
      'https://www.google.com/maps/search/?api=1&query=Zara',
      'https://www.google.com/maps/search/?api=1&query=Zuiki',
    ];

    final List<String> linkUrls = [
      'https://www.alcott.eu/',
      'https://www.bershka.com/',
      'https://www.calliope.style/',
      'https://www.gruppodavidrevolution.it/',
      'https://www2.hm.com/',
      'https://www.kiabi.it/',
      'https://azienda.kik.it/',
      'https://www.piazzaitalia.it/',
      'https://www.primark.com/',
      'https://www.pullandbear.com/',
      'https://www.sinsay.com/',
      'https://www.terranovastyle.com/',
      'https://www.zara.com/',
      'https://www.zuiki.it/',
    ];

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            MingCuteIcons.mgc_large_arrow_left_fill,
            color: Theme.of(context).colorScheme.secondary,
          ),
          onPressed: () {
            Get.back();
          },
        ),
        title: Text(
          S.current.stores_title,
          style: TextStyle(
            color: Theme.of(context).colorScheme.tertiary,
            fontWeight: FontWeight.bold,
            fontFamily: 'CustomFont',
          ),
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.secondary,
      ),
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 30.r, horizontal: 30.r),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/img_stores.png',
                width: 120.r,
                height: 120.r,
              ),
              20.verticalSpace,
              Expanded(
                child: ListView.builder(
                  itemCount: titles.length,
                  itemBuilder: (context, index) {
                    return StoreCard(
                      title: titles[index],
                      mapUrl: mapUrls[index],
                      linkUrl: linkUrls[index],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
