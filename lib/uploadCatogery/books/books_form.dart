import 'package:flutter/material.dart';
import '../../components/button_special.dart';
import '../generalForm/gen_form.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart'; // Import the generated localization file

class BooksFrom extends StatelessWidget {
  const BooksFrom({super.key});

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(localization.booksAddPost),
      ),
      body: Column(
        children: [
          ButtonSpecial(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => GenForm(
                    whichType: localization.books,
                    docName: 'BookS',
                  ),
                ),
              );
            },
            text: localization.books,
          ),
          ButtonSpecial(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => GenForm(
                    whichType: localization.stationery,
                    docName: 'BookS',
                  ),
                ),
              );
            },
            text: localization.stationery,
          ),
          ButtonSpecial(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => GenForm(
                    whichType: localization.other,
                    docName: 'BookS',
                  ),
                ),
              );
            },
            text: localization.other,
          ),
        ],
      ),
    );
  }
}
