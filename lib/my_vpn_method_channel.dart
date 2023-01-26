import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class MethodChannels {
  // 通道名称
  static const String myVPNPlugin = 'my_vpn';
}

class MethodNames {
  static const String mgetPlatformVersion = 'getPlatformVersion';
  static const String mstartVPNService = 'startVPNService';
  static const String mstopVPNService = 'stopVPNService';
  static const String minitCreate = 'initCreate';
  static const String msetVPNAddress = 'setVPNAddress';
}

class ParamNames {}

class MyVPNMethodChannel {
  static const MethodChannel _channel =
      MethodChannel(MethodChannels.myVPNPlugin);

  Future<String?> getPlatformVersion() async {
    final String? version =
        await _channel.invokeMethod<String>(MethodNames.mgetPlatformVersion);
    return version;
  }

  Future<String?> startVPNService(String address,int port) async {
    await _channel.invokeMethod<String>(MethodNames.mstartVPNService,{'address': address, 'port': port});
    return null;
  }

  Future<String?> stopVPNService() async {
    await _channel.invokeMethod<String>(MethodNames.mstopVPNService);
    return null;
  }

  Future<String?> initCreate() async {
    await _channel.invokeMethod<String>(MethodNames.minitCreate);
    return null;
  }

  Future<String?> setVPNAddress(String address,int port) async {
    await _channel.invokeMethod<String>(MethodNames.msetVPNAddress,{'address': address, 'port': port});
    return null;
  }
}
