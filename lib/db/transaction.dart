import 'package:sqflite/sqflite.dart';
import 'package:uuid/v4.dart';

class TransactionModel {
  String uuid = const UuidV4().generate();
  DateTime transactionTime = DateTime.now();
  double amount;
  String details;

  TransactionModel({
    required this.uuid,
    required this.transactionTime,
    required this.amount,
    required this.details,
  });

  TransactionModel.generate({required this.amount, required this.details});

  Map<String, dynamic> toMap() {
    return {
      'uuid': uuid,
      'amount': amount,
      'transaction_time': transactionTime.toString(),
      'details': details,
    };
  }
}

enum TimeRange {
  weekly,
  monthly,
  yearly,
}

Future<List<TransactionModel>> listTransactions({
  required Database db,
  required TimeRange range,
}) async {
  List<Map<String, Object?>> res;
  if (range == TimeRange.monthly) {
    res = await db.query('transactions',
        orderBy: 'transaction_time DESC',
        where: "transaction_time BETWEEN ? AND ?",
        whereArgs: [
          DateTime.parse("${DateTime.now().year}-${DateTime.now().month}-01")
              .toString(),
          DateTime.parse("${DateTime.now().year}-${DateTime.now().month}-32")
              .toString(),
        ]);
  } else if (range == TimeRange.yearly) {
    res = await db.query('transactions',
        orderBy: 'transaction_time DESC',
        where: "transaction_time BETWEEN ? AND ?",
        whereArgs: [
          DateTime.parse("${DateTime.now().year}-01-01").toString(),
          DateTime.parse("${DateTime.now().year}-12-32").toString()
        ]);
  } else {
    var d1 = DateTime.now().subtract(Duration(days: DateTime.now().weekday));
    var d2 = DateTime.now().add(Duration(days: 7 - DateTime.now().weekday));

    res = await db.query('transactions',
        orderBy: 'transaction_time DESC',
        where: "transaction_time BETWEEN ? AND ?",
        whereArgs: [d1.toString(), d2.toString()]);
  }

  return List.generate(
    res.length,
    (i) {
      return TransactionModel(
        uuid: res[i]['uuid'].toString(),
        transactionTime: DateTime.parse(res[i]['transaction_time'].toString()),
        amount: double.parse(res[i]['amount'].toString()),
        details: res[i]['details'].toString(),
      );
    },
  );
}

Future<void> saveTransaction({
  required Database db,
  required TransactionModel t,
}) async {
  await db.insert(
    'transactions',
    t.toMap(),
    conflictAlgorithm: ConflictAlgorithm.fail,
  );
}

Future<void> deleteTransaction({
  required Database db,
  required TransactionModel t,
}) async {
  await db.delete(
    'transactions',
    where: 'uuid = ?',
    whereArgs: [t.uuid.toString()],
  );
}
