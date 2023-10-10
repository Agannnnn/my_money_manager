import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_money_manager/db/transaction.dart';

class TransactionCard extends StatelessWidget {
  final TransactionModel transaction;
  final Function(TransactionModel) onDeleteTransaction;

  const TransactionCard({
    super.key,
    required this.transaction,
    required this.onDeleteTransaction,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 14.0),
      margin: const EdgeInsets.only(top: 8.0),
      decoration: BoxDecoration(
        color: transaction.amount.isNegative
            ? Theme.of(context).colorScheme.errorContainer
            : Theme.of(context).colorScheme.secondaryContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                DateFormat().format(transaction.transactionTime),
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: Theme.of(context).colorScheme.onSecondaryContainer),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5.0),
                child: Text(
                  NumberFormat.currency(
                    locale: Localizations.localeOf(context).toLanguageTag(),
                  ).format(
                    transaction.amount,
                  ),
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        color: transaction.amount.isNegative
                            ? Theme.of(context).colorScheme.error
                            : Colors.green,
                      ),
                ),
              ),
              Text(transaction.details),
            ],
          ),
          IconButton.filledTonal(
            tooltip: "Remove this transaction record",
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(
                Theme.of(context).colorScheme.error,
              ),
            ),
            color: Theme.of(context).colorScheme.onError,
            onPressed: () {
              onDeleteTransaction(transaction);
            },
            icon: const Icon(Icons.delete_rounded),
          ),
        ],
      ),
    );
  }
}
