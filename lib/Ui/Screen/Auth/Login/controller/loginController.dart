import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:twitter_login/entity/auth_result.dart';
import 'package:twitter_login/twitter_login.dart';
import '../../../../../Config/config.dart';
import '../../../../../Core/core.dart';
import '../../../../../Data/data.dart';
import '../../../../../UI/Widget/widget.dart';

class LoginController extends GetxController {
  AppControllerX app=Get.find();
  RxBool isLoading=false.obs;
  bool isSignUp=false;
  signInWithGoogle() async {
      isLoading.value=true;
    try{
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn(
        scopes: <String>[
          'email',
          'profile',
          'https://www.googleapis.com/auth/plus.me',
        ],) .signIn();
      final GoogleSignInAuthentication googleAuth = await googleUser!.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      if(FirebaseAuth.instance.currentUser==null) {
        try{
        await FirebaseAuth.instance.signInWithCredential(credential);
        }catch(e){
          print(e);
        }
      }
      var result =await DatabaseX.loginBySocialMedia(provider: 'google', accessProviderToken: googleAuth.accessToken!);
      app.user=result.$1;
      isSignUp=result.$2;
      await login();
    }catch(e){
      CatchErrorX.console(e);
      ToastX.error(message: e);
    }
    isLoading.value=false;
  }

  facebook()async=>await signInWithFacebook();
  twitter()async=>await signInWithTwitter();
  google()async=>await signInWithGoogle();
  apple()async=>await login();

  Future<void> login() async {
      LocalDataX.put(LocalNames.token, app.user.token);
    if(isSignUp){
      LocalDataX.put(LocalNames.route,RouteNameX.setLocation);
      Get.offAllNamed(RouteNameX.setLocation);
    }else{
      LocalDataX.put(LocalNames.route,RouteNameX.root);
      Get.offAllNamed(RouteNameX.root);
    }
  }

  signInWithFacebook() async {
    isLoading.value = true;
    try {
      // Trigger the Facebook authentication flow
      final LoginResult result = await FacebookAuth.instance.login();

      // Check if the user has authenticated successfully
      if (result.status == LoginStatus.success) {
        // Get the Facebook access token
        final AccessToken accessToken = result.accessToken!;

        // Exchange Facebook access token for Firebase credential
        final AuthCredential credential =
        FacebookAuthProvider.credential(accessToken.token);

        // Sign in to Firebase using the credential
        UserCredential userCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);

        // Check if the user is new or existing
        bool isNewUser = userCredential.additionalUserInfo!.isNewUser;

        // Get user data from your database (assuming it's implemented)
        var userData = await DatabaseX.loginBySocialMedia(
            provider: 'facebook', accessProviderToken: accessToken.token);

        // Update UI or perform necessary actions based on the result
        // For example:
        app.user = userData.$1;
        isSignUp = userData.$2;
        await login(); // Your login logic after authentication
      } else if (result.status == LoginStatus.cancelled) {
        // User cancelled the login flow
        print('User cancelled the login');
      } else {
        // Error in Facebook authentication
        print('Error in Facebook authentication: ${result.message}');
      }
    } catch (e) {
      // Handle errors
      CatchErrorX.console(e);
      ToastX.error(message: e.toString());
    }
    isLoading.value = false;
  }
  signInWithTwitter() async {
    isLoading.value = true;
    try {
      // Initialize Twitter login instance
      final TwitterLogin twitterLogin = TwitterLogin(
        apiKey: 'paPAugvbCW2wq9JiLgWNkaO9D',
        apiSecretKey: 'ktzYRoiBOhQWC9Y2IbtlbSeH9pd3irILlalHJe6wxlfSZdXRE4', redirectURI: '',
      );

      // Trigger the Twitter authentication flow
      final AuthResult result = await twitterLogin.loginV2();

      // Check if the user has authenticated successfully
      if (result.status == TwitterLoginStatus.loggedIn) {
        // Get the Twitter session token and secret
        final String? token = result.authToken;
        final String? secret = result.authTokenSecret;

        // Exchange Twitter token and secret for Firebase credential
        final AuthCredential credential = TwitterAuthProvider.credential(
          accessToken: token!,
          secret: secret!,
        );

        // Sign in to Firebase using the credential
        UserCredential userCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);

        // Check if the user is new or existing
        bool isNewUser = userCredential.additionalUserInfo!.isNewUser;

        // Get user data from your database (assuming it's implemented)
        var userData = await DatabaseX.loginBySocialMedia(
            provider: 'twitter', accessProviderToken: token);

        // Update UI or perform necessary actions based on the result
        // For example:
        app.user = userData.$1;
        isSignUp = userData.$2;
        await login(); // Your login logic after authentication
      } else if (result.status == TwitterLoginStatus.cancelledByUser) {
        // User cancelled the login flow
        print('User cancelled the login');
      } else {
        // Error in Twitter authentication
        print('Error in Twitter authentication: ${result.errorMessage}');
      }
    } catch (e) {
      // Handle errors
      CatchErrorX.console(e);
      ToastX.error(message: e.toString());
    }
    isLoading.value = false;
  }
}
