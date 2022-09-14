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
  bool firstGot = true;

  StreamController streamController;

  _PickUserState(this.company, this.stream, this.streamController);

  List<Widget> cards = [];

  List<Widget> cardsOne = [];
  List<Widget> cardTwo = [];
  List<Widget> cardsThree = [];

  final double carouselItemMargin = 16;

  late PageController _pageControllerOne;
  late PageController _pageControllerTwo;
  late PageController _pageControllerThree;
  int _positionOne = 0;
  int _positionTwo = 0;
  int _positionThree = 0;

  List<UserBuS> allUser = [];

  @override
  void initState() {
    super.initState();
    _pageControllerOne = PageController(initialPage: 1, viewportFraction: 0.5);
    _pageControllerTwo = PageController(initialPage: 1, viewportFraction: 0.5);
    _pageControllerThree =
        PageController(initialPage: 1, viewportFraction: 0.5);
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
          width: 25.h,
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

      if (firstGot) {
        if (allUser.length == 1) {
          cardsOne.add(CardFb(
            allUser[0].user_name,
            Icons.supervised_user_circle,
            allUser[0],
            company,
          ));
        } else if (allUser.length == 2) {
          cardsOne.add(CardFb(
            allUser[0].user_name,
            Icons.supervised_user_circle,
            allUser[0],
            company,
          ));
          cardTwo.add(CardFb(
            allUser[1].user_name,
            Icons.supervised_user_circle,
            allUser[1],
            company,
          ));
        } else if (allUser.length > 2) {
          int runner = 0;
          for (int i = 0; i < allUser.length; i++) {
           
           
            if (runner == 0) {
              cardsOne.add(CardFb(
                allUser[i].user_name,
                Icons.supervised_user_circle,
                allUser[i],
                company,
              ));

              runner++;
            } else if (runner == 1) {
              cardTwo.add(CardFb(
                allUser[i].user_name,
                Icons.supervised_user_circle,
                allUser[i],
                company,
              ));
              runner++;
            } else {
              cardsThree.add(CardFb(
                allUser[i].user_name,
                Icons.supervised_user_circle,
                allUser[i],
                company,
              ));

              runner = 0;
            }
          }
        }

        setState(() {});
        firstGot = false;
      }
    }

    Widget imageSlider(int position, var cards, PageController pageController) {
      return AnimatedBuilder(
        animation: pageController,
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

    pickUser(PageController pageController, List<Widget> cards, int positionR) {
      return Container(
        height: 20.h,
        
        child: PageView.builder(
            controller: pageController,
            itemCount: cards.length,
            onPageChanged: (int position) {
              setState(() {
                positionR = position;
              });
            },
            itemBuilder: (BuildContext context, int position) {
              return imageSlider(position, cards, pageController);
            }),
      );
    }

    getUser();

    return Container(
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        pickUser(_pageControllerOne, cardsOne, _positionOne),
        pickUser(_pageControllerTwo, cardTwo, _positionTwo),
        pickUser(_pageControllerThree, cardsThree, _positionThree),
      ]),
    );
  }
}
