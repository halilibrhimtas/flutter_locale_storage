import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_locale_storage/data/entity/person.dart';
import 'package:flutter_locale_storage/services/database_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Locale Storage',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.amberAccent),
        useMaterial3: true,
      ),
      home: const HomePage(title: 'Flutter Locale Storage'),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController textEditingController = TextEditingController();
  late SharedPreferences preferences;
  String duration = "Not Measured";
  String storageName = "Not Determined";
  String type = "Not Determined";
  String value = "no data entered yet";

  @override
  void initState() {
    getSharedPreferences();
    super.initState();
  }

  getSharedPreferences() async {
    try {
      preferences = await SharedPreferences.getInstance();
      log("shared preferences started");
    } catch (e) {
      log("Shared Preferences init error: ${e.toString()}");
    }
  }

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amberAccent,
        title: Text(
          widget.title,
          style: const TextStyle(
              color: Colors.blueGrey, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: TextFormField(
                controller: textEditingController,
                cursorColor: Colors.white,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  filled: true,
                  fillColor: Colors.teal,
                  hintText: "Please enter your name",
                  hintStyle: TextStyle(color: Colors.white70),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "WRITE TO LOCALE STORAGE:",
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: ElevatedButton(
                    onPressed: () async {
                      final stopWatch = Stopwatch()..start();
                      await preferences.setString(
                          "shared-preferences", textEditingController.text);
                      stopWatch.stop();
                      setState(() {
                        duration = stopWatch.elapsed.toString();
                        storageName = "Shared Preferences";
                        type = "Write";
                        value = textEditingController.text;
                      });
                    },
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.brown),
                    child: const Text("Shared Preferences",
                        style: TextStyle(fontSize: 13, color: Colors.white)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: ElevatedButton(
                    onPressed: () async {
                      final stopWatch = Stopwatch()..start();
                      Person person = Person(
                          id: 2,
                          name: textEditingController.text,
                          saveDate: DateTime.now().toString());
                      await DatabaseService.addPerson(person);
                      stopWatch.stop();
                      log(person!.id.toString());
                      log(person.name.toString());
                      log(person.saveDate.toString());
                      setState(() {
                        duration = stopWatch.elapsed.toString();
                        storageName = "Sqlite";
                        type = "Write";
                        value = textEditingController.text;
                      });
                    },
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.brown),
                    child: const Text("Sqlite",
                        style: TextStyle(fontSize: 13, color: Colors.white)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: ElevatedButton(
                    onPressed: () {},
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.brown),
                    child: const Text("Hive",
                        style: TextStyle(fontSize: 13, color: Colors.white)),
                  ),
                )
              ],
            ),
            const Padding(
              padding: EdgeInsets.only(top: 32.0),
              child: Text(
                "READ FROM LOCALE STORAGE:",
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 48.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: ElevatedButton(
                      onPressed: () {
                        final stopWatch = Stopwatch()..start();
                        value =
                            preferences.getString("shared-preferences") == null
                                ? "Value null"
                                : preferences.getString("shared-preferences")!;
                        stopWatch.stop();
                        setState(() {
                          duration = stopWatch.elapsed.toString();
                          storageName = "Shared Preferences";
                          type = "Read";
                        });
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueAccent),
                      child: const Text("Shared Preferences",
                          style: TextStyle(fontSize: 13, color: Colors.white)),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: ElevatedButton(
                      onPressed: () async {
                        final stopWatch = Stopwatch()..start();
                        Person? person = await DatabaseService.getPerson(2);
                        value = person == null ? "Value null" : person.name!;
                        stopWatch.stop();
                        log(person!.id.toString());
                        log(person.name.toString());
                        log(person.saveDate.toString());
                        setState(() {
                          duration = stopWatch.elapsed.toString();
                          storageName = "Sqlite";
                          type = "Read";
                        });
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueAccent),
                      child: const Text("Sqlite",
                          style: TextStyle(fontSize: 13, color: Colors.white)),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueAccent),
                      child: const Text("Hive",
                          style: TextStyle(fontSize: 13, color: Colors.white)),
                    ),
                  )
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "TEXT: $value",
                  style: const TextStyle(
                      fontWeight: FontWeight.w500, fontSize: 16),
                ),
                Text(
                  "STORAGE NAME: $storageName",
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w500),
                ),
                Text("TYPE: $type",
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w500)),
                Text("DURATION: $duration",
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w500)),
              ],
            )
          ],
        ),
      ),
    );
  }
}
