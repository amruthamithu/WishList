import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:wishlist/models/wish.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // ignore: unused_field
  late double _deviceHeight, _deviceWidth;
  String? _newWishContent;
  Box? _box;
  @override
  Widget build(BuildContext context) {
    _deviceWidth = MediaQuery.of(context).size.width;
    _deviceHeight = MediaQuery.of(context).size.height;
    // print("Input value= $_newWishContent");
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: _deviceHeight * 0.15,
        title: const Text(
          "My Wish List!",
          style: TextStyle(fontSize: 25),
        ),
      ),
      body: _wishView(),
      floatingActionButton: _addWishButton(),
    );
  }

  Widget _wishView() {
    return FutureBuilder(
      future: Hive.openBox('wishes'),
      builder: (BuildContext _context, AsyncSnapshot _snapshot) {
        if (_snapshot.hasData) {
          _box = _snapshot.data;
          return _wishList();
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  Widget _wishList() {
    List wishes = _box!.values.toList();
    // Wish _newWish =
    //     Wish(content: "Go to Gym", timestamp: DateTime.now(), done: false);
    // _box?.add(_newWish.toMap());
    return ListView.builder(
      itemCount: wishes.length,
      itemBuilder: (BuildContext _context, int _index) {
        var wish = Wish.fromMap(wishes[_index]);
        return ListTile(
          title: Text(
            wish.content,
            style: TextStyle(
                decoration: wish.done ? TextDecoration.lineThrough : null),
          ),
          subtitle: Text(wish.timestamp.toString()),
          trailing: Icon(
            wish.done
                ? Icons.check_box_outlined
                : Icons.check_box_outline_blank,
            color: Colors.blueGrey,
          ),
          onTap: () {
            wish.done = !wish.done;
            _box!.putAt(_index, wish.toMap());
            setState(() {});
          },
          onLongPress: () {
            _box!.deleteAt(_index);
            setState(() {});
          },
        );
      },
    );
  }

  Widget _addWishButton() {
    return FloatingActionButton(
      onPressed: _displayWishPopup,
      child: const Icon(Icons.add),
    );
  }

  void _displayWishPopup() {
    showDialog(
      context: context,
      builder: (BuildContext _context) {
        return AlertDialog(
          title: const Text("Add new Wish"),
          content: TextField(
            onSubmitted: (_value) {
              if (_newWishContent != null) {
                var _wish = Wish(
                    content: _newWishContent!,
                    timestamp: DateTime.now(),
                    done: false);
                _box!.add(_wish.toMap());
                setState(() {
                  _newWishContent = null;
                  Navigator.pop(context);
                });
              }
            },
            onChanged: (_value) {
              setState(() {
                _newWishContent = _value;
              });
            },
           
          ),
        );
      },
    );
  }
}
