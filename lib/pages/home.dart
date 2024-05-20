import 'dart:io';

import 'package:band_names_adv_02/bands/band.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Band> bands = [
    Band(id: '1', name: 'nombre-1', votes: 1),
    Band(id: '2', name: 'nombre-2', votes: 2),
    Band(id: '3', name: 'nombre-3', votes: 3),
    Band(id: '4', name: 'nombre-4', votes: 4),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bands list'),
        backgroundColor: Colors.amber,
        elevation: 1,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.only(top: 20.0, right: 20.0),
        itemCount: bands.length,
        itemBuilder: (BuildContext contexts, int i) => _bandTile(bands[i]),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: addNewBand,
        elevation: 1,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _bandTile(Band banda) {
    return Dismissible(
      key: Key(banda.id),
      direction: DismissDirection.startToEnd,
      onDismissed: (direction) {
        print('> 1....borradoooo');
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
          child: Text(banda.id),
        ),
        title: Text(banda.name),
        trailing: Text(
          '${banda.votes}',
          style: const TextStyle(
              color: Colors.blueGrey, fontWeight: FontWeight.bold),
        ),
        onTap: () {
          banda.votes += 1;
          setState(() {});
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
      print('> 1....${name.length}');

      bands.add(Band(id: (bands.length + 1).toString(), name: name, votes: 0));
    } else {
      print('${name.length}');
    }

    setState(() {});
    Navigator.pop(context);
  }
}
