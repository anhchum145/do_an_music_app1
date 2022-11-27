import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.black,
      ),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.black,
        body: Align(
          alignment: Alignment.bottomCenter,
          child: MyWidget(),
        ),
      ),
    );
  }
}

class MyWidget extends StatelessWidget {
  // Get the the seconds from current minute.
  //
  // TODO: Make this your actual progress indicator
  Stream<int> getSecondsFromCurrentMinute() async* {
    final now = DateTime.now();
    final seconds = now.second;
    yield seconds;
    await Future.delayed(Duration(seconds: 1 - seconds));
    yield* getSecondsFromCurrentMinute();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 10,
        ),
        // Song cover
        ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: Image.asset(
            "assets/cover.jpg",
            width: 25,
            height: 25,
          ),
        ),

        // Padding
        SizedBox(width: 15),

        // Title and artist
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Text(
              "AUD",
              style: Theme.of(context).textTheme.headline6,
            ),
            // Artist
            Text(
              "Unknown artist",
              style: Theme.of(context)
                  .textTheme
                  .bodyText2
                  ?.copyWith(color: Colors.grey.withOpacity(.6)),
            ),
          ],
        ),

        // Padding between first 2 columns and Icons
        Expanded(child: SizedBox.expand()),

        //
        // Play button and progress indicator
        //
        Container(
          width: 40,
          height: 40,
          child: GestureDetector(
            onTap: () {},
            child: Icon(
              Icons.skip_previous,
              color: Colors.red,
            ),
          ),
        ),
        StreamBuilder<int>(
            stream: getSecondsFromCurrentMinute(),
            builder: (context, AsyncSnapshot<int> snapshot) {
              double percentageOfSecond = (snapshot.data ?? 0) / 60;

              return Container(
                width: 40,
                height: 40,
                child: Stack(
                  children: [
                    // the circle showing progress
                    Positioned(
                      top: 6,
                      left: 7,
                      child: Container(
                        width: 25,
                        height: 25,
                        child: CircularProgressIndicator(
                          value: percentageOfSecond,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.red,
                          ),
                          backgroundColor: Colors.red.withOpacity(0.15),
                        ),
                      ),
                    ),
                    // the play arrow, inside the circle
                    Positioned(
                      top: 0,
                      left: 0,
                      child: Container(
                        width: 25,
                        height: 25,
                        child: IconButton(
                          icon: Icon(
                            Icons.play_arrow,
                            color: Colors.red,
                          ),
                          onPressed: () {},
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),

        SizedBox(width: 8),

        Container(
          width: 40,
          height: 40,
          child: GestureDetector(
            onTap: () {},
            child: Icon(
              Icons.skip_next,
              color: Colors.red,
            ),
          ),
        ),

        //
        SizedBox(width: 8),

        // Extra padding at the end of the row
        SizedBox(width: 30),
      ],
    );
  }
}
