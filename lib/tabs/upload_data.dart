import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class UploadDataScreen extends StatefulWidget {
  const UploadDataScreen({super.key});

  @override
  State<UploadDataScreen> createState() => _UploadDataScreenState();
}

class _UploadDataScreenState extends State<UploadDataScreen> {
  int? manualMode;
  int? isOperateManually;
  int? isTurnOnLight;
  int? isTurnOnFan;
  int? isTurnOnPump;
  int? isTurnOnMotor;
  bool isLoading = false;
  DatabaseReference ref = FirebaseDatabase.instance.ref("ghm_real_time_data");
  TextStyle style = const TextStyle(fontSize: 18);

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  fetchData() async {
    DatabaseReference ref = FirebaseDatabase.instance.ref("ghm_real_time_data");
    DataSnapshot snapshot = await ref.get();
    print(snapshot.value);
    manualMode = snapshot.child("is_operate_manually").value as int;
    isTurnOnPump = snapshot.child("is_turn_on_pump").value as int;
    isTurnOnLight = snapshot.child("is_turn_on_LED").value as int;
    isTurnOnFan = snapshot.child("is_turn_on_fan_1").value as int;
    isTurnOnMotor = snapshot.child("is_turn_on_servo").value as int;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // fetchData();
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SwitchListTile(
                value: intToBoolConverter(manualMode),
                onChanged: (val) {
                  setState(() {
                    manualMode == 0 ? manualMode = 1 : manualMode = 0;
                  });
                  ref.update({
                    "is_operate_manually": manualMode,
                  });
                },
                title: Text("Manual Mode", style: style),
              ),
              const Divider(
                thickness: 2,
              ),
              const SizedBox(height: 15),
              manualMode != 1
                  ? const Padding(
                      padding: EdgeInsets.symmetric(vertical: 20.0),
                      child: Center(
                          child: Text(
                        "Please enable manual mode",
                        style: TextStyle(color: Colors.grey),
                      )),
                    )
                  : Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          _getSwitchTile("Pump", isTurnOnPump, () async {
                            setState(() {
                              isTurnOnPump == 0
                                  ? isTurnOnPump = 1
                                  : isTurnOnPump = 0;
                            });
                            await ref.update({
                              "is_turn_on_pump": isTurnOnPump,
                            });
                          }),
                          _getSwitchTile("Fan", isTurnOnFan, () async {
                            setState(() {
                              isTurnOnFan == 0
                                  ? isTurnOnFan = 1
                                  : isTurnOnFan = 0;
                            });
                            await ref.update({
                              "is_turn_on_fan_1": isTurnOnFan,
                            });
                          }),
                          _getSwitchTile("Motor", isTurnOnMotor, () async {
                            setState(() {
                              isTurnOnMotor == 0
                                  ? isTurnOnMotor = 1
                                  : isTurnOnMotor = 0;
                            });
                            await ref.update({
                              "is_turn_on_servo": isTurnOnMotor,
                            });
                          }),
                          _getSwitchTile("Light", isTurnOnLight, () async {
                            setState(() {
                              isTurnOnLight == 0
                                  ? isTurnOnLight = 1
                                  : isTurnOnLight = 0;
                            });
                            await ref.update({
                              "is_turn_on_LED": isTurnOnLight,
                            });
                          }),
                        ],
                      ),
                    ),
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: Column(
                  children: [
                    _getField("Temperature", "temprature_refrance_value"),
                    _getField("Humidity", "humidity_refrance_value"),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  _getSwitchTile(String title, int? val, Function onUpdate) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: SwitchListTile(
        value: intToBoolConverter(val),
        onChanged: (val) {
          onUpdate();
        },
        title: Text(title),
      ),
    );
  }

  _getField(String title, String key) {
    TextEditingController _controller = TextEditingController();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: "Set $title",
                border: OutlineInputBorder(),
              ),
            ),
          ),
          SizedBox(width: 10),
          InkWell(
            onTap: () async {
              print(_controller.text);
              try {
                DatabaseReference dbRef =
                    FirebaseDatabase.instance.ref("ghm_real_time_data");
                await dbRef.update({
                  key: _controller.text,
                });
                _controller.clear();
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("$title updated successfully")));
              } catch (e) {
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text("Error : $e")));
              }
            },
            child: const CircleAvatar(
              child: Icon(Icons.check),
            ),
          )
        ],
      ),
    );
  }

  intToBoolConverter(int? val) {
    if (val == 1) {
      return true;
    } else {
      return false;
    }
  }

  boolToIntConverter(bool val) {
    if (val == true) {
      return 1;
    } else {
      return 0;
    }
  }
}
