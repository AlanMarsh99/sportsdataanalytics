import 'package:flutter/material.dart';
//import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:frontend/core/services/auth_services.dart';
import 'package:provider/provider.dart';
import 'dialogs/avatar_selection_dialog.dart';

class EndDrawer extends StatelessWidget {
  const EndDrawer({Key? key}) : super(key: key);

  Widget _buildLogOutItem(BuildContext context) {
    return TextButton(
      child: const Text(
        'LOG OUT',
        style: TextStyle(
          fontSize: 14,
          color: Colors.white,
          fontWeight: FontWeight.w500,
        ),
      ),
      onPressed: () async {
        await AuthService().signOut();
       // Phoenix.rebirth(context);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: const Color(0xFF1B222C),
        child: Column(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Consumer<AuthService>(
                builder: (context, auth, child) {
                  if (auth.status == Status.Authenticated &&
                      auth.userApp != null) {
                    return Column(
                      children: [
                        // Display Current Avatar
                        CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.white,
                          backgroundImage: AssetImage(
                              'avatars/${auth.userApp!.avatar}.png'),
                        ),
                        const SizedBox(height: 15),
                        // Display Username
                        Text(
                          auth.userApp!.username,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 14),
                        ),
                        const SizedBox(height: 10),
                        // "Change Avatar" Button
                        TextButton(
                          onPressed: () {
                            // Open Avatar Selection Dialog
                            showDialog(
                              context: context,
                              useRootNavigator: true,
                              builder: (context) => AvatarSelectionDialog(
                                userApp: auth.userApp!,
                              ),
                            );
                          },
                          child: const Text(
                            'Change Avatar',
                            style: TextStyle(
                              color: Colors.blue,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                      ],
                    );
                  } else {
                    return const CircularProgressIndicator(
                      color: Colors.white,
                    );
                  }
                },
              ),
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: <Widget>[
                  /*_buildDrawerItem(context, 'PROFILE', 6),
                  const SizedBox(height: 10),
                  _buildDrawerItem(context, 'SETTINGS', 7),
                  const SizedBox(height: 10),*/
                  _buildLogOutItem(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
