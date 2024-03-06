import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_floating_bottom_bar/flutter_floating_bottom_bar.dart';
import 'package:group_project/constants/page_enums.dart';
import 'package:group_project/constants/themes/app_colours.dart';
import 'package:group_project/pages/friend/components/custom_friends_navigation_tab.dart';
import 'package:group_project/pages/friend/current_friend.dart';
import 'package:group_project/pages/friend/friend_request.dart';
import 'package:group_project/pages/friend/friend_suggestion.dart';
import 'package:group_project/pages/layout/app_layout.dart';

class FriendPage extends StatefulWidget {
  const FriendPage({super.key, required this.title});
  final String title;

  @override
  FriendPageState createState() => FriendPageState();
}

class FriendPageState extends State<FriendPage>
    with SingleTickerProviderStateMixin {
  late int currentPage;
  late TabController tabController;
  final List<Color> colors = [
    AppColours.secondary,
    AppColours.secondary,
    AppColours.secondary
  ];

  @override
  void initState() {
    currentPage = 0;
    tabController = TabController(length: 3, vsync: this);
    tabController.animation!.addListener(() {
      final value = tabController.animation!.value.round();
      if (value != currentPage && mounted) {
        changePage(value);
      }
    });
    super.initState();
  }

  void changePage(int newPage) {
    setState(() {
      currentPage = newPage;
    });
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Color unselectedColor = colors[currentPage].computeLuminance() < 0.2
        ? Colors.black
        : Colors.white;
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColours.primary,
        appBar: AppBar(
          title: const FittedBox(
            fit: BoxFit.fitWidth,
            child: Text(
              "Friend",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 23,
              ),
            ),
          ),
          centerTitle: true,
          backgroundColor: AppColours.primary,
          actions: [
            IconButton(
              icon: Theme(
                data: ThemeData(
                    iconTheme: const IconThemeData(color: Colors.white)),
                child: const Icon(Icons.arrow_forward_ios),
              ),
              onPressed: () {
                if (!mounted) return;
                Navigator.pushReplacement(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation1, animation2) =>
                        const AppLayout(
                      currentIndex: Pages.HomePage,
                    ),
                    transitionsBuilder:
                        (context, animation1, animation2, child) {
                      const begin = Offset(0.2, 0.0);
                      const end = Offset(0.0, 0.0);
                      const curve = Curves.easeIn;

                      var tween = Tween(begin: begin, end: end)
                          .chain(CurveTween(curve: curve));
                      var offsetAnimation = animation1.drive(tween);

                      return SlideTransition(
                        position: offsetAnimation,
                        child: child,
                      );
                    },
                    transitionDuration: const Duration(milliseconds: 500),
                  ),
                );
              },
            ),
          ],
        ),
        body: BottomBar(
          fit: StackFit.expand,
          icon: (width, height) => Center(
            child: IconButton(
              padding: EdgeInsets.zero,
              onPressed: null,
              icon: Icon(
                Icons.arrow_upward_rounded,
                color: unselectedColor,
                size: width,
              ),
            ),
          ),
          borderRadius: BorderRadius.circular(20),
          duration: const Duration(seconds: 1),
          curve: Curves.decelerate,
          showIcon: true,
          barColor: colors[currentPage].computeLuminance() > 0.2
              ? AppColours.primaryBright
              : Colors.white,
          start: 2,
          end: 0,
          offset: 10,
          barAlignment: Alignment.bottomCenter,
          iconHeight: 35,
          iconWidth: 35,
          reverse: false,
          hideOnScroll: false,
          scrollOpposite: false,
          body: (context, controller) => TabBarView(
            controller: tabController,
            dragStartBehavior: DragStartBehavior.down,
            physics: const BouncingScrollPhysics(),
            children: const [
              FriendSuggestionsTab(),
              CurrentFriendsTab(),
              FriendRequestsTab(),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              CustomFriendsNavigationTab(
                text: "Suggestions",
                color: currentPage == 0 ? colors[0] : unselectedColor,
                onTap: () {
                  tabController.animateTo(0);
                },
              ),
              CustomFriendsNavigationTab(
                text: "Friends",
                color: currentPage == 1 ? colors[1] : unselectedColor,
                onTap: () {
                  tabController.animateTo(1);
                },
              ),
              CustomFriendsNavigationTab(
                text: "Requests",
                color: currentPage == 2 ? colors[2] : unselectedColor,
                onTap: () {
                  tabController.animateTo(2);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
