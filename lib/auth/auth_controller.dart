import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../core/permissions.dart';
import '../routes/app_routes.dart';

class AuthController extends GetxController {
  final _supabase = Supabase.instance.client;
  final _googleSignIn = GoogleSignIn(
    serverClientId: '861888827189-f56hqv33opoqo5ck9qtj8lmik5casqvj.apps.googleusercontent.com',
    scopes: [
      'email',
      'https://www.googleapis.com/auth/cloud-identity.groups.readonly',
    ],
  );

  final isLoading = false.obs;
  final userRole = ''.obs;
  final userName = ''.obs;
  final userEmail = ''.obs;
  final userAvatar = ''.obs;

  User? get currentUser => _supabase.auth.currentUser;
  bool get isLoggedIn => currentUser != null;
  Permissions get permissions => Permissions.of(userRole.value);

  @override
  void onInit() {
    super.onInit();
    _restoreSession();
    _supabase.auth.onAuthStateChange.listen((data) {
      if (data.event == AuthChangeEvent.signedOut) {
        userRole.value = '';
        userName.value = '';
        userEmail.value = '';
        userAvatar.value = '';
        Get.offAllNamed(Routes.login);
      }
    });
  }

  void _restoreSession() {
    final user = _supabase.auth.currentUser;
    if (user == null) return;
    final meta = user.userMetadata ?? {};
    userRole.value = meta['role'] as String? ?? '';
    userName.value = meta['full_name'] as String? ?? meta['name'] as String? ?? '';
    userEmail.value = user.email ?? '';
    userAvatar.value = meta['avatar_url'] as String? ?? meta['picture'] as String? ?? '';
  }

  Future<void> signInWithGoogle() async {
    isLoading.value = true;
    try {
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return; // user cancelled

      final googleAuth = await googleUser.authentication;
      final idToken = googleAuth.idToken;
      final accessToken = googleAuth.accessToken;

      if (idToken == null) {
        Get.snackbar('Error', 'Failed to get Google ID token');
        return;
      }

      final authResponse = await _supabase.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: idToken,
        accessToken: accessToken,
      );

      final supabaseToken = authResponse.session?.accessToken;
      if (supabaseToken == null) {
        Get.snackbar('Error', 'Failed to create session');
        return;
      }

      // Restrict to dharmanaturals.com domain
      if (!googleUser.email.endsWith('@dharmanaturals.com')) {
        await _signOutAll();
        Get.snackbar(
          'Access Denied',
          'Only @dharmanaturals.com accounts are allowed.',
          duration: const Duration(seconds: 4),
        );
        return;
      }

      // Check Google Group membership via Edge Function using user's own token
      final response = await _supabase.functions.invoke(
        'check-user-role',
        headers: {
          'Authorization': 'Bearer $supabaseToken',
          'x-google-access-token': accessToken!,
        },
      );

      if (response.status == 403) {
        print('403 debug: ${response.data}');
        await _signOutAll();
        Get.snackbar(
          'Access Denied',
          response.data.toString(),
          duration: const Duration(seconds: 6),
        );
        return;
      }

      if (response.status != 200) {
        await _signOutAll();
        Get.snackbar('Error', 'Could not verify your access. Try again.');
        return;
      }

      final role = response.data['role'] as String;

      // Persist role in Supabase user metadata so it survives app restarts
      await _supabase.auth.updateUser(UserAttributes(data: {'role': role}));

      userRole.value = role;
      userName.value = googleUser.displayName ?? '';
      userEmail.value = googleUser.email;
      userAvatar.value = googleUser.photoUrl ?? '';

      Get.offAllNamed(Routes.dashboard);
    } on AuthException catch (e) {
      Get.snackbar('Sign-in Failed', e.message);
    } catch (e, stack) {
      print('SIGN_IN_ERROR: $e');
      print('SIGN_IN_STACK: $stack');
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signOut() async {
    await _signOutAll();
  }

  Future<void> _signOutAll() async {
    await _googleSignIn.signOut();
    await _supabase.auth.signOut();
  }
}
