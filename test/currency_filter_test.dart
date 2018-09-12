import 'package:moneyconverter/l10n/app_localizations.dart';
import 'package:moneyconverter/l10n/country_name_localizations.dart';
import 'package:moneyconverter/l10n/currency_localizations.dart';
import 'package:moneyconverter/model/country.dart';
import 'package:moneyconverter/screens/add_currency/currency_filter.dart';
import 'package:test/test.dart';

import 'mocks/mock_currency.dart';

void main() {

  final countryLocalizations = new CountryNameLocalizations({
    "United States": "Amerika",
    "United Kingdom": "Storbritannien",
    "Germany": "Tyskland"
  });

  final currencyLocalizations = new CurrencyLocalizations({
    "EUR": "Euro",
    "USD": "Amerikanska dollar",
    "GBP": "Brittiska pund"
  });
  final localizations = new AppLocalizations(countryLocalizations, currencyLocalizations);

  final countries = [
    new Country("United States", "US", "USD"),
    new Country("United Kingdom", "GB", "GBP"),
    new Country("Germany", "DE", "EUR")
  ];

  var dollar = MockCurrency.dollar;
  var pound = MockCurrency.pound;
  var euro = MockCurrency.euro;
  var currencies = [ dollar, pound, euro ];

  // TODO: The filter shouldn't be localizing things, they should already be localized.
  // TODO: The filter should specify the rules, not the data to filter.
  final filter = new CurrencyFilter(countries, localizations);

  test("When english country name partially matches returns that country`s currency", () {
    expect(filter.getFiltered(currencies, "States"), contains(dollar));
  });

  test("When localized country name partially matches returns that country`s currency", () {
    expect(filter.getFiltered(currencies, "Ame"), contains(dollar));
  });

  test("When currency code matches partially, returns the given currency", () {
    expect(filter.getFiltered(currencies, 'Us'), contains(dollar));
  });

  test("When currency name matches partially, returns the given currency", () {
    expect(filter.getFiltered(currencies, 'eur'), contains(euro));
  });

  test("When localized currency name matches partially, returns the currency", () {
    expect(filter.getFiltered(currencies, "pun"), contains(pound));
  });

  test("When not supplying filter text, returns all currencies", () {
    expect(filter.getFiltered(currencies, ""), currencies);
  });
}