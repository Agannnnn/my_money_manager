import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:my_money_manager/components/account_balance.dart';
import 'package:my_money_manager/db/transaction.dart';

void main() {
  testWidgets('Widget displays all widgets', (tester) async {
    await tester.pumpWidget(AccountBalance(transactions: Future.value([])));

    final titleFinder = find.text('Balance');
    final balanceFinder = find.text(NumberFormat.currency().format(0));
    final iconFinder = find.byIcon(Icons.account_balance_wallet_rounded);

    expect(titleFinder, findsOneWidget);
    expect(balanceFinder, findsOneWidget);
    expect(iconFinder, findsOneWidget);
  });
  testWidgets('Widget displays the correct amount of balance', (tester) async {
    final transactions = [
      TransactionModel.generate(amount: 100000, details: ''),
      TransactionModel.generate(amount: -2000, details: ''),
      TransactionModel.generate(amount: -15000, details: ''),
    ];
    double balance = 0;
    for (var t in transactions) {
      balance += t.amount;
    }

    await tester.pumpWidget(AccountBalance(
      transactions: Future.value(transactions),
    ));
    await tester.pumpAndSettle();

    final balanceFinder = find.text(NumberFormat.currency().format(balance));

    expect(balanceFinder, findsOneWidget);
  });
}
