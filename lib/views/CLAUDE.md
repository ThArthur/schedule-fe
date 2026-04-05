# Claude - Contexto Local | views

> Telas da aplicação Psique Lounge. Leia antes de criar ou modificar telas.

---

## Mapa de Telas

| Arquivo                         | Classe                  | Acesso       | Descrição                                  |
|---------------------------------|-------------------------|--------------|--------------------------------------------|
| `login_screen.dart`             | `LoginScreen`           | Público       | Formulário de login                        |
| `register_screen.dart`          | `RegisterScreen`        | Público       | Formulário de cadastro                     |
| `home_screen.dart`              | `HomeScreen`            | ADMIN         | Shell com BottomNav (Dashboard/Prédios/Agenda/Config) |
| `user_home_screen.dart`         | `UserHomeScreen`        | USER          | Shell com BottomNav (Início/Agendamentos/Perfil) |
| `dashboard_screen.dart`         | `DashboardScreen`       | ADMIN         | Cards de stats + atividade recente (dados hardcoded) |
| `building_rooms_screen.dart`    | `BuildingRoomsScreen`   | ADMIN/USER    | Lista de salas de um prédio                |
| `edit_building_screen.dart`     | `EditBuildingScreen`    | ADMIN         | Criar/editar prédio com imagem             |
| `edit_room_screen.dart`         | `EditRoomScreen`        | ADMIN         | Criar/editar sala com imagem               |
| `calendar_screen.dart`          | `CalendarScreen`        | ADMIN         | Tela de agenda (em desenvolvimento)        |
| `room_prices_screen.dart`       | `RoomPricesScreen`      | ADMIN         | Gerenciar preços de uma sala               |
| `settings_screen.dart`          | `SettingsScreen`        | ADMIN         | Configurações                              |
| `admin/building_rooms_screen.dart` | `BuildingRoomsScreen` | ADMIN        | Variante admin de building_rooms           |

## Padrão de Formulário com Imagem

**Referência**: `lib/views/edit_building_screen.dart`, `lib/views/edit_room_screen.dart`

Telas de criar/editar seguem o padrão:
- `StatefulWidget` com `TextEditingController` por campo
- `File? _image` para imagem local selecionada via `ImagePicker`
- `bool _isSaving` para desabilitar botão durante requisição
- Argumento opcional `<Model>? <entidade>` — `null` = modo criação, não-null = modo edição
- `Navigator.pop(context)` após sucesso; `ScaffoldMessenger.showSnackBar` em caso de erro
- Usa `context.read<ViewModel>()` para mutações (não observa o estado)

## Padrão de Lista com Loading

**Referência**: `lib/views/home_screen.dart`

- Loading state: `Shimmer.fromColors` skeleton (ver `lib/views/home_screen.dart` método `_buildShimmerLoading`)
- Lista vazia: estado `empty state` com ícone + texto + botão de ação
- `RefreshIndicator` envolve o `ListView` para pull-to-refresh

## Consumo de ViewModels nas Views

- **Leitura de estado**: `Consumer<ViewModel>` ou `context.watch<ViewModel>()`
- **Mutações**: `context.read<ViewModel>().método()` — não usa `watch` para evitar rebuilds desnecessários
- **Acesso ao AuthViewModel**: `Provider.of<AuthViewModel>(context)` ou `context.read/watch`

## Navegação

- Todas as navegações são imperativas: `Navigator.push(context, MaterialPageRoute(...))`
- Não há rotas nomeadas nem `go_router`
- Telas de detalhe/edição recebem dados via construtor (não via parâmetros de rota)

## Telas em Desenvolvimento (Stubs)

- `DashboardScreen` — dados hardcoded, ainda não consome API
- `CalendarScreen` — tela vazia
- `SettingsScreen` — tela vazia
- `UserHomeScreen` tabs 1 (Agendamentos) e 2 (Perfil) — `Center(child: Text(...))`

## Gotcha

- `HomeScreen` e `UserHomeScreen` usam `WidgetsBinding.instance.addPostFrameCallback` no `initState` para buscar dados após o primeiro frame — evita chamar `setState` durante build.
- Imagens em cards **devem** passar por `ApiConfig.formatImageUrl()` — ver `lib/core/api_config.dart`.
- `edit_building_screen.dart` exibe a imagem existente via URL do servidor ao editar, mas sobrepõe com `FileImage` local quando o usuário seleciona uma nova.

## Quando Adicionar uma Nova Tela

- Arquivo em `lib/views/<nome>_screen.dart` (snake_case)
- Classe `<Nome>Screen` (PascalCase)
- Telas exclusivas de admin: `lib/views/admin/<nome>_screen.dart`
- Use `lib/views/edit_building_screen.dart` como referência para formulários com imagem
- Use `lib/widgets/custom_text_field.dart` para campos de texto
