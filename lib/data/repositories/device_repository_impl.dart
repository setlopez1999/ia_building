import '../../domain/entities/device.dart';
import '../../domain/repositories/i_device_repository.dart';

class DeviceRepositoryImpl implements IDeviceRepository {
  @override
  List<Device> getDevices() {
    return [
      const Device(
          id: '1', name: 'Samsung S23', isConnected: true, iconAsset: 'assets/smartphone.svg'),
      const Device(
          id: '2', name: 'Samsung A40', isConnected: true, iconAsset: 'assets/smartphone.svg'),
      const Device(
          id: '3', name: 'Motorola 45-8', isConnected: true, iconAsset: 'assets/smartphone.svg'),
      const Device(
          id: '4', name: 'MacBook Pro', isConnected: true, iconAsset: 'assets/laptop.svg'),
    ];
  }
}
