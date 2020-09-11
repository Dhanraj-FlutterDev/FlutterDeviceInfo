import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


void main() => runApp(DeviceInfo());

class DeviceInfo extends StatefulWidget {
  @override
  _DeviceInfoState createState() => _DeviceInfoState();
}

class _DeviceInfoState extends State<DeviceInfo> {
  static final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  Map<String, dynamic> _deviceInfo;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initPlatformState();
  }


  Future<void> initPlatformState() async {
    Map<String, dynamic> deviceData;

    try {
      if (Platform.isAndroid) {
        deviceData = _readAndroidDevice(await deviceInfoPlugin.androidInfo);
      } else if(Platform.isIOS){
      deviceData = _readIOSDevice (await deviceInfoPlugin.iosInfo);
    }
  }on PlatformException {
    deviceData = <String,dynamic> {
    'Error' : 'Failed to get Platform'
    };
    }

    if(!mounted)return;

    setState(() {
    _deviceInfo = deviceData;
    });
  }

  Map<String, dynamic> _readAndroidDevice(AndroidDeviceInfo build) {
    return <String, dynamic>{
      'version.securityPatch': build.version.securityPatch,
      'version.sdkInt': build.version.sdkInt,
      'version.release': build.version.release,
      'version.previewSdkInt': build.version.previewSdkInt,
      'version.incremental': build.version.incremental,
      'version.codename': build.version.codename,
      'version.baseOS': build.version.baseOS,
      'board': build.board,
      'bootloader': build.bootloader,
      'brand': build.brand,
      'device': build.device,
      'display': build.display,
      'fingerprint': build.fingerprint,
      'hardware': build.hardware,
      'host': build.host,
      'id': build.id,
      'manufacturer': build.manufacturer,
      'model': build.model,
      'product': build.product,
      'supported32BitAbis': build.supported32BitAbis,
      'supported64BitAbis': build.supported64BitAbis,
      'supportedAbis': build.supportedAbis,
      'tags': build.tags,
      'type': build.type,
      'isPhysicalDevice': build.isPhysicalDevice,
      'androidId': build.androidId,
      'systemFeatures': build.systemFeatures,
    };
  }

  Map<String, dynamic> _readIOSDevice(IosDeviceInfo data) {
    return <String, dynamic>{
      'name': data.name,
      'systemName': data.systemName,
      'systemVersion': data.systemVersion,
      'model': data.model,
      'localizedModel': data.localizedModel,
      'identifierForVendor': data.identifierForVendor,
      'isPhysicalDevice': data.isPhysicalDevice,
      'utsname.sysname:': data.utsname.sysname,
      'utsname.nodename:': data.utsname.nodename,
      'utsname.release:': data.utsname.release,
      'utsname.version:': data.utsname.version,
      'utsname.machine:': data.utsname.machine,
    };
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
          appBar: AppBar(
            title: Text(Platform.isAndroid ? 'Android Info' : 'IOS info'),
          ),
          body: ListView(
            children: _deviceInfo.keys.map((String property) {
              return Row(
                children: <Widget>[
                  Container(
                    child: Text(
                      property, style: TextStyle(fontWeight: FontWeight.bold),),
                  ),

                  Expanded(child: Container(
                    child: Text('${_deviceInfo[property]}',
                    maxLines: 10,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),),
                ],
              );
            }).toList(),
          ),
        )
    );
  }
}
