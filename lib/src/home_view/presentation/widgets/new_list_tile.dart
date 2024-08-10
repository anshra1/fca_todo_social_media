
part of '../import.dart';
class NewListTile extends StatelessWidget {
  const NewListTile({required this.onPressed, super.key});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: GestureDetector(
        onTap: onPressed,
        child: Row(
          children: [
            Icon(Icons.add, size: 22, color: Colors.blue.shade700),
            kGaps5,
            Text(
              'New List',
              style: p15.copyWith(color: Colors.blue.shade700),
            ),
          ],
        ),
      ),
    );
  }
}
