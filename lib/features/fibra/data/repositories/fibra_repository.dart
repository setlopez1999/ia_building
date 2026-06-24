import '../../../../shared/data/models/fibra.dart';

abstract class FibraRepository {
  Future<Fibra> getFibra();
}
