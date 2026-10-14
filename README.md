# Integrantes da Equipe

- **Ruan Pedro de Araujo Anjos**
- **Francisco Alves Ribeiro Neto**
- **Fabrício Fontenele Vieira**
- **Willamy Josué Santos Serejo**

---

# Hangman Game (Jogo da Forca)

Aplicação móvel desenvolvida em **Flutter/Dart** para a 1ª Avaliação da disciplina de **Programação para Dispositivos Móveis** da **Universidade Estadual do Piauí (UESPI)**, sob orientação do **Prof. Eyder Rios**.

O projeto consiste em uma versão completa e 100% offline do clássico Jogo da Forca, com suporte a respostas compostas por múltiplas palavras, tratamento de caracteres acentuados, preservação automática de espaços e hífens, controle de histórico sem repetições por sessão, estatísticas acumuladas e representação gráfica progressiva da forca.

---

## Principais Funcionalidades

- **Configuração da Partida (RF01, RF02):** Seleção de categorias (`animals`, `humanBody`, `sports`, `technology`) e níveis de dificuldade (`easy`, `medium`, `hard`) obtidos dinamicamente de dados estruturados em JSON, com validação e resumo da seleção antes do início.
- **Sorteio e Controle de Sessão (RF03, RF04, RF12):** Sorteio aleatório de respostas compatíveis com a categoria e dificuldade. Garantia de não repetição de respostas na mesma sessão até o esgotamento do banco, com tratamento e aviso ao usuário.
- **Tentativas Exclusivas por Letras (RF05):** Teclado virtual completo (A-Z) com feedback visual de letras disponíveis, corretas e incorretas. Seleções repetidas não penalizam o jogador.
- **Normalização e Tratamento de Caracteres (RF06):**
  - Comparação insensível a acentos (palpitar `A` revela `A`, `Á`, `À`, `Â` e `Ã`), mantendo a grafia original na interface.
  - Exibição automática e imediata de espaços, hífens e sinais não alfabéticos sem interação do jogador e sem interferir na contagem de vitória.
- **Controle de Erros e Forca Progressiva (RF07, RF08):** Limite de até 6 erros, com evolução gráfica correspondente a cada parte do corpo (cabeça, tronco, braço esquerdo, braço direito, perna esquerda e perna direita).
- **Sistema de Dicas (RF09):** Permite consultar dicas associadas à resposta atual, com controle de consumo único por rodada nas estatísticas da sessão.
- **Condições de Vitória e Derrota (RF10, RF11):** Verificação precisa do término da rodada, exibição do resultado detalhado, revelação da resposta e permissão de nova partida.
- **Estatísticas da Sessão (RF13):** Painel com contagem de rodadas realizadas, vitórias (quantidade e %), derrotas (quantidade e %), total de erros e dicas utilizadas. Armazenamento puramente em memória durante a execução do aplicativo.
- **Identificação da Equipe (RF14):** Tela com os nomes completos dos desenvolvedores acessível diretamente pela interface.

---

## Tecnologias Utilizadas

- **Linguagem:** Dart (versão ^3.13.1)
- **Framework:** Flutter (Material Design 3)
- **Gerenciamento de Estado:** `ChangeNotifier` nativo e `AnimatedBuilder` (sem dependências externas)
- **Arquitetura:** Clean Architecture / Separação de responsabilidades (Domain, Data, Presentation, Core)
- **Análise Estática & Padronização:** `flutter_lints` e aderência às diretrizes do *Effective Dart*

---

## Arquitetura da Solução

O código é estritamente estruturado em inglês nos identificadores técnicos e organizado segundo a separação de responsabilidades:

```text
lib/
├── core/
│   ├── routing/             # Rotas nomeadas da aplicação (AppRoutes)
│   └── theme/               # Paleta de cores, tipografia e temas (AppTheme)
├── data/
│   ├── models/              # Modelos para serialização/desserialização JSON (AnswerEntryModel)
│   └── repositories/        # Implementação do repositório via assets locais (AnswerRepositoryImpl)
├── domain/
│   ├── entities/            # Entidades do domínio do jogo (AnswerEntry, GameSession, SessionStats)
│   ├── enums/               # Tipos enumerados obrigatórios (AnswerCategory, Difficulty, RoundStatus, etc.)
│   ├── repositories/        # Contratos e interfaces de repositório (AnswerRepository)
│   └── services/            # Regras de negócio puras (GameRules, LetterNormalizer)
└── presentation/
    ├── controllers/         # Gerenciamento de estado da sessão (GameNotifier)
    ├── extensions/          # Mapeamento e tradução de enums para a interface em português
    └── screens/             # Telas da aplicação (HomeScreen, GameScreen, StatsScreen, DevelopersScreen)
```

---

## Instruções para Obtenção e Execução

### Pré-requisitos

- Flutter SDK instalado (versão 3.13.1 ou superior)
- Dart SDK configurado
- Dispositivo Android, emulador ou navegador para execução

### Passos de Execução

1. **Clonar o repositório:**

   ```bash
   git clone https://github.com/username/hangman-game.git
   cd hangman-game
   ```

2. **Obter as dependências do projeto:**

   ```bash
   flutter pub get
   ```

3. **Verificar a análise estática do código:**

   ```bash
   flutter analyze
   ```

4. **Executar a formatação do código:**

   ```bash
   dart format .
   ```

5. **Executar a aplicação:**

   ```bash
   flutter run
   ```

---

## Dependências Adicionais

A aplicação não utiliza bibliotecas externas além do próprio SDK do Flutter e dos linters padrão (`flutter_lints`), garantindo execução 100% offline e sem necessidade de conexão com banco de dados ou APIs remotas.
