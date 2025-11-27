import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import 'reset_password_page.dart';

class VerifyOtpPage extends StatefulWidget {
  final String email;
  final String otp;

  const VerifyOtpPage({super.key, required this.email, required this.otp});

  @override
  State<VerifyOtpPage> createState() => _VerifyOtpPageState();
}

class _VerifyOtpPageState extends State<VerifyOtpPage> {
  final otpController = TextEditingController();

  @override
  void dispose() {
    otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Verifikasi OTP")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Kode OTP telah dikirim ke email:\n${widget.email}",
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 24),

            TextField(
              controller: otpController,
              keyboardType: TextInputType.number,
              maxLength: 6,
              decoration: const InputDecoration(
                labelText: "Kode OTP",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 24),

            Consumer<AuthProvider>(
              builder: (context, authProvider, _) {
                return authProvider.isLoading
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: () async {
                          final otp = otpController.text.trim();

                          if (otp.length != 6) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("OTP harus 6 digit angka"),
                              ),
                            );
                            return;
                          }

                          final error = await authProvider.verifyOtp(
                            widget.email,
                            otp,
                          );

                          if (!context.mounted) return;

                          if (error == null) {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ResetPasswordPage(
                                  email: widget.email,
                                  otp: otp,
                                ),
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(
                              context,
                            ).showSnackBar(SnackBar(content: Text(error)));
                          }
                        },
                        child: const Text("VERIFIKASI OTP"),
                      );
              },
            ),
          ],
        ),
      ),
    );
  }
}
