import 'package:PiliPlus/utils/custom_buvid.dart';
import 'package:PiliPlus/utils/login_utils.dart';
import 'package:PiliPlus/utils/storage_pref.dart';
import 'package:material_ui/material_ui.dart';

Future<void> showCustomBuvidDialog(BuildContext context) async {
  final controller = TextEditingController(text: Pref.customAppBuvid);
  String? error;
  var saving = false;
  try {
    await showDialog<void>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('App BUVID'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: controller,
                  autocorrect: false,
                  enableSuggestions: false,
                  textCapitalization: TextCapitalization.none,
                  maxLines: 3,
                  minLines: 1,
                  decoration: InputDecoration(
                    labelText: '自定义 BUVID',
                    hintText: '留空使用原随机编号',
                    errorText: error,
                  ),
                ),
                const SizedBox(height: 16),
                const Text('当前使用'),
                SelectableText(LoginUtils.buvid),
                const SizedBox(height: 16),
                const Text('保存后退出并重新打开 App 生效。清空可恢复原随机编号。此设置影响 App 请求身份，不改变网页 buvid3。'),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: saving ? null : () => Navigator.pop(context),
              child: const Text('取消'),
            ),
            TextButton(
              onPressed: saving ? null : () async {
                try {
                  CustomBuvid.normalize(controller.text);
                } on FormatException catch (e) {
                  setState(() => error = e.message);
                  return;
                }
                setState(() { saving = true; error = null; });
                try {
                  await Pref.saveCustomAppBuvid(controller.text);
                  if (context.mounted) Navigator.pop(context);
                } catch (_) {
                  if (context.mounted) setState(() { saving = false; error = '保存失败，请重试'; });
                }
              },
              child: const Text('保存（重启后生效）'),
            ),
          ],
        ),
      ),
    );
  } finally {
    controller.dispose();
  }
}
