import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:itunesmusic/music.dart';

class MusicList extends StatefulWidget {
  @override
  _MusicListState createState() => _MusicListState();
}

class _MusicListState extends State<MusicList> {
  bool apiCall = false;
  bool loading = false;
  TextEditingController musicController = TextEditingController();
  List<Music> list = [];
  Future<List<Music>> fetchMusicList(String text) async {
    final url = 'https://itunes.apple.com/search?limit=25&term=$text';
    setState(() {
      loading = true;
    });
    final response = await http
        .get(Uri.encodeFull(url), headers: {"Accept": "application/json"});
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      var decData = data["results"] as List;
      list = decData.map<Music>((json) => Music.fromJson(json)).toList();
      setState(() {
        loading = false;
      });
      print(decData);
      setState(() {});
      return list;
    } else {
      throw Exception('Failed to fetch music');
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Itunes Music'),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: <Widget>[
                textField(),
                icon(),
              ],
            ),
          ),
          list.isEmpty
              ? Expanded(
                  child: Align(
                      alignment: Alignment.center,
                      child: Text('Empty',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w400))),
                )
              : listView(),
        ],
      ),
    );
  }

  Widget icon() {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: Container(
        decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(15)),
        child: IconButton(
          icon: Icon(Icons.send, color: Colors.white),
          onPressed: () {
            fetchMusicList(musicController.text);
          },
        ),
      ),
    );
  }

  Widget listView() {
    return Expanded(
      child: loading
          ? Align(
              alignment: Alignment.center,
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: list.length,
              itemBuilder: (context, index) {
                return Card(
                  elevation: 2,
                  child: ListTile(
                    title: Text(list[index].trackCensoredName),
                    subtitle: Text(list[index].artistName),
                  ),
                );
              }),
    );
  }

  Widget textField() {
    return Expanded(
      child: TextFormField(
        controller: musicController,
        decoration: InputDecoration(
          labelText: 'Search Song....',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}
