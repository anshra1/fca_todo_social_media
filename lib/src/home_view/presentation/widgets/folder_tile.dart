
part of '../import.dart';

class FolderTile extends StatelessWidget {
  const FolderTile({
    required this.title,
    required this.isCollapse,
    required this.onPressed,
    super.key,
  });

  final String title;
  final bool isCollapse;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Ink(
        height: 40,
        width: context.width,
        child: Row(
          children: [
            if (!isCollapse)
              const Icon(
                Icons.keyboard_arrow_right,
                size: 22,
                color: Colors.white,
              )
            else
              const Icon(
                Icons.keyboard_arrow_down,
                size: 22,
                color: Colors.white,
              ),
            3.gap,
            Text(
              title,
              style: p18.white,
            ),
          ],
        ),
      ).leftPadding(10),
    );
  }
}
