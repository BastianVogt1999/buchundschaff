import 'dart:async';

import 'package:flutter/material.dart';
import 'package:itm_ichtrinkmehr_flutter/intro/rollen_input.dart';
import 'package:itm_ichtrinkmehr_flutter/values/colors.dart';
import 'package:sizer/sizer.dart';

WhiteMode whiteMode = WhiteMode();

class cusCar extends StatefulWidget {
  Stream stream;
  StreamController streamController;

  cusCar(this.stream, this.streamController);

  @override
  _CustomCarouselFB2State createState() =>
      _CustomCarouselFB2State(stream, streamController);
}

class _CustomCarouselFB2State extends State<cusCar> {
  Stream stream;
  StreamController streamController;

  _CustomCarouselFB2State(this.stream, this.streamController);

  final double carouselItemMargin = 16;

  late PageController _pageController;
  int _position = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 1, viewportFraction: 0.7);
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> cards = [
      CardFb1(
        text: "Anmelden als User",
        imageUrl: Icons.supervised_user_circle,
        subtitle: "",
        isAdmin: "false",
        stream: stream,
        streamControllerUserInput: streamControllerUserInput,
      ),
      CardFb1(
        text: "Anmelden als Admin",
        imageUrl: Icons.admin_panel_settings,
        subtitle: "Erweiterte Funktionen",
        isAdmin: "true",
        stream: stream,
        streamControllerUserInput: streamControllerUserInput,
      ),
    ];

    return PageView.builder(
        controller: _pageController,
        itemCount: cards.length,
        onPageChanged: (int position) {
          setState(() {
            _position = position;
          });
        },
        itemBuilder: (BuildContext context, int position) {
          return imageSlider(position, cards);
        });
  }

  Widget imageSlider(int position, var cards) {
    return AnimatedBuilder(
      animation: _pageController,
      builder: (BuildContext context, widget) {
        return Container(
          margin: EdgeInsets.all(carouselItemMargin),
          child: Center(child: widget),
        );
      },
      child: Container(
        child: cards[position],
      ),
    );
  }
}

class CardFb1 extends StatelessWidget {
  final String text;
  final IconData imageUrl;
  final String subtitle;
  final String isAdmin;
  final Stream stream;
  final StreamController streamControllerUserInput;

  const CardFb1({
    required this.text,
    required this.imageUrl,
    required this.subtitle,
    required this.isAdmin,
    required this.stream,
    required this.streamControllerUserInput,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        streamControllerUserInput.add(isAdmin);
      },
      child: Container(
        width: 40.h,
        height: 28.h,
        padding: const EdgeInsets.all(30.0),
        decoration: BoxDecoration(
          color: Theme.of(context).textSelectionTheme.selectionColor!,
          borderRadius: BorderRadius.circular(12.5),
          boxShadow: [
            BoxShadow(
                offset: const Offset(10, 20),
                blurRadius: 10,
                spreadRadius: 0,
                color: Colors.grey.withOpacity(.2)),
          ],
        ),
        child: Column(
          children: [
            SizedBox(
              height: 10.h,
              child: Icon(
                imageUrl,
                color: Theme.of(context).backgroundColor,
                size: 100,
              ),
            ),
            const Spacer(),
            Text(text,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Theme.of(context).backgroundColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                )),
            const SizedBox(
              height: 5,
            ),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Theme.of(context).backgroundColor,
                  fontWeight: FontWeight.normal,
                  fontSize: 10),
            ),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}
