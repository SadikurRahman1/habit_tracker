import '../../../../../core/exported_files/exported_file.dart';


class CommonBody extends StatelessWidget {
  const CommonBody({super.key, required this.widget});

  final Widget widget;

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Padding(padding: const EdgeInsets.symmetric(horizontal: 16), child: widget));
  }
}
