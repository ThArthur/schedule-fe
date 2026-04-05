# Claude - Contexto Local | models

> Modelos de dados (Plain Dart classes) do projeto. Leia antes de criar ou modificar modelos.

---

## Arquivos

| Arquivo          | Classe      | Campos principais                                |
|------------------|-------------|--------------------------------------------------|
| `building.dart`  | `Building`  | `id?`, `name`, `number`, `complement`, `imageUrl?` |
| `room.dart`      | `Room`      | `id?`, `floor`, `number`, `buildingId`, `imageUrl?` |
| `user.dart`      | `User`      | `email`, `password` (não usado ativamente na app) |

## Padrão de Serialização

**Referência**: `lib/models/building.dart`, `lib/models/room.dart`

Todos os modelos implementam:
- `factory <Classe>.fromJson(Map<String, dynamic> json)` — desserialização da resposta da API.
- `Map<String, dynamic> toJson()` — serialização para envio na requisição.

**Importante**: `toJson()` **não inclui** `id` nem `imageUrl` — esses campos são gerenciados pelo backend e nunca enviados no body da requisição.

## Campos Opcionais

- `id` é `int?` — `null` quando o objeto ainda não foi persistido (criação).
- `imageUrl` é `String?` — `null` quando não há imagem. Sempre trate como nullable nas views.

## Gotcha

- `User` em `lib/models/user.dart` é uma classe simples com `email` e `password` — **não é** o modelo de usuário autenticado. Dados do usuário logado ficam em `AuthViewModel` (`_token`, `_role`, `_userName`).
- `Building.toJson()` não inclui `imageUrl` — o upload de imagem é feito separadamente como multipart. Ver `lib/view_models/building_view_model.dart`.

## Quando Adicionar Aqui

- Novos modelos de domínio que refletem entidades da API (Reservation, RoomPrice, RoomBlock).
- Siga sempre o padrão `fromJson` + `toJson` dos arquivos existentes.
- Não adicione lógica de negócio ou chamadas HTTP nos modelos.
