import de.bezier.guido.*;
public static int NUM_ROWS;
public static int NUM_COLS;
public static int NUM_BOMBS;
public static int w;
public static int h;
public static boolean over=false;
public static boolean notStarted=true;
public static boolean GO=false;
public MSButton[][] buttons; //2d array of minesweeper buttons
public ArrayList <MSButton> mines; //ArrayList of just the minesweeper buttons that are mined

void setup ()
{
    textAlign(CENTER,CENTER);
    
    Interactive.make( this );
    size(3000, 1600);

}
public void setMines()
{
  while(mines.size()< NUM_BOMBS){
    int r=(int)(Math.random()*NUM_ROWS);
    int c=(int)(Math.random()*NUM_COLS);    
    if(mines.contains(buttons[r][c])==false){
      mines.add(buttons[r][c]);
    }
  }
}

public void draw ()
{
    background( 0 );
    textSize(50);
    if(isWon() == true)
        displayWinningMessage();
    fill(255);
    rect(500, 100, 200, 100);
    rect(500, 300, 200, 100);
    rect(500, 500, 200, 100);
    fill(0);
    text("EASY", 600, 150);
    text("MEDIUM", 600, 350);
    text("HARD", 600, 550);
}
public boolean isWon()
{
  if(!notStarted){
   for(int a=0;a<NUM_ROWS;a++){
      for(int b=0;b<NUM_COLS;b++){
        if(!mines.contains(buttons[a][b])&&!buttons[a][b].clicked){
          return false;
        }
      }
   }
   return true;
  }
  return false;
}
public void displayLosingMessage()
{
  over=true;
  for(int r=0;r<NUM_ROWS;r++){
    for(int c=0;c<NUM_COLS;c++){
        buttons[r][c].mousePressed();
    } 
  }
  buttons[4][0].setLabel("Y");
  buttons[4][1].setLabel("O");
  buttons[4][2].setLabel("U");
  buttons[4][4].setLabel("L");
  buttons[4][5].setLabel("O");
  buttons[4][6].setLabel("S");
  buttons[4][7].setLabel("E");
  buttons[4][8].setLabel("!");
  GO=true;
}
public void displayWinningMessage()
{
  if(!GO){
  over=true;
  for(int r=0;r<NUM_ROWS;r++){
    for(int c=0;c<NUM_COLS;c++){
        buttons[r][c].mousePressed();
    } 
  }
  buttons[4][0].setLabel("Y");
  buttons[4][1].setLabel("O");
  buttons[4][2].setLabel("U");
  buttons[4][4].setLabel("W");
  buttons[4][5].setLabel("I");
  buttons[4][6].setLabel("N");
  buttons[4][7].setLabel("!");
  GO=true;
  }
}
public boolean isValid(int r, int c)
{
  return r>=0&&r<=NUM_ROWS-1&&c>=0&&c<=NUM_COLS-1;
}
public int countMines(int row, int col)
{
  int numMines = 0;
  for(int a=-1;a<=1;a++){
    for(int b=-1;b<=1;b++){
      if(isValid(row+a,col+b)){
        if((a!=0||b!=0)&&mines.contains(buttons[row+a][col+b])){
          numMines+=1;
        }
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
        width = w/NUM_COLS;
        height = h/NUM_ROWS;
        myRow = row;
        myCol = col; 
        x = myCol*width;
        y = myRow*height;
        myLabel = "";
        flagged = clicked = false;
        Interactive.add( this ); // register it with the manager
    }
    public void mousePressed () 
    {
        clicked = true;
        if(!GO){
        if(mouseButton==RIGHT){
          if(flagged){
            clicked = false;
            flagged=false;
          }else{
            flagged=true;
          }
        }else if(mines.contains(this)&&!over){
          displayLosingMessage();
        }else if(mines.contains(this)&&over){
        }else if(countMines(myRow, myCol)>0){
          buttons[myRow][myCol].setLabel(countMines(myRow, myCol));
        }else{
          for(int a=-1;a<=1;a++){
            for(int b=-1;b<=1;b++){
              if((a!=0||b!=0)&&isValid(myRow+a,myCol+b)&&buttons[myRow+a][myCol+b].clicked==false){
                buttons[myRow+a][myCol+b].mousePressed();
              }
            }
          }
        }
        }
    }
    public void draw () 
    {    
      if (flagged)
            fill(0);
        else if( clicked && mines.contains(this) ) 
            fill((int)(Math.random()*255),(int)(Math.random()*255),(int)(Math.random()*255));
        else if(clicked)
            fill( 200,100,200 );
        else 
            fill( 100,200,200 );

        rect(x, y, width, height);
        fill(0);
        text(myLabel,x+width/2,y+height/2);
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
public void startgame(){
    mines= new ArrayList <MSButton>();
    buttons = new MSButton[NUM_ROWS][NUM_COLS];
    for(int r=0;r<NUM_ROWS;r++){
      for(int c=0;c<NUM_COLS;c++){
        buttons[r][c] = new MSButton(r,c);
      }
    }
    
    setMines();
}
public void mouseClicked(){
    if(notStarted&&mouseX>=500&&mouseX<=700&&mouseY>=100&&mouseY<=200){
      NUM_ROWS=9;
      NUM_COLS=9;
      NUM_BOMBS=10;
      w=900;
      h=900;
      startgame();
      notStarted=false;
    }
    if(notStarted&&mouseX>=500&&mouseX<=700&&mouseY>=300&&mouseY<=400){
      NUM_ROWS=16;
      NUM_COLS=16;
      NUM_BOMBS=32;
      w=1600;
      h=1600;
      startgame();
      notStarted=false;
    }
    if(notStarted&&mouseX>=500&&mouseX<=700&&mouseY>=500&&mouseY<=600){
      NUM_ROWS=16;
      NUM_COLS=30;
      NUM_BOMBS=60;
      w=3000;
      h=1600;
      startgame();
      notStarted=false;
    }
}
