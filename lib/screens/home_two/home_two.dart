import 'package:cardifly/ui/components/app_button_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:svg_flutter/svg.dart';

class HomeTwo extends StatefulWidget {
  const HomeTwo({super.key});

  @override
  State<HomeTwo> createState() => _HomeTwoState();
}

class _HomeTwoState extends State<HomeTwo> {
  final btnColor = const Color.fromARGB(255, 13, 61, 100);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 50),
                  SvgPicture.asset(
                    'assets/svg/onboarding.svg',
                    width: 200,
                    height: 200,
                  ),
                  const SizedBox(height: 40),
                  const Text(
                    "Bienvenue sur CardiFly",
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  const Text(
                    "Nous vous présentons la nouvelle version de notre \napplication avec code source.",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey, fontSize: 15),
                  ),
                  SizedBox(
                    height: 60,
                    child: Row(
                      children: [
                        const SizedBox(width: 20),
                        Expanded(
                          child: Container(
                            height: 1,
                            decoration: BoxDecoration(
                              color: Colors.grey.withValues(alpha: 0.3),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          "Passez au niveau supérieur.",
                          style: TextStyle(
                            color: Colors.grey.withValues(alpha: 0.8),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Container(
                            height: 1,
                            decoration: BoxDecoration(
                              color: Colors.grey.withValues(alpha: 0.3),
                            ),
                          ),
                        ),
                        const SizedBox(width: 20),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  AppButtonWidget(
                    height: 42,
                    title: "Continuer avec E-mail",
                    onPressed: () {},
                    borderColor: btnColor,
                    backgroundColor: Colors.transparent,
                    enabled: true,
                    labelColor: Colors.black,
                    icon: CupertinoIcons.envelope_fill,
                    iconColor: btnColor,
                  ),
                  const SizedBox(height: 10),
                  AppButtonWidget(
                    height: 42,
                    title: "Continuer avec Google",
                    onPressed: () {},
                    backgroundColor: btnColor,
                    labelColor: Colors.white,
                    svgIcon: 'assets/svg/google.svg',
                  ),
                  const SizedBox(height: 10),
                  AppButtonWidget(
                    height: 42,
                    title: "Continuer avec Apple",
                    onPressed: () {},
                    backgroundColor: btnColor,
                    labelColor: Colors.white,
                    svgIcon: 'assets/svg/apple.svg',
                    iconColor: Colors.white,
                  ),
                  const SizedBox(height: 10),
                  AppButtonWidget(
                    height: 42,
                    title: "Continuer avec Facebook",
                    onPressed: () {},
                    backgroundColor: btnColor,
                    labelColor: Colors.white,
                    svgIcon: 'assets/svg/facebook.svg',
                  ),
                  const SizedBox(height: 20),
                  RichText(
                    text: TextSpan(
                      text: "Déjà un compte ?",
                      style: const TextStyle(color: Colors.black45),
                      children: [
                        TextSpan(
                          text: " Connectez-vous !",
                          style: TextStyle(
                            color: btnColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
