import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shox/core/utils/constants.dart';
import 'package:shox/features/auth/services/auth_service.dart';

void main() {
  late AuthService service;

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    service = AuthService();
  });

  group('session', () {
    test('saveSession remembers the user id', () async {
      await service.saveSession('uid-1');

      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getBool(AppConstants.prefsRememberMe), isTrue);
      expect(prefs.getString(AppConstants.prefsUserId), 'uid-1');
    });

    test('clearSession forgets the user', () async {
      await service.saveSession('uid-1');
      await service.clearSession();

      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getBool(AppConstants.prefsRememberMe), isNull);
      expect(prefs.getString(AppConstants.prefsUserId), isNull);
    });
  });
}
