import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../providers/theme_mode_provider.dart'; // Import provider
import '../../../utils/style.dart';

final Uri _url = Uri.parse('https://github.com/DSCVITBHOPAL/Weathered');

class SettingsView extends ConsumerWidget {
  const SettingsView({super.key});

  Future<void> _launchUrl() async {
    if (!await launchUrl(_url)) {
      throw Exception('Could not launch $_url');
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final themeModeNotifier = ref.read(themeModeProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text("Cài đặt")),
      body: Column(
        children: [
          Center(
            child: Text(
              'Cài đặt',
              style: AppStyle.textTheme.titleLarge,
            ),
          ),
          const Gap(8),

          // Theme Mode Dropdown
          Container(
            height: 75,
            margin: const EdgeInsets.fromLTRB(16, 16, 16, 5),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(15.0),
            ),
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                const Icon(Icons.display_settings_rounded, size: 30.0),
                const Gap(10.0),
                Text('Màu nền', style: AppStyle.textTheme.labelSmall),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      DropdownButton<ThemeMode>(
                        value: themeMode,
                        onChanged: (ThemeMode? newMode) {
                          if (newMode != null) {
                            themeModeNotifier.setThemeMode(newMode);
                          }
                        },
                        items: const [
                          DropdownMenuItem(
                            value: ThemeMode.system,
                            child: Text('Mặc định'),
                          ),
                          DropdownMenuItem(
                            value: ThemeMode.light,
                            child: Text('Sáng'),
                          ),
                          DropdownMenuItem(
                            value: ThemeMode.dark,
                            child: Text('Tối'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Send Feedback
          GestureDetector(
            onTap: _launchUrl,
            child: Container(
              height: 75,
              margin: const EdgeInsets.fromLTRB(16, 16, 16, 5),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(15.0),
              ),
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  const Icon(Icons.mail_outline_rounded, size: 30.0),
                  const Gap(10.0),
                  Text("Gửi phản hồi", style: AppStyle.textTheme.labelSmall),
                ],
              ),
            ),
          ),

          const Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text("SonBaoKhang"),
                Gap(20.0),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
