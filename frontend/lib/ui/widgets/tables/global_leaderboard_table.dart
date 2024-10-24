import 'package:flutter/material.dart';
import 'package:frontend/core/models/user.dart';
import 'package:frontend/ui/theme.dart';

class GlobalLeaderboardTable extends StatelessWidget {
  const GlobalLeaderboardTable({Key? key, required this.users})
      : super(key: key);

  final List<User> users;

  @override
  Widget build(BuildContext context) {
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
                          Image.asset(
                            //user.image,
                            'assets/images/placeholder.png',
                            width: 40,
                            height: 40,
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
