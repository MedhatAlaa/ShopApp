import 'package:flutter/material.dart';
import 'package:shop_app/component/ruse_component.dart';
import 'package:shop_app/helper/cache_helper.dart';
import 'package:shop_app/modules/login/login_screen.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({Key? key}) : super(key: key);

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  List<OnBoarding> boardItems = [
    OnBoarding(
      image: 'assets/images/onBoard1.png',
      title: 'On Board 1 Title',
      body: 'On Board 1 body',
    ),
    OnBoarding(
      image: 'assets/images/onBoard2.jpg',
      title: 'On Board 2 Title',
      body: 'On Board 2 body',
    ),
    OnBoarding(
      image: 'assets/images/onBoard3.jpg',
      title: 'On Board 3 Title',
      body: 'On Board 3 body',
    ),
  ];
  var onBoardingController = PageController();
  bool isLast = false;

  void submit() {
    CacheHelper.saveData(
      key: 'onBoarding',
      value: true,
    ).then((value) {
      if (value) {
        navigateAndFinish(
          context,
          LoginScreen(),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton(
            onPressed: () {
              submit();
            },
            child: const Text('SKIP'),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                physics: const BouncingScrollPhysics(),
                controller: onBoardingController,
                itemBuilder: (context, index) => buildItem(boardItems[index]),
                itemCount: boardItems.length,
                onPageChanged: (val) {
                  if (val == boardItems.length - 1) {
                    setState(() {
                      isLast = true;
                    });
                  } else {
                    setState(() {
                      isLast = false;
                    });
                  }
                },
              ),
            ),
            const SizedBox(
              height: 80.0,
            ),
            Row(
              children: [
                SmoothPageIndicator(
                  controller: onBoardingController,
                  count: boardItems.length,
                  effect: const ExpandingDotsEffect(
                    dotColor: Colors.grey,
                    activeDotColor: Colors.blue,
                    dotHeight: 10.0,
                    dotWidth: 10.0,
                    expansionFactor: 4,
                  ),
                ),
                const Spacer(),
                FloatingActionButton(
                  onPressed: () {
                    if (isLast) {
                      submit();
                    }
                    onBoardingController.nextPage(
                      duration: const Duration(
                        milliseconds: 750,
                      ),
                      curve: Curves.fastLinearToSlowEaseIn,
                    );
                  },
                  child: const Icon(
                    Icons.arrow_forward_ios_rounded,
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 10.0,
            ),
          ],
        ),
      ),
    );
  }

  Widget buildItem(OnBoarding onBoarding) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Image(
              image: AssetImage(onBoarding.image),
            ),
          ),
          const SizedBox(
            height: 10.0,
          ),
          Text(
            onBoarding.title,
            style: const TextStyle(
              fontSize: 30.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(
            height: 15.0,
          ),
          Text(
            onBoarding.body,
            style: const TextStyle(
              fontSize: 20.0,
            ),
          ),
        ],
      );
}

class OnBoarding {
  final String image;
  final String title;
  final String body;

  OnBoarding({
    required this.image,
    required this.title,
    required this.body,
  });
}
