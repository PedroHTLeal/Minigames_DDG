String[] wordList = {"barcelona", "riachuelo", "hipismo", "ampulheta", "madagascar"};
String[] wordHints = {
  "Time europeu",
  "Loja de roupas",
  "Esporte olímpico",
  "Objeto",
  "País"
};
String secretWord;
String wordHint;
char[] guessedWordDisplay;
boolean[] guessedLetters;
int incorrectGuesses = 0;
int maxGuesses = 6;
boolean gameOver = false;
String gameResult = "";

color backgroundColor = color(204, 255, 204);
color hangmanColor = color(0);
color textColor = color(0, 0, 102);
color hintColor = color(0, 0, 102);
color resultTextColor = color(0, 0, 102);
color resultBackgroundColor = color(204, 255, 204);

void setup() {
  size(600, 400);
  startGame();
}

void draw() {
  background(backgroundColor);
  drawHangman();
  displayWord();
  displayGuesses();
  displayHint(); // Adiciona a exibição da dica
  checkGameOver();

  if (gameOver) {
    displayFinalScreen();
  }
}

void startGame() {
  selectWord();
  initializeGame();
}

void selectWord() {
  int randomIndex = floor(random(wordList.length));
  secretWord = wordList[randomIndex].toUpperCase();
  wordHint = wordHints[randomIndex];
}

void initializeGame() {
  guessedWordDisplay = new char[secretWord.length()];
  guessedLetters = new boolean[26]; // A-Z
  for (int i = 0; i < secretWord.length(); i++) {
    guessedWordDisplay[i] = '_';
  }
  incorrectGuesses = 0;
  gameOver = false;
  gameResult = "";
}

void drawHangman() {
  stroke(hangmanColor);
  strokeWeight(2);
  // Base
  line(100, 350, 200, 350);
  line(150, 350, 150, 100);
  line(150, 100, 250, 100);
  line(250, 100, 250, 150);

  if (incorrectGuesses > 0) {
    // Cabeça
    ellipse(250, 175, 25, 25);
  }
  if (incorrectGuesses > 1) {
    // Corpo
    line(250, 200, 250, 275);
  }
  if (incorrectGuesses > 2) {
    // Braço esquerdo
    line(250, 220, 220, 240);
  }
  if (incorrectGuesses > 3) {
    // Braço direito
    line(250, 220, 280, 240);
  }
  if (incorrectGuesses > 4) {
    // Perna esquerda
    line(250, 275, 220, 295);
  }
  if (incorrectGuesses > 5) {
    // Perna direita
    line(250, 275, 280, 295);
  }
}

void displayWord() {
  fill(textColor);
  textSize(32);
  textAlign(LEFT); // Alinha o texto à esquerda
  text(new String(guessedWordDisplay), 300, 150); // Exibe a palavra à direita da forca
}

void displayGuesses() {
  fill(textColor);
  textSize(16);
  textAlign(LEFT);
  text("Tentativas restantes: " + (maxGuesses - incorrectGuesses), 300, 200);
  String guessed = "Letras chutadas: ";
  for (int i = 0; i < 26; i++) {
    if (guessedLetters[i]) {
      guessed += char(i + 'A') + " ";
    }
  }
  text(guessed, 300, 230);
}

void displayHint() {
  fill(hintColor);
  textSize(20); // Dica maior
  textAlign(LEFT);
  text("Dica: " + wordHint, 300, 100); // Exibe a dica
}

void checkGameOver() {
  boolean won = true;
  for (char c : guessedWordDisplay) {
    if (c == '_') {
      won = false;
      break;
    }
  }

  if (won) {
    gameOver = true;
    gameResult = "Você venceu!";
  } else if (incorrectGuesses >= maxGuesses) {
    gameOver = true;
    gameResult = "Você perdeu! A palavra era: " + secretWord;
  }
}

void displayFinalScreen() {
  background(resultBackgroundColor);
  fill(resultTextColor);
  textSize(24);
  textAlign(CENTER, CENTER);
  text(gameResult, width / 2, height / 2);
  textSize(16);
  text("Pressione qualquer tecla para jogar novamente", width / 2, height / 2 + 30);
}

void keyPressed() {
  if (gameOver) {
    startGame(); // Inicia um novo jogo com uma palavra diferente
  } else {
    char guess = char(keyCode);
    if (guess >= 'A' && guess <= 'Z') {
      if (!guessedLetters[guess - 'A']) {
        guessedLetters[guess - 'A'] = true;
        boolean correctGuess = false;
        for (int i = 0; i < secretWord.length(); i++) {
          if (secretWord.charAt(i) == guess) {
            guessedWordDisplay[i] = guess;
            correctGuess = true;
          }
        }
        if (!correctGuess) {
          incorrectGuesses++;
        }
      }
    }
  }
}