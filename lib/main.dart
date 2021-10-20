import 'package:csv/csv.dart';
import 'package:flutter/services.dart';
import 'package:english_words/english_words.dart';
import 'dart:async';
import 'package:flutter/material.dart';

//this will hold the data for the teams such as the name, color and round information
List<List<dynamic>> nhlPlayoffData = [];
void main() async {
  //this will make sure that the app is initialized before it start
  WidgetsFlutterBinding.ensureInitialized();
  //this will get a string from data/Data.csv
  final csvData = await rootBundle.loadString("data/Data.csv");
  //this will covert the string in csv to a list of dynamic lists and store it into nhlPlayoffData
  nhlPlayoffData = CsvToListConverter(textEndDelimiter: "\n").convert(csvData);
  //this will remove the first item of nhlPlayoffData
  nhlPlayoffData.removeAt(0);
  //this will start the app
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  //this is the key of the app
  var myAppKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    //this will return MaterialApp
    return MaterialApp(
      title: 'Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(
        //this will pass home page into the title
        title: 'Home Page',
        //this will pass the key myAppKey
        key: myAppKey,
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  //this will be the boolean if the round is on the end of the brackets
  bool rowEndings = true;
  //this will hold the max height of the bracket
  double? maxHeightOfBracket = 0;
  //this will have the key for the in IntrinsicHeight of the bracket
  var _bracketMaxHeightKey = GlobalKey();
  //this will hold all the teams in each round
  List<List<dynamic>> teamsInRound = [];
  //this will hold the amount of team in each round on the left side
  int leftRoundAmountOfTeams = 16;
  //this will hold the amount of team in each round on the right side
  int rightRoundAmountOfTeams = 1;

  ///Subroutine Name: initState
  ///
  ///Subroutine Description: this will initiate the app with require tasks
  void initState() {
    //this will initialize the app
    super.initState();
    //when the build is finished it will do the statment below
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      //this will set the set the maxHeightOfBracket to the value of  _bracketMaxHeightKey height
      maxHeightOfBracket = _bracketMaxHeightKey.currentContext?.size?.height;
      //this will  set the app in a new state
      setState(() {});
    });
  }

  ///Subroutine Name: amountOfContentRight
  ///
  ///Subroutine Description: this will mulitpy the amount of items that will be
  ///displayed on the right side and set if it is on the end of the row
  void amountOfContentRight(int column) {
    //this will multiply rightRoundAmountOfTeams by two
    rightRoundAmountOfTeams *= 2;
    //this case will take the column and pick a value that match's column
    switch (column) {
      //if column is 0 it will do the statement below
      case 0:
        //this will set rowEndings to true
        rowEndings = true;
        //this will take you out of the case statment
        break;
    }
  }

  ///Subroutine Name: amountOfColumnLeft
  ///
  ///Subroutine Description: this will divide the amount of items that will be
  ///displayed on the left side and set if it is on the end of the row
  void amountOfColumnLeft(int column) {
    //this will divide leftRoundAmountOfTeams by two
    leftRoundAmountOfTeams ~/= 2;
    //this case will take the column and pick a value that match's column
    switch (column) {
      //if column is 1 it will do the statement below
      case 1:
        //this will set rowEndings to false
        rowEndings = false;
        //this will take you out of the case statment
        break;
    }
  }

  ///Subroutine Name: gatherTeamsInEachRound
  ///
  ///Subroutine Description: This will gather all team that are provided and put
  ///them in the round that the have made it to
  void gatherTeamsInEachRound() {
    //this will clear teamsInRound
    teamsInRound = [];
    //this will repeat for the amount of round that are in play the bracket
    for (var i = 0; i <= 5; i++) {
      //this will create a temporary buffer to store the teams in
      List<dynamic> teamRoundBuffer = [];
      //this will do the statment below for every element in nhlPlayoffData
      nhlPlayoffData.forEach((element) {
        //if section 6 in the element is more then i then it will do the statment below
        if (element[6] >= i) {
          //this will add the element into teamRoundBuffer
          teamRoundBuffer.add(element);
        }
      });
      //this will add teamRoundBuffer to teamsInRound
      teamsInRound.add(teamRoundBuffer);
    }
  }

  /// function Name: bracketTiles
  ///
  /// function Description: this will make each tile for the bracket. it will accpet if it is: on the winner tile,
  /// if it is  on left or right of the bracket, the name of the team, the score for the round, and the rgb values individually
  Widget bracketTiles({
    //this will  have if it is on winner tile  or not
    bool onWinner = false,
    //this will have which side of the bracket the team is on
    String leftOrRightSideOfTheBracket = "left",
    //this will take the name of the team
    String teamName = "Blues",
    //this will take the score for that round
    String roundScore = "0",
    //this will take the date of the matches that have not started
    String startingDateOfMatches = "To Be Announced",
    // this will take the value for red given
    var redValue = 0,
    //this will take the value for blue given
    var blueValue = 0,
    // this will take the value for green given
    var greenValue = 0,
  }) {
    //this will have the size of the font
    double thefontSize = 30;
    //this will store the textColor
    Color textColor;
    //this will have the value that the edge should be rounded by
    double roundEdgeValue = 20;
    //if the average  the value of redvalue, bluevalue, and greenValue is more then 126 then it will fo the statement below
    if ((redValue + blueValue + greenValue) / 3 > 126) {
      //this will set textColor to black
      textColor = Colors.black;
    } //if there is any other value then if will do the statment below
    else {
      //this will set textColor to white
      textColor = Colors.white;
    }

// if onWinner is true it will return the limitbox below
    if (onWinner == true) {
      return LimitedBox(
          maxWidth: 250,
          maxHeight: 100,
          child: Container(
              height: MediaQuery.of(context).size.height * .1,
              margin: EdgeInsets.symmetric(vertical: (10)),
              decoration: BoxDecoration(
                  border: Border.all(width: 2),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.5),
                        spreadRadius: 1,
                        blurRadius: 7,
                        offset: Offset(-10, 10))
                  ],
                  borderRadius:
                      BorderRadius.all(Radius.circular(roundEdgeValue)),
                  color: Color.fromRGBO(redValue.toInt(), greenValue.toInt(),
                      blueValue.toInt(), 1.0),
                  shape: BoxShape.rectangle),
              //if leftOrRightSideOfTheBracket is not equal to left than it will give the first row below
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Winner",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.yellow,
                      )),
                ],
              )));
    }

    //this will generate a name and store it in fakeTeamName
    String fakeTeamName = generateWordPairs().take(1).toString();
//this will create  a BoxDecoration that will be the outer box of the team tile and store a different value depending  on leftOrRightSideOfTheBracket
    BoxDecoration containerDecorationDesign = leftOrRightSideOfTheBracket ==
            "left"
        ? BoxDecoration(
            border: Border.all(width: 2),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.5),
                  spreadRadius: 1,
                  blurRadius: 7,
                  offset: Offset(-10, 10))
            ],
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(50),
                bottomLeft: Radius.circular(50),
                topRight: Radius.circular(roundEdgeValue),
                bottomRight: Radius.circular(roundEdgeValue)),
            color: Color.fromRGBO(
                redValue.toInt(), greenValue.toInt(), blueValue.toInt(), 1.0),
            shape: BoxShape.rectangle)
        : BoxDecoration(
            border: Border.all(width: 2),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.5),
                  spreadRadius: 1,
                  blurRadius: 7,
                  offset: Offset(-10, 10))
            ],
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(roundEdgeValue),
                bottomLeft: Radius.circular(roundEdgeValue),
                topRight: Radius.circular(50),
                bottomRight: Radius.circular(50)),
            color: Color.fromRGBO(
                redValue.toInt(), greenValue.toInt(), blueValue.toInt(), 1.0),
            shape: BoxShape.rectangle);

    //If the teamName is equal to NotYet it will do the statment below
    if (teamName == "NotYet") {
      //this will return a limitedbox that is used for when the match have not taken place
      return LimitedBox(
        maxWidth: 250,
        maxHeight: 100,
        child: Container(
            height: MediaQuery.of(context).size.height * .1,
            margin: EdgeInsets.symmetric(vertical: (10)),
            decoration: containerDecorationDesign,
            //if leftOrRightSideOfTheBracket is not equal to left than it will give the first row below
            child: leftOrRightSideOfTheBracket != "left"
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(startingDateOfMatches,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.yellow,
                          )),
                      LimitedBox(
                        maxWidth: 100,
                        child: Container(
                          width: MediaQuery.of(context).size.width * .1,
                          margin: EdgeInsets.only(left: 10),
                          padding: EdgeInsets.only(left: 10),
                          decoration: BoxDecoration(
                              border: Border.all(
                                width: 2,
                                color: Colors.yellow,
                              ),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(50)),
                              image: DecorationImage(
                                image: AssetImage("Images/waiting.png"),
                              ),
                              shape: BoxShape.rectangle),
                        ),
                      ),
                    ],
                  )
                //if leftOrRightSideOfTheBracket is equal to left than it will give the row below
                : Row(
                    children: [
                      LimitedBox(
                        maxWidth: 100,
                        child: Container(
                          width: MediaQuery.of(context).size.width * .1,
                          margin: EdgeInsets.only(right: 10),
                          padding: EdgeInsets.only(right: 10),
                          decoration: BoxDecoration(
                              border: Border.all(
                                width: 2,
                                color: Colors.yellow,
                              ),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(50)),
                              image: DecorationImage(
                                image: AssetImage("Images/waiting.png"),
                              ),
                              shape: BoxShape.rectangle),
                        ),
                      ),
                      Text(
                        startingDateOfMatches,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.yellow),
                      ),
                    ],
                  )),
      );
    }
    //if teamName contains MakeName then it will return the first  limitedbox
    return teamName.contains("MakeName")
        ? LimitedBox(
            maxWidth: 250,
            maxHeight: 100,
            child: Container(
                height: MediaQuery.of(context).size.height * .1,
                margin: EdgeInsets.symmetric(vertical: (10)),
                decoration: containerDecorationDesign,
                //if leftOrRightSideOfTheBracket is not equal to left than it will give the first row below
                child: leftOrRightSideOfTheBracket != "left"
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Expanded(
                              child: Container(
                            child: Text(
                              roundScore,
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: textColor,
                                  fontSize: thefontSize),
                            ),
                            margin: EdgeInsets.only(right: 10),
                          )),
                          Text(
                            fakeTeamName.toString().toUpperCase().substring(
                                1, fakeTeamName.toString().length - 1),
                            style: TextStyle(
                                fontWeight: FontWeight.bold, color: textColor),
                          ),
                          Container(
                            child: Center(
                              child: Text(
                                "${fakeTeamName[1].toUpperCase()}",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: textColor,
                                    fontSize: thefontSize),
                              ),
                            ),
                            height: MediaQuery.of(context).size.height * .1,
                            width: MediaQuery.of(context).size.height * .1,
                            margin: EdgeInsets.only(left: 10),
                            decoration: BoxDecoration(
                                border: Border.all(width: 2),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(50)),
                                shape: BoxShape.rectangle),
                          ),
                        ],
                      )
                    //if leftOrRightSideOfTheBracket is equal to left than it will give the row below
                    : Row(
                        children: [
                          Container(
                            child: Center(
                              child: Text(
                                "${fakeTeamName[1].toUpperCase()}",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: textColor,
                                    fontSize: thefontSize),
                              ),
                            ),
                            height: MediaQuery.of(context).size.height * .1,
                            width: MediaQuery.of(context).size.height * .1,
                            margin: EdgeInsets.only(right: 10),
                            decoration: BoxDecoration(
                                border: Border.all(width: 2),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(50)),
                                shape: BoxShape.rectangle),
                          ),
                          Text(
                            fakeTeamName.toString().toUpperCase().substring(
                                1, fakeTeamName.toString().length - 1),
                            style: TextStyle(
                                fontWeight: FontWeight.bold, color: textColor),
                          ),
                          Expanded(
                              child: Container(
                            child: Text(
                              roundScore,
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: textColor,
                                  fontSize: thefontSize),
                            ),
                            margin: EdgeInsets.only(right: 10),
                          ))
                        ],
                      )),
          )
        //if teamName  does not contains MakeName then it will return this LimitedBox
        : LimitedBox(
            maxWidth: 250,
            maxHeight: 100,
            child: Container(
                margin: EdgeInsets.symmetric(vertical: (10)),
                height: MediaQuery.of(context).size.height * .1,
                decoration: containerDecorationDesign,
                //if leftOrRightSideOfTheBracket is not equal to left than it will give the first row below
                child: leftOrRightSideOfTheBracket != "left"
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Expanded(
                              child: Container(
                            child: Text(
                              roundScore,
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: textColor,
                                  fontSize: thefontSize),
                            ),
                            margin: EdgeInsets.only(right: 10),
                          )),
                          Text(
                            teamName.toUpperCase(),
                            style: TextStyle(
                                fontWeight: FontWeight.bold, color: textColor),
                          ),
                          LimitedBox(
                            maxWidth: 100,
                            child: Container(
                              width: MediaQuery.of(context).size.width * .1,
                              margin: EdgeInsets.only(left: 10),
                              decoration: BoxDecoration(
                                  border: Border.all(width: 2),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(50)),
                                  image: DecorationImage(
                                      image: AssetImage(
                                          "Images/" + "$teamName" + ".png"),
                                      fit: BoxFit.fill),
                                  shape: BoxShape.rectangle),
                            ),
                          ),
                        ],
                      )
                    //if leftOrRightSideOfTheBracket is equal to left than it will give the row below
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          LimitedBox(
                            maxWidth: 100,
                            child: Container(
                              width: MediaQuery.of(context).size.width * .1,
                              margin: EdgeInsets.only(right: 10),
                              decoration: BoxDecoration(
                                  border: Border.all(width: 2),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(50)),
                                  image: DecorationImage(
                                      image: AssetImage(
                                          "Images/" + "$teamName" + ".png"),
                                      fit: BoxFit.fill),
                                  shape: BoxShape.rectangle),
                            ),
                          ),
                          Text(
                            teamName.toUpperCase(),
                            style: TextStyle(
                                fontWeight: FontWeight.bold, color: textColor),
                          ),
                          Expanded(
                              child: Container(
                            child: Text(
                              roundScore,
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: textColor,
                                  fontSize: thefontSize),
                            ),
                            margin: EdgeInsets.only(right: 10),
                          ))
                        ],
                      )));
  }

  @override
  Widget build(BuildContext context) {
    //this will set leftRoundAmountOfTeams to 16
    leftRoundAmountOfTeams = 16;
    //this will set rightRoundAmountOfTeams to 1
    rightRoundAmountOfTeams = 1;
    //this will set rowEndings to true
    rowEndings = true;
    //this will call teamInRound
    gatherTeamsInEachRound();
//this will return this scaffold of the bracket
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: MediaQuery.of(context).size.height * .08,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.black,
        title:
            //this row will hold the logo and the title of the bracket
            Row(
          children: [
            Image.asset("Images/NHL.png"),
            Expanded(
                flex: 1,
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * .05,
                )),
            Text(" NHL 2019 Playoff"),
            Expanded(
                flex: 1,
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * .05,
                )),
            Image.asset("Images/NHL.png")
          ],
        ),
      ),
      backgroundColor: Colors.grey,
      body: ListView(scrollDirection: Axis.vertical, children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: IntrinsicHeight(
              key: _bracketMaxHeightKey,
              child: Row(children: [
                //this is the left side of the bracket
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    //this loop will repeat 6 times from 0 and call amountOfColumnLeft and pass the i to it
                    for (var i = 0; i < 5; i++, amountOfColumnLeft(i))
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          //this loop will repeat to the amount of leftRoundAmountOfTeams
                          for (var a = 0; a < leftRoundAmountOfTeams; a++,)
                            //if rowEndings is true it will return the first row
                            rowEndings
                                ? Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      //this will call teamWidget and will pass blueValue, greenValue, redValue,leftOrRightSideOfTheBracket,roundScore,teamName and return a widget
                                      bracketTiles(
                                          //this will pass in the blue value of the teams color
                                          blueValue: teamsInRound[i][a][9],
                                          //this will pass in the green value of the teams color
                                          greenValue: teamsInRound[i][a][8],
                                          //this will pass in the red value of the teams color
                                          redValue: teamsInRound[i][a][7],
                                          //this will pass what side it is on using number
                                          leftOrRightSideOfTheBracket: "left",
                                          //this will pass the score for that round
                                          roundScore: teamsInRound[i][a][1 + i]
                                              .toString(),
                                          //this will pass the name of the team
                                          teamName: teamsInRound[i][a][0])
                                    ],
                                  )
                                : //if rowEndings is false  it will return the statment below
                                //if i is less than or equal to 2 then it will return the first row
                                i <= 2
                                    ? Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              Container(
                                                width: 30,
                                                height: 10,
                                                color: Colors.black,
                                              ),
                                              Container(
                                                width: 10,
                                                //this will adjust the height of the bracket as much as MainAxisAlignment.spaceAround
                                                height: (maxHeightOfBracket! /
                                                        leftRoundAmountOfTeams) -
                                                    ((maxHeightOfBracket! /
                                                            leftRoundAmountOfTeams) /
                                                        1.8),
                                                color: Colors.black,
                                              ),
                                              Container(
                                                width: 30,
                                                height: 10,
                                                color: Colors.black,
                                              ),
                                            ],
                                          ),
                                          Container(
                                            width: 10,
                                            height: 10,
                                            color: Colors.black,
                                          ),
                                          //this will call teamWidget and will pass blueValue, greenValue, redValue,leftOrRightSideOfTheBracket,roundScore,teamName and return a widget
                                          bracketTiles(
                                              //this will pass in the blue value of the teams color
                                              blueValue: teamsInRound[i][a][9],
                                              //this will pass in the green value of the teams color
                                              greenValue: teamsInRound[i][a][8],
                                              //this will pass in the red value of the teams color
                                              redValue: teamsInRound[i][a][7],
                                              //this will pass what side it is on using number
                                              leftOrRightSideOfTheBracket:
                                                  "left",
                                              //this will pass the score for that round
                                              roundScore: teamsInRound[i][a]
                                                      [1 + i]
                                                  .toString(),
                                              //this will pass the name of the team
                                              teamName: teamsInRound[i][a][0])
                                        ],
                                      )
                                    //if i is more than 2 then it will return this  row
                                    : Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              Container(
                                                width: 30,
                                                height: 10,
                                                color: Colors.black,
                                              ),
                                              Container(
                                                width: 10,
                                                //this will adjust the height of the bracket as much as MainAxisAlignment.spaceAround
                                                height: (maxHeightOfBracket! /
                                                        leftRoundAmountOfTeams) -
                                                    ((maxHeightOfBracket! /
                                                            leftRoundAmountOfTeams) /
                                                        2),
                                                color: Colors.black,
                                              ),
                                              Container(
                                                width: 30,
                                                height: 10,
                                                color: Colors.black,
                                              ),
                                            ],
                                          ),
                                          Container(
                                            width: 10,
                                            height: 10,
                                            color: Colors.black,
                                          ),
                                          //this will call teamWidget and will pass teamName and return a widget
                                          bracketTiles(
                                              //this will pass the teamName as NotYet
                                              teamName: "NotYet",
                                              //this will pass the  date for that match according to the round
                                              startingDateOfMatches:
                                                  teamsInRound[i][a]
                                                      [10 + (i == 3 ? 0 : 1)],
                                              //this will pass the left to leftOrRightSideOfTheBracket
                                              leftOrRightSideOfTheBracket:
                                                  "left")
                                        ],
                                      ),
                        ],
                      ),
                  ],
                ),
                //this is the winner tile for the center of the bracket
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(children: [
                      Container(
                        width: 30,
                        height: 10,
                        color: Colors.black,
                      ),
                      bracketTiles(onWinner: true),
                      Container(
                        width: 30,
                        height: 10,
                        color: Colors.black,
                      ),
                    ])
                  ],
                ),
                //this is the right side of the bracket
                Row(
                  children: [
                    //this loop will repeat 6 times fromm 0 and call amountOfContentRight and pass the i to it
                    for (var i = 4; i > -1; i--, amountOfContentRight(i))
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          //this loop will repeat to the amount of rightRoundAmountOfTeams
                          for (var a = 0; a < rightRoundAmountOfTeams; a++)
                            //if rowEndings is true  it will return the first row
                            rowEndings
                                ? Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      //this will call teamWidget and will pass blueValue, greenValue, redValue,leftOrRightSideOfTheBracket,roundScore,teamName and return a widget
                                      bracketTiles(
                                          //this will pass in the blue value of the teams color
                                          blueValue: teamsInRound[i][a +
                                              (teamsInRound[i].length ~/ 2)][9],
                                          //this will pass in the green value of the teams color
                                          greenValue: teamsInRound[i]
                                                  [a + (teamsInRound[i].length ~/ 2)]
                                              [8],
                                          //this will pass in the red value of the teams color
                                          redValue: teamsInRound[i]
                                                  [a + (teamsInRound[i].length ~/ 2)]
                                              [7],
                                          //this will pass  right into leftOrRightSideOfTheBracket
                                          leftOrRightSideOfTheBracket: "right",
                                          //this will pass in what the score was for the team that round
                                          roundScore: teamsInRound[i]
                                                      [a + (teamsInRound[i].length ~/ 2)]
                                                  [1 + i]
                                              .toString(),
                                          //this will pass the name of the team
                                          teamName: teamsInRound[i]
                                              [a + (teamsInRound[i].length ~/ 2)][0])
                                    ],
                                  ) //if rowEndings is false  it will return the statment below
                                //if i is more than or equal to 2 then it will return the first row
                                : i > 2
                                    ? Row(
                                        children: [
                                          //this will call teamWidget and will pass teamName,what side and , date of the match and return a widget
                                          bracketTiles(
                                              //this will pass the teamName as NotYet
                                              teamName: "NotYet",
                                              //this will pass the first date for that match
                                              startingDateOfMatches:
                                                  teamsInRound[i][a +
                                                          (teamsInRound[i]
                                                                  .length ~/
                                                              2)]
                                                      [i == 4 ? 11 : 11 - 1],
                                          //this will pass  right into leftOrRightSideOfTheBracket
                                              leftOrRightSideOfTheBracket:
                                                  "right"),
                                          Container(
                                            width: 10,
                                            height: 10,
                                            color: Colors.black,
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                width: 30,
                                                height: 10,
                                                color: Colors.black,
                                              ),
                                              Container(
                                                width: 10,
                                                height: (maxHeightOfBracket! /
                                                        rightRoundAmountOfTeams) -
                                                    ((maxHeightOfBracket! /
                                                            rightRoundAmountOfTeams) /
                                                        2),
                                                color: Colors.black,
                                              ),
                                              Container(
                                                width: 30,
                                                height: 10,
                                                color: Colors.black,
                                              ),
                                            ],
                                          ),
                                        ],
                                      )
                                    //if i is less than 2 then i will return this row
                                    : Row(
                                        children: [
                                          //this will call teamWidget and will pass blueValue, greenValue, redValue,leftOrRightSideOfTheBracket,roundScore,teamName and return a widget
                                          bracketTiles(
                                              //this will pass in the blue value of the teams color
                                              blueValue: teamsInRound[i]
                                                      [a + (teamsInRound[i].length ~/ 2)]
                                                  [9],
                                              //this will pass in the green value of the teams color
                                              greenValue: teamsInRound[i]
                                                      [a + (teamsInRound[i].length ~/ 2)]
                                                  [8],
                                              //this will pass in the red value of the teams color
                                              redValue: teamsInRound[i]
                                                      [a + (teamsInRound[i].length ~/ 2)]
                                                  [7],
                                          //this will pass  right into leftOrRightSideOfTheBracket
                                              leftOrRightSideOfTheBracket:
                                                  "right",
                                              //this will pass in what the score was for the team that round
                                              roundScore: teamsInRound[i]
                                                          [a + (teamsInRound[i].length ~/ 2)]
                                                      [1 + i]
                                                  .toString(),
                                              //this will pass the name of the team
                                              teamName: teamsInRound[i]
                                                      [a + (teamsInRound[i].length ~/ 2)]
                                                  [0]),
                                          Container(
                                            width: 10,
                                            height: 10,
                                            color: Colors.black,
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                width: 30,
                                                height: 10,
                                                color: Colors.black,
                                              ),
                                              Container(
                                                width: 10,
                                                height: (maxHeightOfBracket! /
                                                        rightRoundAmountOfTeams) -
                                                    ((maxHeightOfBracket! /
                                                            rightRoundAmountOfTeams) /
                                                        1.8),
                                                color: Colors.black,
                                              ),
                                              Container(
                                                width: 30,
                                                height: 10,
                                                color: Colors.black,
                                              ),
                                            ],
                                          ),
                                        ],
                                      )
                        ],
                      ),
                  ],
                )
              ])),
        )
      ]),
    );
  }
}
