import 'package:air_quality_app/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:permission_handler/permission_handler.dart';

class BGServiceSwitch extends StatefulWidget {
  const BGServiceSwitch({super.key});

  @override
  State<BGServiceSwitch> createState() => _BGServiceSwitchState();
}

class _BGServiceSwitchState extends State<BGServiceSwitch> {
  bool isRunning = false;
  String textEnable = 'Enable poor AQI alerts';
  String textDisable = 'Disable poor AQI alerts';

  @override
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();
    Permission.notification.isDenied
        .then((value) => Permission.notification.request());
    FlutterBackgroundService.initialize(onBGServiceEnabled);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
      child: ElevatedButton(
          onPressed: () async {
            var isRunning = await FlutterBackgroundService().isServiceRunning();
            if (isRunning) {
              FlutterBackgroundService().sendData({'action': 'stopService'});
            } else {
              FlutterBackgroundService.initialize(onBGServiceEnabled);
            }
            setState(() {
              this.isRunning = isRunning;
            });
          },
          child: Text((isRunning) ? textEnable : textDisable)),
    );
  }
}