import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travelconverter/app_core/theme/colors.dart';
import 'package:travelconverter/app_core/theme/sizes.dart';
import 'package:travelconverter/app_core/theme/typography.dart';
import 'package:travelconverter/app_core/widgets/gap.dart';
import 'package:travelconverter/app_core/widgets/page_scaffold.dart';
import 'package:travelconverter/app_core/widgets/utility_extensions.dart';
import 'package:travelconverter/l10n/app_localizations.dart';
import 'package:travelconverter/model/currency.dart';
import 'package:travelconverter/use_cases/currency_selection/state/selected_currencies_notifier.dart';
import 'package:travelconverter/use_cases/edit_currencies/state/available_currencies_provider.dart';
import 'package:travelconverter/use_cases/edit_currencies/state/countries_provider.dart';
import 'package:travelconverter/use_cases/edit_currencies/state/search_filter_provider.dart';
import 'package:travelconverter/use_cases/home/services/add_currency_handler.dart';
import 'package:travelconverter/use_cases/edit_currencies/services/currency_filter.dart';
import 'package:travelconverter/use_cases/edit_currencies/ui/search_input.dart';
import 'package:travelconverter/use_cases/edit_currencies/ui/select_currency_card.dart';

class EditCurrenciesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PageScaffold(
        body: Consumer(builder: (ctx, ref, _) => _buildCurrencyList(ctx, ref)));
  }

  _buildCurrencyList(BuildContext context, WidgetRef ref) {
    final localization = AppLocalizations.of(context);
    final selectedCurrencies = ref.watch(selectedCurrenciesNotifierProvider);
    final selectedCurrencyWidgets = selectedCurrencies
        .map((currency) => Container(
              key: Key(currency.code),
              color: Colors.transparent,
              child: Dismissible(
                  key: Key(currency.code),
                  onDismissed: (direction) {
                    ref
                        .read(selectedCurrenciesNotifierProvider.notifier)
                        .removeCurrency(currency.code);
                  },
                  child: SelectCurrencyCard(
                    currency: currency,
                    onTap: () {},
                    icon: Icons.low_priority,
                    iconColor: lightTheme.accent,
                  )).pad(bottom: Paddings.listGap),
            ))
        .toList();

    final filter = CurrencyFilter(ref.watch(countriesProvider), localization);

    // The ReorderableListView is flutter standard and has a long-press reorder capability
    final searchQuery = ref.watch(searchFilterProvider);
    final allCurrencies = ref.watch(availableCurrenciesProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Add currency', style: ThemeTypography.title),
        Text(
            'Search for currencies to add by name, country of use or currency code',
            style: ThemeTypography.small),
        Gap.list,
        SearchInput(
          autoFocus: selectedCurrencyWidgets.length < 2,
        ),
        Gap.list,
        if (searchQuery.isNotEmpty || selectedCurrencyWidgets.length < 3)
          ...filter.getFiltered(allCurrencies, searchQuery).map((currency) {
            return SearchCurrencyResultEntry(
              currency: currency,
              isSelected: selectedCurrencies.contains(currency),
            );
          }),
        if (selectedCurrencyWidgets.isNotEmpty) ...[
          Gap.list,
          Text('Selected currencies', style: ThemeTypography.title),
          Text('Long press and drag to reorder', style: ThemeTypography.small),
          Gap.list,
          ReorderableListView(
            proxyDecorator: (child, index, animation) => child,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            children: selectedCurrencyWidgets,
            onReorder: (prev, next) => ref
                .read(selectedCurrenciesNotifierProvider.notifier)
                .move(item: selectedCurrencies.elementAt(prev), newIndex: next),
          )
        ]
      ],
    );
  }
}

class SearchCurrencyResultEntry extends ConsumerWidget {
  final Currency currency;
  final bool isSelected;

  SearchCurrencyResultEntry({required this.currency, required this.isSelected});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final card = SelectCurrencyCard(
        currency: currency,
        icon: isSelected ? Icons.check : Icons.add_circle_outline,
        iconColor: isSelected ? lightTheme.green : lightTheme.accent,
        onTap: () {
          AddCurrencyHandler(currency,
                  ref.read(selectedCurrenciesNotifierProvider.notifier))
              .addCurrency(context);
        }).pad(bottom: Paddings.listGap);
    return isSelected ? Opacity(opacity: 0.5, child: card) : card;
  }
}
