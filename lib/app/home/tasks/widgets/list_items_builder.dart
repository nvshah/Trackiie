import 'package:flutter/material.dart';
import 'package:time_tracker/app/home/tasks/widgets/empty_content.dart';

typedef ItemWidgetBuilder<T> = Widget Function(BuildContext context, T item);

class ListItemsBuilder<T> extends StatelessWidget {
  final AsyncSnapshot<List<T>> snapshot;
  final ItemWidgetBuilder<T> itemBuilder;

  const ListItemsBuilder(
      {Key key, @required this.snapshot, @required this.itemBuilder})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (snapshot.hasData) {
      final List<T> items = snapshot.data;
      if (items.isEmpty) {
        return EmptyContent();
      } else {
        _buildList(items);
      }
    } else if (snapshot.hasError) {
      return EmptyContent(
        title: 'Something Went Wrong',
        body: 'No Tasks at moment !',
      );
    }
    return Center(child: CircularProgressIndicator());
  }

  Widget _buildList(List<T> items) {
    return ListView.separated(
        itemCount: items.length + 2,
        separatorBuilder: (context, i) => Divider(height: 0.5),
        itemBuilder: (context, i) {
          //tweak to add seperator before/after first/last item as well
          if (i == 0 || i == items.length + 1) {
            return Container();
          }
          return itemBuilder(context, items[i - 1]);
        });
  }
}
