import 'package:flutter/material.dart';
import 'package:frontend/core/models/user_app.dart';
import 'package:frontend/ui/responsive.dart';

class GlobalLeaderboardTable extends StatelessWidget {
  const GlobalLeaderboardTable({Key? key, required this.users})
      : super(key: key);

  final List<UserApp> users;

  @override
  Widget build(BuildContext context) {
    bool isMobile = Responsive.isMobile(context);
    return Scrollbar(
      thumbVisibility: true,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Scrollbar(
          thumbVisibility: true,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: DataTable(
                columnSpacing: isMobile ? 42 : 65,
                columns: const [
                  DataColumn(
                    label: Text(
                      'Pos.',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Driver',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Points',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                  ),
                ],
                rows: List<DataRow>.generate(
                  users.length,
                  (index) => DataRow(
                    cells: [
                      DataCell(Text(
                        (index + 1).toString(),
                        style: const TextStyle(color: Colors.black),
                      )), // Row index
                      DataCell(Row(
                        children: [
                          CircleAvatar(
                            maxRadius: isMobile ? 18 : 20,
                            backgroundColor: Colors.white,
                            backgroundImage: AssetImage(
                              'assets/avatars/${users[index].avatar}.png',
                            ),
                          ),
                          const SizedBox(width: 5),
                          Text(
                            users[index].username.toString(),
                            style: const TextStyle(color: Colors.black),
                          ),
                        ],
                      )),
                      DataCell(
                        Text(
                          users[index].totalPoints.toString(),
                          style: const TextStyle(color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
