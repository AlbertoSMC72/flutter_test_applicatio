import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'cubit/login_cubit.dart';
import 'cubit/login_state.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _hasInternetConnection = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    // Solicitar permisos de notificaciones al iniciar
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<LoginCubit>().requestNotificationPermissions();
      _checkConnectivity();
    });
  }

  Future<void> _checkConnectivity() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    setState(() {
      _hasInternetConnection = !connectivityResult.contains(ConnectivityResult.none);
    });
    
    // Escuchar cambios en la conectividad
    Connectivity().onConnectivityChanged.listen((List<ConnectivityResult> results) {
      if (mounted) {
        setState(() {
          _hasInternetConnection = !results.contains(ConnectivityResult.none) && results.isNotEmpty;
        });
      }
    });
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
              // Mostrar mensaje de éxito
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.green,
                ),
              );

              // Mostrar información sobre notificaciones si está disponible
              if (state.user.firebaseTokenSaved != null &&
                  state.user.notificationMessage != null) {
                Future.delayed(const Duration(seconds: 1), () {
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(state.user.notificationMessage!),
                        backgroundColor:
                            state.user.firebaseTokenSaved!
                                ? Colors.blue
                                : Colors.orange,
                        duration: const Duration(seconds: 3),
                      ),
                    );
                  }
                });
              }

              // Navegar al home después del login exitoso
              context.push('/home');
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
              // Círculos decorativos (mantener igual)
              Positioned(
                top: -screenHeight * 0.12,
                left: screenWidth * 0.35,
                child: Container(
                  width: screenWidth * 0.5,
                  height: screenWidth * 0.5,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.transparent,
                    border: Border.all(
                      color: const Color(0xFFEDED3D),
                      width: 4,
                    ),
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
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFF3D175C),
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
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFF3D175C),
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
                    border: Border.all(
                      color: const Color(0xFFEDED3D),
                      width: 4,
                    ),
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
                      SizedBox(height: screenHeight * 0.12),

                      // Título "Inicio"
                      Center(
                        child: Text(
                          'Inicio',
                          style: GoogleFonts.monomaniacOne(
                            fontSize: screenWidth * 0.23,
                            color: const Color(0xFFF2F2F2),
                          ),
                        ),
                      ),

                      // Indicador de conectividad
                      Center(
                        child: Container(
                          margin: EdgeInsets.only(top: screenHeight * 0.02),
                          padding: EdgeInsets.symmetric(
                            horizontal: screenWidth * 0.03,
                            vertical: screenHeight * 0.01,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: _hasInternetConnection 
                              ? Colors.green.withOpacity(0.2)
                              : Colors.red.withOpacity(0.2),
                            border: Border.all(
                              color: _hasInternetConnection 
                                ? Colors.green
                                : Colors.red,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                _hasInternetConnection 
                                  ? Icons.wifi 
                                  : Icons.wifi_off,
                                color: _hasInternetConnection 
                                  ? Colors.green
                                  : Colors.red,
                                size: screenWidth * 0.04,
                              ),
                              SizedBox(width: screenWidth * 0.02),
                              Text(
                                _hasInternetConnection 
                                  ? 'Conectado'
                                  : 'Sin conexión',
                                style: GoogleFonts.monomaniacOne(
                                  fontSize: screenWidth * 0.035,
                                  color: _hasInternetConnection 
                                    ? Colors.green
                                    : Colors.red,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      SizedBox(height: screenHeight * 0.08),

                      // Label Correo
                      Text(
                        'Correo',
                        style: GoogleFonts.monomaniacOne(
                          fontSize: screenWidth * 0.045,
                          color: const Color(0xFFF2F2F2),
                          letterSpacing: 1.0,
                        ),
                      ),

                      SizedBox(height: screenHeight * 0.01),

                      // Campo de correo
                      Container(
                        height: screenHeight * 0.065,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF2F2F2),
                          borderRadius: BorderRadius.circular(25),
                          boxShadow: [
                            BoxShadow(
                              offset: const Offset(0, 4),
                              blurRadius: 8,
                              color: Colors.black.withOpacity(0.3),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: screenWidth * 0.04,
                                ),
                                child: TextField(
                                  controller: _emailController,
                                  enabled: _hasInternetConnection,
                                  onChanged:
                                      (value) => context
                                          .read<LoginCubit>()
                                          .updateEmail(value),
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
                            Padding(
                              padding: EdgeInsets.only(
                                right: screenWidth * 0.04,
                              ),
                              child: Icon(
                                Icons.email,
                                color: _hasInternetConnection 
                                  ? Colors.black54
                                  : Colors.grey,
                                size: screenWidth * 0.06,
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: screenHeight * 0.03),

                      // Label Contraseña
                      Text(
                        'Contraseña',
                        style: GoogleFonts.monomaniacOne(
                          fontSize: screenWidth * 0.045,
                          color: const Color(0xFFF2F2F2),
                          letterSpacing: 1.0,
                        ),
                      ),

                      SizedBox(height: screenHeight * 0.01),

                      // Campo de contraseña
                      Container(
                        height: screenHeight * 0.065,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF2F2F2),
                          borderRadius: BorderRadius.circular(25),
                          boxShadow: [
                            BoxShadow(
                              offset: const Offset(0, 4),
                              blurRadius: 8,
                              color: Colors.black.withOpacity(0.3),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: screenWidth * 0.04,
                                ),
                                child: TextField(
                                  controller: _passwordController,
                                  obscureText: true,
                                  enabled: _hasInternetConnection,
                                  onChanged:
                                      (value) => context
                                          .read<LoginCubit>()
                                          .updatePassword(value),
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
                            Padding(
                              padding: EdgeInsets.only(
                                right: screenWidth * 0.04,
                              ),
                              child: Icon(
                                Icons.key,
                                color: _hasInternetConnection 
                                  ? Colors.black54
                                  : Colors.grey,
                                size: screenWidth * 0.06,
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: screenHeight * 0.05),

                      // Botones de acción
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          // Botón de Inicio de Sesión
                          BlocBuilder<LoginCubit, LoginState>(
                            builder: (context, state) {
                              final isLoading = state is LoginLoading;

                              return GestureDetector(
                                onTap: (_hasInternetConnection && !isLoading)
                                    ? () {
                                        context.read<LoginCubit>().loginUser();
                                      }
                                    : null,
                                child: Container(
                                  width: screenWidth * 0.25,
                                  height: screenHeight * 0.06,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(25),
                                    color: (_hasInternetConnection && !isLoading)
                                        ? const Color(0xFFEDED3D) // Amarillo
                                        : Colors.grey,
                                    boxShadow: [
                                      BoxShadow(
                                        offset: const Offset(0, 4),
                                        blurRadius: 8,
                                        color: Colors.black.withOpacity(0.3),
                                      ),
                                    ],
                                  ),
                                  child: Center(
                                    child: (_hasInternetConnection && isLoading)
                                        ? SizedBox(
                                            width: screenWidth * 0.05,
                                            height: screenWidth * 0.05,
                                            child: const CircularProgressIndicator(
                                              strokeWidth: 2,
                                              valueColor:
                                                  AlwaysStoppedAnimation<Color>(
                                                      Colors.black87),
                                            ),
                                          )
                                        : Icon(
                                            Icons.login,
                                            color: (_hasInternetConnection && !isLoading)
                                                ? Colors.black87
                                                : Colors.white54,
                                            size: screenWidth * 0.06,
                                          ),
                                  ),
                                ),
                              );
                            },
                          ),

                          // Botón para libros descargados (solo visible sin internet)
                          if (!_hasInternetConnection)
                            GestureDetector(
                              onTap: () {
                                context.push('/downloaded');
                              },
                              child: Container(
                                width: screenWidth * 0.35,
                                height: screenHeight * 0.06,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(25),
                                  color: const Color(0xFF3D175C), // Morado
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
                                    Icon(
                                      Icons.download,
                                      color: const Color(0xFFF2F2F2),
                                      size: screenWidth * 0.05,
                                    ),
                                    SizedBox(width: screenWidth * 0.02),
                                    Text(
                                      'Libros\nOffline',
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.monomaniacOne(
                                        fontSize: screenWidth * 0.03,
                                        color: const Color(0xFFF2F2F2),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                        ],
                      ),

                      SizedBox(height: screenHeight * 0.04),

                      // Texto para ir a registro (solo visible con internet)
                      if (_hasInternetConnection)
                        Center(
                          child: GestureDetector(
                            onTap: () => context.push('/register'),
                            child: RichText(
                              text: TextSpan(
                                style: GoogleFonts.monomaniacOne(
                                  fontSize: screenWidth * 0.04,
                                  color: const Color(0xFFF2F2F2),
                                  letterSpacing: 1.0,
                                ),
                                children: [
                                  const TextSpan(text: 'No tienes cuenta? '),
                                  TextSpan(
                                    text: 'Regístrate aquí',
                                    style: GoogleFonts.monomaniacOne(
                                      fontSize: screenWidth * 0.04,
                                      color: const Color(0xFFEDED3D),
                                      letterSpacing: 1.0,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                      // Mensaje informativo cuando no hay internet
                      if (!_hasInternetConnection)
                        Container(
                          margin: EdgeInsets.only(top: screenHeight * 0.03),
                          padding: EdgeInsets.all(screenWidth * 0.04),
                          decoration: BoxDecoration(
                            color: Colors.orange.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(color: Colors.orange),
                          ),
                          child: Column(
                            children: [
                              Icon(
                                Icons.info_outline,
                                color: Colors.orange,
                                size: screenWidth * 0.06,
                              ),
                              SizedBox(height: screenHeight * 0.01),
                              Text(
                                'Sin conexión a internet\n\nPuedes acceder a tus libros descargados presionando el botón "Libros Offline"',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.monomaniacOne(
                                  fontSize: screenWidth * 0.035,
                                  color: Colors.orange,
                                ),
                              ),
                            ],
                          ),
                        ),

                      SizedBox(height: screenHeight * 0.05),
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
}