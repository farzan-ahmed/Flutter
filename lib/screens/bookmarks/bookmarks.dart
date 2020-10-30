import 'dart:convert';
import 'package:browserapp/models/bookmark.dart';
import 'package:flutter/material.dart';
import '../../classes/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BookmarksScreen extends StatefulWidget {
  BookmarksScreen({Key key, this.bookmarks}) : super(key: key);

  final List<Bookmark> bookmarks;

  @override
  _BookmarksScreenState createState() => _BookmarksScreenState();
}

class _BookmarksScreenState extends State<BookmarksScreen> {
  void _triggerOption(Bookmark bookmark, String option) async {
    switch (option) {
      case 'delete':
        SharedPreferences sharedPreferences =
            await SharedPreferences.getInstance();
        setState(() {
          widget.bookmarks.remove(bookmark);
          sharedPreferences.setString(
              'bookmarks', jsonEncode(widget.bookmarks));
        });
        break;
      default:
        throw ("The option '$option' is not implemented.");
    }
  }

  @override
  Widget build(BuildContext context) {
    final Iterable<ListTile> tiles = widget.bookmarks.map((Bookmark bookmark) {
      return ListTile(
        trailing: PopupMenuButton<String>(
          icon: Icon(Icons.more_vert),
          onSelected: (String option) => _triggerOption(bookmark, option),
          itemBuilder: (BuildContext context) {
            return [
              PopupMenuItem(
                child: Text('Delete'),
                value: 'delete',
              )
            ].toList();
          },
        ),
        title: Text(
          bookmark.title,
          style: TextStyle(fontSize: 16.0),
        ),
        subtitle: Text(
          bookmark.url,
          style: TextStyle(fontSize: 14.0),
        ),
        onTap: () => Navigator.pop(context, bookmark.url),
      );
    });

    final List<Widget> dividedTiles =
        ListTile.divideTiles(context: context, tiles: tiles).toList();

    final Center emptyContainer =
        Center(child: Text('You haven\'t added any bookmarks yet.'));

    Widget listView = ListView(
      children: dividedTiles,
    );

    return WillPopScope(
        onWillPop: () async {
          if (Navigator.of(context).userGestureInProgress)
            return false;
          else
            return true;
        },
        child: Scaffold(
            appBar: AppBar(
              title: Text(Constants.OPTION_BOOKMARKS),
            ),
            body: widget.bookmarks.isEmpty ? emptyContainer : listView));
  }
}
