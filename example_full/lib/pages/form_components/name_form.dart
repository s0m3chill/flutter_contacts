import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/properties/name.dart';
import 'package:translator/translator.dart';

enum Language { en, uk }

class NameForm extends StatefulWidget {
  final Name name;
  final void Function(Name) onUpdate;

  NameForm(
    this.name, {
    @required this.onUpdate,
    Key key,
  }) : super(key: key);

  @override
  _NameFormState createState() => _NameFormState();
}

class _NameFormState extends State<NameForm> {
  final _formKey = GlobalKey<FormState>();
  final _translator = GoogleTranslator();
  List<TextEditingController> _translationControllers;
  final _regEx = RegExp(r'[^\w\s]+');

  TextEditingController _firstController;
  TextEditingController _lastController;
  TextEditingController _middleController;
  TextEditingController _prefixController;
  TextEditingController _suffixController;
  TextEditingController _nicknameController;
  TextEditingController _firstPhoneticController;
  TextEditingController _lastPhoneticController;
  TextEditingController _middlePhoneticController;

  @override
  void initState() {
    super.initState();
    _firstController = TextEditingController(text: widget.name.first);
    _lastController = TextEditingController(text: widget.name.last);
    _middleController = TextEditingController(text: widget.name.middle);
    _prefixController = TextEditingController(text: widget.name.prefix);
    _suffixController = TextEditingController(text: widget.name.suffix);
    _nicknameController = TextEditingController(text: widget.name.nickname);
    _firstPhoneticController =
        TextEditingController(text: widget.name.firstPhonetic);
    _lastPhoneticController =
        TextEditingController(text: widget.name.lastPhonetic);
    _middlePhoneticController =
        TextEditingController(text: widget.name.middlePhonetic);

    _translationControllers = [
      _firstController,
      _lastController,
      _middleController
    ];
  }

  void _onChanged() {
    final name = Name(
        first: _firstController.text,
        last: _lastController.text,
        middle: _middleController.text,
        prefix: _prefixController.text,
        suffix: _suffixController.text,
        nickname: _nicknameController.text,
        firstPhonetic: _firstPhoneticController.text,
        lastPhonetic: _lastPhoneticController.text,
        middlePhonetic: _middlePhoneticController.text);
    widget.onUpdate(name);
  }

  void _onTranslate() {
    final nameString = _translationControllers.first.text;
    final isCyrillic = _regEx.hasMatch(nameString);
    final language =
        isCyrillic ? describeEnum(Language.en) : describeEnum(Language.uk);
    for (var c in _translationControllers) {
      _translator.translate(c.text, to: language).then((result) {
        setState(() {
          c.text = result.text;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
            onPressed: () {
              _onTranslate();
            },
            child: Text('Translate')),
        ListTile(
          subtitle: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
              key: _formKey,
              onChanged: _onChanged,
              child: Column(
                children: [
                  TextFormField(
                    controller: _firstController,
                    keyboardType: TextInputType.text,
                    textCapitalization: TextCapitalization.words,
                    decoration: InputDecoration(hintText: 'First name'),
                  ),
                  TextFormField(
                    controller: _lastController,
                    keyboardType: TextInputType.text,
                    textCapitalization: TextCapitalization.words,
                    decoration: InputDecoration(hintText: 'Last name'),
                  ),
                  TextFormField(
                    controller: _middleController,
                    keyboardType: TextInputType.text,
                    textCapitalization: TextCapitalization.words,
                    decoration: InputDecoration(hintText: 'Middle name'),
                  ),
                  TextFormField(
                    controller: _prefixController,
                    keyboardType: TextInputType.text,
                    textCapitalization: TextCapitalization.words,
                    decoration: InputDecoration(hintText: 'Prefix'),
                  ),
                  TextFormField(
                    controller: _suffixController,
                    keyboardType: TextInputType.text,
                    textCapitalization: TextCapitalization.words,
                    decoration: InputDecoration(hintText: 'Suffix'),
                  ),
                  TextFormField(
                    controller: _nicknameController,
                    keyboardType: TextInputType.text,
                    textCapitalization: TextCapitalization.words,
                    decoration: InputDecoration(hintText: 'Nickname'),
                  ),
                  TextFormField(
                    controller: _firstPhoneticController,
                    keyboardType: TextInputType.text,
                    textCapitalization: TextCapitalization.words,
                    decoration:
                        InputDecoration(hintText: 'Phonetic first name'),
                  ),
                  TextFormField(
                    controller: _lastPhoneticController,
                    keyboardType: TextInputType.text,
                    textCapitalization: TextCapitalization.words,
                    decoration: InputDecoration(hintText: 'Phonetic last name'),
                  ),
                  TextFormField(
                    controller: _middlePhoneticController,
                    keyboardType: TextInputType.text,
                    textCapitalization: TextCapitalization.words,
                    decoration:
                        InputDecoration(hintText: 'Phonetic middle name'),
                  ),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}
