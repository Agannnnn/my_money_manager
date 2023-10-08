import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NewTransactionButton extends StatefulWidget {
  final Future<void> Function() updateTransactions;
  final Future<void> Function(double amount, String details) saveNewTransaction;

  const NewTransactionButton({
    super.key,
    required this.updateTransactions,
    required this.saveNewTransaction,
  });

  @override
  State<NewTransactionButton> createState() => _NewTransactionButtonState();
}

class _NewTransactionButtonState extends State<NewTransactionButton> {
  double _amount = 0;
  String _details = "";

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      tooltip: 'Save New Transaction',
      onPressed: () {
        showDialog(
            builder: (context) {
              return AlertDialog(
                title: Text(
                  "SAVE NEW TRANSACTION",
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(color: Theme.of(context).colorScheme.primary),
                ),
                content: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                            RegExp(r'^-?([1-9][\d.]*)*'),
                          ),
                        ],
                        onChanged: (value) {
                          if (value.isNotEmpty &&
                              value != '-' &&
                              value != '.') {
                            setState(() => _amount = double.parse(value));
                          }
                        },
                        keyboardType: const TextInputType.numberWithOptions(
                          signed: true,
                          decimal: true,
                        ),
                        autofocus: true,
                        decoration: const InputDecoration(
                          filled: true,
                          labelText: 'Transaction Amount',
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.only(top: 2.0, bottom: 6.0),
                        child: Text(
                          "Add symbol '-' before the amount to save spending transactions",
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall!
                              .copyWith(
                                  color:
                                      Theme.of(context).colorScheme.onSurface),
                        ),
                      ),
                      TextField(
                        onChanged: (value) {
                          if (value.isNotEmpty) {
                            setState(() => _details = value.trim());
                          }
                        },
                        keyboardType: TextInputType.text,
                        decoration: const InputDecoration(
                          filled: true,
                          labelText: 'Transaction Detail',
                        ),
                      ),
                    ],
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      'Cancel',
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .copyWith(color: Theme.of(context).colorScheme.error),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      widget
                          .saveNewTransaction(_amount, _details)
                          .then((value) {
                        setState(() {
                          _amount = 0;
                        });
                        widget
                            .updateTransactions()
                            .then((value) => Navigator.pop(context));
                      });
                    },
                    child: const Text('Ok'),
                  ),
                ],
              );
            },
            context: context);
      },
      child: const Icon(Icons.add_rounded),
    );
  }
}
