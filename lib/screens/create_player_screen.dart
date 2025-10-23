import 'package:dino_run/models/game/player.dart';
import 'package:dino_run/models/player_data.dart';
import 'package:dino_run/screens/main_menu_screen.dart';
import 'package:dino_run/widgets/plank_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:gap/gap.dart';

class CreateProfileScreen extends StatefulWidget {
  const CreateProfileScreen({super.key});

  static const path = '/create-profile-screen';

  @override
  State<CreateProfileScreen> createState() => _CreateProfileScreenState();
}

class _CreateProfileScreenState extends State<CreateProfileScreen> {
  final formKey = GlobalKey<FormState>();

  final firstnameController = TextEditingController();
  final middlenameController = TextEditingController();
  final lastnameController = TextEditingController();
  final sectionController = TextEditingController();
  final ageController = TextEditingController();

  DateTime? dateOfBirth;

  String? stringValidator(String? value) => (value == null || value.isEmpty) ? 'Fill this field.' : null;

  @override
  initState() {
    super.initState();
    // Lock to portrait mode
    // SystemChrome.setPreferredOrientations([
    //   DeviceOrientation.portraitUp,
    // ]);

    setHorizontalMode();
  }

  Future<void> setHorizontalMode() async {
    await SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
  }

  int calculateAge(DateTime birthDate) {
    DateTime today = DateTime.now();
    int age = today.year - birthDate.year;

    // Adjust if birthday hasn't occurred yet this year
    if (today.month < birthDate.month || (today.month == birthDate.month && today.day < birthDate.day)) {
      age--;
    }

    return age;
  }

  int page = 0;

  void next() {
    if (page >= 5) return;
    setState(() {
      page++;
    });
  }

  void back() {
    if (page <= 0) return;
    setState(() {
      page--;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Form(
        key: formKey,
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(fit: BoxFit.fill, image: AssetImage('assets/images/question background.png')),
              ),
            ),
            Positioned(
              top: MediaQuery.sizeOf(context).height * 0.15,
              left: MediaQuery.sizeOf(context).width * 0.15,
              right: MediaQuery.sizeOf(context).width * 0.15,
              bottom: MediaQuery.sizeOf(context).height * 0.25,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Visibility(
                      visible: page == 0,
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            TextFormField(
                              controller: firstnameController,
                              decoration: InputDecoration(hintText: 'Enter Firstname'),
                              textAlign: TextAlign.center,
                              validator: stringValidator,
                            ),
                            SizedBox(height: 24),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                PlankButton(
                                  onTap: () => next(),
                                  label: 'Next',
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                    Visibility(
                      visible: page == 1,
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            TextFormField(
                              controller: middlenameController,
                              decoration: InputDecoration(hintText: 'Enter Middlename'),
                              textAlign: TextAlign.center,
                              validator: stringValidator,
                            ),
                            SizedBox(height: 24),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                PlankButton(
                                  onTap: () => back(),
                                  label: 'Back',
                                ),
                                PlankButton(
                                  onTap: () => next(),
                                  label: 'Next',
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                    Visibility(
                      visible: page == 2,
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            TextFormField(
                              controller: lastnameController,
                              decoration: InputDecoration(hintText: 'Enter Lastname'),
                              textAlign: TextAlign.center,
                              validator: stringValidator,
                            ),
                            SizedBox(height: 24),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                PlankButton(
                                  onTap: () => back(),
                                  label: 'Back',
                                ),
                                PlankButton(
                                  onTap: () => next(),
                                  label: 'Next',
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                    Visibility(
                      visible: page == 3,
                      child: Column(
                        children: [
                          Center(
                            child: Text('What\'s your  Section?'),
                          ),
                          TextFormField(
                            controller: sectionController,
                            decoration: InputDecoration(hintText: 'Enter your Section'),
                            validator: stringValidator,
                          ),
                          SizedBox(height: 24),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              PlankButton(
                                onTap: () => back(),
                                label: 'Back',
                              ),
                              PlankButton(
                                onTap: () => next(),
                                label: 'Next',
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                    Visibility(
                      visible: page == 4,
                      child: Column(
                        children: [
                          Center(
                            child: Text('How Old are you?'),
                          ),
                          Gap(24),
                          TextFormField(
                            controller: ageController,
                            decoration: InputDecoration(
                              hintText: 'Age',
                            ),
                            keyboardType: TextInputType.numberWithOptions(),
                            validator: stringValidator,
                          ),
                          Gap(24),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              PlankButton(
                                onTap: () => back(),
                                label: 'Back',
                              ),
                              PlankButton(
                                onTap: () async {
                                  if (formKey.currentState!.validate()) {
                                    final player = Player(
                                      firstname: firstnameController.text,
                                      lastname: lastnameController.text,
                                      middlename: middlenameController.text,
                                      section: sectionController.text,
                                      age: int.tryParse(ageController.text) ?? 0,
                                    );
                                    await context.read<PlayerData>().playerRepository.createPlayer(player);
                                    await setHorizontalMode();
                                    if (context.mounted) context.go(MainMenuScreen.path);
                                  }
                                },
                                label: 'Proceed',
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
