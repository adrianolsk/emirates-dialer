import 'package:flutter/material.dart';
import 'utils/constants.dart';
import 'services/countrycode_service.dart';
import 'dart:async';
// import 'package:uae_dialer/services/utils_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'utils/circle_button.dart';
import 'package:flutter/services.dart';

class CardPage extends StatefulWidget {
  @override
  CardPageState createState() {
    return CardPageState();
  }
}

// final countriesItemsList = await loadCountryCodes();
class CardPageState extends State<CardPage> {
  final _formKey = GlobalKey<FormState>();
  var _stdCodesList = [];
  var _referPractice;
  final _textController = TextEditingController();
  var _details;
  // double _result = 0.0;
  int _radioValue = 0;

  @override
  initState() {
    super.initState();
    updateStoreCardDetails();
    getCountryCodes();
  }

  Future getCountryCodes() async {
    var countryCodesList = await loadCountryCodes();

    print("**** length " + countryCodesList.length.toString());
    setState(() {
      _stdCodesList = countryCodesList;
    });
  }

  Future updateStoreCardDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _details = prefs.getStringList("CARD_DETAILS");
    if (_details != null) {
      print(_details.length);
      print(_details[0]);
      print(_details[1]);
      print(_details[2]);
      print(_details[3]);
      _textController.text = _details[0];
      _referPractice = _details[1];
      if (_details[3] != null) _radioValue = int.parse(_details[3]);
    } else
      print("No card details are stored");
  }

  void _handleRadioValueChange(int value) {
    setState(() {
      _radioValue = value;
      print(value);

      // switch (_radioValue) {
      //   case 0:
      //     _result =
      //     break;
      //   case 1:
      //     _result =
      //     break;
      //   case 2:
      //     _result =
      //     break;
      // }
    });
  }

  // final buttons =

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: new Padding(
          padding: const EdgeInsets.all(15.0),
          child: new Column(
            children: <Widget>[
              new Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text.rich(
                      TextSpan(
                        text: 'Select your Recharge Provider',
                        style: TextStyle(fontSize: 18.0), // default text style
                      ),
                    )
                  ]),
              new Padding(
                  padding: const EdgeInsets.fromLTRB(0.0, 20.0, 10.0, 20.0),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        new Radio(
                          value: 1,
                          groupValue: _radioValue,
                          onChanged: _handleRadioValueChange,
                        ),
                        new Text.rich(
                          TextSpan(
                            text: 'Etisalat (Five)',
                            style: TextStyle(
                                fontSize: 16.0,
                                fontWeight:
                                    FontWeight.bold), // default text style
                          ),
                        ),
                        new Radio(
                          value: 2,
                          groupValue: _radioValue,
                          onChanged: _handleRadioValueChange,
                        ),
                        new Text.rich(
                          TextSpan(
                            text: 'Du (Hello)',
                            style: TextStyle(
                                fontSize: 16.0,
                                fontWeight:
                                    FontWeight.bold), // default text style
                          ),
                        ),
                      ])),
              new Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text.rich(
                      TextSpan(
                        text: 'Enter Card Number',
                        style: TextStyle(fontSize: 18.0), // default text style
                      ),
                    )
                  ]),
              TextFormField(
                controller: _textController,
                keyboardType: TextInputType.number,
                maxLength: 15,
                style: new TextStyle(
                  fontWeight: FontWeight.w200,
                  color: Colors.black,
                  fontSize: 18.0,
                ),
                decoration: new InputDecoration(
                    hintText: HING_ENTER_NUMBER,
                    suffixIcon: CircleIconButton(
                      onPressed: () {
                        this.setState(() {
                          _textController.clear();
                        });
                      },
                    )),
                maxLines: 1,
                validator: (value) {
                  if (value.isEmpty) {
                    return ERROR_CARD_DETAILS;
                  }
                },
              ),
              new Padding(
                  padding: const EdgeInsets.fromLTRB(5.0, 25.0, 25.0, 40.0),
                  child: new Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      new Row(children: <Widget>[
                        new Expanded(
                          child: Text.rich(
                            TextSpan(
                              text: 'Country Code',
                              style: TextStyle(
                                  fontSize: 18.0), // default text style
                              children: <TextSpan>[
                                TextSpan(
                                    text: '*',
                                    style: TextStyle(
                                        fontStyle: FontStyle.italic,
                                        color: Colors.red,
                                        fontSize: 18.0))
                              ],
                            ),
                          ),
                          flex: 3,
                        ),
                        new DropdownButtonHideUnderline(
                          child: new DropdownButton<String>(
                            value: _referPractice,
                            isDense: true,
                            hint: new Text(CONST_SELECT),
                            items: _stdCodesList.map((value) {
                              return new DropdownMenuItem<String>(
                                value: value.dialCode,
                                child: new Text(
                                    "${value.code} ${value.dialCode}",
                                    style: TextStyle(
                                        fontStyle: FontStyle.normal,
                                        fontWeight: FontWeight.w600)),
                              );
                            }).toList(),
                            onChanged: (String newValue) {
                              setState(() {
                                _referPractice = newValue;
                              });
                            },
                          ),
                        )
                      ])
                    ],
                  )),
              new Container(
                  // height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.all(5.0),
                  child: new Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        new Expanded(
                          child: new Padding(
                              padding: EdgeInsets.all(5.0),
                              child: new MaterialButton(
                                height: 40.0,
                                minWidth: 100.0,
                                textColor: Colors.white,
                                color: Colors.green,
                                child: new Text(BTN_SAVE_TEXT),
                                onPressed: () {
                                  print(_radioValue);
                                  SystemChannels.textInput
                                      .invokeMethod('TextInput.hide');
                                  if (_formKey.currentState.validate() &&
                                      _referPractice != null) {
                                    _storeCardNumberAndCountryCode(
                                        _radioValue,
                                        _textController.text.trim(),
                                        _referPractice);
                                    Scaffold.of(context).showSnackBar(SnackBar(
                                        content:
                                            Text(SUCCESSFUL_CARD_DETAILS)));
                                  } else {
                                    Scaffold.of(context).showSnackBar(SnackBar(
                                        content: Text(ERROR_COUNTRY_CODE)));
                                  }
                                },
                              )),
                          flex: 2,
                        ),
                        new Expanded(
                            child: new Padding(
                                padding: EdgeInsets.all(5.0),
                                child: new MaterialButton(
                                  height: 40.0,
                                  minWidth: 100.0,
                                  textColor: Colors.white,
                                  color: Colors.red,
                                  child: new Text(BTN_CLEAR_TEXT),
                                  onPressed: () {
                                    _textController.clear();
                                  },
                                )),
                            flex: 2)
                      ])),
            ],
          )),
    );
  }
}

_storeCardNumberAndCountryCode(
    int cardSelection, String number, String countryCode) async {
  // print(" ${number} code ${countryCode}");
  var stdCode = countryCode.replaceAll("+", "00");
  stdCode = stdCode.replaceAll(" ", "");
  print(stdCode);
  SharedPreferences prefs = await SharedPreferences.getInstance();
  final cardDetails = new List<String>();
  cardDetails.add(number);
  cardDetails.add(countryCode);
  cardDetails.add(stdCode);
  cardDetails.add(cardSelection.toString());

  await prefs.setStringList("CARD_DETAILS", cardDetails);
}
