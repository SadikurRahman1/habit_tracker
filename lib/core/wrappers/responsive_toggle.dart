import '../exported_files/exported_file.dart';


class ResponsiveToggle extends StatelessWidget {
  final List<String> options;
  final List<String>? images; // optional images list
  final double borderRadius;
  final Color selectedColor;
  final Color unselectedColor;
  final Color selectedTextColor;
  final Color unselectedTextColor;
  final Function(String selectedOption)? onChange;
  final int initialIndex;

  // Internal controller
  final RxInt _selectedIndex = 0.obs;

  ResponsiveToggle({
    super.key,
    required this.options,
    this.images,
    this.borderRadius = 32,
    this.selectedColor = AppColors.mainColor,
    this.unselectedColor = Colors.white,
    this.selectedTextColor = Colors.white,
    this.unselectedTextColor = Colors.black,
    this.onChange,  
    this.initialIndex = 0,
  });

  @override
  Widget build(BuildContext context) {
      _selectedIndex.value = initialIndex;
    return ResponsiveContainer(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(color: selectedColor, width: 2),
      ),
      child: Row(
        children: List.generate(options.length, (index) {
          return Expanded(
            child: Obx(() {
              final isSelected = _selectedIndex.value == index;

              return GestureDetector(
                onTap: () {
                  _selectedIndex.value = index;
                  if (onChange != null) onChange!(options[index]);
                },
                child: ResponsiveContainer(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                  decoration: BoxDecoration(
                    color: isSelected ? selectedColor : unselectedColor,
                    borderRadius: BorderRadius.circular(borderRadius),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Show image only if images list is provided AND this option is selected
                      if (images != null &&
                          images!.length > index &&
                          isSelected)
                        Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: ResponsiveImage(path: images![index], size: 24, color: AppColors.white,),
                        ),

                      ResponsiveText(
                        text: options[index],
                        color: isSelected ? selectedTextColor : unselectedTextColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ],
                  ),
                ),
              );
            }),
          );
        }),
      ),
    );
  }
}
