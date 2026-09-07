import 'package:flutter/material.dart';
import 'models/user_profile.dart';
import 'services/storage_service.dart';
import 'screens/onboarding_screen.dart';
import 'screens/home_screen.dart';
import 'screens/subject_list_screen.dart';
import 'screens/mock_exam_screen.dart';
import 'screens/flashcard_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/lab_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const NexusStudyApp());
}

class NexusStudyApp extends StatelessWidget {
  const NexusStudyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NEXUS Study',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF090D16),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF38BDF8),
          secondary: Color(0xFF6366F1),
          surface: Color(0xFF131B2E),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF0F172A),
          foregroundColor: Colors.white,
          elevation: 0,
        ),
      ),
      home: const MainNavigationShell(),
    );
  }
}

class MainNavigationShell extends StatefulWidget {
  const MainNavigationShell({super.key});

  @override
  State<MainNavigationShell> createState() => _MainNavigationShellState();
}

class _MainNavigationShellState extends State<MainNavigationShell> {
  UserProfile? _profile;
  bool _isLoading = true;
  int _currentTab = 0;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  void _loadProfile() async {
    final p = await StorageService().loadProfile();
    setState(() {
      _profile = p;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: Color(0xFF090D16),
        body: Center(
          child: CircularProgressIndicator(color: Color(0xFF38BDF8)),
        ),
      );
    }

    // If onboarding is not completed, show OnboardingScreen
    if (_profile == null || !_profile!.hasCompletedOnboarding) {
      return OnboardingScreen(
        onCompleted: (newProfile) {
          setState(() {
            _profile = newProfile;
          });
        },
      );
    }

    final screens = [
      HomeScreen(
        profile: _profile!,
        onProfileTap: () => setState(() => _currentTab = 5),
        onLabTap: () => setState(() => _currentTab = 2),
      ),
      const SubjectListScreen(),
      const LabScreen(),
      const MockExamScreen(),
      const FlashcardScreen(),
      ProfileScreen(
        profile: _profile!,
        onProfileUpdated: (updated) {
          setState(() {
            _profile = updated;
          });
        },
        onResetRequested: () {
          setState(() {
            _profile = UserProfile.defaultProfile();
            _currentTab = 0;
          });
        },
      ),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF090D16),
      body: IndexedStack(
        index: _currentTab,
        children: screens,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentTab,
        onDestinationSelected: (idx) {
          setState(() => _currentTab = idx);
        },
        backgroundColor: const Color(0xFF0F172A),
        indicatorColor: const Color(0xFF38BDF8).withValues(alpha: 0.25),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home, color: Color(0xFF38BDF8)),
            label: 'ホーム',
          ),
          NavigationDestination(
            icon: Icon(Icons.menu_book_outlined),
            selectedIcon: Icon(Icons.menu_book, color: Color(0xFF38BDF8)),
            label: '全教科演習',
          ),
          NavigationDestination(
            icon: Icon(Icons.biotech_outlined),
            selectedIcon: Icon(Icons.biotech, color: Color(0xFF38BDF8)),
            label: '実験室',
          ),
          NavigationDestination(
            icon: Icon(Icons.timer_outlined),
            selectedIcon: Icon(Icons.timer, color: Color(0xFF38BDF8)),
            label: '模試',
          ),
          NavigationDestination(
            icon: Icon(Icons.style_outlined),
            selectedIcon: Icon(Icons.style, color: Color(0xFF38BDF8)),
            label: '暗記カード',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person, color: Color(0xFF38BDF8)),
            label: 'マイページ',
          ),
        ],
      ),
    );
  }
}
