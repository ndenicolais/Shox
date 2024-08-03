import 'package:flutter/material.dart';
import 'package:shox/generated/l10n.dart';
import 'package:shox/onboarding/onboarding_info.dart';

class OnboardingItems {
  List<OnboardingInfo> items = [
    OnboardingInfo(
      title: S.current.onboarding_first_title,
      description: S.current.onboarding_first_description,
      image: Image.asset('assets/images/onboarding_add.png'),
    ),
    OnboardingInfo(
      title: S.current.onboarding_second_title,
      description: S.current.onboarding_second_description,
      image: Image.asset('assets/images/onboarding_filter.png'),
    ),
    OnboardingInfo(
      title: S.current.onboarding_third_title,
      description: S.current.onboarding_third_description,
      image: Image.asset('assets/images/onboarding_view.png'),
    ),
    OnboardingInfo(
      title: S.current.onboarding_fourth_title,
      description: S.current.onboarding_fourth_description,
      image: Image.asset('assets/images/onboarding_graphs.png'),
    ),
  ];
}
