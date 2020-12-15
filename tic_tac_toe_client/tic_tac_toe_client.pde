//Client (sends O's (1))

import processing.net.*;

Client myClient;
int[][] grid;
int turn;

void setup() {
  size(300, 400);
  grid = new int[3][3]; //rows then columns
  strokeWeight(3);
  textAlign(CENTER, CENTER);
  textSize(50);
  myClient = new Client(this, "127.0.0.1", 1234);
}

void draw() {
  
  //receiving messages
  if (myClient.available() > 0) {
    String incoming = myClient.readString();
    if (incoming.length() == 1) {
      turn = int(incoming);
      println("Event recieved. Turn is " + turn);
    } else {
      int r = int(incoming.substring(0,1));
      int c = int(incoming.substring(2,3));
      grid[r][c] = 2;
      turn = 1;
      println("coordinates: " + r + "," + c);
    }
  }
  
  background(255);
  
  //draw diving lines
  stroke(0);
  line(0, 100, 300, 100);
  line(0, 200, 300, 200);
  line(100, 0, 100, 300);
  line(200, 0, 200, 300);
  
  //draw x's and o's on screen
  int row = 0;
  int col = 0;
  while (row < 3) {
    drawXO(row, col);
    col++;
    if (col == 3) {
      col = 0;
      row++;
    }
  }
  
  //draw mouse coordinates
  fill(0);
  textSize(30);
  text(mouseX + "," + mouseY, 100, 350);
  
  //draw turn indicator
  if (turn == 0) {
    fill(255, 0, 0);
  } else if (turn == 1) {
    fill(0, 255, 0);
  }
  ellipse(250, 350, 70, 70);

}

void drawXO(int row, int col) {
  pushMatrix();
  translate(row*100, col*100);
  if (grid[row][col] == 1) {
    fill(255);
    ellipse(50, 50, 90, 90);
  } else if (grid[row][col] == 2) {
    line(10, 10, 90, 90);
    line(90, 10, 10, 90);
  }
  popMatrix();
}

void mouseReleased() {
  if (mouseY <= 300) {
    int row = mouseX/100;
    int col = mouseY/100;
    if (grid[row][col] == 0 && turn == 1) {
      grid[row][col] = 1;
      myClient.write(row + "," + col);
      turn = 0;
    }
  }
}
