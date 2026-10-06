import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:easygold_app_v3/generated/assets.gen.dart';
import 'package:easygold_app_v3/generated/locale_keys.g.dart';
import 'package:material_ui/material_ui.dart';
import 'package:overlay_kit/overlay_kit.dart';

class EasyLoadingOverlay {
  static void easyLoadingOverlay({String? title, bool? dismiss}) {
    OverlayLoadingProgress.start(
      gifOrImagePath: Assets.images.ezLoading.path,
      barrierDismissible: dismiss ?? false,
      widget: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            top: 320,
            right: 50,
            left: 50,
            child: Assets.images.ezLoading.image(width: 200, height: 200),
          ),
          Positioned(
            top: 480,
            right: 50,
            left: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title ?? LocaleKeys.loading.tr(),
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                  ),
                ),
                WaitingDot(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static void dismiss() async {
    OverlayLoadingProgress.stop();
  }
}

class WaitingDot extends StatelessWidget {
  final double? fontSize;
  final Color? color;
  const WaitingDot({super.key, this.fontSize = 14, this.color});
  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: TextStyle(
        color: color,
        fontSize: fontSize,
        letterSpacing: 1,
        fontWeight: FontWeight.bold,
      ),
      child: AnimatedTextKit(
        totalRepeatCount: 100,
        repeatForever: true,
        animatedTexts: [
          TyperAnimatedText(
            '...',
            speed: Duration(milliseconds: 200),
            curve: Curves.easeInOut,
          ),
        ],
        isRepeatingAnimation: true,
      ),
    );
  }
}
