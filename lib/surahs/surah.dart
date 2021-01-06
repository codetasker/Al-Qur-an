import 'dart:convert';

import 'package:al_quran/settings/settings.dart';
import 'package:al_quran/surahs/surah_model.dart';
import 'package:flutter/material.dart';

class Surah extends StatelessWidget {
  final String surah;
  final String number;

  Surah({this.surah, this.number});

  List<SurahModel> parseJosn(String response) {
    if (response == null) {
      return [];
    }
    final parsed = json.decode(response).cast<Map<String, dynamic>>();
    return parsed
        .map<SurahModel>((json) => new SurahModel.fromJson(json))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    print(surah);
    print(number);
    return Scaffold(
      appBar: AppBar(
        title: Text(surah.toString()),
        actions: [
          settingsNav(context),
        ],
      ),
      body: Center(
        child: Container(child: buildSurah(context)),
      ),
    );
  }

  IconButton settingsNav(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.settings),
      onPressed: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Settings(),
        ),
      ),
    );
  }

  FutureBuilder<String> buildSurah(BuildContext context) {
    return FutureBuilder(
      future: DefaultAssetBundle.of(context)
          .loadString('assets/quran/en.pretty.json'),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return CircularProgressIndicator();
        // print(snapshot.data);

        List<SurahModel> surahs = parseJosn(snapshot.data.toString())
            .where((element) => element.surah_number == int.parse(number))
            .toList();
        print(surahs.length);

        return ayahs(surahs);
      },
    );
  }

  ListView ayahs(List<SurahModel> surahs) {
    return ListView.separated(
      itemCount: surahs.length,
      separatorBuilder: (context, int index) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Divider(
            thickness: 2.0,
          ),
        );
      },
      itemBuilder: (BuildContext context, int index) {
        return index == 0 &&
                surahs[index].surah_number != 1 &&
                surahs[index].surah_number != 9
            ? Column(
                children: [basmalaTile(context), ayahTlle(index, surahs)],
              )
            : ayahTlle(index, surahs);
      },
    );
  }

  Padding basmalaTile(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: ImageIcon(
          AssetImage(
            'assets/quran/basmala2.png',
          ),
          size: 50.0,
          color: Colors.green.shade900,
        ),
      ),
    );
  }

  ListTile ayahTlle(int index, List<SurahModel> surahs) {
    return ListTile(
      leading: ayahNumber(index),
      title: ayah(surahs, index),
      subtitle: Text(surahs[index].translation),
    );
  }

  Padding ayah(List<SurahModel> surahs, int index) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, top: 8.0),
      child: Text(
        surahs[index].text,
        textDirection: TextDirection.rtl,
        style: TextStyle(
          fontSize: 25,
          color: Colors.green.shade900,
          fontFamily: 'uthmani',
        ),
      ),
    );
  }

  Container ayahNumber(int index) {
    return Container(
      height: 45,
      width: 45,
      child: Stack(
        children: [
          ImageIcon(
            AssetImage('assets/ayyah_icon.png'),
            size: 45,
          ),
          Align(
              alignment: Alignment.center,
              child: Center(child: Text((index + 1).toString()))),
        ],
      ),
    );
  }
}
