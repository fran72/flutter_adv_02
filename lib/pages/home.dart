import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:provider/provider.dart';

import 'package:band_names_adv_02/bands/band.dart';
import 'package:band_names_adv_02/services/socket_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Band> bands = [
    Band(id: 1, name: 'nombre-1', votes: 1),
    Band(id: 2, name: 'nombre-2', votes: 2),
    Band(id: 3, name: 'nombre-3', votes: 3),
    Band(id: 4, name: 'nombre-4', votes: 4),
  ];

  @override
  Widget build(BuildContext context) {
    final socketService = Provider.of<SocketService>(context);

    socketService.socket.on('active-bands', (payload) {
      bands = (payload as List).map((band) => Band.fromMap(band)).toList();
      setState(() {});
      debugPrint('active-bands...............................');
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bands list'),
        backgroundColor: Colors.black,
        elevation: 1,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 10),
            child: (socketService.serverStatus == ServerStatus.online)
                ? const Icon(Icons.face, color: Colors.green)
                : const Icon(Icons.face, color: Colors.red),
          ),
        ],
      ),
      body: Column(
        children: [
          _showGraph('Bands list'),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.only(top: 20.0, right: 20.0),
              itemCount: bands.length,
              itemBuilder: (BuildContext contexts, int i) =>
                  _bandTile(bands[i]),
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: addNewBand,
        elevation: 1,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _bandTile(Band banda) {
    final socketService = Provider.of<SocketService>(context, listen: false);

    return Dismissible(
      key: Key(banda.id.toString()),
      direction: DismissDirection.startToEnd,
      onDismissed: (_) {
        socketService.socket.emit('delete-band', {'id': banda.id});
      },
      background: Container(
        color: Colors.amber,
        child: const Align(
          alignment: Alignment.center,
          child: Text('eliminar Banda'),
        ),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.blueAccent,
          child: Text(banda.id.toString()),
        ),
        title: Text(banda.name),
        trailing: Text(
          '${banda.votes}',
          style: const TextStyle(
              color: Colors.blueGrey, fontWeight: FontWeight.bold),
        ),
        onTap: () {
          socketService.socket.emit('vote-band', {'id': banda.id});
        },
      ),
    );
  }

  addNewBand() {
    final textController = TextEditingController();
    if (Platform.isAndroid) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('data'),
              content: TextField(
                controller: textController,
              ),
              actions: [
                MaterialButton(
                  textColor: Colors.blue,
                  elevation: 5,
                  onPressed: () => addBandToList(textController.text),
                  child: const Text('save',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      )),
                )
              ],
            );
          });
    }

    if (Platform.isIOS) {
      showCupertinoDialog(
          context: context,
          builder: (context) {
            return CupertinoAlertDialog(
                title: const Text('data ios'),
                content: CupertinoTextField(
                  controller: textController,
                ),
                actions: [
                  CupertinoDialogAction(
                    isDefaultAction: true,
                    child: const Text('Add'),
                    onPressed: () => addBandToList(textController.text),
                  ),
                  CupertinoDialogAction(
                    isDestructiveAction: true,
                    child: const Text('Close'),
                    onPressed: () => Navigator.pop(context),
                  )
                ]);
          });
    }
  }

  addBandToList(String name) {
    if (name.length > 1) {
      // bands.add(Band(id: (bands.length + 1), name: name, votes: 0));
      final socketService = Provider.of<SocketService>(context, listen: false);

      socketService.socket.emit('add-band', {'name': name});
    }
    Navigator.pop(context);
  }

  Widget _showGraph(String name) {
    Map<String, double> dataMap = {};

    for (var band in bands) {
      dataMap.putIfAbsent(band.name, () => band.votes.toDouble());
    }

    final List<Color> colorList = [
      Colors.amber,
      Colors.red,
      Colors.green,
      Colors.blue,
    ];

    return SizedBox(
      width: double.infinity,
      height: 200,
      child: PieChart(
        dataMap: dataMap,
        animationDuration: const Duration(milliseconds: 800),
        chartLegendSpacing: 32,
        chartRadius: MediaQuery.of(context).size.width / 3.2,
        colorList: colorList,
        initialAngleInDegree: 0,
        chartType: ChartType.ring,
        ringStrokeWidth: 22,
        centerText: "HYBRID",
        legendOptions: const LegendOptions(
          showLegendsInRow: false,
          legendPosition: LegendPosition.right,
          showLegends: true,
          legendTextStyle: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        chartValuesOptions: const ChartValuesOptions(
          showChartValueBackground: true,
          showChartValues: true,
          showChartValuesInPercentage: false,
          showChartValuesOutside: false,
          decimalPlaces: 1,
        ),
        // gradientList: ---To add gradient colors---
        // emptyColorGradient: ---Empty Color gradient---
      ),
    );
  }
}
