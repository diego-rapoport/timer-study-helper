import 'dart:async';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  State<StatefulWidget> createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  Timer? time;
  Duration myDuration = const Duration(milliseconds: 0);
  int id = 0;
  String total = "00:00:00";
  final List<DataRow> _rowList = [];

  void startTimer() {
    if (time is Timer && time!.isActive) {
      stopTime();
      return;
    }
    setTimeUp();
    time = Timer.periodic(const Duration(seconds: 1), (_) {
      setTimeUp();
    });
  }

  void setTimeUp() {
    const upBySeconds = 1;
    setState(() {
      final seconds = myDuration.inSeconds + upBySeconds;
      myDuration = Duration(seconds: seconds);
    });
  }

  void stopTime() {
    setState(() {
      time!.cancel();
    });
  }

  void restartTime() {
    setState(() {
      myDuration = const Duration(milliseconds: 0);
    });
  }

  String stringToDigits(int n) => n.toString().padLeft(2, '0');

  String durationToDigits(Duration duration) {
    final hours = stringToDigits(duration.inHours.remainder(24));
    final minutes = stringToDigits(duration.inMinutes.remainder(60));
    final seconds = stringToDigits(duration.inSeconds.remainder(60));
    final timestamp = '$hours:$minutes:$seconds';
    return timestamp;
  }

  Duration digitsToDuration(String digits) {
    List<String> totalTimeParts = digits.split(':');
    Duration duration = Duration(
        hours: int.parse(totalTimeParts[0]),
        minutes: int.parse(totalTimeParts[1]),
        seconds: int.parse(totalTimeParts[2]));
    return duration;
  }

  void saveTime() {
    Text? child =
        _rowList.isNotEmpty ? _rowList.last.cells[2].child as Text : null;
    if (child == null || child.data != durationToDigits(myDuration)) {
      final timestamp = durationToDigits(myDuration);
      _addRow(timestamp);
      _addTotalTime(timestamp);
      return;
    }
  }

  Widget getPlayPauseIcon() {
    if (time is! Timer || !time!.isActive) {
      return const Icon(Icons.play_arrow);
    } else {
      return const Icon(Icons.pause);
    }
  }

  DataTable _createDataTable() {
    return DataTable(
      columns: _createColumns(),
      rows: _rowList,
    );
  }

  List<DataColumn> _createColumns() {
    return [
      const DataColumn(label: Text('ID')),
      const DataColumn(label: Text('Name')),
      const DataColumn(label: Text('Time'))
    ];
  }

  void _addRow(String timeString) {
    setState(() {
      _rowList.add(DataRow(cells: <DataCell>[
        DataCell(Text(id.toString())),
        const DataCell(Text("Name"), placeholder: true),
        DataCell(Text(timeString)),
      ]));
    });
    id++;
  }

  void _addTotalTime(String lastTime) {
    setState(() {
      Duration totalTimeParts = digitsToDuration(total);
      Duration totalLastParts = digitsToDuration(lastTime);
      Duration totalSum = totalTimeParts + totalLastParts;
      total = durationToDigits(totalSum);
    });
  }

  void clearTable() {
    setState(() {
      _rowList.clear();
      total = "00:00:00";
    });
  }

  @override
  Widget build(BuildContext context) {
    final hours = stringToDigits(myDuration.inHours.remainder(24));
    final minutes = stringToDigits(myDuration.inMinutes.remainder(60));
    final seconds = stringToDigits(myDuration.inSeconds.remainder(60));
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
            appBar: AppBar(
              title: const Text("Study Helper"),
              backgroundColor: Colors.purple,
              centerTitle: true,
            ),
            body: Builder(
                builder: (context) => Center(
                        child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 30),
                          child: Text('$hours:$minutes:$seconds',
                              style: const TextStyle(
                                fontSize: 36,
                                fontWeight: FontWeight.w500,
                              )),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              FloatingActionButton(
                                onPressed: startTimer,
                                backgroundColor: Colors.purple,
                                child: getPlayPauseIcon(),
                              ),
                              FloatingActionButton(
                                onPressed: restartTime,
                                backgroundColor: Colors.purple,
                                child: const Icon(Icons.history),
                              ),
                              FloatingActionButton(
                                onPressed: saveTime,
                                backgroundColor: Colors.purple,
                                child: const Icon(Icons.alarm_add),
                              )
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            Expanded(
                                child: SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              child: _createDataTable(),
                            )),
                          ],
                        ),
                        Text("Total: $total"),
                        Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            child: FloatingActionButton(
                              onPressed: clearTable,
                              backgroundColor: Colors.purple,
                              child: const Icon(Icons.delete),
                            ))
                      ],
                    )))));
  }
}
