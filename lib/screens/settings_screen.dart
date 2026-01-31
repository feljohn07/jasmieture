import 'package:dino_run/game/audio_manager.dart';
import 'package:dino_run/models/bgm.dart';
import 'package:dino_run/repositories/audio_repository.dart';
import 'package:dino_run/view_models.dart/quiz_data.dart';
import 'package:dino_run/models/settings.dart';
import 'package:dino_run/view_models.dart/language_provider.dart';
import 'package:dino_run/view_models.dart/shop_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart'; // IMPORT THIS
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
              image: DecorationImage(
                  fit: BoxFit.fill,
                  image: AssetImage('assets/images/question background.png')),
            ),
          ),
          Positioned(
            top: MediaQuery.sizeOf(context).height * 0.15,
            left: MediaQuery.sizeOf(context).width * 0.13,
            right: MediaQuery.sizeOf(context).width * 0.13,
            child: SizedBox(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // --- 1. MUSIC TOGGLE ---
                  Selector<SettingsData, bool>(
                    selector: (_, settings) => settings.settings.bgm,
                    builder: (context, bgm, __) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 14.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              context.watch<LanguageProvider>().music,
                              style:
                              TextStyle(fontSize: 18, color: Colors.black),
                            ),
                            Switch(
                              activeThumbColor: Colors.green,
                              value: bgm,
                              onChanged: (bool value) async {
                                await Provider.of<SettingsData>(context,
                                    listen: false)
                                    .setBgm(value);
                                if (context.mounted && value) {
                                  AudioManager.instance.startBgm(
                                      Provider.of<SettingsData>(context,
                                          listen: false)
                                          .bgmPath);
                                } else {
                                  AudioManager.instance.stopBgm();
                                }
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  )
                      .animate(delay: 100.ms) // Delay start
                      .fade(duration: 400.ms)
                      .slideX(begin: -0.1, end: 0, curve: Curves.easeOut),

                  // --- 2. SFX TOGGLE ---
                  Selector<SettingsData, bool>(
                    selector: (_, settings) => settings.settings.sfx,
                    builder: (context, sfx, __) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 14.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              context.watch<LanguageProvider>().effects,
                              style:
                              TextStyle(fontSize: 18, color: Colors.black),
                            ),
                            Switch(
                              activeThumbColor: Colors.green,
                              value: sfx,
                              onChanged: (bool value) {
                                Provider.of<SettingsData>(context,
                                    listen: false)
                                    .setSfx(value);
                              },
                            )
                          ],
                        ),
                      );
                    },
                  )
                      .animate(delay: 200.ms) // Delay slightly more
                      .fade(duration: 400.ms)
                      .slideX(begin: -0.1, end: 0, curve: Curves.easeOut),

                  // --- 3. BG MUSIC DROPDOWN ---
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
                            DropdownMenuItem(
                                value: AudioBgm.bgm, child: Text('Default')),
                            DropdownMenuItem(
                                value: AudioBgm.bgm0, child: Text('BGM 1')),
                            DropdownMenuItem(
                                value: AudioBgm.mineCraft01,
                                child: Text('BGM 2')),
                            DropdownMenuItem(
                                value: AudioBgm.mineCraft02,
                                child: Text('BGM 3')),
                            DropdownMenuItem(
                                value: AudioBgm.mineCraft03,
                                child: Text('BGM 4')),
                            DropdownMenuItem(
                                value: AudioBgm.mineCraft04,
                                child: Text('BGM 5')),
                            DropdownMenuItem(
                                value: AudioBgm.retro, child: Text('BGM 6')),
                          ],
                          onChanged: (value) {
                            if (value != null)
                              Provider.of<SettingsData>(context, listen: false)
                                  .setBgmPath(value);
                          },
                        ),
                      ),
                    ],
                  )
                      .animate(delay: 300.ms)
                      .fade(duration: 400.ms)
                      .slideX(begin: -0.1, end: 0, curve: Curves.easeOut),

                  // --- 4. LANGUAGE SELECTOR ---
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
                            foregroundColor:
                            WidgetStatePropertyAll(Colors.black),
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
                                style: TextStyle(
                                    fontSize: 15, color: Colors.black),
                              ),
                            ),
                            ButtonSegment(
                              value: 'cebuano',
                              label: Text(
                                'Cebuano',
                                style: TextStyle(
                                    fontSize: 15, color: Colors.black),
                              ),
                            ),
                          ],
                          selected: {languageProvider.selectedLanguage},
                        ),
                      ),
                    ],
                  )
                      .animate(delay: 400.ms)
                      .fade(duration: 400.ms)
                      .slideX(begin: -0.1, end: 0, curve: Curves.easeOut),
                ],
              ),
            ),
          ),

          // --- TITLE IMAGE ---
          Positioned(
            top: MediaQuery.sizeOf(context).height * 0.03,
            left: 0,
            right: 0,
            child: Center(
              child: Image.asset('assets/images/settings.png',
                  height: MediaQuery.sizeOf(context).height * 0.12,
                  width: MediaQuery.sizeOf(context).width * 0.45),
            ),
          )
              .animate()
              .fade(duration: 500.ms)
              .moveY(begin: -50, end: 0, curve: Curves.easeOut), // Drop Down

          // --- COPYRIGHT TEXT ---
          Positioned(
            bottom: MediaQuery.sizeOf(context).height * 0.25,
            left: 0,
            right: 0,
            child: Center(
                child: InkWell(
                    onLongPress: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            scrollable: true,
                            title: Text('Override Stars'),
                            content: Text('Set Shop Stars to 500?'),
                            actions: [
                              TextButton(
                                  onPressed: () => context.pop(),
                                  child: Text('cancel')),
                              SizedBox(
                                  width: 145,
                                  child: ElevatedButton(
                                      onPressed: () {
                                        context.read<ShopData>().setStar(500);
                                        context.pop();
                                      },
                                      child: Text('Yes')))
                            ],
                          );
                        },
                      );
                    },
                    child: Text('@2025'))),
          ).animate(delay: 600.ms).fade(), // Fade in last

          // --- BACK ARROW ---
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
          )
              .animate(delay: 200.ms)
              .fade()
              .moveX(begin: -30, end: 0, curve: Curves.easeOut),
        ],
      ),
    );
  }
}