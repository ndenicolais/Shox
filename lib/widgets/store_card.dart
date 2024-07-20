import 'package:flutter/material.dart';
import 'package:ming_cute_icons/ming_cute_icons.dart';
import 'package:url_launcher/url_launcher.dart';

class StoreCard extends StatelessWidget {
  final String title;
  final String mapUrl;
  final String linkUrl;

  const StoreCard({
    super.key,
    required this.title,
    required this.mapUrl,
    required this.linkUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.secondary,
      margin: const EdgeInsets.all(10),
      elevation: 5,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 10),
          Center(
            child: Column(
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'CustomFont',
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: Icon(
                        MingCuteIcons.mgc_map_line,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      onPressed: () {
                        _launchURL(mapUrl);
                      },
                    ),
                    const SizedBox(width: 10),
                    IconButton(
                      icon: Icon(
                        MingCuteIcons.mgc_external_link_line,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      onPressed: () {
                        _launchURL(linkUrl);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  void _launchURL(String url) async {
    await launchUrl(Uri.parse(url));
  }
}
