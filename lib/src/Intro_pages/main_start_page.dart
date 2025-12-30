import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gleekeyu/src/Auth/Login/userLogin_view.dart';
import 'package:gleekeyu/src/Auth/Ragistration/register.dart';
import 'package:gleekeyu/src/HomePage/homePage_view.dart';
import 'package:gleekeyu/utils/style/constants.dart';
import 'package:gleekeyu/utils/style/palette.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../widgets/fade_slide_transition.dart';

class MainStartPage extends StatefulWidget {
  const MainStartPage({Key? key}) : super(key: key);

  @override
  State<MainStartPage> createState() => _MainStartPageState();
}

class _MainStartPageState extends State<MainStartPage>
    with SingleTickerProviderStateMixin {
  AnimationController? _animationController;
  Animation<double>? _formElementAnimation;

  var space;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: kLoginAnimationDuration,
    );
    var fadeSlideTween = Tween<double>(begin: 0.0, end: 1.0);
    _formElementAnimation = fadeSlideTween.animate(
      CurvedAnimation(
        parent: _animationController!,
        curve: const Interval(0.45, 0.8, curve: Curves.easeInOut),
      ),
    );
    _animationController!.forward();
  }

  @override
  Widget build(BuildContext context) {
    var height =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;
    space = height > 650 ? kSpaceM : kSpaceS;
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            bottom: 50,
            child: backGroudImage(),
          ),
          start(),
        ],
      ),
    );
  }

  Widget backGroudImage() {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/backg5.webp'),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget start() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        padding: const EdgeInsets.all(20),

        width: MediaQuery.of(context).size.width,
        height: 300,
        decoration: BoxDecoration(
          color: Color(0xff101928),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xff101928).withOpacity(0.01),
              Color(0xff101928).withOpacity(0.3),
              Color(0xff101928).withOpacity(0.5),
              Color(0xff101928).withOpacity(0.7),
              Color(0xff101928),
              Color(0xff101928),
            ],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            const SizedBox(height: 15),
            FadeSlideTransition(
              animation: _formElementAnimation!,
              additionalOffset: space,
              child: const Center(
                child: Text(
                  "Your Relaxing Retreat: Gleekey's Inviting Accommodations",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 15),
            FadeSlideTransition(
              animation: _formElementAnimation!,
              additionalOffset: space,
              child: MaterialButton(
                color: kOrange,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text('START', style: Palette.onboardingText1),
                onPressed: () {
                  final box = Hive.box('gleekey');
                  box.put('isEverLogedin', "true");
                  Get.offAll(() => const HomePage());
                },
              ),
            ),
            const SizedBox(height: 15),
            FadeSlideTransition(
              animation: _formElementAnimation!,
              additionalOffset: space,
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Register()),
                  );
                },
                child: Text(
                  'don’t have account?',
                  style: Palette.onboardingText2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
