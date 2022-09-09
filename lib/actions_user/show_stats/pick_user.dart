import 'dart:async';

import 'package:flutter/material.dart';
import 'package:itm_ichtrinkmehr_flutter/actions_user/show_stats/stats_main.dart';
import 'package:itm_ichtrinkmehr_flutter/values/user.dart';
import 'package:itm_ichtrinkmehr_flutter/web_db/select_statements.dart';

import '../../values/company.dart';

import 'package:sizer/sizer.dart';

class PickUser extends StatefulWidget {
  Company company;
  Stream stream;
  StreamController streamController;

  PickUser(this.company, this.stream, this.streamController, {Key? key})
      : super(key: key);

  @override
  State<PickUser> createState() =>
      _PickUserState(company, stream, streamController);
}

class _PickUserState extends State<PickUser> {
  Company company;
  Stream stream;

  StreamController streamController;

  _PickUserState(this.company, this.stream, this.streamController);

  List<Widget> cards = [];

  final double carouselItemMargin = 16;

  late PageController _pageController;
  int _position = 0;

  List<UserBuS> allUser = [];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 3, viewportFraction: 0.5);
  }

  @override
  Widget build(BuildContext context) {
    bool pickingwidget = true;

    Widget CardFb(
      String text,
      IconData imageUrl,
      UserBuS user,
      Company company,
    ) {
      return GestureDetector(
        onTap: () {
          streamController.add(user);
        },
        child: Container(
          width: 20.h,
          height: 18.h,
          padding: EdgeInsets.all(2.h),
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
              Text(text,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Theme.of(context).backgroundColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 25.sp,
                  )),
              const SizedBox(
                height: 5,
              ),
            ],
          ),
        ),
      );
    }

    getUser() async {
      allUser = await SelectStatements().selectAllUserOfCompany(company);

      for (int i = 0; i < allUser.length; i++) {
        cards.add(CardFb(
          allUser[i].user_name,
          Icons.supervised_user_circle,
          allUser[i],
          company,
        ));
      }
      setState(() {});
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

    pickUser() {
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

    getUser();

    return Container(
      child: pickUser(),
    );
  }
}
