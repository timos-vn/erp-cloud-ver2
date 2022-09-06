import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart' show timeDilation;

import 'package:provider/provider.dart';
import 'package:sign_in_button/sign_in_button.dart';
import 'package:sse/providers/login_theme.dart';
import 'package:sse/animation_widget/auth_card_login_builder.dart';
import 'package:sse/animation_widget/fade_in.dart';
import 'package:sse/themes/gradient_box.dart';
import 'package:sse/animation_widget/hero_text.dart';
import 'package:sse/utils/auth/auth.dart';
import 'package:sse/utils/utils.dart';

import '../../../themes/color_helper.dart';
import '../../../utils/const.dart';
import '../../../model/models/login_user_type.dart';

export 'package:sign_in_button/src/button_list.dart';

class LoginProvider {
  /// Used for custom sign-in buttons.
  ///
  /// NOTE: Both [button] and [icon] can be added to [LoginProvider],
  /// but [button] will take preference over [icon]
  final Buttons? button;

  /// The icon shown on the provider button
  ///
  /// NOTE: Both [button] and [icon] can be added to [LoginProvider],
  /// but [button] will take preference over [icon]
  final IconData? icon;

  /// The label shown under the provider
  final String label;

  /// Enable or disable the animation of the button.
  ///
  /// Default: true
  final bool animated;

  const LoginProvider(
      {this.button,
        this.icon,
        this.label = '',
        this.animated = true})
      : assert(button != null || icon != null);
}

class _Header extends StatefulWidget {
  const _Header({
    this.logo,
    this.logoTag,
    this.logoWidth = 0.75,
    this.title,
    this.titleTag,
    this.height = 250.0,
    this.logoController,
    this.titleController,
    required this.loginTheme,
    this.footer,
  });

  final ImageProvider? logo;
  final String? logoTag;
  final double logoWidth;
  final String? title;
  final String? titleTag;
  final double height;
  final LoginTheme loginTheme;
  final AnimationController? logoController;
  final AnimationController? titleController;
  final String? footer;

  @override
  __HeaderState createState() => __HeaderState();
}

class __HeaderState extends State<_Header> {
  double _titleHeight = 0.0;

  /// https://stackoverflow.com/a/56997641/9449426
  double getEstimatedTitleHeight() {
    if (Utils.isNullOrEmpty(widget.title)) {
      return 0.0;
    }

    final theme = Theme.of(context);
    final renderParagraph = RenderParagraph(
      TextSpan(
        text: widget.title,
        style: theme.textTheme.headline3!.copyWith(
          fontSize: widget.loginTheme.beforeHeroFontSize,
        ),
      ),
      textDirection: TextDirection.ltr,
      maxLines: 1,
    );

    renderParagraph.layout(const BoxConstraints());

    return renderParagraph
        .getMinIntrinsicHeight(widget.loginTheme.beforeHeroFontSize)
        .ceilToDouble();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _titleHeight = getEstimatedTitleHeight();
  }

  @override
  void didUpdateWidget(_Header oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.title != oldWidget.title) {
      _titleHeight = getEstimatedTitleHeight();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const gap = 5.0;
    final logoHeight = min(
        (widget.height - MediaQuery.of(context).padding.top) -
            _titleHeight -
            gap,
        kMaxLogoHeight);
    final displayLogo = widget.logo != null && logoHeight >= kMinLogoHeight;
    final cardWidth = min(MediaQuery.of(context).size.width * 0.75, 360.0);

    var logo = displayLogo
        ? Image(
      image: widget.logo!,
      filterQuality: FilterQuality.high,
      height: logoHeight,
      width: widget.logoWidth * cardWidth,
    )
        : const SizedBox.shrink();

    if (widget.logoTag != null) {
      logo = Hero(
        tag: widget.logoTag!,
        child: logo,
      );
    }

    Widget? title;
    if (widget.titleTag != null && !Utils.isNullOrEmpty(widget.title)) {
      title = HeroText(
        widget.title,
        key: kTitleKey,
        tag: widget.titleTag,
        largeFontSize: widget.loginTheme.beforeHeroFontSize,
        smallFontSize: widget.loginTheme.afterHeroFontSize,
        style: theme.textTheme.headline3,
        viewState: ViewState.enlarged,
      );
    }
    else if (!Utils.isNullOrEmpty(widget.title)) {
      title = Text(
        widget.title!,
        key: kTitleKey,
        style: theme.textTheme.headline3,
      );
    } else {
      title = null;
    }

    return SafeArea(
      child: SizedBox(
        height: (widget.height - MediaQuery.of(context).padding.top),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            if (displayLogo)
              FadeIn(
                controller: widget.logoController,
                offset: .25,
                fadeDirection: FadeDirection.topToBottom,
                child: logo,
              ),
            const SizedBox(height: gap),
            FadeIn(
              controller: widget.titleController,
              offset: .5,
              fadeDirection: FadeDirection.topToBottom,
              child: title!,
            ),
          ],
        ),
      ),
    );
  }
}

class CustomLogin extends StatefulWidget {
  CustomLogin(
      {Key? key,
        /// The [ImageProvider] or asset path [String] for the logo image to be displayed
        dynamic logo,
        this.theme,
        required this.onLogin,
        this.onSubmitAnimationCompleted,
        this.logoTag,
        this.userType = LoginUserType.email,
        this.titleTag,
        this.loginProviders = const <LoginProvider>[],
        this.disableCustomPageTransformer = false,
        this.children,
        this.scrollable = false})
      : assert((logo is String?) || (logo is ImageProvider?)),
        logo = logo is String ? AssetImage(logo) : logo,
        super(key: key);


  /// [LoginUserType] can be email, name or phone, by default is email. It will change how
  /// the edit text autofill and behave accordingly to your choice
  final LoginUserType userType;

  /// Called when the user hit the submit button when in login mode
  final LoginCallback onLogin;

  /// list of LoginProvider each have an icon and a callback that will be Called when
  /// the user hit the provider icon button
  /// if not specified nothing will be shown
  final List<LoginProvider> loginProviders;

  /// The image provider for the logo image to be displayed
  final ImageProvider? logo;

  /// FlutterLogin's theme. If not specified, it will use the default theme as
  /// shown in the demo gifs and use the colorsheme in the closest `Theme`
  /// widget
  final LoginTheme? theme;

  /// Called after the submit animation's completed. Put your route transition
  /// logic here. Recommend to use with [logoTag] and [titleTag]
  final Function? onSubmitAnimationCompleted;

  /// Hero tag for logo image. If not specified, it will simply fade out when
  /// changing route
  final String? logoTag;

  /// Hero tag for title text. Need to specify `LoginTheme.beforeHeroFontSize`
  /// and `LoginTheme.afterHeroFontSize` if you want different font size before
  /// and after hero animation
  final String? titleTag;


  /// Disable the page transformation between switching authentication modes.
  /// Fixes #97 if disabled. https://github.com/NearHuscarl/flutter_login/issues/97
  final bool disableCustomPageTransformer;

  /// Supply custom widgets to the auth stack such as a custom logo widget
  final List<Widget>? children;

  /// If set to true, make the login window scrollable when overflowing instead
  /// of resizing the window.
  /// Default: false
  final bool scrollable;

  @override
  _CustomLoginState createState() => _CustomLoginState();
}

class _CustomLoginState extends State<CustomLogin>
    with TickerProviderStateMixin {
  final GlobalKey<AuthCardLoginState> authCardKey = GlobalKey();

  static const loadingDuration = Duration(milliseconds: 400);


  late AnimationController _loadingController;
  late AnimationController _logoController;
  late AnimationController _titleController;

  @override
  void initState() {
    super.initState();
    _loadingController = AnimationController(
      vsync: this,
      duration: loadingDuration,
    )..addStatusListener((status) {
      if (status == AnimationStatus.forward) {
        _logoController.forward();
        _titleController.forward();
      }
      if (status == AnimationStatus.reverse) {
        _logoController.reverse();
        _titleController.reverse();
      }
    });
    _logoController = AnimationController(
      vsync: this,
      duration: loadingDuration,
    );
    _titleController = AnimationController(
      vsync: this,
      duration: loadingDuration,
    );

    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        _loadingController.forward();
      }
    });
  }

  @override
  void dispose() {
    _loadingController.dispose();
    _logoController.dispose();
    _titleController.dispose();
    super.dispose();
  }

  void _reverseHeaderAnimation() {
    if (widget.logoTag == null) {
      _logoController.reverse();
    }
    if (widget.titleTag == null) {
      _titleController.reverse();
    }
  }

  Widget _buildHeader(double height, LoginTheme loginTheme) {
    return _Header(
      logoController: _logoController,
      titleController: _titleController,
      height: height,
      logo: widget.logo,
      logoTag: widget.logoTag,
      logoWidth: widget.theme?.logoWidth ?? 0.75,
      title: ' ',
      titleTag: widget.titleTag,
      loginTheme: loginTheme,
    );
  }

  ThemeData _mergeTheme({required ThemeData theme, required LoginTheme loginTheme}) {
    final blackOrWhite =
    theme.brightness == Brightness.light ? Colors.black54 : Colors.white;
    final primaryOrWhite = theme.brightness == Brightness.light
        ? theme.primaryColor
        : Colors.white;
    final originalPrimaryColor = loginTheme.primaryColor ?? theme.primaryColor;
    final primaryDarkShades = getDarkShades(originalPrimaryColor);
    final primaryColor = primaryDarkShades.length == 1
        ? lighten(primaryDarkShades.first!)
        : primaryDarkShades.first;
    final primaryColorDark = primaryDarkShades.length >= 3
        ? primaryDarkShades[2]
        : primaryDarkShades.last;
    final accentColor = loginTheme.accentColor ?? theme.colorScheme.secondary;
    final errorColor = loginTheme.errorColor ?? theme.errorColor;
    // the background is a dark gradient, force to use white text if detect default black text color
    final isDefaultBlackText = theme.textTheme.headline3!.color ==
        Typography.blackMountainView.headline3!.color;
    final titleStyle = theme.textTheme.headline3!
        .copyWith(
      color: loginTheme.accentColor ??
          (isDefaultBlackText
              ? Colors.white
              : theme.textTheme.headline3!.color),
      fontSize: loginTheme.beforeHeroFontSize,
      fontWeight: FontWeight.w300,
    )
        .merge(loginTheme.titleStyle);
    final footerStyle = theme.textTheme.bodyText1!
        .copyWith(
      color: loginTheme.accentColor ??
          (isDefaultBlackText
              ? Colors.white
              : theme.textTheme.headline3!.color),
    )
        .merge(loginTheme.footerTextStyle);
    final textStyle = theme.textTheme.bodyText2!
        .copyWith(color: blackOrWhite)
        .merge(loginTheme.bodyStyle);
    final textFieldStyle = theme.textTheme.subtitle1!
        .copyWith(color: blackOrWhite, fontSize: 14)
        .merge(loginTheme.textFieldStyle);
    final buttonStyle = theme.textTheme.button!
        .copyWith(color: Colors.white)
        .merge(loginTheme.buttonStyle);
    final cardTheme = loginTheme.cardTheme;
    final inputTheme = loginTheme.inputTheme;
    final buttonTheme = loginTheme.buttonTheme;
    final roundBorderRadius = BorderRadius.circular(100);



    TextStyle labelStyle;

    if (loginTheme.primaryColorAsInputLabel) {
      labelStyle = TextStyle(color: primaryColor);
    } else {
      labelStyle = TextStyle(color: blackOrWhite);
    }

    return theme.copyWith(
      primaryColor: primaryColor,
      primaryColorDark: primaryColorDark,
      errorColor: errorColor,
      cardTheme: theme.cardTheme.copyWith(
        clipBehavior: cardTheme.clipBehavior,
        color: cardTheme.color ?? theme.cardColor,
        elevation: cardTheme.elevation ?? 12.0,
        margin: cardTheme.margin ?? const EdgeInsets.all(4.0),
        shape: cardTheme.shape ??
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      ),
      inputDecorationTheme: theme.inputDecorationTheme.copyWith(
        filled: inputTheme.filled,
        fillColor: inputTheme.fillColor ??
            Color.alphaBlend(
              primaryOrWhite.withOpacity(.07),
              Colors.grey.withOpacity(.04),
            ),
        contentPadding: inputTheme.contentPadding ??
            const EdgeInsets.symmetric(vertical: 4.0),
        errorStyle: inputTheme.errorStyle ?? TextStyle(color: errorColor),
        labelStyle: inputTheme.labelStyle ?? labelStyle,
        enabledBorder: inputTheme.enabledBorder ??
            inputTheme.border ??
            OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.transparent),
              borderRadius: roundBorderRadius,
            ),
        focusedBorder: inputTheme.focusedBorder ??
            inputTheme.border ??
            OutlineInputBorder(
              borderSide: BorderSide(color: primaryColor!, width: 1.5),
              borderRadius: roundBorderRadius,
            ),
        errorBorder: inputTheme.errorBorder ??
            inputTheme.border ??
            OutlineInputBorder(
              borderSide: BorderSide(color: errorColor),
              borderRadius: roundBorderRadius,
            ),
        focusedErrorBorder: inputTheme.focusedErrorBorder ??
            inputTheme.border ??
            OutlineInputBorder(
              borderSide: BorderSide(color: errorColor, width: 1.5),
              borderRadius: roundBorderRadius,
            ),
        disabledBorder: inputTheme.disabledBorder ??
            inputTheme.border ??
            OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.transparent),
              borderRadius: roundBorderRadius,
            ),
      ),
      floatingActionButtonTheme: theme.floatingActionButtonTheme.copyWith(
        backgroundColor: buttonTheme.backgroundColor ?? primaryColor,
        splashColor: buttonTheme.splashColor ?? theme.colorScheme.secondary,
        elevation: buttonTheme.elevation ?? 4.0,
        highlightElevation: buttonTheme.highlightElevation ?? 2.0,
        shape: buttonTheme.shape ?? const StadiumBorder(),
      ),
      // put it here because floatingActionButtonTheme doesnt have highlightColor property
      highlightColor:
      loginTheme.buttonTheme.highlightColor ?? theme.highlightColor,
      textTheme: theme.textTheme.copyWith(
        headline3: titleStyle,
        bodyText2: textStyle,
        subtitle1: textFieldStyle,
        subtitle2: footerStyle,
        button: buttonStyle,
      ),
      colorScheme:
      Theme.of(context).colorScheme.copyWith(secondary: accentColor),
    );
  }

  @override
  Widget build(BuildContext context) {
    final loginTheme = widget.theme ?? LoginTheme();
    final theme = _mergeTheme(theme: Theme.of(context), loginTheme: loginTheme);
    final deviceSize = MediaQuery.of(context).size;
    final headerMargin = loginTheme.headerMargin ?? 15;
    final cardInitialHeight = loginTheme.cardInitialHeight ?? 300;
    final cardTopPosition = loginTheme.cardTopPosition ??
        max(deviceSize.height / 2 - cardInitialHeight / 2, 85);
    final headerHeight = cardTopPosition - headerMargin;

    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: widget.theme ?? LoginTheme(),
        ),
        ChangeNotifierProvider(
          create: (context) => Auth(
            onLogin: widget.onLogin,
          ),
        ),
      ],
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: <Widget>[
            GradientBox(
              colors: [
                loginTheme.pageColorLight ?? Color.fromARGB(242, 255, 252, 252),
                loginTheme.pageColorDark ?? Color.fromARGB(242, 255, 252, 252),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            SingleChildScrollView(
              child: Theme(
                data: theme,
                child: Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    Positioned(
                      child: AuthCardLogin(
                        key: authCardKey,
                        userType: widget.userType,
                        loadingController: _loadingController,
                        onSubmit: _reverseHeaderAnimation,
                        onSubmitCompleted: widget.onSubmitAnimationCompleted,
                        disableCustomPageTransformer:
                        widget.disableCustomPageTransformer,
                        scrollable: widget.scrollable,
                      ),
                    ),
                    Positioned(
                      top: cardTopPosition - headerHeight - headerMargin,
                      child: _buildHeader(headerHeight, loginTheme),
                    ),
                    ...?widget.children,
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
