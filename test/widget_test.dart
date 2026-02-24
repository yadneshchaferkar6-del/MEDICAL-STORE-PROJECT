import 'package:flutter_test/flutter_test.dart';
import 'package:medical_store_app/main.dart';

void main() {
  testWidgets('renders app title', (WidgetTester tester) async {
    await tester.pumpWidget(const MediQuickApp());

    expect(find.text('MediQuick Store'), findsOneWidget);
    expect(find.text('Popular Products'), findsOneWidget);
  });
}
