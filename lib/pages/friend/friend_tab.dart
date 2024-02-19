import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_floating_bottom_bar/flutter_floating_bottom_bar.dart';
import 'package:group_project/constants/themes/app_colours.dart';
import 'package:group_project/pages/friend/current_friend.dart';
import 'package:group_project/pages/friend/friend_request.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_contacts/flutter_contacts.dart';

class FriendPage extends StatefulWidget {
  FriendPage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _FriendPageState createState() => _FriendPageState();
}

class _FriendPageState extends State<FriendPage> with SingleTickerProviderStateMixin {
  late int currentPage;
  late TabController tabController;
  final List<Color> colors = [AppColours.secondaryDark, AppColours.secondaryDark, AppColours.secondaryDark];
  List<Contact> contacts = [];

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
    _checkAndRequestContactPermission();
  }

  Future<void> _checkAndRequestContactPermission() async {
    var status = await Permission.contacts.status;

    if (!status.isGranted) {
      await _requestContactsPermission();
    }
  }

  Future<void> _requestContactsPermission() async {
    var result = await Permission.contacts.request();
    print('Contact Permission Status: ${result}');
    if (result.isGranted) {
      await _getContacts();
    } else if (result.isPermanentlyDenied) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Permission Required'),
            content: Text('Contacts permission is required to use this feature. Please grant the permission in settings.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  Future<void> _getContacts() async {
    List<Contact> fetchedContacts = await FlutterContacts.getContacts(withProperties: true);
    setState(() {
      contacts = fetchedContacts;
    });
  }

  Future<void> _checkContactsPermissionAndFetch() async {
    var status = await Permission.contacts.status;
    if (status.isGranted) {
      await _getContacts();
    }
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
    _checkContactsPermissionAndFetch();

    final Color unselectedColor = colors[currentPage].computeLuminance() < 0.2 ? Colors.black : Colors.white;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: FittedBox(
            fit: BoxFit.fitWidth,
            child: Text(
              "Friend",
              style: const TextStyle(
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
                data: ThemeData(iconTheme: IconThemeData(color: Colors.white)),
                child: const Icon(Icons.arrow_forward_ios),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
        body: BottomBar(
          child: TabBar(
            indicatorPadding: const EdgeInsets.fromLTRB(6, 0, 6, 0),
            controller: tabController,
            indicator: UnderlineTabIndicator(
              borderSide: BorderSide(
                color: currentPage == 0 ? colors[0] : currentPage == 1 ? colors[1] : currentPage == 2 ? colors[2] : unselectedColor,
                width: 4,
              ),
              insets: EdgeInsets.fromLTRB(16, 0, 16, 8),
            ),
            tabs: [
              SizedBox(
                height: 55,
                width: 40,
                child: Center(
                  child: IconButton(
                    icon: Icon(
                      Icons.home,
                      color: currentPage == 0 ? colors[0] : unselectedColor,
                    ),
                    onPressed: () {
                      tabController.animateTo(0);
                    },
                  ),
                ),
              ),
              SizedBox(
                height: 55,
                width: 40,
                child: Center(
                  child: IconButton(
                    icon: Icon(
                      Icons.search,
                      color: currentPage == 1 ? colors[1] : unselectedColor,
                    ),
                    onPressed: () {
                      tabController.animateTo(1);
                    },
                  ),
                ),
              ),
              SizedBox(
                height: 55,
                width: 40,
                child: Center(
                  child: IconButton(
                    icon: Icon(
                      Icons.add,
                      color: currentPage == 2 ? colors[2] : unselectedColor,
                    ),
                    onPressed: () {
                      tabController.animateTo(2);
                    },
                  ),
                ),
              ),
            ],
          ),
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
          borderRadius: BorderRadius.circular(500),
          duration: Duration(seconds: 1),
          curve: Curves.decelerate,
          showIcon: true,
          width: MediaQuery.of(context).size.width * 0.8,
          barColor: colors[currentPage].computeLuminance() > 0.2 ? Colors.black : Colors.white,
          start: 2,
          end: 0,
          offset: 10,
          barAlignment: Alignment.bottomCenter,
          iconHeight: 35,
          iconWidth: 35,
          reverse: false,
          hideOnScroll: false,
          scrollOpposite: false,
          onBottomBarHidden: () {},
          onBottomBarShown: () {},
          body: (context, controller) => TabBarView(
            controller: tabController,
            dragStartBehavior: DragStartBehavior.down,
            physics: const BouncingScrollPhysics(),
            children: [
              FriendSuggestionsTab(controller: controller, color: Colors.green, contacts: contacts),
              CurrentFriendsTab(),
              FriendRequestsTab(),
            ],
          ),
        ),
      ),
    );
  }
}

class FriendSuggestionsTab extends StatelessWidget {
  const FriendSuggestionsTab({Key? key, required ScrollController controller, required MaterialColor color, required this.contacts}) : super(key: key);

  final List<Contact> contacts;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: contacts.isEmpty
          ? Text('No contact found')
          : ListView.builder(
        itemCount: contacts.length,
        itemBuilder: (context, index) {
          // Display your contact items here
          return ListTile(
            title: Text(contacts[index].displayName),
            // Add more contact information as needed
          );
        },
      ),
    );
  }
}
