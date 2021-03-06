import 'package:flutter/material.dart';
import 'package:time_tracker/app/home/tasks/screens/tasks_page.dart';
import 'package:time_tracker/app/home/widgets/cupertino_home_scaffold.dart';
import 'package:time_tracker/app/home/widgets/tab_item.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TabItem _currentTab = TabItem.tasks;

  //Bottom navigation mappings
  Map<TabItem, WidgetBuilder> get _widgetBuilders => {
        TabItem.tasks: (_) => TasksPage(),
        TabItem.entries: (_) => Container(),
        TabItem.account: (_) => Container(),
      };

  void _select(TabItem item) {
    if (item == _currentTab) return;
    setState(() {
      _currentTab = item;
    });
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoHomeScaffold(
      currentTab: _currentTab,
      onSelectTab: _select,
      widgetBuilders: _widgetBuilders,
    );
  }
}
