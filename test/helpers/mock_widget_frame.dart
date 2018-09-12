import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:moneyconverter/l10n/app_localizations_delegate.dart';
import 'package:moneyconverter/l10n/fallback_material_localisations_delegate.dart';
import 'package:moneyconverter/state_container.dart';

import '../mocks/mock_app_state.dart';

class MockWidgetFrame extends StatefulWidget {
  final Widget _child;

  MockWidgetFrame({Widget child}) : this._child = child;

  @override
  _MockWidgetFrameState createState() {
    return new _MockWidgetFrameState();
  }
}

class _MockWidgetFrameState extends State<MockWidgetFrame> {
  @override
  Widget build(BuildContext context) {
    return new StateContainer(
        state: mockAppState(),
        child: MaterialApp(
            localizationsDelegates: [
              AppLocalizationsDelegate(context),
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              const FallbackMaterialLocalisationsDelegate()
            ],
            supportedLocales: AppLocalizationsDelegate.supportedLocales,
            home: widget._child
        )
    );
  }
}
