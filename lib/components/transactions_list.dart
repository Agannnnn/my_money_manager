import 'package:flutter/material.dart';
import 'package:my_money_manager/components/transaction_card.dart';
import 'package:my_money_manager/db/transaction.dart';

class TransactionCardsList extends StatelessWidget {
  final Function(TransactionModel) onDeleteTransaction;
  final Future<List<TransactionModel>> _transactions;

  const TransactionCardsList({
    super.key,
    required Future<List<TransactionModel>> transactions,
    required this.onDeleteTransaction,
  }) : _transactions = transactions;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _transactions,
      builder: (
        context,
        AsyncSnapshot<List<TransactionModel>> snapshot,
      ) {
        List<Widget> elements;

        if (snapshot.hasData && snapshot.data!.isNotEmpty) {
          elements = List.generate(
            snapshot.data!.length,
            (index) => TransactionCard(
              transaction: snapshot.data![index],
              onDeleteTransaction: (TransactionModel t) =>
                  onDeleteTransaction(t),
            ),
          );
        } else {
          elements = [
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 14.0),
              margin: const EdgeInsets.only(top: 8.0),
              decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.errorContainer,
                  borderRadius: BorderRadius.circular(8.0)),
              child: Center(
                child: Text(
                  'No Transaction Record Found',
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(color: Theme.of(context).colorScheme.error),
                ),
              ),
            )
          ];
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: elements,
        );
      },
    );
  }
}
