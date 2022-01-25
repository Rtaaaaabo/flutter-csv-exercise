import 'package:flutter/material.dart';
import 'package:csv/csv.dart';
import 'package:demo_csv/allCsv.dart';
import 'package:demo_csv/loadCsvDataScreen.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:random_string/random_string.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter CSV',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter CSV'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title)
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            MaterialButton(onPressed: () => {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => AllCsvFilesScreen())
              )
            },
            color: Colors.cyanAccent,
            child: Text("携帯のストレージから取得します"),
            ),
            MaterialButton(onPressed: () => {
              loadCsvFromStorage();
            },
            color: Colors.cyanAccent,
            child: Text("任意のCsvを取得します"),
            ),
            MaterialButton(onPressed: () => {
              generateCsv();
            },
            color: Colors.cyanAccent,
            child: Text("Csvファイルを取得します")
            )
          ]
        )
      )
    );
  }

  generateCsv() async {
    List<List<String>> data = [
      ["No.", "Name", "Roll No."],
      ["1", randomAlpha(3), randomNumeric(3)],
      ["2", randomAlpha(3), randomNumeric(3)],
      ["3", randomAlpha(3), randomNumeric(3)]
    ];
    String csvData = ListToCsvConverter().convert(data);
    final String directory = (await getApplicationSupportDirectory()).path;
    final path = "$directory/csv-${DateTime.now()}.csv";
    print(path);
    final File file = File(path);
    await file.writeAsString(csvData);
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => {
          return LoadCsvDataScreen(path: path);
        }
      )
    );
  }

  loadCsvFromStorage() async {
    FilePickerResult result = await FilePicker.platform.pickFiles(
      allowedExtensions: ['csv'],
      type: FileType.custom,
    );
    String path = result.files.first.path;
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => {
          return LoadCsvDataScreen(path: path);
        }
      )
    )
  }
}
