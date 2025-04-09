import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:machine_test_flutter/theme/palette.dart';

import '../../../core/commons/global_variables/global_variables.dart';
import '../controller/auth_controller.dart';
import 'otp_screen.dart';

class PhoneNumberPage extends ConsumerWidget {
  PhoneNumberPage({super.key});

  final TextEditingController phoneController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(authControllerProvider);
    // final errorMessage = ref.watch(authErrorMessageProvider);

    return Scaffold(
      backgroundColor: Palette.whiteColor,
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
                          ? CircularProgressIndicator(color: Palette.whiteColor)
                          : const Text(
                              "Next",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Palette.whiteColor,
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
