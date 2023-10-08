import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import 'package:my_money_manager/db/transaction.dart';

class AccountBalance extends StatelessWidget {
  const AccountBalance({
    super.key,
    required Future<List<TransactionModel>> transactions,
  }) : _transactions = transactions;

  final Future<List<TransactionModel>> _transactions;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 14.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        textDirection: TextDirection.ltr,
        children: [
          Column(
            textDirection: TextDirection.ltr,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Balance',
                textDirection: TextDirection.ltr,
              ),
              FutureBuilder(
                future: _transactions,
                builder: (
                  context,
                  AsyncSnapshot<List<TransactionModel>> snapshot,
                ) {
                  double balance = 0;
                  if (snapshot.hasData) {
                    for (var e in snapshot.data!) {
                      balance += e.amount;
                    }
                  }
                  return Text(
                    intl.NumberFormat.currency(locale: Platform.localeName)
                        .format(balance),
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge!
                        .copyWith(color: Colors.green),
                    textDirection: TextDirection.ltr,
                  );
                },
              ),
            ],
          ),
          const Icon(
            Icons.account_balance_wallet_rounded,
            size: 30.0,
            textDirection: TextDirection.ltr,
          ),
        ],
      ),
    );
  }
}
