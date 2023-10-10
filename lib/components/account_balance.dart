import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import 'package:locale_emoji/locale_emoji.dart' as le;
import 'package:my_money_manager/db/transaction.dart';

class AccountBalance extends StatelessWidget {
  const AccountBalance({
    super.key,
    required Future<List<TransactionModel>> transactions,
    required this.supportedLocales,
    required this.setLocale,
  }) : _transactions = transactions;

  final Future<List<TransactionModel>> _transactions;
  final List<Locale> supportedLocales;
  final Function(Locale locale) setLocale;

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
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: MenuAnchor(
                  builder: (context, controller, child) => IconButton.filled(
                    icon: const Icon(Icons.arrow_downward_rounded),
                    onPressed: () {
                      if (controller.isOpen) {
                        controller.close();
                      } else {
                        controller.open();
                      }
                    },
                  ),
                  menuChildren: List.generate(
                    supportedLocales.length,
                    (index) {
                      return MenuItemButton(
                        child: Text("${le.getFlagEmoji(
                          countryCode: supportedLocales[index].countryCode!,
                        )!} ${intl.NumberFormat.currency(locale: supportedLocales[index].toLanguageTag()).currencyName}"),
                        onPressed: () {
                          setLocale(supportedLocales[index]);
                        },
                      );
                    },
                  ),
                ),
              ),
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
                        intl.NumberFormat.currency(
                          locale:
                              Localizations.localeOf(context).toLanguageTag(),
                        ).format(balance),
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
