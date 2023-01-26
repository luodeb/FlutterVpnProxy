import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'my_vpn_method_channel.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool isRunning = false;
  String address = "";
  int port = -1;
  var addressEditingController = TextEditingController();
  var portEditingController = TextEditingController();

  @override
  void dispose() {
    if (isRunning) MyVPNMethodChannel().stopVPNService();
    super.dispose();
  }
  @override
  void initState() {
    initSPStore();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          const SizedBox(height: 100),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
            child: Row(children: [
              const Text("IP地址: ", style: TextStyle(fontSize: 24)),
              Expanded(
                  child: CupertinoTextField(
                enabled: !isRunning,
                controller: addressEditingController,
                placeholder: "127.0.0.1",
                onChanged: (value) {
                  address = value;
                },
              ))
            ]),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
            child: Row(children: [
              const Text("端口号: ", style: TextStyle(fontSize: 24)),
              Expanded(
                  child: CupertinoTextField(
                controller: portEditingController,
                enabled: !isRunning,
                keyboardType: TextInputType.number,
                placeholder: "-1",
                onChanged: (value) {
                  port = int.parse(value);
                },
              ))
            ]),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
            height: 70,
            child: ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(
                    !isRunning ? Colors.blue : Colors.grey),
              ),
              onPressed: !isRunning
                  ? () async {
                      if (port < 0) {
                        Fluttertoast.showToast(msg: "Unknown Port");
                      } else {
                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        prefs.setString("address", address);
                        prefs.setInt("port", port);
                        MyVPNMethodChannel().startVPNService(address, port);
                        setState(() {
                          isRunning = true;
                        });
                      }
                    }
                  : null,
              child: const Text(
                '启动VPN',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 28.0),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
            height: 70,
            child: ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(
                    isRunning ? Colors.blue : Colors.grey),
              ),
              onPressed: isRunning
                  ? () async {
                      MyVPNMethodChannel().stopVPNService();
                      setState(() {
                        isRunning = false;
                      });
                    }
                  : null,
              child: const Text(
                '关闭VPN',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 28.0),
              ),
            ),
          ),
        ],
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {},
      //   tooltip: 'Increment',
      //   child: const Icon(Icons.add),
      // ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Future<void> initSPStore() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    address = prefs.getString('address') ?? "127.0.0.1";
    port = prefs.getInt('port') ?? -1;
    setState(() {
      addressEditingController.text = address;
      portEditingController.text = port.toString();
    });
  }
}
