import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:space_atlas/main.dart';
import 'package:space_atlas/models/filters.dart';
import 'package:space_atlas/models/launch.dart';
import 'package:space_atlas/screens/landing_screen.dart';
import 'package:space_atlas/screens/launch_list_screen.dart';
import 'package:space_atlas/screens/filter_screen.dart';
import 'package:space_atlas/widgets/blue_gradient_button.dart';

// Mock LaunchProvider for testing
class MockLaunchProvider with ChangeNotifier {
  List<Launch> _mockLaunches = [];
  Set<String> _mockLikedLaunchIds = {};
  bool isLoading = false;

  // Public getter for launches
  List<Launch> get launches => _mockLaunches;

  // Check if a launch is liked
  bool isLiked(String launchId) => _mockLikedLaunchIds.contains(launchId);

  // Mock fetchLaunches method
  Future<void> fetchLaunches({bool reset = false}) async {
    isLoading = true;
    notifyListeners();
    // Simulate API call delay
    await Future.delayed(Duration(milliseconds: 100));
    _mockLaunches = [
      Launch(
        id: '1',
        name: 'Test Launch 1',
        net: DateTime.now().add(Duration(days: 1)).toIso8601String(),
        agencyName: 'Test Agency',
        missionDescription: 'Test mission description',
      ),
      Launch(
        id: '2',
        name: 'Test Launch 2',
        net: DateTime.now().add(Duration(days: 2)).toIso8601String(),
        agencyName: 'Another Agency',
      ),
    ];
    isLoading = false;
    notifyListeners();
  }

  // Mock toggleLike method
  void toggleLike(String launchId) {
    if (_mockLikedLaunchIds.contains(launchId)) {
      _mockLikedLaunchIds.remove(launchId);
    } else {
      _mockLikedLaunchIds.add(launchId);
    }
    notifyListeners();
  }

  // Mock currentFilters getter (adjust as per your Filters class)
  Filters get currentFilters => Filters(agency: null, showOnlyLiked: false);

  // Mock setFilters method (implement if needed in tests)
  void setFilters(Filters filters) {
    // No-op for now; add logic if required
    notifyListeners();
  }

  // Mock agencies getter
  List<String> get agencies =>
      _mockLaunches.map((launch) => launch.agencyName).toSet().toList();
}

void main() {
  group('SpaceAtlas Widget Tests', () {
    // Test LandingScreen
    testWidgets('LandingScreen displays title and Get Started button', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: LandingScreen(),
          routes: {'/launch_list': (context) => LaunchListScreen()},
        ),
      );

      expect(find.text('Space Launch Atlas'), findsOneWidget);
      expect(find.text('By SantoshNtrjn'), findsOneWidget);
      expect(find.text('Get Started'), findsOneWidget);

      // Tap Get Started button and check navigation
      await tester.tap(find.text('Get Started'));
      await tester.pumpAndSettle();
      expect(find.byType(LaunchListScreen), findsOneWidget);
    });

    // Test LaunchListScreen
    testWidgets('LaunchListScreen displays launches and filter button', (
      WidgetTester tester,
    ) async {
      final mockProvider = MockLaunchProvider();
      await mockProvider.fetchLaunches(); // Preload mock data

      await tester.pumpWidget(
        ChangeNotifierProvider<MockLaunchProvider>.value(
          value: mockProvider,
          child: MaterialApp(
            home: LaunchListScreen(),
            routes: {'/filter': (context) => FilterScreen()},
          ),
        ),
      );

      // Wait for rendering
      await tester.pump(Duration.zero);

      expect(find.text('SpaceAtlas'), findsOneWidget);
      expect(find.text('Filter'), findsOneWidget);
      expect(find.text('Refresh'), findsOneWidget);
      expect(find.text('Test Launch 1'), findsOneWidget);
      expect(find.text('Test Launch 2'), findsOneWidget);
      expect(find.text('Load More'), findsOneWidget);

      // Test liking a launch
      expect(find.byIcon(Icons.favorite), findsNothing); // Initially no likes
      expect(
        find.byIcon(Icons.favorite_border),
        findsNWidgets(2),
      ); // Both unliked
      await tester.tap(find.byIcon(Icons.favorite_border).first);
      await tester.pump();
      expect(find.byIcon(Icons.favorite), findsOneWidget); // First launch liked
      expect(
        find.byIcon(Icons.favorite_border),
        findsOneWidget,
      ); // Second still unliked
    });

    // Test FilterScreen
    testWidgets('FilterScreen displays agencies and Refine button', (
      WidgetTester tester,
    ) async {
      final mockProvider = MockLaunchProvider();
      await mockProvider.fetchLaunches(); // Preload mock data

      await tester.pumpWidget(
        ChangeNotifierProvider<MockLaunchProvider>.value(
          value: mockProvider,
          child: MaterialApp(home: FilterScreen()),
        ),
      );

      expect(find.text('Filter Launches'), findsOneWidget);
      expect(find.text('Select Agency'), findsOneWidget);
      expect(find.text('Test Agency'), findsOneWidget);
      expect(find.text('Another Agency'), findsOneWidget);
      expect(find.text('Show Only Liked Launches'), findsOneWidget);
      expect(find.text('Refine'), findsOneWidget);

      // Test agency selection
      await tester.tap(find.text('Test Agency'));
      await tester.pump();
      expect(find.byIcon(Icons.check), findsOneWidget);

      // Test Refine button
      await tester.tap(find.text('Refine'));
      await tester.pumpAndSettle();
      expect(find.byType(FilterScreen), findsNothing); // Should pop back
    });

    // Test BlueGradientButton
    testWidgets('BlueGradientButton renders with correct text', (
      WidgetTester tester,
    ) async {
      bool pressed = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BlueGradientButton(
              onPressed: () => pressed = true,
              text: 'Test Button',
            ),
          ),
        ),
      );

      expect(find.text('Test Button'), findsOneWidget);
      await tester.tap(find.text('Test Button'));
      expect(pressed, isTrue);
    });
  });
}
