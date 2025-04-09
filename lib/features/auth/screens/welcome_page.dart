import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:machine_test_flutter/core/commons/constants/image_constants.dart';
import 'package:machine_test_flutter/core/commons/global_variables/global_variables.dart';
import 'package:machine_test_flutter/features/auth/screens/signin_with_phone.dart';
import 'package:machine_test_flutter/theme/palette.dart';

class DatingWelcomePage extends StatelessWidget {
  const DatingWelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            Constants.welcomePicture,
            fit: BoxFit.cover,
          ),
          Container(
            color: Colors.black12.withOpacity(0.3),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: height * 0.12,
                ),
                SvgPicture.asset(
                  Constants.appLogo,
                  height: height * 0.065,
                ),
                SizedBox(height: height * 0.02),
                Text(
                  "Connect. Meet. Love.\nWith Fliq Dating",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: height * 0.036,
                    fontWeight: FontWeight.bold,
                    color: Palette.whiteColor,
                    height: 1.4,
                  ),
                ),
                Spacer(),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Palette.whiteColor,
                      foregroundColor: Palette.whiteColor,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    onPressed: () {},
                    icon: Image.asset(
                      Constants.googleLogo,
                      fit: BoxFit.fill,
                      height: height * 0.025,
                    ),
                    label: Text(
                      "Sign in with Google",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: height * 0.015,
                        fontWeight: FontWeight.w400,
                        color: Palette.blackColor,
                        height: 1.4,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: height * 0.02),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF1877F2),
                      foregroundColor: Palette.whiteColor,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    onPressed: () {},
                    icon: Image.asset(
                      Constants.facebookLogo,
                      fit: BoxFit.fill,
                      height: height * 0.025,
                    ),
                    label: Text(
                      "Sign in with Facebook",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: height * 0.015,
                        fontWeight: FontWeight.w400,
                        color: Palette.whiteColor,
                        height: 1.4,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: height * 0.02),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.pinkAccent,
                      foregroundColor: Palette.whiteColor,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PhoneNumberPage()));
                    },
                    icon: Image.asset(
                      Constants.phone,
                      fit: BoxFit.fill,
                      height: height * 0.025,
                    ),
                    label: Text(
                      "Sign in with phone number",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: height * 0.015,
                        fontWeight: FontWeight.w400,
                        color: Palette.whiteColor,
                        height: 1.4,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: height * 0.03),
                Text.rich(
                  TextSpan(
                    text: 'By signing up, you agree to our ',
                    style: GoogleFonts.poppins(
                        color: Colors.white70, fontSize: 12),
                    children: [
                      TextSpan(
                        text: 'Terms',
                        style: TextStyle(
                          decoration: TextDecoration.underline,
                          color: Palette.whiteColor,
                        ),
                      ),
                      TextSpan(text: '. See how we use your data in our '),
                      TextSpan(
                        text: 'Privacy Policy.',
                        style: TextStyle(
                          decoration: TextDecoration.underline,
                          color: Palette.whiteColor,
                        ),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: height * 0.03,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
