import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NoticeCard extends StatelessWidget {
  final String title;
  final String description;
  final String date;
  final String view;

  const NoticeCard(
      {super.key,
      required this.title,
      required this.description,
      required this.date,
      required this.view});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    bool isDesktop = width > 600;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Color(0xFFF8FAFC),
        title: Text('Notice Board',
            style: GoogleFonts.nunito(
                textStyle:
                TextStyle(fontSize: 20, fontWeight: FontWeight.bold))),
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_ios_new_outlined,
              size: 23,
            )),
      ),
      backgroundColor: const Color(0xFFF8FAFC),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      Icons.campaign,
                      size: 30,
                      color: Colors.green.shade700,
                    )),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Text(title,
                      style: GoogleFonts.nunito(
                          textStyle: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold))),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                const Icon(
                  Icons.calendar_month_outlined,
                  size: 16,
                  color: Color(0xFF94A3B8),
                ),
                SizedBox(
                  width: 5,
                ),
                Text(
                  date,
                  style: GoogleFonts.nunito(
                      fontSize: 13, color: Colors.grey.shade500),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              height: 1,
              color: Colors.grey.shade300,
            ),
            SizedBox(
              height: 10,
            ),
            Text('Notice Details',
                style: GoogleFonts.nunito(
                    textStyle:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold))),
            SizedBox(
              height: 10,
            ),
            Text(description,
                style: GoogleFonts.nunito(
                    textStyle:
                        TextStyle(fontSize: 15, color: Colors.grey.shade500))),
            SizedBox(
              height: 10,
            ),
            Container(
              height: 1,
              color: Colors.grey.shade300,
            ),
            SizedBox(
              height: 10,
            ),
            Text('Views($view)',
                style: GoogleFonts.nunito(
                    textStyle:
                    TextStyle(fontSize: 20, fontWeight: FontWeight.bold))),
          ],
        ),
      ),
    );
  }
}
