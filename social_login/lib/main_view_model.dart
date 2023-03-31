import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:social_login/kakao_login.dart';

class MainViewModel {
  final SocialLogin _socialLogin;
  bool isLoggedIn = false;
  User? user;

  MainViewModel(this._socialLogin);

  Future login() async {
    isLoggedIn = await _socialLogin.login();
    if (isLoggedIn) {
      user = await UserApi.instance.me();
    }
  }

  Future logout() async {
    await _socialLogin.logout();
    isLoggedIn = false;
    user = null;
  }
}
