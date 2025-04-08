import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:japx/japx.dart';

class AuthRepository {
  Future<bool> sendOtp(String phoneNumber) async {
    final url = Uri.parse(
      'https://test.myfliqapp.com/api/v1/auth/registration-otp-codes/actions/phone/send-otp',
    );

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "data": {
          "type": "registration_otp_codes",
          "attributes": {
            "phone": phoneNumber,
          }
        }
      }),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      final errorBody = jsonDecode(response.body);
      final errorMessage =
          errorBody['errors']?[0]?['detail'] ?? 'Something went wrong';
      throw Exception(errorMessage);
    }
  }

  Future<Map<String, dynamic>> verifyOtp(String phone, String otp) async {
    final url = Uri.parse(
      'https://test.myfliqapp.com/api/v1/auth/registration-otp-codes/actions/phone/verify-otp',
    );

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "data": {
          "type": "registration_otp_codes",
          "attributes": {
            "phone": phone,
            "otp": int.parse(otp),
            "device_meta": {
              "type": "mobile",
              "name": "Flutter App",
              "os": "Android/iOS",
              "browser": "Flutter",
              "browser_version": "1.0",
              "user_agent": "Flutter",
              "screen_resolution": "1080x1920",
              "language": "en-US"
            }
          }
        }
      }),
    );

    if (response.statusCode == 200) {
      final parsed = Japx.decode(jsonDecode(response.body));
      return parsed['data'];
    } else {
      throw Exception("OTP Verification Failed: ${response.body}");
    }
  }
}
