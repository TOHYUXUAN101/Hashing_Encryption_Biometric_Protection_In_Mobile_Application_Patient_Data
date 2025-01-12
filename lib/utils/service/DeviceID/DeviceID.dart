import 'package:flutter/services.dart';
import 'package:mobile_device_identifier/mobile_device_identifier.dart';

class DeviceIdHelper{
  final MobileDeviceIdentifier _mobileDeviceIdentifier = MobileDeviceIdentifier();

  Future<String> getDeviceId() async {
    String deviceId;
    try {
      deviceId = await _mobileDeviceIdentifier.getDeviceId() ?? 'Unknown platform version';
    } on PlatformException {
      deviceId = 'Failed to get platform version.';
    }

    return deviceId;
  }
}