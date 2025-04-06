import java.util.ArrayList;
import java.util.Collections;
import java.util.InputMismatchException;
import java.util.Random;
import java.util.Scanner;

public class marciano {

    static Scanner scanner = new Scanner(System.in);
    static Random random = new Random();
    static ArrayList<Recorde> recordes = new ArrayList<>();
    static final int TENTATIVAS_MAXIMAS = 8;
    static boolean jogadorAcertou = false;

    public static void main(String[] args) {
        introducaoDoJogo();
        boolean jogarNovamente = true;

        while (jogarNovamente) {
            jogadorAcertou = false;
            int numeroSecreto = jogarJogoDoMarciano();
            if (numeroSecreto != -1) {
                if (jogadorAcertou) {
                    exibirMenuPosJogo(numeroSecreto);
                } else {
                    System.out.println("Você não pode acessar o Desafio Final. Tente novamente no próximo jogo.");
                }
            }
            jogarNovamente = solicitarNovoJogo();
        }

        System.out.println("Obrigado por jogar!");
    }

    static void introducaoDoJogo() {
        System.out.println("Bem-vindo ao Jogo do Marciano!");
        System.out.println("Em uma galáxia distante, um Marciano travesso escondeu um número entre 01 e 99.");
        System.out.println("Sua missão é adivinhar esse número antes que ele fuja para outra dimensão!");
        System.out.println("Você terá " + TENTATIVAS_MAXIMAS + " tentativas para provar sua habilidade.");
        System.out.println("Boa sorte, Terráqueo!");
        System.out.println("------------------------------------------------------------------");
    }

    static int jogarJogoDoMarciano() {
        int numeroSecreto = random.nextInt(99) + 1;
        int tentativas = 0;
        boolean acertou = false;

        System.out.println("\nNovo jogo! Adivinhe o número entre 01 e 99.");

        while (tentativas < TENTATIVAS_MAXIMAS && !acertou) {
            tentativas++;
            System.out.println("Tentativas restantes: " + (TENTATIVAS_MAXIMAS - tentativas));
            int tentativa = obterTentativaDoJogador(tentativas);
            if (tentativa == -1) {
                return -1;
            }

            if (tentativa == numeroSecreto) {
                acertou = true;
                jogadorAcertou = true;
                System.out.println("Parabéns! Você acertou em " + tentativas + " tentativas!");
                atualizarRecordes(tentativas);
            } else if (tentativa < numeroSecreto) {
                System.out.println("O número secreto é maior.");
            } else {
                System.out.println("O número secreto é menor.");
            }
        }

        if (!acertou) {
            System.out.println("Você não conseguiu adivinhar em " + TENTATIVAS_MAXIMAS + " tentativas. O número era " + numeroSecreto + ".");
        }

        return numeroSecreto;
    }

    static int obterTentativaDoJogador(int tentativaNumero) {
        int tentativa;
        while (true) {
            try {
                System.out.print("Tentativa " + tentativaNumero + ": Digite sua tentativa (01 a 99, ou 0 para sair): ");
                tentativa = scanner.nextInt();
                scanner.nextLine();

                if (tentativa == 0) {
                    return -1;
                }

                if (tentativa >= 1 && tentativa <= 99) {
                    return tentativa;
                } else {
                    System.out.println("Tentativa inválida. Digite um número entre 01 e 99.");
                }
            } catch (InputMismatchException e) {
                System.out.println("Entrada inválida. Digite um número inteiro.");
                scanner.nextLine();
            }
        }
    }

    static void atualizarRecordes(int tentativas) {
        System.out.print("Digite seu nome para o recorde: ");
        String nome = scanner.nextLine();
        recordes.add(new Recorde(nome, tentativas));
        Collections.sort(recordes);
        exibirRecordes();
    }

    static void exibirRecordes() {
        System.out.println("\n--- Recordes ---");
        if (recordes.isEmpty()) {
            System.out.println("Nenhum recorde registrado ainda.");
        } else {
            for (int i = 0; i < Math.min(5, recordes.size()); i++) {
                System.out.println((i + 1) + ". " + recordes.get(i).nome + " - " + recordes.get(i).tentativas + " tentativas");
            }
        }
        System.out.println("------------------");
    }

    static void exibirMenuPosJogo(int numeroSecreto) {
        System.out.println("\nO que você deseja fazer agora?");
        System.out.println("1. Jogar Novamente");
        System.out.println("2. Ir para o Desafio Final");
        System.out.println("3. Sair");

        int escolha = obterEscolhaDoUsuario(1, 3);

        switch (escolha) {
            case 1:
                break;
            case 2:
                exibirLegendaDesafioFinal();
                desafioFinal(numeroSecreto);
                break;
            case 3:
                System.out.println("Obrigado por jogar!");
                System.exit(0);
                break;
        }
    }

    static int obterEscolhaDoUsuario(int min, int max) {
        int escolha;
        while (true) {
            try {
                System.out.print("Escolha uma opção: ");
                escolha = scanner.nextInt();
                scanner.nextLine();

                if (escolha >= min && escolha <= max) {
                    return escolha;
                } else {
                    System.out.println("Opção inválida. Escolha um número entre " + min + " e " + max + ".");
                }
            } catch (InputMismatchException e) {
                System.out.println("Entrada inválida. Digite um número inteiro.");
                scanner.nextLine();
            }
        }
    }

    static boolean solicitarNovoJogo() {
        System.out.print("\nVocê gostaria de jogar novamente? (s/n): ");
        char resposta = scanner.next().toLowerCase().charAt(0);
        scanner.nextLine();
        return (resposta == 's');
    }

    static void exibirLegendaDesafioFinal() {
        System.out.println("\n--- Legenda do Desafio Final ---");
        System.out.println("No Desafio Final, o feedback da sua tentativa será dado da seguinte forma:");
        System.out.println(" - Números entre parênteses '()' indicam que o dígito está presente no código, mas na posição incorreta.");
        System.out.println(" - Números entre colchetes '[]' indicam que o dígito está presente e na posição correta.");
        System.out.println(" - Números sem nenhum símbolo indicam que o dígito não está presente no código.");
        System.out.println("----------------------------------");
    }

    static void desafioFinal(int numeroJogoNormal) {
        System.out.println("\n--- Desafio Final ---");
        System.out.println("Você deve adivinhar a ordem correta de um código secreto de 5 dígitos.");
        int digito1 = numeroJogoNormal / 10;
        int digito2 = numeroJogoNormal % 10;
        System.out.println("Você já sabe que dois dos dígitos são: " + digito1 + " e " + digito2 + ".");
        System.out.println("Você tem 8 tentativas.");

        ArrayList<Integer> codigoSecreto = gerarCodigoSecreto(numeroJogoNormal);
        int tentativas = 0;
        boolean acertou = false;

        while (tentativas < TENTATIVAS_MAXIMAS && !acertou) {
            tentativas++;
            System.out.println("Tentativas restantes: " + (TENTATIVAS_MAXIMAS - tentativas));
            String tentativa = obterTentativaCodigo(tentativas);
            if (tentativa.equalsIgnoreCase("sair")) {
                System.out.println("Desafio Final encerrado.");
                return;
            }

            if (verificarTentativaCodigo(tentativa, codigoSecreto)) {
                acertou = true;
                System.out.println("Parabéns! Você acertou o código secreto!");
            } else {
                exibirFeedbackTentativa(tentativa, codigoSecreto, digito1, digito2);
            }
        }

        if (!acertou) {
            System.out.print("Você não conseguiu adivinhar o código secreto. O código era: ");
            for (int digito : codigoSecreto) {
                System.out.print(digito);
            }
            System.out.println();
        }
        System.out.println("----------------------");
    }

    static ArrayList<Integer> gerarCodigoSecreto(int numeroJogoNormal) {
        ArrayList<Integer> digitosDisponiveis = new ArrayList<>();
        for (int i = 0; i <= 9; i++) {
            digitosDisponiveis.add(i);
        }

        int digito1 = numeroJogoNormal / 10;
        int digito2 = numeroJogoNormal % 10;

        digitosDisponiveis.remove(Integer.valueOf(digito1));
        digitosDisponiveis.remove(Integer.valueOf(digito2));

        ArrayList<Integer> codigoSecreto = new ArrayList<>(Collections.nCopies(5, -1));

        int posicaoDigito1 = random.nextInt(5);
        codigoSecreto.set(posicaoDigito1, digito1);

        int posicaoDigito2;
        do {
            posicaoDigito2 = random.nextInt(5);
        } while (posicaoDigito2 == posicaoDigito1);
        codigoSecreto.set(posicaoDigito2, digito2);

        for (int i = 0; i < 5; i++) {
            if (codigoSecreto.get(i) == -1) {
                int indice = random.nextInt(digitosDisponiveis.size());
                codigoSecreto.set(i, digitosDisponiveis.remove(indice));
            }
        }

        return codigoSecreto;
    }

    static String obterTentativaCodigo(int tentativaNumero) {
        String tentativa;
        while (true) {
            System.out.print("Tentativa " + tentativaNumero + ": Digite um código de 5 dígitos ou 'sair': ");
            tentativa = scanner.nextLine().trim();
            if (tentativa.equalsIgnoreCase("sair") || tentativa.matches("\\d{5}")) {
                return tentativa;
            }
            System.out.println("Código inválido. Digite exatamente 5 dígitos.");
        }
    }

    static boolean verificarTentativaCodigo(String tentativa, ArrayList<Integer> codigoSecreto) {
        for (int i = 0; i < 5; i++) {
            if (Character.getNumericValue(tentativa.charAt(i)) != codigoSecreto.get(i)) {
                return false;
            }
        }
        return true;
    }

    static void exibirFeedbackTentativa(String tentativa, ArrayList<Integer> codigoSecreto, int digito1, int digito2) {
        StringBuilder feedback = new StringBuilder();
        for (int i = 0; i < 5; i++) {
            int digito = Character.getNumericValue(tentativa.charAt(i));
            if (digito == codigoSecreto.get(i)) {
                feedback.append("[").append(digito).append("]");
            } else if (codigoSecreto.contains(digito)) {
                feedback.append("(").append(digito).append(")");
            } else {
                feedback.append(digito);
            }
        }
        System.out.println("Feedback: " + feedback);
    }
}

class Recorde implements Comparable<Recorde> {
    String nome;
    int tentativas;

    Recorde(String nome, int tentativas) {
        this.nome = nome;
        this.tentativas = tentativas;
    }

    public int compareTo(Recorde outro) {
        return Integer.compare(this.tentativas, outro.tentativas);
    }
}
