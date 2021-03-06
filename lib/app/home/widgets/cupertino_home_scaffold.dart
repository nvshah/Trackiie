import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:time_tracker/app/home/widgets/tab_item.dart';

class CupertinoHomeScaffold extends StatelessWidget {
  final TabItem currentTab;
  final ValueChanged<TabItem> onSelectTab;
  final Map<TabItem, WidgetBuilder> widgetBuilders;
  final Map<TabItem, GlobalKey<NavigatorState>> navigatorKeys;

  const CupertinoHomeScaffold({
    Key key,
    @required this.currentTab,
    @required this.onSelectTab,
    @required this.widgetBuilders,
    @required this.navigatorKeys,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
        tabBar: CupertinoTabBar(
          items: [
            _buildItem(TabItem.tasks),
            _buildItem(TabItem.entries),
            _buildItem(TabItem.account),
          ],
          onTap: (i) => onSelectTab(TabItem.values[i]),
        ),
        tabBuilder: (_, index) {
          final tabItem = TabItem.values[index];
          return CupertinoTabView(
            //to avoid back navigation problem on android
            navigatorKey: navigatorKeys[tabItem],
            builder: (context) => widgetBuilders[tabItem](context),
          );
        });
  }

  BottomNavigationBarItem _buildItem(TabItem tabItem) {
    final tabData = TabItemData.allTabs[tabItem];
    //as cupertino does not distinguish selected tab automatically, we need to make it manually
    final color = currentTab == tabItem ? Colors.indigo : Colors.grey;
    return BottomNavigationBarItem(
        icon: Icon(
          tabData.icon,
          color: color,
        ),
        title: Text(
          tabData.title,
          style: TextStyle(color: color),
        ));
  }
}
