import 'package:cardifly/config/router_manager.dart';
import 'package:cardifly/screens/onboarding/onboarding_screens/onboarding_one/_partials/onboarding_back_button.dart';
import 'package:cardifly/screens/onboarding/onboarding_screens/onboarding_one/_partials/onboarding_hero_frame.dart';
import 'package:cardifly/screens/onboarding/onboarding_screens/onboarding_one/_partials/onboarding_page_content.dart';
import 'package:cardifly/screens/onboarding/onboarding_screens/onboarding_one/_partials/onboarding_page_indicator.dart';
import 'package:cardifly/screens/onboarding/onboarding_screens/onboarding_one/_partials/onboarding_text_block.dart';
import 'package:cardifly/ui/components/app_button_widget.dart';
import 'package:cardifly/ui/components/app_fade_in.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


class OnboardingOne extends StatefulWidget {
  const OnboardingOne({super.key});

  @override
  State<OnboardingOne> createState() => _OnboardingOneState();
}

class _OnboardingOneState extends State<OnboardingOne> {
  static const sidePadding = 32.0;
  static const heroGap = 34.0;
  static const indicatorGap = 22.0;
  static const buttonGap = 32.0;
  static const bottomGap = 16.0;
  static const buttonHeight = 42.0;

  final _controller = PageController();
  final _pages = OnboardingPageContent.pages;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textHeight =
        OnboardingTextBlock.heightFor(MediaQuery.textScalerOf(context));
    final safeBottom = MediaQuery.viewPaddingOf(context).bottom;

    final ctaBottom = bottomGap + safeBottom;
    final indicatorBottom =
        ctaBottom + buttonHeight + buttonGap + textHeight + indicatorGap;
    const textTop = heroGap + OnboardingPageIndicator.height + indicatorGap;
    final chromeHeight =
        textTop + textHeight + buttonGap + buttonHeight + ctaBottom;

    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          final heroHeight = (constraints.maxHeight - chromeHeight)
              .clamp(0.0, constraints.maxHeight);

          final pageView = PageView.builder(
            controller: _controller,
            itemCount: _pages.length,
            itemBuilder: (context, index) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                OnboardingHeroFrame(
                  page: _pages[index],
                  height: heroHeight,
                ),
                const SizedBox(height: textTop),
                SizedBox(
                  height: textHeight,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: sidePadding,
                    ),
                    child: OnboardingTextBlock(
                      title: _pages[index].title,
                      body: _pages[index].body,
                      titleColor: _pages[index].foreground,
                      bodyColor: _pages[index].bodyColor,
                    ),
                  ),
                ),
              ],
            ),
          );

          return AnimatedBuilder(
            animation: _controller,
            child: pageView,
            builder: (context, child) {
              final background = _lerp((page) => page.background);

              return AnnotatedRegion<SystemUiOverlayStyle>(
                value: _overlayStyle(background),
                child: ColoredBox(
                  color: background,
                  child: Stack(
                    children: [
                      Positioned.fill(child: child!),
                      Positioned(
                        left: sidePadding,
                        bottom: indicatorBottom,
                        child: AppFadeIn(
                          delay: const Duration(milliseconds: 120),
                          child: OnboardingPageIndicator(
                            count: _pages.length,
                            current: _offset,
                            activeColor: _lerp((page) => page.foreground),
                            inactiveColor: _lerp((page) => page.dimIndicator),
                          ),
                        ),
                      ),
                      Positioned(
                        left: sidePadding,
                        right: sidePadding,
                        bottom: ctaBottom,
                        child: AppFadeIn(
                          delay: const Duration(milliseconds: 220),
                          child: Row(
                            children: [
                              OnboardingBackButton(
                                size: buttonHeight,
                                color: _lerp((page) => page.foreground),
                                progress: _offset,
                                onPressed: _goBack,
                              ),
                              Expanded(
                                child: AppButtonWidget(
                                  title: _currentPage.actionLabel,
                                  radius: buttonHeight / 2,
                                  backgroundColor: Colors.white,
                                  labelColor:
                                      _lerp((page) => page.ctaForeground),
                                  onPressed: _goForward,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  /// Fractional page offset, safe to read before the first layout pass.
  double get _offset {
    if (!_controller.hasClients || !_controller.position.hasContentDimensions) {
      return 0;
    }
    return _controller.page ?? 0;
  }

  OnboardingPageContent get _currentPage =>
      _pages[_offset.round().clamp(0, _pages.length - 1)];

  /// Blends one colour of the two pages the swipe currently straddles.
  Color _lerp(Color Function(OnboardingPageContent page) of) {
    final offset = _offset;
    final low = offset.floor().clamp(0, _pages.length - 1);
    final high = offset.ceil().clamp(0, _pages.length - 1);
    return Color.lerp(of(_pages[low]), of(_pages[high]), offset - low)!;
  }

  SystemUiOverlayStyle _overlayStyle(Color background) {
    final isDark =
        ThemeData.estimateBrightnessForColor(background) == Brightness.dark;
    return SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
      statusBarBrightness: isDark ? Brightness.dark : Brightness.light,
      systemNavigationBarColor: background,
      systemNavigationBarIconBrightness:
          isDark ? Brightness.light : Brightness.dark,
    );
  }

  void _goBack() {
    _controller.previousPage(
      duration: const Duration(milliseconds: 320),
      curve: Curves.easeOutCubic,
    );
  }

  void _goForward() {
    if (_offset.round() < _pages.length - 1) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 320),
        curve: Curves.easeOutCubic,
      );
      return;
    }
    // TODO: persist Constants.kOnboardingAlreadySeen through a view model.
    Navigator.pushReplacementNamed(context, RouteName.welcomeTwo);
  }
}
