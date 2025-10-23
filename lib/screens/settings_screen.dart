import 'package:dino_run/game/audio_manager.dart';
import 'package:dino_run/models/bgm.dart';
import 'package:dino_run/repositories/audio_repository.dart';
import 'package:dino_run/view_models.dart/quiz_data.dart';
import 'package:dino_run/models/settings.dart';
import 'package:dino_run/view_models.dart/language_provider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final languageProvider = context.watch<LanguageProvider>();
    final languageProviderRead = context.read<LanguageProvider>();

    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(fit: BoxFit.fill, image: AssetImage('assets/images/question background.png')),
            ),
          ),
          Positioned(
            top: MediaQuery.sizeOf(context).height * 0.15,
            left: MediaQuery.sizeOf(context).width * 0.13,
            right: MediaQuery.sizeOf(context).width * 0.13,
            child: SizedBox(
              // width: MediaQuery.of(context).size.width * 0.95,
              // height: MediaQuery.of(context).size.height * 0.95,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Selector<SettingsData, bool>(
                    selector: (_, settings) => settings.settings.bgm,
                    builder: (context, bgm, __) {
                      return SizedBox(
                        height: 40,
                        child: SwitchListTile(
                          activeThumbColor: Colors.green,
                          title: Text(
                            context.watch<LanguageProvider>().music,
                            style: TextStyle(fontSize: 18, color: Colors.black),
                          ),
                          value: bgm,
                          onChanged: (bool value) async {
                            await Provider.of<SettingsData>(context, listen: false).setBgm(value);
                            if (context.mounted && value) {
                              AudioManager.instance.startBgm(Provider.of<SettingsData>(context, listen: false).bgmPath);
                            } else {
                              AudioManager.instance.stopBgm();
                            }
                          },
                        ),
                      );
                    },
                  ),
                  Selector<SettingsData, bool>(
                    selector: (_, settings) => settings.settings.sfx,
                    builder: (context, sfx, __) {
                      return SizedBox(
                        height: 40,
                        child: SwitchListTile(
                          activeThumbColor: Colors.green,
                          title: Text(
                            context.watch<LanguageProvider>().effects,
                            style: TextStyle(fontSize: 18, color: Colors.black),
                          ),
                          value: sfx,
                          onChanged: (bool value) {
                            Provider.of<SettingsData>(context, listen: false).setSfx(value);
                          },
                        ),
                      );
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 14.0),
                        child: Text(
                          'Bg Music',
                          style: TextStyle(fontSize: 18, color: Colors.black),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(right: 28),
                        width: 300,
                        child: DropdownButton(
                          icon: Container(),
                          hint: Text(
                            'Default',
                          ),
                          value: context.watch<SettingsData>().bgmPath,
                          items: [
                            DropdownMenuItem(value: AudioBgm.bgm, child: Text('Default')),
                            DropdownMenuItem(value: AudioBgm.bgm0, child: Text('BGM 1')),
                            DropdownMenuItem(value: AudioBgm.mineCraft01, child: Text('BGM 2')),
                            DropdownMenuItem(value: AudioBgm.mineCraft02, child: Text('BGM 3')),
                            DropdownMenuItem(value: AudioBgm.mineCraft03, child: Text('BGM 4')),
                            DropdownMenuItem(value: AudioBgm.mineCraft04, child: Text('BGM 5')),
                            DropdownMenuItem(value: AudioBgm.retro, child: Text('BGM 6')),
                          ],
                          onChanged: (value) {
                            if (value != null) Provider.of<SettingsData>(context, listen: false).setBgmPath(value);
                          },
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 14.0),
                        child: Text(
                          context.watch<LanguageProvider>().language,
                          style: TextStyle(fontSize: 18, color: Colors.black),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 28.0),
                        child: SegmentedButton(
                          style: ButtonStyle(
                            foregroundColor: WidgetStatePropertyAll(Colors.black),
                            iconColor: WidgetStatePropertyAll(Colors.green),
                          ),
                          onSelectionChanged: (language) {
                            languageProviderRead.changeLanguage(language.first);
                          },
                          multiSelectionEnabled: false,
                          segments: [
                            ButtonSegment(
                              value: 'english',
                              label: Text(
                                'English',
                                style: TextStyle(fontSize: 15, color: Colors.black),
                              ),
                            ),
                            ButtonSegment(
                              value: 'cebuano',
                              label: Text(
                                'Cebuano',
                                style: TextStyle(fontSize: 15, color: Colors.black),
                              ),
                            ),
                          ],
                          selected: {languageProvider.selectedLanguage},
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: MediaQuery.sizeOf(context).height * 0.03,
            left: 0,
            right: 0,
            child: Center(
              child: Image.asset('assets/images/settings.png',
                  height: MediaQuery.sizeOf(context).height * 0.12, width: MediaQuery.sizeOf(context).width * 0.45),
            ),
          ),
          Positioned(
            bottom: MediaQuery.sizeOf(context).height * 0.25,
            left: 0,
            right: 0,
            child: Center(child: Text('@2025')),
          ),
          Positioned(
            height: MediaQuery.sizeOf(context).height * 0.1,
            width: MediaQuery.sizeOf(context).width * 0.1,
            top: 14,
            left: 14,
            child: InkWell(
              onTap: () {
                AudioManager.instance.playSfx(AudioSfx.click);
                context.go('/');
              },
              child: Image.asset(
                'assets/images/back arrow.png',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
