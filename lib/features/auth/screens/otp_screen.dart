import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:machine_test_flutter/theme/palette.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../../core/commons/global_variables/global_variables.dart';
import '../../chat/screens/chat_list_screen.dart';
import '../controller/auth_controller.dart';

class OtpScreen extends ConsumerStatefulWidget {
  final String phoneNumber;
  const OtpScreen({super.key, required this.phoneNumber});

  @override
  ConsumerState<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends ConsumerState<OtpScreen> {
  final TextEditingController otpController = TextEditingController();
  void handleVerify(BuildContext context) async {
    final controller = ref.read(authControllerProvider.notifier);

    final navigator = Navigator.of(context);
    final messenger = ScaffoldMessenger.of(context);

    final success = await controller.verifyOtp(
      widget.phoneNumber,
      otpController.text.trim(),
    );

    if (!context.mounted) return;

    if (success) {
      navigator.pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => ChatUsersList()),
        (_) => false,
      );
    } else {
      messenger.showSnackBar(
        const SnackBar(content: Text("Invalid OTP")),
      );
    }
  }

  @override
  void dispose() {
    otpController.dispose();
    // TODO: implement dispose
    super.dispose();
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
                    color: Palette.blackColor,
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
                        color: Palette.blackColor,
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
                  activeColor: Palette.blackColor,
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
                  color: Palette.blueColor,
                ),
              ),
              Spacer(),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () {
                    handleVerify(context);
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
