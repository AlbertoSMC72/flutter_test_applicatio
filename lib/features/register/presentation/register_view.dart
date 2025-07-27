// features/register/presentation/register_view.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'cubit/register_cubit.dart';
import 'cubit/register_state.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFF1E1E1E),
      body: SafeArea(
        child: BlocListener<RegisterCubit, RegisterState>(
          listener: (context, state) {
            if (state is RegisterSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.green,
                ),
              );
              // Navegar a la pantalla de login después del registro exitoso
              Navigator.pushReplacementNamed(context, '/Login');
            } else if (state is RegisterError) {
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
              // Círculos decorativos (mantienen el diseño original)
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

              // Contenido principal
              SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.08),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: screenHeight * 0.05),

                      // Título "Registro"
                      Center(
                        child: Text(
                          'Registro',
                          style: GoogleFonts.monomaniacOne(
                            fontSize: screenWidth * 0.23,
                            color: const Color(0xFFF2F2F2),
                          ),
                        ),
                      ),

                      SizedBox(height: screenHeight * 0.08),

                      // Campo Usuario
                      _buildTextField(
                        label: 'Usuario',
                        controller: _usernameController,
                        icon: Icons.person_outline,
                        onChanged: (value) => context.read<RegisterCubit>().updateUsername(value),
                        errorField: 'username',
                        screenWidth: screenWidth,
                        screenHeight: screenHeight,
                      ),

                      SizedBox(height: screenHeight * 0.025),

                      // Campo Correo
                      _buildTextField(
                        label: 'Correo',
                        controller: _emailController,
                        icon: Icons.email_outlined,
                        keyboardType: TextInputType.emailAddress,
                        onChanged: (value) => context.read<RegisterCubit>().updateEmail(value),
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
                        onChanged: (value) => context.read<RegisterCubit>().updatePassword(value),
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

                      SizedBox(height: screenHeight * 0.025),

                      // Campo Confirmar Contraseña
                      _buildTextField(
                        label: 'Confirmar contraseña',
                        controller: _confirmPasswordController,
                        icon: Icons.key,
                        obscureText: _obscureConfirmPassword,
                        onChanged: (value) => context.read<RegisterCubit>().updateConfirmPassword(value),
                        errorField: 'confirmPassword',
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureConfirmPassword ? Icons.visibility : Icons.visibility_off,
                            color: Colors.black54,
                          ),
                          onPressed: () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
                        ),
                        screenWidth: screenWidth,
                        screenHeight: screenHeight,
                      ),

                      SizedBox(height: screenHeight * 0.05),

                      // Botón de Registro
                      Center(
                        child: BlocBuilder<RegisterCubit, RegisterState>(
                          builder: (context, state) {
                            final isLoading = state is RegisterLoading;
                            
                            return GestureDetector(
                              onTap: isLoading ? null : () {
                                context.read<RegisterCubit>().registerUser();
                              },
                              child: Container(
                                width: screenWidth * 0.25,
                                height: screenHeight * 0.06,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(25),
                                  color: isLoading 
                                      ? Colors.grey 
                                      : const Color(0xFFFFEB3B),
                                  boxShadow: [
                                    BoxShadow(
                                      offset: const Offset(0, 4),
                                      blurRadius: 8,
                                      color: Colors.black.withOpacity(0.3),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    if (isLoading)
                                      SizedBox(
                                        width: screenWidth * 0.05,
                                        height: screenWidth * 0.05,
                                        child: const CircularProgressIndicator(
                                          strokeWidth: 2,
                                          valueColor: AlwaysStoppedAnimation<Color>(Colors.black87),
                                        ),
                                      )
                                    else
                                      Icon(
                                        Icons.person_add,
                                        color: Colors.black87,
                                        size: screenWidth * 0.05,
                                      ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),

                      SizedBox(height: screenHeight * 0.08),

                      Center(
                        child: GestureDetector(
                          onTap: () => context.push("/login"),
                          child: RichText(
                            text: TextSpan(
                              style: GoogleFonts.monomaniacOne(
                                fontSize: screenWidth * 0.04,
                                color: const Color(0xFFF2F2F2),
                                letterSpacing: 1.0,
                              ),
                              children: [
                                const TextSpan(text: 'Ya tienes cuenta ? '),
                                TextSpan(
                                  text: 'Inicia sesión',
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

                      SizedBox(height: screenHeight * 0.1),
                    ],
                  ),
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
    return BlocBuilder<RegisterCubit, RegisterState>(
      builder: (context, state) {
        String? errorText;
        
        if (state is RegisterValidationError) {
          switch (errorField) {
            case 'username':
              errorText = state.usernameError;
              break;
            case 'email':
              errorText = state.emailError;
              break;
            case 'password':
              errorText = state.passwordError;
              break;
            case 'confirmPassword':
              errorText = state.confirmPasswordError;
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