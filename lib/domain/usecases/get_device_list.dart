import '../entities/device.dart';
import '../repositories/i_device_repository.dart';

class GetDeviceList {
  final IDeviceRepository repository;

  GetDeviceList(this.repository);

  List<Device> call() {
    return repository.getDevices();
  }
}
