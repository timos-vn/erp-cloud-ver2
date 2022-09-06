import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:sse/model/models/login_data.dart';
import 'package:sse/screen/login/login_bloc.dart';
import 'package:sse/screen/login/login_event.dart';
import 'package:sse/utils/auth/auth.dart';
import 'package:sse/utils/utils.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../model/models/login_user_type.dart';
import '../../../animation_widget/animation_text_form_field.dart';
import '../../../animation_widget/custom_animation_background.dart';
import '../../../animation_widget/animated_button.dart';
import '../../../animation_widget/fade_in.dart';
import '../../../utils/const.dart';
import '../../widget/register_use.dart';
import '../login_state.dart';

class LoginCard extends StatefulWidget {
  const LoginCard({
    Key? key,
    required this.loadingController,
    required this.onSwitchRecoveryPassword,
    this.onSwitchSignUpAdditionalData,
    required this.userType,
    this.onSubmitCompleted,
  }) : super(key: key);

  final AnimationController loadingController;
  final Function onSwitchRecoveryPassword;
  final Function? onSwitchSignUpAdditionalData;
  final Function? onSubmitCompleted;
  final LoginUserType userType;

  @override
  _LoginCardState createState() => _LoginCardState();
}

class _LoginCardState extends State<LoginCard> with TickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey();

  final _passwordFocusNode = FocusNode();
  final _nameFocusNode = FocusNode();
  final _confirmPasswordFocusNode = FocusNode();

  late TextEditingController _hotIdController;
  late TextEditingController _nameController;
  late TextEditingController _passController;

  var _isLoading = false;
  var _isSubmitting = false;

  /// switch between login and signup
  late AnimationController _switchAuthController;
  late AnimationController _postSwitchAuthController;
  late AnimationController _submitController;

  ///list of AnimationController each one responsible for a authentication provider icon
  List<AnimationController> _providerControllerList = <AnimationController>[];

  Interval? _hotIdTextFieldLoadingAnimationInterval;
  Interval? _nameTextFieldLoadingAnimationInterval;
  Interval? _passTextFieldLoadingAnimationInterval;
  Interval? _textButtonLoadingAnimationInterval;
  late Animation<double> _buttonScaleAnimation;

  bool get buttonEnabled => !_isLoading && !_isSubmitting;

  bool showBackground = false;

  late LoginBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = LoginBloc(context);
    _hotIdController = TextEditingController();
    _nameController = TextEditingController();
    _passController = TextEditingController();

    widget.loadingController.addStatusListener(handleLoadingAnimationStatus);

    _switchAuthController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _postSwitchAuthController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _submitController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _hotIdTextFieldLoadingAnimationInterval = const Interval(0, .39);
    _nameTextFieldLoadingAnimationInterval = const Interval(0, .85);
    _passTextFieldLoadingAnimationInterval = const Interval(.15, 1.0);
    _textButtonLoadingAnimationInterval = const Interval(.6, 1.0, curve: Curves.easeOut);
    _buttonScaleAnimation =
        Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
          parent: widget.loadingController,
          curve: const Interval(.4, 1.0, curve: Curves.easeOutBack),
        ));
  }

  void handleLoadingAnimationStatus(AnimationStatus status) {
    if (status == AnimationStatus.forward) {
      setState(() {
        _isLoading = true;
        showBackground = true;
      });
    }
    if (status == AnimationStatus.completed) {
      setState(()  {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    widget.loadingController.removeStatusListener(handleLoadingAnimationStatus);
    _passwordFocusNode.dispose();
    _confirmPasswordFocusNode.dispose();

    _switchAuthController.dispose();
    _postSwitchAuthController.dispose();
    _submitController.dispose();

    for (var controller in _providerControllerList) {
      controller.dispose();
    }
    super.dispose();
  }


  Future<bool> _submit() async {
    FocusScope.of(context).requestFocus(FocusNode());

    _formKey.currentState!.save();
    await _submitController.forward();
    setState(() {
      _isSubmitting = true;
    });
    final auth = Provider.of<Auth>(context, listen: false);
    bool? success;

    // auth.authType = AuthType.userPassword;
    print(auth.hotId);print(auth.username);print(auth.password);
    success = await auth.onLogin?.call(LoginData(
        hotId: auth.hotId,
        username: auth.username,
        password: auth.password,
      ));

    await _submitController.reverse();

    if(success == false){
      // showErrorToast(context, messages.flushbarTitleError, error!);
      Utils.showCustomToast(context, Icons.warning_amber_outlined, 'Sai thông tin tài khoản hoặc mật khẩu');
      setState(() {
        _isSubmitting = false;
        // showBackground = false;
      });
      return false;
    }else {
      setState(() {
        showBackground = false;
      });
    }

    widget.onSubmitCompleted?.call();

    return true;
  }

  Widget _buildHotIdField(double width, Auth auth,) {
    return AnimatedTextFormField(
      controller: _hotIdController,
      width: width,
      loadingController: widget.loadingController,
      interval: _hotIdTextFieldLoadingAnimationInterval,
      labelText: Utils.getLabelText(LoginUserType.hotId),
      autofillHints: _isSubmitting
          ? null
          : [Utils.getAutoFillHints(LoginUserType.hotId)],
      prefixIcon: Icon(MdiIcons.badgeAccountOutline,color: Color.fromARGB(255, 0, 51, 114),),
      keyboardType: Utils.getKeyboardType(widget.userType),
      textInputAction: TextInputAction.next,
      onFieldSubmitted: (value) {
        print('123');
        FocusScope.of(context).requestFocus(_nameFocusNode);
      },
      // validator: widget.userValidator,
      onSaved: (value) => auth.hotId = value!,
      enabled: !_isSubmitting,
    );
  }

  Widget _buildUserField(double width, Auth auth,) {
    return AnimatedTextFormField(
      controller: _nameController,
      width: width,
      loadingController: widget.loadingController,
      interval: _nameTextFieldLoadingAnimationInterval,
      labelText: Utils.getLabelText(LoginUserType.name),
      autofillHints: _isSubmitting
          ? null
          : [Utils.getAutoFillHints(LoginUserType.name)],
      prefixIcon: Icon(Icons.account_circle_outlined,color: Color.fromARGB(255, 0, 51, 114),),
      keyboardType: Utils.getKeyboardType(widget.userType),
      textInputAction: TextInputAction.next,
      focusNode: _nameFocusNode,
      onFieldSubmitted: (value) {
        FocusScope.of(context).requestFocus(_passwordFocusNode);
      },
      // validator: widget.userValidator,
      onSaved: (value) => auth.username = value!,
      enabled: !_isSubmitting,
    );
  }

  Widget _buildPasswordField(double width, Auth auth,) {
    return AnimatedPasswordTextFormField(
      animatedWidth: width,
      loadingController: widget.loadingController,
      interval: _passTextFieldLoadingAnimationInterval,
      labelText: Utils.getLabelText(LoginUserType.pass),
      autofillHints: _isSubmitting
          ? null
          : [AutofillHints.password],
      controller: _passController,
      textInputAction:TextInputAction.done,
      // auth.isLogin ?  : TextInputAction.next,
      focusNode: _passwordFocusNode,
      onFieldSubmitted: (value) {
        _submit();
      },
      // validator: widget.passwordValidator,
      onSaved: (value) => auth.password = value!,
      enabled: !_isSubmitting,
    );
  }

  Widget _buildRegisterUse(ThemeData theme,) {
    return FadeIn(
      controller: widget.loadingController,
      fadeDirection: FadeDirection.bottomToTop,
      offset: .5,
      curve: _textButtonLoadingAnimationInterval!,
      child: TextButton(
        onPressed: buttonEnabled
            ? () {
          showDialog(
              context: context,
              builder: (context) {
                return WillPopScope(
                  onWillPop: () async => true,
                  child: RegisterUseComponent(
                    title: 'Liên hệ với chúng tôi',
                    content: 'Bạn muốn gọi tới số 0243 568 22 22',
                  ),
                );
              }).then((value)async{
                if(value != null){
                  final Uri launchUri = Uri(
                    scheme: 'tel',
                    path: '02435682222',
                  );
                  await launchUrl(launchUri);
                }
          });
        }
            : null,
        child: Text(
          'Đăng ký sử dụng ?',
          style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),
          textAlign: TextAlign.left,
        ),
      ),
    );
  }

  Widget _buildSubmitButton(ThemeData theme, ) {
    return ScaleTransition(
      scale: _buttonScaleAnimation,
      child: AnimatedButton(
        controller: _submitController,
        text: '      Đăng nhập      ',
        onPressed: () => _submit(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<Auth>(context, listen: true);
    //final messages = Provider.of<LoginMessages>(context, listen: false);
    final theme = Theme.of(context);
    final cardWidth = min(MediaQuery.of(context).size.width * 9.9, 360.0);
    const cardPadding = 4.0;
    final textFieldWidth = cardWidth - cardPadding * 1;
    final authForm = Form(
      key: _formKey,
      child: Column(
        children: [
          Container(

            padding: const EdgeInsets.only(
              left: cardPadding,
              right: cardPadding,
              top: cardPadding + 10,
            ),
            width: cardWidth,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _buildHotIdField(textFieldWidth, auth),
                const SizedBox(height: 20),
                _buildUserField(textFieldWidth, auth),
                const SizedBox(height: 20),
                _buildPasswordField(textFieldWidth, auth),
                const SizedBox(height: 10),
              ],
            ),
          ),
          Container(
            padding:const EdgeInsets.only(right: cardPadding, bottom: cardPadding, left: cardPadding,),
            width: cardWidth,
            child: Column(
              children: <Widget>[
                Align(
                    alignment:Alignment.centerRight,
                    child: _buildRegisterUse(theme,)),
                SizedBox(height: 10,),
                _buildSubmitButton(theme, ),
              ],
            ),
          ),
        ],
      ),
    );

    return BlocListener<LoginBloc, LoginState>(
      bloc: _bloc,
      listener: (context,state){
        if (state is LoginSuccess) {
          // print('1122331312');
          // Utils.showCustomToast(context, Icons.check_circle_outline, 'Login Success');
          //libGetX.Get.off(InfoCompanyPage(username: _loginBloc.username,),transition: libGetX.Transition.zoom);
          // Navigator.push(context, MaterialPageRoute(builder: (context)=>ViewHTML(html: _loginBloc.html,)));
          //Get.snackbar('Status','Login is ssf',snackPosition: SnackPosition.BOTTOM, margin: EdgeInsets.symmetric(vertical: 5,horizontal: 5));
        }
        if (state is LoginFailure) {
          Utils.showCustomToast(context, Icons.error, 'Check: ${state.error}');
          Const.HOST_URL = '';
          Const.PORT_URL = 0;
          //libGetX.Get.snackbar('Status'.tr,state.error.toString(),snackPosition: SnackPosition.BOTTOM, margin: EdgeInsets.symmetric(vertical: 5,horizontal: 5));
        }
      },
      child: BlocBuilder<LoginBloc, LoginState>(
        bloc: _bloc,
        builder: (BuildContext context, LoginState state){
          return Stack(
            alignment: AlignmentDirectional.center,
            children: [
              AnimatedBackground(width: 100, show: showBackground),
              FittedBox(
                child: authForm,
              ),
              Positioned(
                bottom: MediaQuery.of(context).size.height * 0.1,
                left: 0,right: 0,
                child: _buildLoginDemo(),
              )
            ],
          );
        },
      ),
    );
  }

  Widget _buildLoginDemo() {
    return FadeIn(
      controller: widget.loadingController,
      fadeDirection: FadeDirection.bottomToTop,
      offset: .5,
      curve: _textButtonLoadingAnimationInterval!,
      child: TextButton(
          onPressed:  null,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Bạn chưa có tài khoản ?',
                style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600),
              ),
              SizedBox(
                width: 5,
              ),
              Text(
                'Demo',
                style:TextStyle(
                    color: Color(0xfff79c4f),
                    fontSize: 13,
                    fontWeight: FontWeight.w600),
              ),
            ],
          )
      ),
    );
  }
}
