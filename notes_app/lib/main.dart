import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'data/auth_repository.dart';
import 'firebase_options.dart';
import 'data/note_repository.dart';
import 'bloc/auth_cubit.dart';
import 'bloc/notes_cubit.dart';
import 'presentation/auth_screen.dart';
import 'presentation/notes_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final authRepository = AuthRepository();
    final noteRepository = NoteRepository();
    return BlocProvider<AuthCubit>(
      create: (_) => AuthCubit(authRepository),
      child: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, state) {
          if (state is Authenticated) {
            return BlocProvider<NotesCubit>(
              create: (_) => NotesCubit(noteRepository, state.user.uid),
              child: MaterialApp(
                title: 'Notes App',
                debugShowCheckedModeBanner: false,
                theme: ThemeData(
                  colorScheme: ColorScheme.fromSeed(
                    seedColor: Colors.deepPurple,
                  ),
                  useMaterial3: true,
                  appBarTheme: const AppBarTheme(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.deepPurple,
                    elevation: 2,
                    centerTitle: true,
                    titleTextStyle: TextStyle(
                      color: Colors.deepPurple,
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                      letterSpacing: 1.2,
                    ),
                  ),
                  floatingActionButtonTheme:
                      const FloatingActionButtonThemeData(
                        backgroundColor: Colors.deepPurple,
                        foregroundColor: Colors.white,
                        shape: StadiumBorder(),
                        elevation: 4,
                      ),
                  cardTheme: CardTheme(
                    color: Colors.white,
                    elevation: 4,
                    margin: const EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 8,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  snackBarTheme: const SnackBarThemeData(
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                    ),
                  ),
                  inputDecorationTheme: InputDecorationTheme(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.deepPurple.withOpacity(0.05),
                  ),
                ),
                home: const NotesScreen(),
              ),
            );
          } else if (state is AuthLoading) {
            return const MaterialApp(
              debugShowCheckedModeBanner: false,
              home: Scaffold(body: Center(child: CircularProgressIndicator())),
            );
          } else {
            return MaterialApp(
              title: 'Notes App',
              debugShowCheckedModeBanner: false,
              theme: ThemeData(
                colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
                useMaterial3: true,
                appBarTheme: const AppBarTheme(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.deepPurple,
                  elevation: 2,
                  centerTitle: true,
                  titleTextStyle: TextStyle(
                    color: Colors.deepPurple,
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                    letterSpacing: 1.2,
                  ),
                ),
                floatingActionButtonTheme: const FloatingActionButtonThemeData(
                  backgroundColor: Colors.deepPurple,
                  foregroundColor: Colors.white,
                  shape: StadiumBorder(),
                  elevation: 4,
                ),
                cardTheme: CardTheme(
                  color: Colors.white,
                  elevation: 4,
                  margin: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 8,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                snackBarTheme: const SnackBarThemeData(
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                ),
                inputDecorationTheme: InputDecorationTheme(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.deepPurple.withOpacity(0.05),
                ),
              ),
              home: const AuthScreen(),
            );
          }
        },
      ),
    );
  }
}

// ...existing code...
