import 'package:flutter_test/flutter_test.dart';
import 'package:xi_game/main.dart';

void main() {
  testWidgets('App starts correctly', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const XIGame());

    // Verify that the app starts (will show intro first)
    expect(find.text('XI'), findsWidgets);
  });
}
