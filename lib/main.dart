import 'package:flutter/material.dart';
import 'package:my_money_manager/components/account_balance.dart';
import 'package:my_money_manager/components/new_transaction_button.dart';
import 'package:my_money_manager/components/transactions_list.dart';
import 'package:my_money_manager/db/transaction.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final database =
      await openDatabase(join(await getDatabasesPath(), 'mymoneymanager.db'));

  final db = database;
  await db.execute(
    '''
    CREATE TABLE IF NOT EXISTS transactions (
      uuid CHARACTER(32) PRIMARY KEY,
      transaction_time DATETIME NOT NULL,
      amount DOUBLE NOT NULL,
      details TEXT NOT NULL
    )''',
  );

  runApp(MyApp(db: db));
}

class MyApp extends StatefulWidget {
  final Database db;

  const MyApp({super.key, required this.db});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Future<List<TransactionModel>> _transactions = Future.value([]);
  TimeRange _range = TimeRange.weekly;

  @override
  void initState() {
    super.initState();

    refreshTransactions();
  }

  Future<void> refreshTransactions() async {
    setState(() {
      _transactions = listTransactions(db: widget.db, range: _range);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Money Manager',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(1, 68, 93, 72),
          brightness: Brightness.light,
        ),
        textTheme: const TextTheme(
          titleLarge: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w700,
          ),
          titleMedium: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
          bodyMedium: TextStyle(
            fontSize: 16,
          ),
          bodySmall: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w300,
          ),
        ),
        useMaterial3: true,
      ),
      home: Scaffold(
        floatingActionButton: NewTransactionButton(
          saveNewTransaction: (amount, detail) => saveTransaction(
            db: widget.db,
            t: TransactionModel.generate(amount: amount, details: detail),
          ),
          updateTransactions: () => refreshTransactions(),
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            setState(() {
              refreshTransactions();
            });
          },
          child: GestureDetector(
            onHorizontalDragEnd: (details) {
              if (!details.primaryVelocity!.isNegative) {
                switch (_range) {
                  case TimeRange.yearly:
                    setState(() => _range = TimeRange.monthly);
                    refreshTransactions();
                    break;
                  case TimeRange.monthly:
                    setState(() => _range = TimeRange.weekly);
                    refreshTransactions();
                    break;
                  default:
                    break;
                }
              } else {
                switch (_range) {
                  case TimeRange.weekly:
                    setState(() => _range = TimeRange.monthly);
                    refreshTransactions();
                    break;
                  case TimeRange.monthly:
                    setState(() => _range = TimeRange.yearly);
                    refreshTransactions();
                    break;
                  default:
                    break;
                }
              }
            },
            child: ListView(
              scrollDirection: Axis.vertical,
              padding:
                  const EdgeInsets.symmetric(vertical: 24.0, horizontal: 18.0),
              children: [
                AccountBalance(transactions: _transactions),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: SegmentedButton<TimeRange>(
                    showSelectedIcon: false,
                    segments: const [
                      ButtonSegment(
                        tooltip: "Show this week's transactions",
                        value: TimeRange.weekly,
                        label: Text("WEEKLY"),
                      ),
                      ButtonSegment(
                        tooltip: "Show this month's transactions",
                        value: TimeRange.monthly,
                        label: Text("MONTHLY"),
                      ),
                      ButtonSegment(
                        tooltip: "Show this year's transaction",
                        value: TimeRange.yearly,
                        label: Text("YEARLY"),
                      ),
                    ],
                    selected: <TimeRange>{_range},
                    onSelectionChanged: (val) {
                      setState(() {
                        _range = val.first;
                      });
                      refreshTransactions();
                    },
                  ),
                ),
                TransactionCardsList(
                  transactions: _transactions,
                  onDeleteTransaction: (TransactionModel t) {
                    deleteTransaction(db: widget.db, t: t).then(
                      (value) => refreshTransactions(),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
