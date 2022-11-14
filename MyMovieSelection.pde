
import java.util.*;
import uibooster.*;
import rita.*;


UiBooster movieListMenu= new UiBooster(); //This is the name of the Movie List selection menu
UiBooster characterMenu= new UiBooster(); //This is the name of the Character List selection menu

Table movieList;   //This table will hold the information from the movie_titles_metadata_header.csv file
Table movieLines;  //This table will hold the information from the movie_lines_header.csv file


String selectedMovieName;  // this is the variable that holds the selected string from the movie list menu
String selectedMovieID; // this is the variable that holds the movie ID associated with the movie name selected from the 
                        // movie list menu
String selectedCharacter; //This is the character selected from the characterMenu

String[] movieOptions;
String[] pos;
ArrayList<String> characterOptions = new ArrayList<String>();
ArrayList<String> characterDialogue = new ArrayList<String>();


int numRowsInMovieList;  //This holds the number of rows in the Movie List Table
int numRowsInMovieLines; //This holds the number of rows in the Movie Lines Table
int numOfMovieIDRefs = 0;
int ppnOnLine = 0;


void setup() {
  size(800, 400); 
  background(10);
  
  //Fill the Movie List Table with Data from the movie_titles_metadata_header.csv file
  movieList = loadTable("data/movie_titles_metadata_header.csv", "header");
  
  //Fill the Movie Lines Table with Data from the movie_lines_header.csv file
  movieLines = loadTable("data/movie_lines_header.csv", "header");
  
  // Find the number of rows in each table. These numbers are used to create the dropdown menus of the appropriate size
  
  numRowsInMovieList = movieList.getRowCount();
  numRowsInMovieLines = movieLines.getRowCount();
  
  println(numRowsInMovieList);
  println(numRowsInMovieLines);
  
  //Create an array of string, called movieOption, to hold all of the movie names from the MovieList table. The size of this array is obviously going to 
  // be equal to the number of rows in the MovieList table
 
  movieOptions= new String[numRowsInMovieList];
  
  

//Fill in the movieOptions array with the names of the movies from the movieList Table.
  
  for (int i=0; i<numRowsInMovieList; i++){
    movieOptions[i] = movieList.getRow(i).getString("MovieName");
  }
  
//Use the movieOptions array in creating the movieListMenu

  selectedMovieName = movieListMenu.showSelectionDialog(
                  "Select your favorite movie?",        // Question
                  "Movie Selector",                    // window title
                  movieOptions); // choices
    
//Search through the movieList Table until the Movie Name matches with the selectedMovieName. When it does, assign the variable
// called selectedMovieID with the value of the associated MovieID
   for (int i=0; i<numRowsInMovieList; i++){
    if (selectedMovieName == movieList.getRow(i).getString("MovieName")){
       selectedMovieID = movieList.getRow(i).getString("MovieID");
       break;
    }
   }
   
  print("selectedMovieID = ");
  println(selectedMovieID);
  
  
  //Create an ArrayList of character names associated with the selectedMovieID
  
  for (TableRow row : movieLines.findRows(selectedMovieID, "MovieID")) { //look at each row in the table whose MovieID is equal to the selectedMovieID 
    if(characterOptions.indexOf(row.getString("CharacterName")) == -1){ //Identify the character name from that row and if the charactername is not already in the arraylist
      characterOptions.add(row.getString("CharacterName"));             // then add it to the list    
    }
  }
  
  println(characterOptions);
 
   selectedCharacter = characterMenu.showSelectionDialog(
                  "Select Your Character",        // Question
                  "Characters from " + selectedMovieName,     // window title
                  characterOptions); // choices
    
  
  print("selected Character = ");
  println(selectedCharacter);  
  
  

 for (int i=0; i<numRowsInMovieLines; i++){
   if (selectedMovieID.equals(movieLines.getRow(i).getString("MovieID")))
      if (selectedCharacter.equals(movieLines.getRow(i).getString("CharacterName"))){
             characterDialogue.add(movieLines.getRow(i).getString("MovieLine"));
      }
 }
 
 
 println(characterDialogue);
 println(characterDialogue.size());
 

 for (int i=0; i<characterDialogue.size();i++){
     pos = RiTa.pos(characterDialogue.get(i));

     for(int j=0;j<pos.length;j++)
       if(pos[j] == "prp"){
         ppnOnLine++;
         break;
       }

 }
 
   // println(characterDialogue.get(i));
    print("The number lines with personal pronouns is: ");
    println(ppnOnLine);
    println("total number of lines of dialogue = " + characterDialogue.size());
    println ("% of lines with ppn = " + (float)ppnOnLine/characterDialogue.size() *100);
}

void draw() {
    textAlign(CENTER, CENTER);
    textSize(32);
        text("Your favorite movie is " + selectedMovieName, 100, 32);
         text("Your character is " + selectedCharacter, 100, 96);

    arc(width/2, height/2, 300, 300, 0, 2.0*PI*ppnOnLine/characterDialogue.size());
}
