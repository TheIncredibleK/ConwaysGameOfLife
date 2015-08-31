
//The gap between starting positions, each rect will be 5 in size
int gap = 5;

//Initialization, Some starting variables
//Max cell position values for checking
//The boolean board and then randomising the board
void setup() {
  size(500, 500);
  maxCellsHeight = height/gap;
  maxCellsWidth = width/gap;
  board = new boolean[maxCellsWidth][maxCellsHeight];
  buffer = new boolean[maxCellsWidth][maxCellsHeight];
  randomise();
}
int maxCellsWidth;
int maxCellsHeight;
boolean board[][]; 
boolean buffer[][];
boolean paused = false;

//Just calls the necessary functions
void draw() {
  background(0);

  draw_background();
  drawBoard();


  if (!paused) {
    for (int row = 0; row < maxCellsWidth; row++) {
      for (int col = 0; col < maxCellsHeight; col++) {
        int count = countNeighbours(row, col);
        checkRules(row, col, count);
      }
    }
  }
}

//This was originally more complex, but has since become just drawing
//A black background
void draw_background() {
  background(0);
}

//Randomises the board
void randomise() {
  //These two for loops basically says 'For ever cell in the board'
  for (int i = 0; i < maxCellsWidth; i++) {
    for (int j = 0; j < maxCellsHeight; j++) {
      //Rand is a random int from 0-4
      int rand = int(random(0, 5));
      //If it's greater than 3, then set it to true
      if (rand > 1)
      {
        board[i][j] = true;
      }
    }
  }
}

void keyPressed() {
  if(key == ' ') {
    paused = !paused;
  }
  if(key == 'c')
  {
    randomise();
  }
}

void mousePressed() {
  int x = int(mouseX/gap);
  int y = int(mouseY/gap);
  
  board[x][y] = !board[x][y];
}

//Draws the board of rects, The actual 'living cells' are produced here
void drawBoard() {
  fill(0, 255, 0);

  for (int row = 0; row < maxCellsWidth; row++) {
    for (int col = 0; col < maxCellsHeight; col++) {
      if (board[row][col] == true) {
        rect((row * gap), (col * gap), gap, gap);
      }
    }
  }
}


//Function to count the neighbours cell
int countNeighbours(int row, int col) {

  //Limits us to one board to check against
  for (int i = 0; i < maxCellsWidth; i++) {
    for (int j = 0; j < maxCellsHeight; j++) {
      buffer[i][j] = board[i][j];
    }
  }


  int count = 0;
  //Just the row+1 set
  if ((row+1) < (maxCellsWidth-1)) {
    //If col-1 is within bounds
    if ((col-1) > 0) {
      if (buffer[row+1][col-1]) {
        count++;
      }
      if (buffer[row][col-1]) {
        count++;
      }
    }
    if (col+1 < maxCellsHeight-1) {
      if (buffer[row+1][col+1]) {
        count++;
      }
      if (buffer[row][col+1]) {
        count++;
      }
    }
  }
  if ((row-1) > 0) {
    if ((col+1) < maxCellsHeight -1) {
      if (buffer[row-1][col+1]) {
        count++;
      }
    }
    if ((col-1) > 0) {
      if (buffer[row-1][col-1]) {
        count++;
      }
    }
  }
  return count;
}


//Putting this where it will be used to save the trouble of seeing

/* Rules are as follows
 1. Any LIVING cell with less than 2 neighbours dies
 2. Any LIVING cell with 2/3 live neighours lives
 3. Any LIVING cell with more than 3 neighbours dies
 4. Any DEAD cell with EXACTLY 3 neighbours becomes a living cell
 */

void checkRules(int row, int col, int count) {
  if (buffer[row][col]) {
    if (count < 2) {
      board[row][col] = false;
    }
    if (count == 2 || count == 3) {
      board[row][col] = true;
    }
    if (count > 3) {
      board[row][col] = false;
    }
  }
  if (!buffer[row][col]) {
    if (count == 3) {
      board[row][col] = true;
    }
  }
}

