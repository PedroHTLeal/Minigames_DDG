enum GameState { MENU, SELECT_DIFFICULTY, READY, PLAYING, GAME_OVER }
GameState gameState = GameState.MENU;

int score1 = 0, score2 = 0;
int winningScore = 7;

float paddle1Y, paddle2Y;
float paddleWidth = 10, paddleHeight = 80;
float paddleSpeed = 5;

float ballX, ballY;
float ballSize = 20;
float ballSpeedX, ballSpeedY;

boolean singlePlayer = true;
int difficulty = 1;

boolean roundStarted = false;

void setup() {
  size(800, 400);
  resetGame();
}

void draw() {
  background(0);
  drawMiddleLine();

  switch (gameState) {
    case MENU:
      drawMenu();
      break;
    case SELECT_DIFFICULTY:
      drawDifficultySelection();
      break;
    case READY:
      drawReady();
      break;
    case PLAYING:
      drawGame();
      updateBall();
      break;
    case GAME_OVER:
      drawGameOver();
      break;
  }
}

void drawMiddleLine() {
  stroke(255);
  for (int y = 0; y < height; y += 20) {
    line(width/2, y, width/2, y+10);
  }
}

void drawMenu() {
  fill(255);
  textAlign(CENTER);
  textSize(24);
  text("PONG by Kaleido Void Studios", width/2, height/3);
  textSize(16);
  text("Digite 1 para jogar contra CPU", width/2, height/2);
  text("Digite 2 para jogar contra Player", width/2, height/2 + 30);
}

void drawDifficultySelection() {
  fill(255);
  textAlign(CENTER);
  textSize(20);
  text("Selecione a dificuldade:", width/2, height/3);
  text("1 - Iniciante", width/2, height/2);
  text("2 - Amador", width/2, height/2 + 30);
  text("3 - Profissional", width/2, height/2 + 60);
}

void drawReady() {
  fill(255);
  textAlign(CENTER);
  textSize(32);
  text("Preparar?", width/2, height/2);
}

void drawGame() {
  fill(255);
  rect(20, paddle1Y, paddleWidth, paddleHeight);
  rect(width - 20 - paddleWidth, paddle2Y, paddleWidth, paddleHeight);
  ellipse(ballX, ballY, ballSize, ballSize);

  textSize(32);
  textAlign(CENTER);
  text(score1 + " : " + score2, width/2, 40);

  movePaddles();
}

void drawGameOver() {
  fill(255);
  textAlign(CENTER);
  textSize(32);
  String winner = score1 > score2 ? "Player 1 venceu!" : "Player 2 venceu!";
  if (singlePlayer) winner = score1 > score2 ? "Você venceu!" : "A IA venceu!";
  text(winner, width/2, height/2);
  textSize(20);
  text("Pressione ESPAÇO para reiniciar", width/2, height/2 + 40);
}

void movePaddles() {
  if (keyPressed) {
    if (key == 'w' || key == 'W') {
      paddle1Y -= paddleSpeed;
    }
    if (key == 's' || key == 'S') {
      paddle1Y += paddleSpeed;
    }
  }

  if (singlePlayer) {
    moveAI();
  } else {
    if (keyPressed) {
      if (keyCode == UP) {
        paddle2Y -= paddleSpeed;
      }
      if (keyCode == DOWN) {
        paddle2Y += paddleSpeed;
      }
    }
  }

  paddle1Y = constrain(paddle1Y, 0, height - paddleHeight);
  paddle2Y = constrain(paddle2Y, 0, height - paddleHeight);
}

void moveAI() {
  float target = ballY - paddleHeight / 2;
  float aiSpeed = 2;
  if (difficulty == 2) aiSpeed = 3.5;
  if (difficulty == 3) aiSpeed = 5;

  if (paddle2Y < target) paddle2Y += aiSpeed;
  else paddle2Y -= aiSpeed;
  paddle2Y = constrain(paddle2Y, 0, height - paddleHeight);
}

void updateBall() {
  if (!roundStarted) return;

  ballX += ballSpeedX;
  ballY += ballSpeedY;

  if (ballY < 0 || ballY > height) ballSpeedY *= -1;

  if (ballX - ballSize/2 < 30 && ballY > paddle1Y && ballY < paddle1Y + paddleHeight) {
    ballSpeedX *= -1.1;
    ballSpeedY = random(-4, 4);
  }

  if (ballX + ballSize/2 > width - 30 && ballY > paddle2Y && ballY < paddle2Y + paddleHeight) {
    ballSpeedX *= -1.1;
    ballSpeedY = random(-4, 4);
  }

  if (ballX < 0) {
    score2++;
    checkWin();
  } else if (ballX > width) {
    score1++;
    checkWin();
  }
}

void checkWin() {
  if (score1 >= winningScore || score2 >= winningScore) {
    gameState = GameState.GAME_OVER;
    roundStarted = false;
  } else {
    resetRound();
  }
}

void resetGame() {
  paddle1Y = paddle2Y = height / 2 - paddleHeight / 2;
  score1 = score2 = 0;
  roundStarted = false;
  gameState = GameState.MENU;
}

void resetRound() {
  ballX = width/2;
  ballY = height/2;
  roundStarted = false;

  if (score1 == 0 && score2 == 0) {
    ballSpeedX = 0;
    ballSpeedY = 0;
    gameState = GameState.READY;
  } else {
    startGame();  
  }
}

void startGame() {
  roundStarted = true;
  gameState = GameState.PLAYING;
  ballSpeedX = random(1) < 0.5 ? 4 : -4;
  ballSpeedY = random(-3, 3);
}

void keyPressed() {
  if (gameState == GameState.MENU) {
    if (key == '1') {
      singlePlayer = true;
      gameState = GameState.SELECT_DIFFICULTY;
    } else if (key == '2') {
      singlePlayer = false;
      gameState = GameState.READY;
    }
  } else if (gameState == GameState.SELECT_DIFFICULTY) {
    if (key >= '1' && key <= '3') {
      difficulty = int(key) - 48;
      gameState = GameState.READY;
    }
  } else if (gameState == GameState.READY) {
    if (key == ' ') {
      startGame();
    }
  } else if (gameState == GameState.GAME_OVER) {
    if (key == ' ') {
      resetGame();
    }
  }
}
