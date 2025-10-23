import 'package:dino_run/core/shared/colors.dart';
import 'package:dino_run/game/audio_manager.dart';
import 'package:dino_run/models/game/player.dart';
import 'package:dino_run/models/player_data.dart';
import 'package:dino_run/repositories/audio_repository.dart';
import 'package:dino_run/screens/main_menu_screen.dart';
import 'package:dino_run/widgets/plank_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  static const path = '/profile-screen';

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final formKey = GlobalKey<FormState>();

  Player? player;

  final firstnameController = TextEditingController();
  final middlenameController = TextEditingController();
  final lastnameController = TextEditingController();
  final sectionController = TextEditingController();
  final ageController = TextEditingController();

  DateTime? dateOfBirth;

  @override
  void initState() {
    super.initState();
    loadProfile();
  }

  void loadProfile() {
    player = context.read<PlayerData>().playerRepository.getPlayer();
    if (player != null) {
      firstnameController.text = player!.firstname;
      middlenameController.text = player!.middlename;
      lastnameController.text = player!.lastname;
      sectionController.text = player!.section;
      ageController.text = player!.age.toString();
      // calculateAge(player!.dateOfBirth).toString();
      // dateOfBirth = player!.dateOfBirth;
    }
  }

  String? stringValidator(String? value) => (value == null || value.isEmpty) ? 'Fill this field.' : null;

  int calculateAge(DateTime birthDate) {
    DateTime today = DateTime.now();
    int age = today.year - birthDate.year;

    // Adjust if birthday hasn't occurred yet this year
    if (today.month < birthDate.month || (today.month == birthDate.month && today.day < birthDate.day)) {
      age--;
    }

    return age;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(builder: (context, constraints) {
        return Stack(
          children: [
            Container(
              height: constraints.maxHeight,
              decoration: BoxDecoration(
                image: DecorationImage(fit: BoxFit.fill, image: AssetImage('assets/images/question background.png')),
              ),
              child: Padding(
                padding: EdgeInsets.only(
                  left: constraints.maxWidth * 0.15,
                  right: constraints.maxWidth * 0.15,
                  top: constraints.maxHeight * 0.15,
                  bottom: constraints.maxHeight * 0.25,
                ),
                child: SingleChildScrollView(
                  clipBehavior: Clip.hardEdge,
                  child: Form(
                    key: formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //   children: [
                        //     Text(
                        //       'Player Profile',
                        //       style: TextStyle(fontSize: 32),
                        //     ),
                        //     InkWell(
                        //         onTap: () {
                        //           context.go(MainMenuScreen.path);
                        //         },
                        //         child: Icon(Icons.close, size: 32, color: Colors.red)),
                        //   ],
                        // ),
                        SizedBox(
                          height: 14,
                        ),
                        Row(
                          spacing: 14,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Flexible(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('First name'),
                                  TextFormField(
                                    controller: firstnameController,
                                    validator: stringValidator,
                                  ),
                                ],
                              ),
                            ),
                            Flexible(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Middle name'),
                                  TextFormField(
                                    controller: middlenameController,
                                    validator: stringValidator,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 14,
                        ),
                        Row(
                          spacing: 14,
                          children: [
                            Flexible(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Last name'),
                                  TextFormField(
                                    controller: lastnameController,
                                    validator: stringValidator,
                                  ),
                                ],
                              ),
                            ),
                            Flexible(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Section'),
                                  TextFormField(
                                    controller: sectionController,
                                    validator: stringValidator,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 14),
                        Row(
                          children: [
                            Flexible(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Age'),
                                  TextFormField(
                                    controller: ageController,
                                    decoration: InputDecoration(),
                                    validator: stringValidator,
                                  ),
                                ],
                              ),
                            ),
                            Flexible(
                              child: PlankButton(
                                onTap: () async {
                                  if (formKey.currentState!.validate()) {
                                    // final player = Player(
                                    //   firstname: firstnameController.text,
                                    //   lastname: lastnameController.text,
                                    //   middlename: middlenameController.text,
                                    //   section: sectionController.text,
                                    //   dateOfBirth: dateOfBirth!,
                                    // );

                                    player
                                      ?..firstname = firstnameController.text
                                      ..lastname = lastnameController.text
                                      ..middlename = middlenameController.text
                                      ..section = sectionController.text
                                      ..age = int.tryParse(ageController.text) ?? 0;

                                    await context.read<PlayerData>().playerRepository.updatePlayer(player!);
                                    if (context.mounted) context.go(MainMenuScreen.path);
                                  }
                                },
                                label: 'Update',
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 14,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              top: MediaQuery.sizeOf(context).height * 0.01,
              left: 0,
              right: 0,
              child: Center(
                child: Image.asset('assets/images/player profile.png',
                    height: MediaQuery.sizeOf(context).height * 0.15, width: MediaQuery.sizeOf(context).width * 0.45),
              ),
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
        );
      }),
    );
  }
}
