import 'dart:async';
import 'package:aad_oauth/aad_oauth.dart';
import 'package:aad_oauth/model/config.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:local_share/src/features/offres/routing/app_router.dart';
import 'package:local_share/src/services/api.dart';

import 'microsoft_login_state.dart';

class AuthCubit extends Cubit<AuthState> {
  late AadOAuth oauth;

  AuthCubit() : super(AuthInitial()) {
    final Config config = Config(
      tenant: "0bd66e42-d830-4cdc-b580-f835a405d038",
      clientId: "9a75030d-e141-4531-abb6-4110fe10b364",
      scope: "openid profile offline_access User.Read",
      navigatorKey: navigatorKey,
      webUseRedirect: false,
      redirectUri: kIsWeb
          ? "http://localhost:8080/"
          : "https://login.live.com/oauth20_desktop.srf",
      postLogoutRedirectUri: kIsWeb
          ? "http://localhost:8080/"
          : "https://login.live.com/oauth20_desktop.srf",
    );
    oauth = AadOAuth(config);
    checkExistingSession();
  }

  Future<void> checkExistingSession() async {
    try {
      bool isLogged = await oauth.hasCachedAccountInformation;
      if (isLogged) {
        await fetchUserDataAndEmitSuccess();
      } else {
        emit(AuthInitial());
      }
    } catch (e) {
      emit(AuthInitial());
    }
  }

  Future<void> login() async {
    emit(AuthLoading());
    try {
      await oauth.login();
      await fetchUserDataAndEmitSuccess();
    } catch (e) {
      emit(AuthError("Login failed. Please try again."));
    }
  }

  Future<void> fetchUserDataAndEmitSuccess() async {
    emit(AuthLoading());
    try {
      final accessToken = await oauth.getAccessToken().timeout(
        const Duration(seconds: 4),
        onTimeout: () =>
            throw TimeoutException('Token acquisition iframe timed out'),
      );

      if (accessToken == null) {
        emit(AuthInitial());
        return;
      }

      Response jsonResponse = await API().getUserDetails(token: accessToken);
      final Map<String, dynamic> userData = jsonResponse.data;

      final String azureId = userData["id"];
      final String name = userData["displayName"] ?? "Not Available";
      final String email = userData["mail"] ?? "Not Available";
      final String mobilePhone = userData['mobilePhone'] ?? 'Not Available';
      final String jobTitle = userData['jobTitle'] ?? 'Not Available';
      final String officeLocation =
          userData['officeLocation'] ?? 'Not Available';
      final String department = userData['department'] ?? 'Not Available';

      try {
        await Dio().post(
          "https://localhost:7024/api/User/sync",
          data: {"azureId": azureId, "userName": name, "email": email},
        );
      } catch (e) {
        print("Erreur lors de la synchronisation avec le backend : $e");
      }

      Uint8List? photo;
      try {
        Response photoResponse = await API().getProfileImage(
          token: accessToken,
        );
        if (photoResponse.data != null && photoResponse.data is List<int>) {
          photo = Uint8List.fromList(photoResponse.data);
        }
      } catch (_) {
        photo = null;
      }

      emit(
        AuthSuccess(
          photo,
          name,
          email,
          mobilePhone,
          jobTitle,
          officeLocation,
          department,
        ),
      );
    } catch (e) {
      try {
        await oauth.logout();
      } catch (_) {}
      emit(AuthInitial());
    }
  }

  Future<void> logout() async {
    emit(AuthLoading());
    try {
      await oauth.logout();
      emit(AuthInitial());
    } catch (e) {
      emit(AuthInitial());
    }
  }
}
