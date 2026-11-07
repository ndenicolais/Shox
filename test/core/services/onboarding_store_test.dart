import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shox/core/services/onboarding_store.dart';
import 'package:shox/core/utils/constants.dart';

void main() {
  Future<OnboardingStore> storeWith(Map<String, Object> values) async {
    SharedPreferences.setMockInitialValues(values);
    return OnboardingStore(await SharedPreferences.getInstance());
  }

  test('is not seen on a fresh install', () async {
    expect((await storeWith({})).seen, isFalse);
  });

  test('markSeen persists the flag', () async {
    final store = await storeWith({});
    await store.markSeen();

    expect(store.seen, isTrue);
    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getBool(AppConstants.prefsOnboardingSeen), isTrue);
  });

  test('reads the flag saved by older versions', () async {
    final store = await storeWith({'onboarding_completed': true});
    expect(store.seen, isTrue);
  });
}
