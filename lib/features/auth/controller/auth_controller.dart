import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../../core/commons/global_variables/global_variables.dart';
import '../repository/auth_repository.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository();
});

final authControllerProvider =
    StateNotifierProvider<AuthController, bool>((ref) {
  final repository = ref.read(authRepositoryProvider);
  final storage = ref.read(secureStorageProvider);
  return AuthController(ref, repository, storage);
});

final authErrorMessageProvider = StateProvider<String?>((ref) => null);

class AuthController extends StateNotifier<bool> {
  final AuthRepository repository;
  final FlutterSecureStorage storage;

  final Ref ref;

  AuthController(this.ref, this.repository, this.storage) : super(false);

  Future<bool> sendOtp(String phoneNumber) async {
    state = true;
    try {
      final repository = ref.read(authRepositoryProvider);
      await repository.sendOtp(phoneNumber);
      ref.read(authErrorMessageProvider.notifier).state = null;
      return true;
    } catch (e) {
      ref.read(authErrorMessageProvider.notifier).state =
          e.toString().replaceFirst('Exception: ', '');
      return false;
    } finally {
      state = false;
    }
  }

  Future<bool> verifyOtp(String phone, String otp) async {
    try {
      final data = await ref.read(authRepositoryProvider).verifyOtp(phone, otp);

      final accessToken = data['auth_status']?['access_token'];
      final userId = data['id'];

      await storage.write(key: 'accessToken', value: accessToken);
      await storage.write(key: 'user_id', value: userId);
      ref.read(userIdProvider.notifier).update(
            (state) => userId,
          );

      return true;
    } catch (e) {
      return false;
    }
  }
}
