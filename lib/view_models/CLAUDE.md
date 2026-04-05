# Claude - Contexto Local | view_models

> State management e chamadas HTTP da aplicação. Leia antes de criar ou modificar ViewModels.

---

## Arquivos

| Arquivo                         | Classe              | Responsabilidade                                      |
|---------------------------------|---------------------|-------------------------------------------------------|
| `auth_view_model.dart`          | `AuthViewModel`     | Login, registro, logout, persistência de token/role   |
| `building_view_model.dart`      | `BuildingViewModel` | CRUD de prédios + upload de imagem                    |
| `room_view_model.dart`          | `RoomViewModel`     | CRUD de salas globais + filtro por building           |
| `admin/room_view_model.dart`    | `RoomViewModel`     | Variante admin com `buildingId` obrigatório em fetch  |

## Padrão de ViewModel (CRÍTICO)

**Referência**: `lib/view_models/building_view_model.dart`

Todo ViewModel de recurso segue:
- Estende `ChangeNotifier`
- Estado interno: lista do recurso, `_isLoading`, `_token`
- `updateToken(String? token)` — chamado pelo `ChangeNotifierProxyProvider` quando o token muda
- Retorno booleano nas operações de escrita (`true` = sucesso)
- `notifyListeners()` **sempre** após mudar estado (inclusive em `finally`/catch)

## Propagação de Token

**Referência**: `lib/main.dart`

ViewModels que precisam do JWT usam `ChangeNotifierProxyProvider`:
- `AuthViewModel` é a fonte do token
- `BuildingViewModel` e `RoomViewModel` recebem o token via `updateToken()` a cada mudança de `AuthViewModel`
- **Nunca** passe o token diretamente de uma View — sempre consuma pelo ProxyProvider

## Autenticação — AuthViewModel

**Referência**: `lib/view_models/auth_view_model.dart`

- Token decodificado manualmente via base64url do payload JWT (sem biblioteca)
- Campos persistidos: `token`, `role`, `userName` no `SharedPreferences`
- `isAdmin` = `role == 'ROLE_ADMIN'` (backend envia com prefixo `ROLE_`)
- `_loadAuthData()` é chamado no construtor — app restaura sessão automaticamente no startup

## Upload de Imagens

**Referência**: `lib/view_models/building_view_model.dart` (métodos `createBuilding`, `updateBuilding`)

Requisições com imagem usam `http.MultipartRequest`:
- Part JSON: campo `'building'` ou `'room'`, `contentType: application/json`
- Part imagem: campo `'image'`, `File? imageFile` (opcional)
- Após sucesso, chama `fetchBuildings()`/`fetchRooms()` para atualizar o estado local

## Duas Versões de RoomViewModel (GOTCHA)

| Localização                          | Diferença principal                                       |
|--------------------------------------|-----------------------------------------------------------|
| `lib/view_models/room_view_model.dart`    | `deleteRoom(int id)` — sem buildingId                |
| `lib/view_models/admin/room_view_model.dart` | `deleteRoom(int id, int buildingId)` + `fetchRooms({int? buildingId})` |

- O `main.dart` registra o **global** (`lib/view_models/room_view_model.dart`)
- O admin variant pode ser instanciado localmente em telas admin específicas
- Confirme qual usar antes de modificar qualquer um

## Convenções

- Operações de leitura: sem anotação especial — são métodos `Future<void>` simples
- Operações de escrita: retornam `Future<bool>` — as views exibem feedback baseado no resultado
- Erros de rede: capturados com `try/catch`, logados com `debugPrint`, retornam `false` — **sem rethrow**
- Nunca exponha `_token` diretamente às views

## Quando Adicionar um Novo ViewModel

- Crie em `lib/view_models/<recurso>_view_model.dart`
- Siga o padrão de `building_view_model.dart` como referência
- Se precisar do token, registre no `main.dart` como `ChangeNotifierProxyProvider`
