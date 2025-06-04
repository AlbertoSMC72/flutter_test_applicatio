// features/login/presentation/login_view.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'cubit/login_cubit.dart';
import 'cubit/login_state.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFF1E1E1E),
      body: SafeArea(
        child: BlocListener<LoginCubit, LoginState>(
          listener: (context, state) {
            if (state is LoginSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.green,
                ),
              );
              // Navegar al home después del login exitoso
              Navigator.pushReplacementNamed(context, '/Home');
            } else if (state is LoginError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          child: Stack(
            children: [
              // Círculo amarillo superior
              Positioned(
                top: -screenHeight * 0.12,
                left: screenWidth * 0.35,
                child: Container(
                  width: screenWidth * 0.5,
                  height: screenWidth * 0.5,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.transparent,
                    border: Border.all(color: const Color(0xFFEDED3D), width: 4),
                  ),
                ),
              ),
              // Círculo morado superior derecha
              Positioned(
                top: -screenHeight * 0.08,
                right: -screenWidth * 0.25,
                child: Container(
                  width: screenWidth * 0.7,
                  height: screenWidth * 0.7,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFF3D175C),
                  ),
                ),
              ),
              // Círculo morado inferior izquierda
              Positioned(
                bottom: -screenHeight * 0.12,
                left: -screenWidth * 0.25,
                child: Container(
                  width: screenWidth * 0.7,
                  height: screenWidth * 0.7,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFF3D175C),
                  ),
                ),
              ),
              // Círculo amarillo inferior
              Positioned(
                bottom: -screenHeight * 0.12,
                right: screenWidth * 0.3,
                child: Container(
                  width: screenWidth * 0.5,
                  height: screenWidth * 0.5,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.transparent,
                    border: Border.all(color: const Color(0xFFEDED3D), width: 4),
                  ),
                ),
              ),

              // Contenido principal sin scroll
              Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.08),
                child: Column(
                  children: [
                    SizedBox(height: screenHeight * 0.12),

                    // Título "Inicio"
                    Text(
                      'Inicio',
                      style: GoogleFonts.monomaniacOne(
                        fontSize: screenWidth * 0.23,
                        color: const Color(0xFFF2F2F2),
                      ),
                    ),

                    SizedBox(height: screenHeight * 0.1),

                    // Contenido del formulario
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Campo Correo
                          _buildTextField(
                            label: 'Correo',
                            controller: _emailController,
                            icon: Icons.email_outlined,
                            keyboardType: TextInputType.emailAddress,
                            onChanged: (value) => context.read<LoginCubit>().updateEmail(value),
                            errorField: 'email',
                            screenWidth: screenWidth,
                            screenHeight: screenHeight,
                          ),

                          SizedBox(height: screenHeight * 0.025),

                          // Campo Contraseña
                          _buildTextField(
                            label: 'Contraseña',
                            controller: _passwordController,
                            icon: Icons.key,
                            obscureText: _obscurePassword,
                            onChanged: (value) => context.read<LoginCubit>().updatePassword(value),
                            errorField: 'password',
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword ? Icons.visibility : Icons.visibility_off,
                                color: Colors.black54,
                              ),
                              onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                            ),
                            screenWidth: screenWidth,
                            screenHeight: screenHeight,
                          ),

                          const Spacer(),

                          // Botón de Inicio de Sesión
                          Center(
                            child: BlocBuilder<LoginCubit, LoginState>(
                              builder: (context, state) {
                                final isLoading = state is LoginLoading;
                                
                                return GestureDetector(
                                  onTap: isLoading ? null : () {
                                    context.read<LoginCubit>().loginUser();
                                  },
                                  child: Container(
                                    width: screenWidth * 0.25,
                                    height: screenHeight * 0.06,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(25),
                                      color: isLoading 
                                          ? Colors.grey 
                                          : const Color(0xFFEDED3D),
                                      boxShadow: [
                                        BoxShadow(
                                          offset: const Offset(0, 4),
                                          blurRadius: 8,
                                          color: Colors.black.withOpacity(0.3),
                                        ),
                                      ],
                                    ),
                                    child: Center(
                                      child: isLoading
                                          ? SizedBox(
                                              width: screenWidth * 0.05,
                                              height: screenWidth * 0.05,
                                              child: const CircularProgressIndicator(
                                                strokeWidth: 2,
                                                valueColor: AlwaysStoppedAnimation<Color>(Colors.black87),
                                              ),
                                            )
                                          : Icon(
                                              Icons.login,
                                              color: Colors.black87,
                                              size: screenWidth * 0.06,
                                            ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),

                          SizedBox(height: screenHeight * 0.04),

                          // Texto para ir a registro
                          Center(
                            child: GestureDetector(
                              onTap: () => Navigator.pushReplacementNamed(context, '/Register'),
                              child: RichText(
                                text: TextSpan(
                                  style: GoogleFonts.monomaniacOne(
                                    fontSize: screenWidth * 0.04,
                                    color: const Color(0xFFF2F2F2),
                                    letterSpacing: 1.0,
                                  ),
                                  children: [
                                    const TextSpan(text: 'No tienes cuenta ? '),
                                    TextSpan(
                                      text: 'Regístrate',
                                      style: TextStyle(
                                        fontSize: screenWidth * 0.04,
                                        color: const Color(0xFFEDED3D),
                                        fontWeight: FontWeight.bold,
                                        decoration: TextDecoration.underline,
                                        decorationColor: const Color(0xFFEDED3D),
                                        letterSpacing: 1.0,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),

                          SizedBox(height: screenHeight * 0.02),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    required Function(String) onChanged,
    required String errorField,
    required double screenWidth,
    required double screenHeight,
    TextInputType? keyboardType,
    bool obscureText = false,
    Widget? suffixIcon,
  }) {
    return BlocBuilder<LoginCubit, LoginState>(
      builder: (context, state) {
        String? errorText;
        
        if (state is LoginValidationError) {
          switch (errorField) {
            case 'email':
              errorText = state.emailError;
              break;
            case 'password':
              errorText = state.passwordError;
              break;
          }
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: GoogleFonts.monomaniacOne(
                fontSize: screenWidth * 0.04,
                color: const Color(0xFFF2F2F2),
                letterSpacing: 1.0,
              ),
            ),
            SizedBox(height: screenHeight * 0.01),
            Container(
              height: screenHeight * 0.06,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                color: const Color(0xFFE0E0E0),
                border: errorText != null 
                    ? Border.all(color: Colors.red, width: 1)
                    : null,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.05,
                      ),
                      child: TextField(
                        controller: controller,
                        keyboardType: keyboardType,
                        obscureText: obscureText,
                        onChanged: onChanged,
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: screenWidth * 0.04,
                        ),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: '',
                        ),
                      ),
                    ),
                  ),
                  if (suffixIcon != null)
                    suffixIcon
                  else
                    Padding(
                      padding: EdgeInsets.only(right: screenWidth * 0.04),
                      child: Icon(
                        icon,
                        color: Colors.black54,
                        size: screenWidth * 0.06,
                      ),
                    ),
                ],
              ),
            ),
            if (errorText != null)
              Padding(
                padding: EdgeInsets.only(
                  top: screenHeight * 0.005,
                  left: screenWidth * 0.05,
                ),
                child: Text(
                  errorText,
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: screenWidth * 0.03,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}