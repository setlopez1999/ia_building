import 'package:flutter/material.dart';
import 'package:tvapp/config/theme/app.theme.dart';
import 'package:tvapp/core/domain/entities/category/category_entity.dart';
import 'package:tvapp/ui/shared/utils/check_index.handler.dart';
import 'package:tvapp/ui/shared/widgets/google_text.widget.dart';

class CategoryChip extends StatelessWidget {
  const CategoryChip({
    super.key,
    required this.category,
    required this.categoryActive,
    required this.onPressed,
  });

  final Category category;
  final String categoryActive;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Stack(
        children: [
          SizedBox(
            height: 29,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Center(
                child: GoogleTextWidget(
                  textAlign: TextAlign.center,
                  category.name,
                  style: TextStyle(
                    color: checkIndex<Color, String>(
                      category.id,
                      compareIndex: categoryActive,
                      onTrue: AppTheme.textColor(context),
                      onFalse: AppTheme.textColor(context).withAlpha(150),
                    ),
                    fontSize: 14,
                    fontWeight: checkIndex<FontWeight, String>(
                      category.id,
                      compareIndex: categoryActive,
                      onTrue: FontWeight.w700,
                      onFalse: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 8,
            right: 8,
            child:Container(
              height: 4,
              decoration: BoxDecoration(
                  color: checkIndex<Color, String>(
                    category.id,
                    compareIndex: categoryActive,
                    onTrue: AppTheme.secondaryColor(context),
                    onFalse: Colors.transparent,
                  ),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(4),
                    topRight: Radius.circular(4),
                  )
              ),
            ),
          )
        ],
      ),
    );
  }
}
