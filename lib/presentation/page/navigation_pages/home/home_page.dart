import 'dart:async';

import 'package:corrupt/features/channel/domain/entity/class_table_entity.dart';
import 'package:corrupt/features/channel/domain/entity/common_school_data_entity.dart';
import 'package:corrupt/features/channel/domain/entity/data_fetch_type.dart';
import 'package:corrupt/features/channel/domain/use_case/school_impl_select_usecase.dart';
import 'package:corrupt/features/channel/provider/local_school_data_provider.dart';
import 'package:corrupt/features/pref/domain/entity/local_data_key.dart';
import 'package:corrupt/features/pref/domain/entity/settings_key.dart';
import 'package:corrupt/features/pref/provider/local_pref_provider.dart';
import 'package:corrupt/infrastructure/di.dart';
import 'package:corrupt/presentation/i18n/app_localizations.dart';
import 'package:corrupt/presentation/page/login_screen.dart';
import 'package:corrupt/presentation/page/main_screen.dart';
import 'package:corrupt/presentation/page/navigation_pages/home/home_update_card.dart';
import 'package:corrupt/presentation/util/class_time_util.dart';
import 'package:corrupt/presentation/widget/load_waiting_mask_widget.dart';
import 'package:corrupt/presentation/widget/simple_widget.dart';
import 'package:dartlin/collections.dart';
import 'package:dartlin/control_flow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' hide Consumer;
import 'package:fpdart/fpdart.dart';
import 'package:intl/intl.dart';

part 'home_cards.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  late final Timer _timer;
  DateTime _time = DateTime.timestamp().toLocal();

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(Duration(milliseconds: 100), (_) {
      setState(() {
        _time = DateTime.timestamp().toLocal();
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    final needValues = <AsyncValue<Option<dynamic>>>[ref.watch(prefProvider(LocalDataKey.logged))];
    return loadWaitingMask(
      values: needValues,
      requiredValues: needValues,
      context: context,
      child: (result) {
        final isLogged = result[0] as bool;
        return SingleChildScrollView(
          child: Padding(
            padding: EdgeInsetsGeometry.directional(start: 8, end: 8),
            child: Column(
              children: [
                IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Flexible(fit: FlexFit.tight, child: _cardGreeting(context,_time)),
                      Flexible(fit: FlexFit.tight, child: _cardTime(context,_time)),
                    ],
                  ),
                ),
                ...isLogged ? _loggedWidget(context) : _notLoggedWidget(context),
              ],
            ),
          ),
        );
      },
    );
  }

  Iterable<Widget> _loggedWidget(BuildContext context) {
    return <Widget>[
      _cardUpdate(context, ref),
      _cardClassTime(context, _time, ref),
      _cardFunctions(context, ref),
    ];
  }

  Iterable<Widget> _notLoggedWidget(BuildContext context) {
    return <Widget>[
      _cardRequestLogin(context),
      _cardUpdate(context, ref),
      _cardClassTime(context, _time, ref),
      _cardFunctions(context, ref),
    ];
  }
}
