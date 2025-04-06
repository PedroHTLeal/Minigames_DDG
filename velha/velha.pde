int[][] boardValues = new int[4][4];
char[][] boardMarks = new char[4][4];
boolean[][] marked = new boolean[4][4];

int currentPlayer = 1;
boolean isCPUMode = true;
boolean gameStarted = false;
boolean showEndScreen = false;
String winner = "";

int die1, die2, diceSum;
boolean rolled = false;
boolean turnOver = false;
int timerStart;
int maxTime = 8000;

PFont font;
color player1Color = color(0, 102, 255);
color player2Color = color(0, 200, 0);
color cpuColor     = color(255, 50, 50);

int cellSize = 100;
int margin = 50;
int boardX, boardY;

void setup() {
  size(600, 700);
  font = createFont("Arial", 32);
  textFont(font);
  boardX = width/2 - (cellSize*2);
  boardY = 200;
  resetBoard();
}

void draw() {
  background(255);

  if (!gameStarted && !showEndScreen) {
    showMenu();
    return;
  }

  if (showEndScreen) {
    showEndGameScreen();
    return;
  }

  drawTitle();
  drawBoard();
  drawDiceInfo();
  drawTimer();
  drawTurn();

  if (rolled && millis() - timerStart > maxTime && !turnOver) {
    println("Tempo esgotado!");
    passTurn();
  }

  if (rolled && currentPlayer == 2 && isCPUMode && !turnOver) {
    cpuPlay();
  }

  checkWin();
}

void resetBoard() {
  ArrayList<Integer> pool = new ArrayList<Integer>();
  for (int i = 2; i <= 12; i++) {
    int count = (i == 11 || i == 12) ? 1 : 2;
    for (int j = 0; j < count; j++) {
      pool.add(i);
    }
  }
  java.util.Collections.shuffle(pool);
  int idx = 0;
  for (int i = 0; i < 4; i++) {
    for (int j = 0; j < 4; j++) {
      boardValues[i][j] = pool.get(idx++);
      boardMarks[i][j] = ' ';
      marked[i][j] = false;
    }
  }
}

void drawBoard() {
  strokeWeight(2);
  for (int i = 0; i < 4; i++) {
    for (int j = 0; j < 4; j++) {
      int x = boardX + j * cellSize;
      int y = boardY + i * cellSize;
      fill(230);
      rect(x, y, cellSize, cellSize);
      fill(0);
      textSize(28);
      textAlign(CENTER, CENTER);
      text(boardValues[i][j], x + cellSize/2, y + cellSize/2);

      if (marked[i][j]) {
        fill(currentMarkColor(boardMarks[i][j]));
        textSize(60);
        text(boardMarks[i][j], x + cellSize/2, y + cellSize/2);
      }
    }
  }
}

color currentMarkColor(char mark) {
  if (mark == 'X') return player1Color;
  if (isCPUMode) return cpuColor;
  return player2Color;
}

void drawDiceInfo() {
  if (!rolled) return;

  int x = width/2 - 140;
  int y = 120;
  drawDie(die1, x);
  textSize(32);
  fill(0);
  text("+", x + 65, y);
  drawDie(die2, x + 90);
  text("=", x + 170, y);
  text(diceSum, x + 220, y);
}

void drawDie(int val, int x) {
  int y = 90;
  fill(255);
  rect(x, y, 40, 40);
  fill(0);
  textAlign(CENTER, CENTER);
  text(val, x + 20, y + 20);
}

void drawTimer() {
  if (!rolled) return;

  int timePassed = millis() - timerStart;
  float angle = map(timePassed, 0, maxTime, 0, TWO_PI);
  pushMatrix();
  translate(width/2, 300);
  fill(currentPlayer == 1 ? player1Color : (isCPUMode ? cpuColor : player2Color));
  arc(0, 0, 80, 80, -HALF_PI, -HALF_PI + TWO_PI - angle, PIE);
  popMatrix();
}

void drawTitle() {
  fill(0);
  textAlign(CENTER, CENTER);
  textSize(28);
  text("Tic Tac Toe Matemático by Kaleido Void Studios", width/2, 30);
}

void drawTurn() {
  textSize(20);
  fill(0);
  textAlign(CENTER);
  String txt = "Vez do " + (currentPlayer == 1 ? "Player 1 (X)" : (isCPUMode ? "CPU (O)" : "Player 2 (O)"));
  text(txt, width/2, 60);
  if (!rolled) {
    fill(100);
    rect(width/2 - 60, 70, 120, 30);
    fill(255);
    text("Rolar Dados", width/2, 85);
  }
}

void mousePressed() {
  if (!gameStarted) {
    if (mouseY > height/2 - 20 && mouseY < height/2 + 20) {
      if (mouseX > width/2 - 120 && mouseX < width/2 + 120) {
        isCPUMode = true;
        gameStarted = true;
      }
    }
    if (mouseY > height/2 + 60 && mouseY < height/2 + 100) {
      if (mouseX > width/2 - 120 && mouseX < width/2 + 120) {
        isCPUMode = false;
        gameStarted = true;
      }
    }
    return;
  }

  if (showEndScreen) {
    if (mouseX > width/2 - 100 && mouseX < width/2 + 100) {
      if (mouseY > height/2 + 20 && mouseY < height/2 + 60) {
        isCPUMode = true;
        restartGame();
      } else if (mouseY > height/2 + 80 && mouseY < height/2 + 120) {
        isCPUMode = false;
        restartGame();
      }
    }
    return;
  }

  if (!rolled) {
    if (mouseX > width/2 - 60 && mouseX < width/2 + 60 &&
        mouseY > 70 && mouseY < 100) {
      rollDice();
    }
    return;
  }

  if (turnOver || (currentPlayer == 2 && isCPUMode)) return;

  for (int i = 0; i < 4; i++) {
    for (int j = 0; j < 4; j++) {
      int x = boardX + j * cellSize;
      int y = boardY + i * cellSize;
      if (mouseX > x && mouseX < x + cellSize &&
          mouseY > y && mouseY < y + cellSize &&
          !marked[i][j]) {
        int val = boardValues[i][j];
        if (val == die1 || val == die2 || val == diceSum) {
          boardMarks[i][j] = currentPlayer == 1 ? 'X' : 'O';
          marked[i][j] = true;
          turnOver = true;
        }
      }
    }
  }

  if (turnOver) passTurn();
}

void rollDice() {
  die1 = int(random(1, 7));
  die2 = int(random(1, 7));
  diceSum = die1 + die2;
  rolled = true;
  timerStart = millis();
  turnOver = false;
}

void passTurn() {
  rolled = false;
  turnOver = false;
  currentPlayer = 3 - currentPlayer;
}

void cpuPlay() {
  delay(1000);
  for (int i = 0; i < 4; i++) {
    for (int j = 0; j < 4; j++) {
      if (!marked[i][j] &&
         (boardValues[i][j] == die1 || boardValues[i][j] == die2 || boardValues[i][j] == diceSum)) {
        boardMarks[i][j] = 'O';
        marked[i][j] = true;
        turnOver = true;
        passTurn();
        return;
      }
    }
  }
  // Nenhuma jogada possível
  passTurn();
}

void checkWin() {
  for (int i = 0; i < 4; i++) {
    if (checkLine(boardMarks[i][0], boardMarks[i][1], boardMarks[i][2], boardMarks[i][3])) {
      endGame(boardMarks[i][0]);
      return;
    }
    if (checkLine(boardMarks[0][i], boardMarks[1][i], boardMarks[2][i], boardMarks[3][i])) {
      endGame(boardMarks[0][i]);
      return;
    }
  }
  if (checkLine(boardMarks[0][0], boardMarks[1][1], boardMarks[2][2], boardMarks[3][3])) {
    endGame(boardMarks[0][0]);
    return;
  }
  if (checkLine(boardMarks[0][3], boardMarks[1][2], boardMarks[2][1], boardMarks[3][0])) {
    endGame(boardMarks[0][3]);
    return;
  }
}

boolean checkLine(char a, char b, char c, char d) {
  return a != ' ' && a == b && b == c && c == d;
}

void endGame(char winnerMark) {
  showEndScreen = true;
  if (winnerMark == 'X') winner = "Player 1 venceu!";
  else if (isCPUMode) winner = "CPU venceu!";
  else winner = "Player 2 venceu!";
}

void showEndGameScreen() {
  background(255);
  fill(0);
  textAlign(CENTER);
  textSize(32);
  text(winner, width/2, height/2 - 60);

  fill(100);
  rect(width/2 - 100, height/2 + 20, 200, 40);
  fill(255);
  textSize(20);
  text("Novo jogo vs CPU", width/2, height/2 + 40);

  fill(100);
  rect(width/2 - 100, height/2 + 80, 200, 40);
  fill(255);
  text("Novo jogo vs Player 2", width/2, height/2 + 100);
}

void showMenu() {
  background(255);
  fill(0);
  textAlign(CENTER);
  textSize(28);
  text("Escolha o modo de jogo", width/2, height/2 - 100);

  fill(100);
  rect(width/2 - 120, height/2 - 20, 240, 40);
  fill(255);
  textSize(20);
  text("Jogar contra CPU", width/2, height/2);

  fill(100);
  rect(width/2 - 120, height/2 + 60, 240, 40);
  fill(255);
  text("Jogar contra Player 2", width/2, height/2 + 80);
}

void restartGame() {
  resetBoard();
  rolled = false;
  showEndScreen = false;
  currentPlayer = 1;
}
