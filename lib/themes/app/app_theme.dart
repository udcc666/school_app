import 'package:flutter/material.dart';

class AppTheme {

  static BorderRadius buttonRadius = BorderRadius.circular(20);
  static BorderRadius containerRadius = BorderRadius.circular(20);

  static List<BoxShadow> get defaultShadow => [
      BoxShadow(
        color: Colors.black.withValues(alpha: 0.05),
        blurRadius: 10,
        offset: const Offset(0, 4),
      ),
    ];

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: const ColorScheme(
        brightness: Brightness.light,

        primary: Color(0xFF0061A4),
        onPrimary: Colors.white,

        secondary: Color(0xFF006194),
        onSecondary: Colors.white,

        error: Color(0xFFBA1A1A),
        onError: Color(0xFF000000),

        surface: Color(0xFFF8F9FF),
        onSurface: Color(0xFF1C1B1F),
        
        primaryContainer: Color(0xFF0061A4),
        onPrimaryContainer: Color(0xFFFFFFFF),
      ),
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      cardTheme: CardThemeData(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: const ColorScheme(
        brightness: Brightness.dark,

        primary: Color(0xFFFFFFFF),
        onPrimary: Color(0xFF000000),

        secondary: Color(0xFF222222),
        onSecondary: Colors.white,
        
        error: Color(0xFFFF0000),
        onError: Colors.white,
        
        surface: Color(0xFF151515),
        onSurface: Colors.white,

        primaryContainer: Color(0xFF101010),
        onPrimaryContainer: Colors.white,
      ),
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      cardTheme: CardThemeData(
        elevation: 2,
        color: const Color(0xFF272757).withValues(alpha: 0.5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      dividerColor: Colors.white24,
    );
  }
  
  static ThemeData get darkGoogleTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: const ColorScheme(
        brightness: Brightness.dark,

        surface: Color(0xFF1D1E1F), 
        onSurface: Colors.white,

        surfaceContainer: Color(0xFF0E0E0E), 
        onSurfaceVariant: Color(0xFFC4C7C5),

        primary: Color(0xFFA8C7FA),
        onPrimary: Color(0xFF062E6F),
        
        secondary: Color(0xFF7FCFFF),
        onSecondary: Color(0xFF003355),
        error: Color(0xFFF2B8B5),
        onError: Color(0xFF601410),
      ),
      
      scaffoldBackgroundColor: const Color(0xFF1D1E1F),

      dividerTheme: const DividerThemeData(
        thickness: 1,
        space: 1,
        color: Color(0xFF444746),
      ),
      
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 4, // Define a "altura" da sombra
          shadowColor: Colors.black.withValues(alpha: 0.05),
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: buttonRadius,
          ),
        ),
      ),
    );
  }

  static ThemeData get lightGoogleTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: const ColorScheme(
        brightness: Brightness.light,

        surface: Color(0xFFF8F9FA), 
        onSurface: Color(0xFF1F1F1F),

        surfaceContainer: Color(0xFFFFFFFF), 
        onSurfaceVariant: Color(0xFF444746),

        primary: Color(0xFF0B57D0),
        onPrimary: Colors.white,
        
        secondary: Color(0xFF00639B),
        onSecondary: Colors.white,

        error: Color(0xFFB3261E),
        onError: Colors.white,
      ),
      
      scaffoldBackgroundColor: const Color(0xFFF8F9FA),

      dividerTheme: const DividerThemeData(
        thickness: 1,
        space: 1,
        color: Color(0xFFE3E3E3),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 4, // Define a "altura" da sombra
          shadowColor: Colors.black.withValues(alpha: 0.05),
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: buttonRadius,
          ),
        ),
      ),
      
    );
  }
  
  static ThemeData get blueTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: const ColorScheme(
        brightness: Brightness.dark,

        primary: Color(0xFF00009F),
        onPrimary: Colors.white,

        secondary: Color(0xFF8686AC),
        onSecondary: Colors.white,
        
        error: Color(0xFFFF0000),
        onError: Colors.white,
        
        surface: Color(0xFF0F0E47),
        onSurface: Colors.white,

        primaryContainer: Color(0xFF171747),
        onPrimaryContainer: Colors.white,
      ),
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      cardTheme: CardThemeData(
        elevation: 2,
        color: const Color(0xFF272757).withValues(alpha: 0.5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }
}
