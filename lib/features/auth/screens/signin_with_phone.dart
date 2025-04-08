// import 'dart:convert';
//
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
//
// import 'otp_screen.dart';
//
// class PhoneNumberPage extends StatefulWidget {
//   const PhoneNumberPage({Key? key}) : super(key: key);
//
//   @override
//   State<PhoneNumberPage> createState() => _PhoneNumberPageState();
// }
//
// class _PhoneNumberPageState extends State<PhoneNumberPage> {
//   @override
//   Widget build(BuildContext context) {
//     final TextEditingController phoneController = TextEditingController();
//
//     Future<void> sendOtp(String phoneNumber, BuildContext context) async {
//       final url = Uri.parse(
//         'https://test.myfliqapp.com/api/v1/auth/registration-otp-codes/actions/phone/send-otp',
//       );
//
//       try {
//         final response = await http.post(
//           url,
//           headers: {'Content-Type': 'application/json'},
//           body: jsonEncode({
//             "data": {
//               "type": "registration_otp_codes",
//               "attributes": {
//                 "phone": phoneNumber,
//               }
//             }
//           }),
//         );
//
//         if (response.statusCode == 200) {
//           final decoded = jsonDecode(response.body);
//           final otp = decoded['data'];
//
//           print("✅ OTP received from API: $otp");
//
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (_) => OtpScreen(phoneNumber: phoneNumber),
//             ),
//           );
//         } else {
//           print("Error response: ${response.body}");
//         }
//       } catch (e) {
//         print("❌ Exception: $e");
//       }
//     }
//
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Back Arrow
//               IconButton(
//                 onPressed: () {
//                   Navigator.pop(context);
//                 },
//                 icon:
//                     const Icon(Icons.arrow_back_ios_new, color: Colors.black87),
//               ),
//
//               const SizedBox(height: 20),
//
//               // Title
//               const Center(
//                 child: Text(
//                   "Enter your phone number",
//                   style: TextStyle(
//                     fontSize: 22,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.black87,
//                   ),
//                 ),
//               ),
//
//               const SizedBox(height: 32),
//
//               // Phone input field
//               Container(
//                 padding: const EdgeInsets.symmetric(horizontal: 16),
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(12),
//                   border: Border.all(color: Colors.grey.shade300),
//                 ),
//                 child: Row(
//                   children: [
//                     const Icon(Icons.phone_android, color: Colors.grey),
//                     const SizedBox(width: 8),
//
//                     // Country Code
//                     DropdownButton<String>(
//                       value: '+91',
//                       underline: const SizedBox(),
//                       items: ['+91', '+1', '+44'].map((code) {
//                         return DropdownMenuItem(
//                           value: code,
//                           child: Text(code),
//                         );
//                       }).toList(),
//                       onChanged: (val) {
//                         phoneController.text = val!;
//                         setState(() {});
//                       },
//                     ),
//
//                     const SizedBox(width: 8),
//
//                     // Vertical Divider
//                     Container(
//                       width: 1,
//                       height: 24,
//                       color: Colors.grey.shade300,
//                     ),
//                     const SizedBox(width: 8),
//
//                     // Phone Number Field
//                     Expanded(
//                       child: TextFormField(
//                         controller: phoneController,
//                         keyboardType: TextInputType.phone,
//                         decoration: const InputDecoration(
//                           hintText: '974568 1203',
//                           border: InputBorder.none,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//
//               const SizedBox(height: 12),
//
//               const Text(
//                 "Fliq will send you a text with a verification code.",
//                 style: TextStyle(color: Colors.black54),
//               ),
//
//               const Spacer(),
//
//               // Next Button
//               SizedBox(
//                 width: double.infinity,
//                 height: 48,
//                 child: ElevatedButton(
//                   onPressed: () {
//                     final phone =
//                         '+91${phoneController.text}'; // Replace with controller.text
//                     sendOtp(phone, context);
//                     // Navigate to OTP verification
//                   },
//                   style: ElevatedButton.styleFrom(
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(30),
//                     ),
//                     padding: EdgeInsets.zero,
//                     backgroundColor: Colors.transparent,
//                     elevation: 0,
//                   ),
//                   child: Ink(
//                     decoration: BoxDecoration(
//                       gradient: const LinearGradient(
//                         colors: [Color(0xFFFF5B7F), Color(0xFFFF76A4)],
//                       ),
//                       borderRadius: BorderRadius.circular(30),
//                     ),
//                     child: Container(
//                       alignment: Alignment.center,
//                       child: const Text(
//                         "Next",
//                         style: TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.white,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//
//               const SizedBox(height: 24),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/commons/global_variables/global_variables.dart';
import '../controller/auth_controller.dart';
import 'otp_screen.dart';

class PhoneNumberPage extends ConsumerWidget {
  PhoneNumberPage({Key? key}) : super(key: key);

  final TextEditingController phoneController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(authControllerProvider);
    // final errorMessage = ref.watch(authErrorMessageProvider);

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
                  "Enter your phone number",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: height * 0.032,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(height: 32),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.phone_android, color: Colors.grey),
                    const SizedBox(width: 8),
                    Text(
                      '+91',
                      style: GoogleFonts.poppins(
                          color: Colors.black, fontSize: height * 0.019),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      width: 1,
                      height: 24,
                      color: Colors.grey.shade300,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextFormField(
                        controller: phoneController,
                        keyboardType: TextInputType.phone,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(10),
                        ],
                        decoration: InputDecoration(
                          hintText: '9745681203',
                          hintStyle: GoogleFonts.poppins(
                            color: Colors.grey,
                            fontSize: height * 0.019,
                          ),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Text(
                "Fliq will send you a text with a verification code.",
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: height * 0.014,
                  fontWeight: FontWeight.w400,
                  color: Colors.black54,
                ),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: isLoading
                      ? null
                      : () async {
                          final rawPhone = phoneController.text.trim();

                          if (rawPhone.length != 10 ||
                              !RegExp(r'^\d{10}$').hasMatch(rawPhone)) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text(
                                      "Please enter a valid 10-digit number")),
                            );
                            return;
                          }

                          final phone = '+91$rawPhone';
                          final success = await ref
                              .read(authControllerProvider.notifier)
                              .sendOtp(phone);
                          if (success && context.mounted) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => OtpScreen(phoneNumber: phone),
                              ),
                            );
                          }
                        },
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
                      child: isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                              "Next",
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
