import 'package:flutter/material.dart';
import 'package:frontend/core/models/avatar.dart';
import 'package:frontend/core/models/user_app.dart';
import 'package:frontend/core/services/auth_services.dart';
import 'package:frontend/core/services/firestore_service.dart';
import 'package:frontend/ui/responsive.dart';
import 'package:frontend/ui/theme.dart';
import 'package:provider/provider.dart';

class AvatarSelectionDialog extends StatefulWidget {
  final UserApp userApp;

  const AvatarSelectionDialog({Key? key, required this.userApp})
      : super(key: key);

  @override
  _AvatarSelectionDialogState createState() => _AvatarSelectionDialogState();
}

class _AvatarSelectionDialogState extends State<AvatarSelectionDialog> {
  final FirestoreService _firestoreService = FirestoreService();
  late Future<List<Avatar>> _avatarsFuture;
  String? selectedAvatar;
  bool isMobile = false;

  @override
  void initState() {
    super.initState();
    // Fetch avatars when the dialog is initialized
    _avatarsFuture = _firestoreService.getAvatars();
  }

  /// Updates the user's avatar in Firestore and provides feedback.
  Future<void> _updateAvatar(String avatarName) async {
    try {
      await _firestoreService.updateUserAvatar(widget.userApp.id, avatarName);
      AuthService authService =
          Provider.of<AuthService>(context, listen: false);
      authService.updateAvatar(avatarName);
      Navigator.of(context).pop(true); // Indicate success
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Avatar updated successfully!'),
          backgroundColor: primary,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update avatar: ${e.toString()}'),
          backgroundColor: secondary,
        ),
      );
    }
  }

  /// Builds the action button row with a Close button.
  Widget _actionButtonRow() {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          TextButton(
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
            child: Container(
              width: 110,
              decoration: BoxDecoration(
                color: white,
                borderRadius: const BorderRadius.all(
                  Radius.circular(20),
                ),
                border: Border.all(color: primary, width: 2),
              ),
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: const Text(
                'CLOSE',
                style: TextStyle(
                  color: primary,
                  fontSize: 14.0,
                  fontWeight: FontWeight.w400,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          const SizedBox(
            width: 15,
          ),
          TextButton(
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
            ),
            onPressed: () async {
              await _updateAvatar(selectedAvatar!);
            },
            child: Container(
              width: 110,
              decoration: BoxDecoration(
                color: secondary,
                borderRadius: const BorderRadius.all(
                  Radius.circular(20),
                ),
                border: Border.all(color: secondary, width: 2),
              ),
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: const Text(
                'SAVE',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14.0,
                  fontWeight: FontWeight.w400,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Builds the grid of avatars.
  Widget _buildAvatarsGrid(List<Avatar> avatars) {
    return SizedBox(
      height: isMobile
          ? MediaQuery.of(context).size.height * 0.6
          : MediaQuery.of(context).size.height * 0.5,
      width: isMobile ? MediaQuery.of(context).size.width - 50 : 350,
      child: GridView.builder(
        shrinkWrap: true,
        //physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: isMobile ? 4 : 3,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: 1, // Maintain square cells
        ),
        itemCount: avatars.length,
        itemBuilder: (context, index) {
          Avatar avatar = avatars[index];
          bool isUnlocked = widget.userApp.level >= avatar.level;
          //bool isSelected = widget.userApp.avatar == avatar.id;

          return Tooltip(
            message: isUnlocked ? '' : 'Level ${avatar.level} required',
            child: InkWell(
              onTap: () {
                if (isUnlocked) {
                  setState(() {
                    selectedAvatar = avatar.name;
                  });
                }
              },
              child: Stack(
                children: [
                  // Display Avatar Image
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.grey[200],
                    backgroundImage:
                        AssetImage('assets/avatars/${avatar.name}.png'),
                    child: !isUnlocked
                        ? Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(60),
                              color: Colors.black.withOpacity(0.7),
                            ),
                            child: const Icon(
                              Icons.lock,
                              color: Colors.white,
                              size: 28,
                            ),
                          )
                        : null,
                  ),
                  // Display Checkmark if Avatar is Selected
                  if (isUnlocked)
                    if (selectedAvatar == avatar.name)
                      Positioned(
                        top: 0,
                        right: 20,
                        child: Icon(
                          Icons.check_circle,
                          color: Colors.green[900],
                        ),
                      ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    isMobile = Responsive.isMobile(context);
    return AlertDialog(
      backgroundColor: white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            "Change avatar",
            style: TextStyle(color: primary, fontWeight: FontWeight.bold),
          ),
          IconButton(
            padding: const EdgeInsets.all(0),
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.close_rounded,
              size: 24,
              color: Colors.grey,
            ),
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: FutureBuilder<List<Avatar>>(
              future: _avatarsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  // Show loading indicator while fetching avatars
                  return Container(
                    height: 300,
                    child: const Center(
                      child: CircularProgressIndicator(
                        color: primary,
                      ),
                    ),
                  );
                } else if (snapshot.hasError) {
                  // Show detailed error message if fetching fails
                  return Center(
                    child: Text(
                      'Error loading avatars: ${snapshot.error}',
                      style: const TextStyle(color: Colors.red),
                    ),
                  );
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  // Show message if no avatars are available
                  return const Center(
                      child: Text('No avatars available.',
                          style: TextStyle(color: Colors.black)));
                } else {
                  List<Avatar> avatars = snapshot.data!;
                  selectedAvatar = selectedAvatar ?? widget.userApp.avatar;
                  return _buildAvatarsGrid(avatars);
                }
              },
            ),
          ),
          const SizedBox(height: 25),
          _actionButtonRow(),
        ],
      ),
    );
  }
}