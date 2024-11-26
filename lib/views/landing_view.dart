import 'package:chat_app/constants/app_colors.dart';
import 'package:chat_app/constants/app_text_styles.dart';
import 'package:chat_app/views/login_view.dart';
import 'package:chat_app/views/register_view.dart';
import 'package:chat_app/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:typewritertext/typewritertext.dart';


class LandingView extends StatefulWidget {
  const LandingView({ super.key });

  @override
  _LandingViewState createState() => _LandingViewState();
}

class _LandingViewState extends State<LandingView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Hero(
                  tag: 'flash',
                  child: SvgPicture.asset(
                    'assets/svg/flash.svg',
                    color: AppColors.amber,
                    height: 46,
                  ),
                ),
                SizedBox(
                  width: 200,
                  child: TypeWriter.text(
                    'Flash chat',
                    duration: const Duration(milliseconds: 50),
                    style: AppTextStyles.font40,
                    maxLines: 1,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            CustomButton(
              title: 'Sign in',
              color: AppColors.orange,
              textColor: AppColors.black,
              splashColor: AppColors.amberAccent,
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return const LoginView();
                }));
              },
            ),
            const SizedBox(height: 24),
            CustomButton(
              title: 'Register',
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return const RegisterView();
                }));
              },
            ),
          ],
        ),
      ),
    );
  }
}