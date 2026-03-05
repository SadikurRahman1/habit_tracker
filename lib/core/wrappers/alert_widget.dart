import '../../../../../core/exported_files/exported_file.dart';

class CustomAlert {
  static void show({
    required BuildContext context,
    required String imagePath,
    required String message,
    String? redMessage,
    required String buttonText,
    VoidCallback? onButtonPressed,
  }) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 🔹 Image
              Image.asset(
                imagePath,
                width: 120,
                height: 120,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 16),

              // 🔹 Main Message
              Text(
                message,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),

              // 🔹 Red-colored text (optional)
              if (redMessage != null)
                Text(
                  redMessage,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.red,
                  ),
                ),

              const SizedBox(height: 24),

              // 🔹 Button
              ResponsiveButton(
                title: buttonText,
                onTap: () {
                  Navigator.of(context).pop();
                  if (onButtonPressed != null) {
                    onButtonPressed();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
