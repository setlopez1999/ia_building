import '../../../../shared/data/models/user.dart';

abstract class PerfilRepository {
  Future<User> getProfile();
  Future<void> updateProfile(String nombre, String telefono);
}
