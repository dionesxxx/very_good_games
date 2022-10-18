import 'package:flutter/material.dart';
import 'package:very_good_games/l10n/l10n.dart';
import 'package:very_good_games/theme/theme.dart';

class FavoritedButton extends StatefulWidget {
  const FavoritedButton({
    super.key,
    this.isFavorited = false,
    this.onToggleFavorited,
  });

  final bool isFavorited;
  final ValueChanged<bool>? onToggleFavorited;

  @override
  State<FavoritedButton> createState() => _FavoritedButtonState();
}

class _FavoritedButtonState extends State<FavoritedButton> {
  @override
  void initState() {
    _value = widget.isFavorited;
    super.initState();
  }

  bool _value = false;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Stack(
      children: [
        Positioned.fill(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 50),
            decoration: _value
                ? BoxDecoration(
                    borderRadius: BorderRadius.circular(40),
                    border: Border.all(color: kPrimaryColor, width: 2.3),
                  )
                : BoxDecoration(
                    borderRadius: BorderRadius.circular(40),
                    color: kPrimaryColor,
                    boxShadow: [
                      BoxShadow(
                        offset: const Offset(4, 8),
                        blurRadius: 24,
                        color: kPrimaryColor.withOpacity(.25),
                      ),
                    ],
                  ),
            width: 140,
          ),
        ),
        TextButton.icon(
          style: TextButton.styleFrom(
            splashFactory: NoSplash.splashFactory,
            foregroundColor: _value ? null : Colors.white,
            padding: const EdgeInsets.fromLTRB(26, 12, 26, 12),
            textStyle: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          onPressed: () {
            setState(() {
              _value = !_value;
              widget.onToggleFavorited!(_value);
            });
          },
          icon: Icon(_value ? Icons.done : Icons.add, size: 20),
          label: Text(l10n.favoriteGame),
        ),
      ],
    );
  }
}
