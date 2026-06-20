import '../entities/device.dart';

abstract class IDeviceRepository {
  List<Device> getDevices();
}
