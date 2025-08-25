import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sales_manager/config/assets.dart';
import 'package:sales_manager/config/providers/current_user_notifier.dart';
import 'package:sales_manager/ui/core/colors.dart';

class CustomAppBar extends ConsumerWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserNotifierProvider);
    return Container(
      decoration: const BoxDecoration(gradient: AppColors.blueGreenGradient),
      child: Container(
        height: preferredSize.height,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(Assets.appBarBg), // your PNG pattern
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
                      "Hello,",
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.white,
                        height: 1,
                      ),
                    ),
                    Text(
                      user?.firstName ?? "User Name",
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Colors.white,
                        height: 1,
                      ),
                    ),
                    Text(
                      user?.type.toString() ?? "User Type",
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 10,
                        height: 1.6,
                      ),
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
