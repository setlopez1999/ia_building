import 'package:flutter/material.dart';
import 'package:tvapp/core/domain/entities/category/category_entity.dart';
import 'package:tvapp/ui/shared/widgets/google_text.widget.dart';

class CategoryGridButton extends StatelessWidget {

  const CategoryGridButton({super.key, required this.category, required this.onPressed});

  final Category category;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width:75,
        height: 100,
        child: Column(children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Material(
              color: Colors.transparent,
              child: Ink.image(
                width: 75,
                height: 75,
                fit: BoxFit.cover,
                image: NetworkImage(
                  category.card,
                ),
                child: InkWell(
                  onTap: onPressed,
                ),
              ),
            ),
          ),
          const SizedBox(height: 4),
          GoogleTextWidget(
            category.name,
            maxLines: 1,
            style: const TextStyle(
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
          ),
        ])
    );
  }
}
