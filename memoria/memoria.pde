int numPares = 6;
int numCartas = numPares * 2;
int[] cartas;
boolean[] viradas;
boolean[] encontradas;
int cartaSelecionada1 = -1;
int cartaSelecionada2 = -1;
int tentativas = 0;
int acertos = 0;
int comboAtual = 0; // << Novo: combo atual
int maiorCombo = 0; // << Novo: maior combo alcançado
int larguraCarta = 100;
int alturaCarta = 120;
PImage[] imagens;
PImage versoCarta;
String[] temas = {"frutas", "objetos", "personagens"};
String temaAtual = "frutas";
boolean jogoIniciado = false;
PFont fonteTitulo;
PFont fonteInstrucao;
PFont fonteTema;
color corFundo = color(220);
color corTexto = color(50);
color corBotao = color(100, 150, 200);
color corTextoBotao = color(255);
int botaoLargura = 150;
int botaoAltura = 40;
int botaoX;
int botaoY;
boolean jogoFinalizado = false;
boolean aguardandoPausa = false;
int tempoPausa = 1000;
int tempoVirada = 0;

String[][] linksTemas = {
  {
    "https://i.pinimg.com/736x/7d/21/ba/7d21bac43eab86e78d35454f664029c7.jpg",
    "https://i.pinimg.com/736x/6f/0c/b2/6f0cb27d1fd2257f841ee752f6d99f2d.jpg",
    "https://i.pinimg.com/736x/d5/b1/ee/d5b1ee043c6742daeb07f5d12d48591b.jpg",
    "https://i.pinimg.com/736x/10/66/e2/1066e21e625a23571fe52b85568739ac.jpg",
    "https://i.pinimg.com/736x/77/be/4c/77be4c593d50eaa9f1718103d29b203d.jpg",
    "https://i.pinimg.com/736x/f5/86/dc/f586dc149657d79f1b70b90553b3d2f1.jpg"
  },
  {
    "https://i.pinimg.com/736x/cc/44/a3/cc44a35b3d2b18a713c6938ee8d44e6a.jpg",
    "https://i.pinimg.com/736x/87/81/d6/8781d63e3eca2e5d8dc0fa6dfba3eb6c.jpg",
    "https://i.pinimg.com/736x/3d/90/6f/3d906f3c6794c81f60124687bb9d46c4.jpg",
    "https://i.pinimg.com/736x/3d/9a/a3/3d9aa3e0f0b9b9ff359b14f76e1ee780.jpg",
    "https://i.pinimg.com/736x/66/c0/52/66c052726391706e5b4c667e1e500dff.jpg",
    "https://i.pinimg.com/736x/29/1b/57/291b571a8ea862a2f0e6037d1a79ebb8.jpg"
  },
  {
    "https://i.pinimg.com/736x/08/ef/29/08ef29666fa9f82c8e80f3107f5b100a.jpg",
    "https://i.pinimg.com/736x/10/fc/ca/10fccaffa90ff7b6aeade229a0756ab5.jpg",
    "https://i.pinimg.com/736x/6a/25/f6/6a25f64b9b831504a797d27dcfe53330.jpg",
    "https://i.pinimg.com/736x/14/0c/24/140c248717e6a79b4eee30ef63e1e7d1.jpg",
    "https://i.pinimg.com/736x/56/a6/22/56a6220b5cd554d9ff00941025cf67cd.jpg",
    "https://i.pinimg.com/736x/00/e0/88/00e088ee0818afded34d683a5dbf4c90.jpg"
  }
};

void setup() {
  size(800, 600);
  fonteTitulo = createFont("Arial", 48, true);
  fonteInstrucao = createFont("Arial", 16, true);
  fonteTema = createFont("Arial", 20, true);
  textAlign(CENTER, CENTER);
  versoCarta = createImage(larguraCarta, alturaCarta, RGB);
  versoCarta.loadPixels();
  for (int i = 0; i < versoCarta.pixels.length; i++) versoCarta.pixels[i] = color(150);
  versoCarta.updatePixels();
  carregarTema(temaAtual);
  inicializarJogo();
  botaoX = width / 2 - botaoLargura / 2;
  botaoY = height - 100;
}

void draw() {
  background(corFundo);

  if (!jogoIniciado) {
    textFont(fonteTitulo);
    fill(corTexto);
    text("Jogo da Memória", width / 2, height / 4);
    textFont(fonteInstrucao);
    text("Selecione um tema e clique em Iniciar", width / 2, height / 3);
    float yTema = height / 2 - 40;
    for (String tema : temas) {
      fill(corTexto);
      if (tema.equals(temaAtual)) fill(255, 100, 100);
      textFont(fonteTema);
      text(tema, width / 2, yTema);
      yTema += 30;
    }
    fill(corBotao);
    rect(botaoX, botaoY, botaoLargura, botaoAltura, 10);
    textFont(fonteInstrucao);
    fill(corTextoBotao);
    text("Iniciar Jogo", width / 2, botaoY + botaoAltura / 2);
    return;
  }

  if (jogoFinalizado) {
    textFont(fonteTitulo);
    fill(corTexto);
    text("Parabéns, você venceu!", width / 2, height / 3);
    textFont(fonteTema);
    text("Você acertou " + acertos + " pares em " + tentativas + " tentativas.", width / 2, height / 2);
    text("Maior Combo: " + maiorCombo, width / 2, height / 2 + 30);
    textFont(fonteInstrucao);
    text("Clique para jogar novamente", width / 2, height - 50);
    return;
  }

  int espacoHorizontal = 15;
  int espacoVertical = 15;
  int cartasPorLinha = 4;
  int numLinhas = (int) ceil((float) numCartas / cartasPorLinha);
  float larguraTotalGrid = (cartasPorLinha * larguraCarta) + ((cartasPorLinha - 1) * espacoHorizontal);
  float alturaTotalGrid = (numLinhas * alturaCarta) + ((numLinhas - 1) * espacoVertical);
  float margemLateral = (width - larguraTotalGrid) / 2;
  float margemSuperior = (height - alturaTotalGrid) / 2;

  for (int i = 0; i < numCartas; i++) {
    int coluna = i % cartasPorLinha;
    int linha = i / cartasPorLinha;
    int x = (int) (coluna * (larguraCarta + espacoHorizontal) + larguraCarta / 2 + margemLateral);
    int y = (int) (linha * (alturaCarta + espacoVertical) + alturaCarta / 2 + margemSuperior);
    if (encontradas[i] || viradas[i]) {
      image(imagens[cartas[i]], x - larguraCarta / 2, y - alturaCarta / 2, larguraCarta, alturaCarta);
    } else {
      image(versoCarta, x - larguraCarta / 2, y - alturaCarta / 2, larguraCarta, alturaCarta);
    }
  }

  textFont(fonteInstrucao);
  fill(corTexto);
  textAlign(LEFT, TOP);
  text("Tentativas: " + tentativas, (int)margemLateral, 30);
  text("Acertos: " + acertos + " / " + numPares, (int)margemLateral, 50);
  text("Combo Atual: " + comboAtual, (int)margemLateral, 70);
  text("Maior Combo: " + maiorCombo, (int)margemLateral, 90);
  textAlign(CENTER, CENTER);

  if (aguardandoPausa && millis() - tempoVirada > tempoPausa) {
    if (cartas[cartaSelecionada1] == cartas[cartaSelecionada2]) {
      encontradas[cartaSelecionada1] = true;
      encontradas[cartaSelecionada2] = true;
      acertos++;
      comboAtual++;
      if (comboAtual > maiorCombo) maiorCombo = comboAtual;
      if (acertos == numPares) jogoFinalizado = true;
    } else {
      viradas[cartaSelecionada1] = false;
      viradas[cartaSelecionada2] = false;
      comboAtual = 0;
    }
    cartaSelecionada1 = -1;
    cartaSelecionada2 = -1;
    aguardandoPausa = false;
  }
}

void mousePressed() {
  if (jogoFinalizado) {
    jogoFinalizado = false;
    jogoIniciado = false;
    inicializarJogo();
    return;
  }
  if (!jogoIniciado) {
    float yTema = height / 2 - 55;
    for (int i = 0; i < temas.length; i++) {
      if (mouseX > width / 2 - 100 && mouseX < width / 2 + 100 &&
          mouseY > yTema - 15 && mouseY < yTema + 15) {
        temaAtual = temas[i];
        carregarTema(temaAtual);
        return;
      }
      yTema += 30;
    }
    if (mouseX > botaoX && mouseX < botaoX + botaoLargura &&
        mouseY > botaoY && mouseY < botaoY + botaoAltura) {
      jogoIniciado = true;
    }
    return;
  }

  if (aguardandoPausa) return;

  int espacoHorizontal = 15;
  int espacoVertical = 15;
  int cartasPorLinha = 4;
  float larguraTotalGrid = (cartasPorLinha * larguraCarta) + ((cartasPorLinha - 1) * espacoHorizontal);
  float margemLateral = (width - larguraTotalGrid) / 2;
  float margemSuperior = 100;

  for (int i = 0; i < numCartas; i++) {
    int coluna = i % cartasPorLinha;
    int linha = i / cartasPorLinha;
    int x = (int) (coluna * (larguraCarta + espacoHorizontal) + larguraCarta / 2 + margemLateral);
    int y = (int) (linha * (alturaCarta + espacoVertical) + alturaCarta / 2 + margemSuperior);

    if (!viradas[i] && !encontradas[i] &&
        mouseX > x - larguraCarta / 2 && mouseX < x + larguraCarta / 2 &&
        mouseY > y - alturaCarta / 2 && mouseY < y + alturaCarta / 2) {
      viradas[i] = true;
      if (cartaSelecionada1 == -1) {
        cartaSelecionada1 = i;
      } else if (cartaSelecionada2 == -1) {
        cartaSelecionada2 = i;
        tentativas++;
        tempoVirada = millis();
        aguardandoPausa = true;
      }
      break;
    }
  }
}

void inicializarJogo() {
  cartas = new int[numCartas];
  viradas = new boolean[numCartas];
  encontradas = new boolean[numCartas];
  for (int i = 0; i < numPares; i++) {
    cartas[i * 2] = i;
    cartas[i * 2 + 1] = i;
  }
  embaralharCartas();
  tentativas = 0;
  acertos = 0;
  comboAtual = 0;
  maiorCombo = 0;
  cartaSelecionada1 = -1;
  cartaSelecionada2 = -1;
}

void embaralharCartas() {
  for (int i = cartas.length - 1; i > 0; i--) {
    int j = (int) random(i + 1);
    int temp = cartas[i];
    cartas[i] = cartas[j];
    cartas[j] = temp;
  }
}

void carregarTema(String tema) {
  int indice = 0;
  for (int i = 0; i < temas.length; i++) {
    if (temas[i].equals(tema)) {
      indice = i;
      break;
    }
  }
  imagens = new PImage[numPares];
  for (int i = 0; i < numPares; i++) {
    imagens[i] = loadImage(linksTemas[indice][i]);
  }
}
