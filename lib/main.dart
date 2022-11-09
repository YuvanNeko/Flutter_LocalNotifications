import 'dart:async';

import 'package:battery_plus/battery_plus.dart';
import 'package:flutter/material.dart';
import 'package:notifications/services/notification.dart';

void main() => runApp(const MaterialApp(
      home: Home(),
      debugShowCheckedModeBanner: false,
    ));
var battery = Battery();

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final battery = Battery();

  StreamSubscription? streamSubscription;

  late Timer timer;

  int batteryLevel = 100;

  BatteryState batteryState = BatteryState.full;

  @override
  void initState() {
    super.initState();

    listenBatteryLevel();
    listenBatteryState();
  }

  void listenBatteryState() => streamSubscription =
      battery.onBatteryStateChanged.listen((batteryState) => setState(() {
            this.batteryState = batteryState;
          }));
  void listenBatteryLevel() {
    updateBatteryLevel();
    timer = Timer.periodic(const Duration(seconds: 15), (_) async {
      updateBatteryLevel();
    });
  }

  Future<void> updateBatteryLevel() async {
    final batteryLevel = await battery.batteryLevel;

    setState(() {
      this.batteryLevel = batteryLevel;
    });
  }

  @override
  void dispose() {
    timer.cancel();
    streamSubscription?.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Local Notifications"),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [buildBatteryState(batteryState)],
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [buildBatteryLevel(batteryLevel)],
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                  onPressed: () => sendNotification(
                      title: "Battery Percentage",
                      body: 'Your battery Percentage: $batteryLevel'),
                  child: const Text("Push Battery Status"))
            ],
          )
        ],
      ),
    );
  }
}

Widget buildBatteryLevel(int batteryLevel) => Text(
      '$batteryLevel%',
      style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
    );

Widget buildBatteryState(BatteryState batteryState) {
  switch (batteryState) {
    case BatteryState.full:
      return Column(
        children: const [
          Icon(
            Icons.battery_full,
            size: 200,
            color: Colors.green,
          ),
          Text("Full!")
        ],
      );
    case BatteryState.charging:
      return Column(
        children: const [
          Icon(
            Icons.battery_charging_full_rounded,
            size: 200,
            color: Colors.green,
          ),
          Text("Charging...")
        ],
      );
    case BatteryState.discharging:
      return Column(
        children: const [
          Icon(
            Icons.battery_alert_rounded,
            size: 200,
            color: Colors.red,
          ),
          Text("Discharging...")
        ],
      );
    case BatteryState.unknown:
      return Column(
        children: const [
          Icon(
            Icons.battery_unknown,
            size: 200,
            color: Colors.amber,
          ),
          Text("Unknown...")
        ],
      );
  }
}
