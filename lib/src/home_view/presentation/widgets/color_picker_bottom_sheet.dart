
part of '../import.dart';
class ColorPickerBottomSheet {
  ColorPickerBottomSheet._();

  static void showColorBottomSheet({
    required BuildContext context,
    required ValueNotifier<Setting> colorNotifier,
  }) {
    showModalBottomSheet<void>(
      context: context,
      builder: (context) => ColorSheet(colorNotifier),
    );
  }
}

final List<Color> colors = [
  Colors.pink,
  Colors.red,
  Colors.deepOrange,
  Colors.green,
  Colors.teal,
  Colors.grey,
  Colors.blue,
  Colors.purple,
];

class ColorSheet extends StatelessWidget {
  const ColorSheet(this.setting, {super.key});

  final ValueNotifier<Setting> setting;

  @override
  Widget build(BuildContext context) {
   
    return SizedBox(
      height: 110,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'Pick a theme',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: colors.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8),
                  child: GestureDetector(
                    onTap: () {
                      setting.value = setting.value.copyWith(
                        colorName: colors[index].toHex(),
                      );
                    },
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: colors[index],
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.grey, width: 2),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
