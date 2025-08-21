import 'package:flutter/material.dart';
import 'package:sales_manager/ui/theme.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.blue, AppColors.green], // blue → green
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          stops: [0.0, 1.0],
        ),
      ),
      child: Container(
        height: preferredSize.height,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              "assets/images/app_bar_bg.jpg",
            ), // your PNG pattern
            fit: BoxFit.cover,
            opacity: 0.2,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                // Profile image
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: const CircleAvatar(
                    radius: 28,
                    backgroundImage: AssetImage("assets/profile.jpg"),
                  ),
                ),

                // Greeting & Name
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Hello",
                      style: Theme.of(
                        context,
                      ).textTheme.bodySmall?.copyWith(color: Colors.white),
                    ),
                    Text(
                      "Sidharth G K",
                      style: Theme.of(
                        context,
                      ).textTheme.bodyLarge?.copyWith(color: Colors.white),
                    ),
                    Text(
                      "Executive",
                      style: TextStyle(color: Colors.white70, fontSize: 10),
                    ),
                  ],
                ),

                const Spacer(),

                // Icons
                Icon(Icons.chat_outlined, color: Colors.white, size: 24),
                const SizedBox(width: 16),
                Icon(
                  Icons.notifications_none_rounded,
                  color: Colors.white,
                  size: 24,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(100);
}
