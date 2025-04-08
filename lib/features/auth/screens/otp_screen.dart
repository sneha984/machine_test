// import 'dart:convert';
//
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'package:http/http.dart' as http;
// import 'package:japx/japx.dart';
// import 'package:machine_test_flutter/chat_list_screen.dart';
// import 'package:pin_code_fields/pin_code_fields.dart';
//
// import 'global_variables.dart';
//
// class OtpScreen extends ConsumerStatefulWidget {
//   final String phoneNumber;
//
//   const OtpScreen({Key? key, required this.phoneNumber}) : super(key: key);
//
//   @override
//   ConsumerState<OtpScreen> createState() => _OtpScreenState();
// }
//
// class _OtpScreenState extends ConsumerState<OtpScreen> {
//   final TextEditingController otpController = TextEditingController();
//   final storage = const FlutterSecureStorage();
//
//   Future<void> verifyOtp(String otp) async {
//     final url = Uri.parse(
//         'https://test.myfliqapp.com/api/v1/auth/registration-otp-codes/actions/phone/verify-otp');
//
//     final response = await http.post(
//       url,
//       headers: {'Content-Type': 'application/json'},
//       body: jsonEncode({
//         "data": {
//           "type": "registration_otp_codes",
//           "attributes": {
//             "phone": widget.phoneNumber,
//             "otp": int.parse(otp),
//             "device_meta": {
//               "type": "mobile",
//               "name": "Flutter App",
//               "os": "Android/iOS",
//               "browser": "Flutter",
//               "browser_version": "1.0",
//               "user_agent": "Flutter",
//               "screen_resolution": "1080x1920",
//               "language": "en-US"
//             }
//           }
//         }
//       }),
//     );
//
//     if (response.statusCode == 200) {
//       final parsedJson = jsonDecode(response.body);
//       final japxData = Japx.decode(parsedJson);
//
//       final userId = japxData['data']?['id'];
//       final accessToken = japxData['data']?['auth_status']?['access_token'];
//
//       // Save data securely
//       final storage = ref.read(secureStorageProvider);
//       await storage.write(key: 'accessToken', value: accessToken);
//
//       await storage.write(key: 'user_id', value: userId);
//
//       // await storage.write(key: 'access_token', value: accessToken);
//
//       print("✅ OTP Verified. User ID: $userId");
//       print("✅ OTP Verified. User ID: $accessToken");
//
//       // Navigate to Chat Screen
//       Navigator.pushAndRemoveUntil(
//         context,
//         MaterialPageRoute(builder: (context) => ChatUsersScreen()),
//         (route) => true,
//       );
//     } else {
//       print("❌ Verification failed: ${response.body}");
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Invalid OTP")),
//       );
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Verify OTP")),
//       body: Padding(
//         padding: const EdgeInsets.all(24.0),
//         child: Column(
//           children: [
//             const Text("Enter the OTP sent to your phone"),
//             const SizedBox(height: 20),
//             const SizedBox(height: 24),
//             PinCodeTextField(
//               appContext: context,
//               length: 6,
//               onChanged: (value) => otpController.text = value,
//               onCompleted: (value) => otpController.text = value,
//               keyboardType: TextInputType.number,
//               pinTheme: PinTheme(
//                 shape: PinCodeFieldShape.box,
//                 borderRadius: BorderRadius.circular(10),
//                 fieldHeight: 50,
//                 fieldWidth: 40,
//                 activeColor: Colors.black,
//                 inactiveColor: Colors.grey,
//                 selectedColor: Colors.pink,
//               ),
//             ),
//             const SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () {
//                 verifyOtp(otpController.text.trim());
//               },
//               child: const Text("Verify"),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:machine_test_flutter/features/chat/screens/chat_list_screen.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../../core/commons/global_variables/global_variables.dart';
import '../controller/auth_controller.dart';

class OtpScreen extends ConsumerStatefulWidget {
  final String phoneNumber;
  const OtpScreen({Key? key, required this.phoneNumber}) : super(key: key);

  @override
  ConsumerState<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends ConsumerState<OtpScreen> {
  final TextEditingController otpController = TextEditingController();

  void handleVerify() async {
    final controller = ref.read(authControllerProvider.notifier);
    final success = await controller.verifyOtp(
      widget.phoneNumber,
      otpController.text.trim(),
    );

    if (success) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => ChatUsersList()),
        (_) => false,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Invalid OTP")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(
              left: width * 0.05, top: height * 0.023, right: width * 0.05),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_back, color: Colors.black87),
              ),
              const SizedBox(height: 20),
              Center(
                child: Text(
                  "Enter your verification code",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: height * 0.032,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
              ),
              SizedBox(
                height: height * 0.07,
              ),
              Row(
                children: [
                  Text(
                    widget.phoneNumber,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: height * 0.016,
                      fontWeight: FontWeight.w400,
                      color: Colors.black54,
                    ),
                  ),
                  SizedBox(
                    width: width * 0.02,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      "Edit",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: height * 0.017,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: height * 0.02),
              PinCodeTextField(
                appContext: context,
                length: 6,
                onChanged: (value) => otpController.text = value,
                keyboardType: TextInputType.number,
                onCompleted: (value) => otpController.text = value,
                pinTheme: PinTheme(
                  shape: PinCodeFieldShape.box,
                  borderRadius: BorderRadius.circular(10),
                  fieldHeight: 50,
                  fieldWidth: 40,
                  selectedBorderWidth: 0.7,
                  disabledBorderWidth: 0.7,
                  errorBorderWidth: 0.7,
                  inactiveBorderWidth: 0.7,
                  borderWidth: 0.1,
                  activeBorderWidth: 0.7,
                  activeColor: Colors.black,
                  inactiveColor: Colors.grey,
                  selectedColor: Colors.pink,
                ),
              ),
              SizedBox(height: height * 0.01),
              Text(
                "Didn't get anything? No worries, lets's try again.",
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: height * 0.015,
                  fontWeight: FontWeight.w400,
                  color: Colors.black54,
                ),
              ),
              Text(
                "Resend",
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: height * 0.016,
                  fontWeight: FontWeight.w600,
                  color: Colors.blue,
                ),
              ),
              Spacer(),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: handleVerify,
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: EdgeInsets.zero,
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                  ),
                  child: Ink(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFFF5B7F), Color(0xFFFF76A4)],
                      ),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Container(
                      alignment: Alignment.center,
                      child: Text(
                        "Verify",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
