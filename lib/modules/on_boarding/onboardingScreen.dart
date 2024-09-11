import 'package:flutter/material.dart';
import '../../services/authentication/auth_gate.dart';
import '../../shared/cash_helper.dart';
import '../../shared/componants.dart';
//
// class OnboardingScreen extends StatefulWidget {
//   @override
//   _OnboardingScreenState createState() => _OnboardingScreenState();
// }
//
// class _OnboardingScreenState extends State<OnboardingScreen> {
//   PageController _pageController = PageController(initialPage: 0);
//   int _currentPage = 0;
//
//   // Onboarding data (images, titles, descriptions)
//   final List<Map<String, String>> _onboardingData = [
//     {
//       "image": "assets/images/onboard1.jpg", // Replace with your image asset
//       "title": "Connect with Friends",
//       "description": "Easily connect with your friends anytime, anywhere."
//     },
//     {
//       "image": "assets/images/onboard3.jpg",
//       "title": "Real-Time Messaging",
//       "description": "Enjoy seamless real-time conversations with anyone."
//     },
//     {
//       "image": "assets/images/onboard2.jpg",
//       "title": "Safe & Secure",
//       "description": "Your conversations are end-to-end encrypted and fully secure."
//     },
//   ];
//
//   // Function to change page indicator
//   void _onPageChanged(int page) {
//     setState(() {
//       _currentPage = page;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         actions: [
//           TextButton(onPressed: () {
//             CashHelper.setData('onboarding', true);
//             Navigator.pushReplacement(
//               context,
//               MaterialPageRoute(builder: (context) => AuthGate()),
//             );
//           },
//               child:
//               Text("Skip",
//                 style: TextStyle(
// color: Colors.blue,
//                   fontSize: 20
//
//                 ),
//               ),
//
//           )
//         ],
//       ),
//       body: Stack(
//         alignment: Alignment.topCenter,
//         children: [
//           // PageView for swiping between onboarding screens
//           PageView.builder(
//             controller: _pageController,
//             onPageChanged: _onPageChanged,
//             itemCount: _onboardingData.length,
//             itemBuilder: (context, index) => OnboardingContent(
//               image: _onboardingData[index]['image']!,
//               title: _onboardingData[index]['title']!,
//               description: _onboardingData[index]['description']!,
//             ),
//           ),
//           // Bottom section for progress dots and buttons
//           Positioned(
//             bottom: 50,
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 // Dots indicator
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: List.generate(
//                     _onboardingData.length,
//                         (index) => _buildDot(index),
//                   ),
//                 ),
//                 SizedBox(height: 30),
//                 // Get Started button
//                 _currentPage == _onboardingData.length - 1
//                     ? ElevatedButton(
//                   onPressed: () {
//                     CashHelper.setData('onboarding', true);
//                     Navigator.pushReplacement(
//                       context,
//                       MaterialPageRoute(builder: (context) => AuthGate()),
//                     );
//                   },
//                   child: Text("Get Started"),
//                   style: ElevatedButton.styleFrom(
//                     padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(30),
//                     ),
//                   ),
//                 )
//                     : SizedBox.shrink(), // Hide button if not last page
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   // Widget to create dots indicator
//   Widget _buildDot(int index) {
//     return AnimatedContainer(
//       duration: Duration(milliseconds: 200),
//       margin: EdgeInsets.symmetric(horizontal: 5),
//       height: 10,
//       width: _currentPage == index ? 20 : 10,
//       decoration: BoxDecoration(
//         color: _currentPage == index ? Colors.blue : Colors.grey,
//         borderRadius: BorderRadius.circular(5),
//       ),
//     );
//   }
// }

import 'package:flutter/cupertino.dart';
import 'package:flutter/painting.dart';

class OnboardingScreen extends StatefulWidget {
  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  var controller = PageController();
  bool isLast = false;
  late List<BoardingShopAPP> list = [
    BoardingShopAPP(
        "assets/images/onboard1.jpg", "Connect with friends", "Easily connect with your friends anytime, anywhere."),
    BoardingShopAPP(
        "assets/images/onboard3.jpg", "Real-Time Messaging", "Enjoy seamless real-time conversations with anyone."),
    BoardingShopAPP(
        "assets/images/onboard2.jpg", "Safe & Secure", "Your conversations are end-to-end encrypted and fully secure.")
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: [
            TextButton(
              onPressed: () {
                CashHelper.setData('onboarding', true);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AuthGate(),
                    ));
              },
              child: const Text(
                "SKIP",
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 18,
                ),
              ),
            )
          ],
        ),
        body: PageView.builder(
          physics: BouncingScrollPhysics(),
          itemBuilder: (BuildContext context, int index) =>
              boardingOfChatAPP(context, controller, list[index], isLast),
          controller: controller,
          itemCount: list.length,
          onPageChanged: (value) {
            setState(() {
              value == list.length - 1 ? isLast = true : isLast = false;
            });
          },
        ));
  }
}

class BoardingShopAPP {
  late String assets;
  late String boardTitle;
  late String boardBody;

  BoardingShopAPP(this.assets, this.boardTitle, this.boardBody);
}
