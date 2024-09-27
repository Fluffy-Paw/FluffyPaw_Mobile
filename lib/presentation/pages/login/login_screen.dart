import 'package:fluffypawmobile/dependency_injection/dependency_injection.dart';
import 'package:fluffypawmobile/presentation/pages/home/home.dart';
import 'package:fluffypawmobile/presentation/pages/signup/component/custom_button.dart';
import 'package:fluffypawmobile/presentation/pages/signup/component/custom_input_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/scheduler.dart'; // Import thêm thư viện này để dùng SchedulerBinding

class LogIn extends ConsumerStatefulWidget {
  @override
  _LogInState createState() => _LogInState();
}

class _LogInState extends ConsumerState<LogIn> {
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _rememberMe = false; // Checkbox state

  @override
  Widget build(BuildContext context) {
    final loginViewModel = ref.watch(loginViewModelProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Log In'),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.fromLTRB(24, 17, 24, 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomInputField(
                label: 'Username',
                hintText: "Enter Your Username",
                controller: _userNameController,
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(height: 20),
              CustomInputField(
                label: 'Password',
                hintText: "Enter Your Password",
                controller: _passwordController,
                isPassword: true,
              ),
              SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Checkbox(
                        value: _rememberMe,
                        onChanged: (bool? value) {
                          setState(() {
                            _rememberMe = value!;
                          });
                        },
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Remember me',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w400,
                          fontSize: 12,
                          color: Color(0xFF1B1B1B),
                        ),
                      ),
                    ],
                  ),
                  Text(
                    'Forgot password?',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w400,
                      fontSize: 12,
                      color: Color(0xFF838383),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 40),
              CustomButton(
                text: 'Log In',
                onPressed: () async {
                  if (_userNameController.text.isEmpty || _passwordController.text.isEmpty) {
                    // Hiển thị thông báo lỗi nếu email hoặc mật khẩu bị để trống
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Email và mật khẩu không được để trống',
                          style: TextStyle(fontSize: 16),
                          textAlign: TextAlign.center,
                        ),
                        backgroundColor: Colors.red,
                        duration: const Duration(milliseconds: 1500),
                        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        margin: EdgeInsets.symmetric(horizontal: 24.0),
                      ),
                    );
                  } else {
                    // Gọi login từ ViewModel và xử lý kết quả
                    final result = await ref.read(loginViewModelProvider.notifier).login(
                      _userNameController.text,
                      _passwordController.text,
                      context
                    );

                    // Sử dụng fold để xử lý kết quả Either
                    result.fold(
                          (failure) {
                        // Hiển thị lỗi nếu login thất bại
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Đăng nhập thất bại. Vui lòng thử lại.',
                              style: TextStyle(fontSize: 16),
                              textAlign: TextAlign.center,
                            ),
                            backgroundColor: Colors.red,
                            duration: const Duration(milliseconds: 1500),
                            padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            margin: EdgeInsets.symmetric(horizontal: 24.0),
                          ),
                        );
                      },
                          (apiResponse) {
                        // if (apiResponse.statusCode == 200) {
                        //   // Nếu đăng nhập thành công, điều hướng đến trang Home
                        //   Navigator.pushReplacement(
                        //     context,
                        //     MaterialPageRoute(
                        //       builder: (context) => Home(),
                        //     ),
                        //   );
                        // } else {
                        //   // Hiển thị thông báo lỗi nếu trạng thái không phải 200
                        //   ScaffoldMessenger.of(context).showSnackBar(
                        //     SnackBar(
                        //       content: Text(
                        //         apiResponse.message ?? 'Đăng nhập thất bại.',
                        //         style: TextStyle(fontSize: 16),
                        //         textAlign: TextAlign.center,
                        //       ),
                        //       backgroundColor: Colors.red,
                        //       duration: const Duration(milliseconds: 1500),
                        //       padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
                        //       behavior: SnackBarBehavior.floating,
                        //       shape: RoundedRectangleBorder(
                        //         borderRadius: BorderRadius.circular(12.0),
                        //       ),
                        //       margin: EdgeInsets.symmetric(horizontal: 24.0),
                        //     ),
                        //   );
                        // }
                      },
                    );
                  }
                },
              ),


              SizedBox(height: 28),
              loginViewModel.when(
                data: (message) {
                  if (message != null) {
                    SchedulerBinding.instance.addPostFrameCallback((_) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('$message'),
                          backgroundColor: Colors.green,
                        ),
                      );
                    });
                    // Điều hướng tới trang chính
                    // Navigator.pushReplacementNamed(context, '/home');
                  }
                  return SizedBox(); // Trả về một widget trống nếu token null
                },
                error: (error, stack) {
                  SchedulerBinding.instance.addPostFrameCallback((_) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Đăng nhập thất bại: $error'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  });
                  return SizedBox();
                },
                loading: () => Center(child: CircularProgressIndicator()),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRegisterLink() {
    return Center(
      child: RichText(
        text: TextSpan(
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w400,
            fontSize: 14,
            color: Color(0xFF838383),
          ),
          children: [
            TextSpan(text: "Don't have an account? "),
            TextSpan(
              text: 'Register',
              style: TextStyle(color: Color(0xFFF6C8E1)),
            ),
          ],
        ),
      ),
    );
  }
}
