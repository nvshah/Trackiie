import 'package:flutter/material.dart';

enum TabItem { tasks, entries, account }

class TabItemData {
  final IconData icon;
  final String title;

  const TabItemData({@required this.icon, @required this.title});

  static const allTabs = {
    TabItem.tasks: TabItemData(icon: Icons.work, title: "Tasks"),
    TabItem.entries: TabItemData(icon: Icons.view_headline, title: "Entries"),
    TabItem.account: TabItemData(icon: Icons.person, title: "Account"),
  };
}
