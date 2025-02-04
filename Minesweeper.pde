import de.bezier.guido.*;
public final static int NUM_ROWS = 20;
public final static int NUM_COLS = 20;
private MSButton[][] buttons; //2d array of minesweeper buttons
private ArrayList <MSButton> mines; //ArrayList of just the minesweeper buttons that are mined
public int count, openCount;
public boolean loss;

void setup ()
{
    size(1000, 1000);
    textAlign(CENTER,CENTER);
    textSize(20);
    // make the manager
    Interactive.make( this );
    buttons = new MSButton[NUM_ROWS][NUM_COLS];
    //your code to initialize buttons goes here
    for(int c = 0; c < NUM_COLS; c++){
      for(int r = 0; r < NUM_ROWS; r++)
        buttons[r][c] = new MSButton(r,c);
    }
    loss = false;
    mines = new ArrayList <MSButton> ();
    setMines();
    count = mines.size();
    openCount = 0;
}
public void setMines()
{
 for(int i = 0; i < 50; i++){
    int r = (int) (Math.random()*NUM_ROWS);
    int c = (int) (Math.random()*NUM_COLS);
      if(!mines.contains(buttons[r][c]))
        mines.add(buttons[r][c]);
      else 
        i--;
  }
}

public void draw ()
{
    background(200,50,200);
    if(isWon() == true)
        displayWinningMessage();
}
public boolean isWon()
{
    if(openCount == ((NUM_ROWS*NUM_COLS)-50))
      return true;
    else
      return false;
}
public void displayLosingMessage(){
    fill(255, 150, 0);
    rect(300, 50, 400, 100);
    fill(20, 200, 20);
    text("You Lose :(", 500, 100);
}
public void displayWinningMessage()
{
    fill(20, 200, 20);
    rect(300, 50, 400, 100);
    fill(255, 150, 0);
    text("You WIN! :D", 500, 100);
noLoop();
}
public boolean isValid(int r, int c)
{
    if((r >= 0)&&(c >= 0)&&(r < NUM_ROWS)&&(c < NUM_COLS))
      return true;
    else
      return false;
}
public int countMines(int row, int col)
{
    int numMines = 0;
    for(int l = col-1; l < col+2; l++){
      for(int w = row-1; w < row+2; w++){
         if(isValid(w, l)==true){
            if(mines.contains(buttons[w][l]))
              numMines++;
         }
      } 
    }
    return numMines;
}
public class MSButton
{
    private int myRow, myCol;
    private float x,y, width, height;
    private boolean clicked, flagged;
    private String myLabel;
    
    public MSButton ( int row, int col )
    {
        width = 800/NUM_COLS;
        height = 800/NUM_ROWS;
        myRow = row;
        myCol = col; 
        x = myCol*width+100;
        y = myRow*height+150;
        myLabel = "";
        flagged = clicked = false;
        Interactive.add( this ); // register it with the manager
    }

   
    public void mousePressed () 
    {
       
      if(mouseButton == RIGHT){
        if((buttons[myRow][myCol].isFlagged() == false)&&(clicked == false)){
          flagged = true;
          count --;
        }
        else if(clicked == false){
          flagged = false;
          count ++;
        }
      }
      else if(buttons[myRow][myCol].isFlagged() == false) {
        clicked = true;
        if(mines.contains(buttons[myRow][myCol]) == true){
          for(int c = 0; c < NUM_COLS; c++){
                for(int r = 0; r < NUM_ROWS; r++){
                  if(buttons[r][c].isFlagged() == true){
                    if(!mines.contains(buttons[r][c]))
                        buttons[r][c].setLabel("X");
                    }
                  else{
                    buttons[r][c].clicked = true;
                    if((countMines(r, c) != 0)&&(!mines.contains(buttons[r][c])))
                        buttons[r][c].setLabel(countMines(r,c));
                  }
                }
            }
            loss = true;
        }
        else { 
          openCount++;
          if(countMines(myRow, myCol) == 0){
            for(int o = myCol-1; o < myCol+2; o++){
              for(int p = myRow-1; p < myRow+2; p++){
                if((isValid(p,o)==true)&&(buttons[p][o].clicked == false))  
                  buttons[p][o].mousePressed();
              }
            }           
          }
          else 
            buttons[myRow][myCol].setLabel(countMines(myRow,myCol));
        }
      }
   }
    

    public void draw () 
    {    
      fill(0);
      rect(25, 25, 200, 100); 
      fill(255);
      text("Number of Mines:", 125, 50);
      text(count, 125, 100);
      if(loss == true){
        displayLosingMessage();
     }
        if (flagged)
            fill(200,200,0);
        else if( clicked && mines.contains(this) ) 
             fill(200,0,0);
        else if(clicked)
            fill(0,100,100);
        else 
            fill(0,0,200);

        rect(x, y, width, height);
        fill(255, 200, 255);
        text(myLabel,x+width/2,y+height/2);
        if (isWon() == true)
          displayWinningMessage();
    }
    public void setLabel(String newLabel)
    {   
        myLabel = newLabel;
    }
    public void setLabel(int newLabel)
    {     
        myLabel = ""+ newLabel;
    }
    public boolean isFlagged()
    {
        return flagged;
    }
}
