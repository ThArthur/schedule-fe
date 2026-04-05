# Claude - Bootloader de Sessão | Schedule FE (Psique Lounge)

> **INSTRUÇÃO FIXA**: Leia este arquivo na inicialização. Sua prioridade é eficiência de tokens e precisão técnica.

---

## Eficiência de Tokens (Token Economy)

- **Contexto Local**: Para detalhes de um módulo, leia o `CLAUDE.md` dentro do diretório correspondente antes de explorar arquivos.
- **Arquivos de Referência**: Nunca releia arquivos que já foram discutidos na sessão — use referências de caminho.
- **Respostas Diretas**: Vá direto ao código ou solução. Sem introduções.
- **Subagentes**: Use para exploração massiva (ex: varrer todas as views de uma vez), mantendo a janela principal limpa.
- **Incremental**: Não reexplique padrões já estabelecidos. Referencie pelo nome da classe/arquivo.

## Protocolo de Trabalho

1. **Ambiente**: O usuário entrega a branch — não execute operações git.
2. **Design**: Priorize simplicidade. Use o modo de planejamento para mudanças arquiteturais.
3. **Verificação**: Sempre rode `flutter analyze` antes de considerar a tarefa concluída.
4. **Auto-Aperfeiçoamento**: Errou? Salve uma memória `feedback` via sistema de memória do Claude.
5. **NUNCA faça commit**: Sem pedido explícito do usuário.
6. **Dúvidas sobre nova feature?**: Pergunte qual tela/ViewModel pode servir de referência — ver `lib/views/edit_building_screen.dart` para o padrão de formulário com imagem.
7. **Bugs**: Recebeu relatório → analise e conserte direto. Mínimo de context switching.

## Stack

- **Flutter** | Dart SDK `^3.10.3`
- **State management**: `provider ^6.1.1` (ChangeNotifier + ChangeNotifierProxyProvider)
- **HTTP**: `http ^1.1.0` + `http_parser ^4.0.2` (multipart)
- **Persistência local**: `shared_preferences ^2.2.1` (token JWT + role + nome)
- **UI**: `shimmer ^3.0.0` (loading skeleton), Material 3
- **Imagens**: `image_picker ^1.0.4`
- **Env**: `flutter_dotenv ^5.1.0` — arquivo `.env` na raiz

## Arquitetura (MVVM)

```
lib/
├── main.dart           # Entry point: configura MultiProvider, rota raiz
├── core/               # Utilitários globais (ver CLAUDE.md local)
├── models/             # Modelos de dados (ver CLAUDE.md local)
├── view_models/        # Lógica + chamadas HTTP (ver CLAUDE.md local)
│   └── admin/          # ViewModels com comportamento diferenciado para admin
├── views/              # Telas (ver CLAUDE.md local)
│   └── admin/          # Telas exclusivas de admin
└── widgets/            # Componentes reutilizáveis (ver CLAUDE.md local)
```

## Fluxo de Navegação

```
Startup → AuthViewModel._loadAuthData() (SharedPreferences)
  → não autenticado  → LoginScreen
  → autenticado ADMIN → HomeScreen      (BottomNav: Dashboard, Prédios, Agenda, Config)
  → autenticado USER  → UserHomeScreen  (BottomNav: Início, Meus Agendamentos, Perfil)
```

Não há `go_router` nem rotas nomeadas — navegação via `Navigator.push` com `MaterialPageRoute`.

## Tema Visual

- **Primary (ouro)**: `#D4AF37`
- **Secondary**: `#C5A028`
- **Dark**: `#1A1A1A` (fundo de botões, AppBar text)
- **Background**: `#FBFBFB`
- Material 3 habilitado (`useMaterial3: true`)
- Para obter o gold: `Theme.of(context).colorScheme.primary`

## Autenticação (CRÍTICO)

- Token JWT armazenado em `SharedPreferences` com chaves `token`, `role`, `userName`.
- Role extraída do payload JWT (campo `authorities[0].authority`) — ver `lib/view_models/auth_view_model.dart`.
- `isAdmin` = `role == 'ROLE_ADMIN'` (backend envia com prefixo `ROLE_`).
- Token propagado para outros ViewModels via `ChangeNotifierProxyProvider` → `updateToken()`.

## Variável de Ambiente

| Variável  | Default                     | Descrição                     |
|-----------|-----------------------------|-------------------------------|
| `API_URL` | `http://localhost:8090/api` | URL base da API Spring Boot   |

- Arquivo: `.env` (raiz do projeto, incluído como asset em `pubspec.yaml`).
- Acesso: `ApiConfig.baseUrl` — ver `lib/core/api_config.dart`.

## Gotcha

- Imagens no emulador/dispositivo Android: `ApiConfig.formatImageUrl()` substitui `localhost` pelo host do `API_URL`. Sempre use esse método ao exibir imagens — ver `lib/core/api_config.dart`.
- Há **dois** `RoomViewModel`: `lib/view_models/room_view_model.dart` (global) e `lib/view_models/admin/room_view_model.dart` (admin, com filtro por `buildingId`). Confirme qual usar antes de modificar.
- `DashboardScreen` tem dados **hardcoded** — ainda não consome API.
- Tabs `Meus Agendamentos` e `Perfil` em `UserHomeScreen` são stubs.

## Localização de Conhecimento (CLAUDE.md Locais)

- `lib/core`: Configuração de API e utilitário de URL de imagem.
- `lib/models`: Modelos de dados e padrão de serialização.
- `lib/view_models`: State management, chamadas HTTP e padrão de token.
- `lib/views`: Telas, navegação e padrões de UI.
- `lib/widgets`: Componentes reutilizáveis.

## Comandos

```bash
flutter run                     # Rodar em dispositivo/emulador conectado
flutter run -d chrome           # Rodar no navegador (web)
flutter build apk               # Build Android
flutter analyze                 # Análise estática (lint)
flutter test                    # Rodar testes
flutter pub get                 # Instalar dependências
```

---
**App Name**: Psique Lounge | **Backend**: `schedule` (Spring Boot, porta 8090)
