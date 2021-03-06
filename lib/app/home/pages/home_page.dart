import 'package:flutter/material.dart';
import 'package:time_tracker/app/home/account/pages/account_page.dart';
import 'package:time_tracker/app/home/tasks/screens/tasks_page.dart';
import 'package:time_tracker/app/home/widgets/cupertino_home_scaffold.dart';
import 'package:time_tracker/app/home/widgets/tab_item.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TabItem _currentTab = TabItem.tasks;

  //navigator key mappings esp to handle back navigation issue on android
  Map<TabItem, GlobalKey<NavigatorState>> get _navigatorKeys => {
        TabItem.tasks: GlobalKey<NavigatorState>(),
        TabItem.entries: GlobalKey<NavigatorState>(),
        TabItem.account: GlobalKey<NavigatorState>(),
      };

  //Bottom navigation mappings
  Map<TabItem, WidgetBuilder> get _widgetBuilders => {
        TabItem.tasks: (_) => TasksPage(),
        TabItem.entries: (_) => Container(),
        TabItem.account: (_) => AccountPage(),
      };

  void _select(TabItem item) {
    if (item == _currentTab) return;
    setState(() {
      _currentTab = item;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      //Inorder to avoid back navigation problem on android back button click
      onWillPop: () async =>
          !(await _navigatorKeys[_currentTab].currentState.maybePop()),
      child: CupertinoHomeScaffold(
        currentTab: _currentTab,
        onSelectTab: _select,
        widgetBuilders: _widgetBuilders,
        navigatorKeys: _navigatorKeys,
      ),
    );
  }
}
