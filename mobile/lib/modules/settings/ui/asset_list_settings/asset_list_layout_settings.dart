import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:immich_mobile/modules/home/ui/asset_grid/asset_grid_data_structure.dart';
import 'package:immich_mobile/modules/settings/providers/app_settings.provider.dart';
import 'package:immich_mobile/modules/settings/services/app_settings.service.dart';

class LayoutSettings extends HookConsumerWidget {
  const LayoutSettings({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appSettingService = ref.watch(appSettingsServiceProvider);

    final useDynamicLayout = useState(true);
    final groupBy = useState(GroupAssetsBy.day);

    void switchChanged(bool value) {
      appSettingService.setSetting(AppSettingsEnum.dynamicLayout, value);
      useDynamicLayout.value = value;
      ref.invalidate(appSettingsServiceProvider);
    }

    void changeGroupValue(GroupAssetsBy? value) {
      if (value != null) {
        appSettingService.setSetting(
          AppSettingsEnum.groupAssetsBy,
          value.index,
        );
        groupBy.value = value;
        ref.invalidate(appSettingsServiceProvider);
      }
    }

    useEffect(
      () {
        useDynamicLayout.value =
            appSettingService.getSetting<bool>(AppSettingsEnum.dynamicLayout);
        groupBy.value = GroupAssetsBy.values[
            appSettingService.getSetting<int>(AppSettingsEnum.groupAssetsBy)];

        return null;
      },
      [],
    );

    return Column(
      children: [
        SwitchListTile.adaptive(
          activeColor: Theme.of(context).primaryColor,
          title: const Text(
            "asset_list_layout_settings_dynamic_layout_title",
            style: TextStyle(
              fontSize: 12,
            ),
          ).tr(),
          onChanged: switchChanged,
          value: useDynamicLayout.value,
        ),
        ListTile(
          title: const Text(
            "asset_list_layout_settings_group_by",
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ).tr(),
        ),
        RadioListTile(
          activeColor: Theme.of(context).primaryColor,
          title: const Text(
            "asset_list_layout_settings_group_by_month_day",
            style: TextStyle(
              fontSize: 12,
            ),
          ).tr(),
          value: GroupAssetsBy.day,
          groupValue: groupBy.value,
          onChanged: changeGroupValue,
          controlAffinity: ListTileControlAffinity.trailing,
        ),
        RadioListTile(
          activeColor: Theme.of(context).primaryColor,
          title: const Text(
            "asset_list_layout_settings_group_by_month",
            style: TextStyle(
              fontSize: 12,
            ),
          ).tr(),
          value: GroupAssetsBy.month,
          groupValue: groupBy.value,
          onChanged: changeGroupValue,
          controlAffinity: ListTileControlAffinity.trailing,
        ),
        RadioListTile(
          activeColor: Theme.of(context).primaryColor,
          title: const Text(
            "asset_list_layout_settings_group_automatically",
            style: TextStyle(
              fontSize: 12,
            ),
          ).tr(),
          value: GroupAssetsBy.auto,
          groupValue: groupBy.value,
          onChanged: changeGroupValue,
          controlAffinity: ListTileControlAffinity.trailing,
        ),
      ],
    );
  }
}
