# Claude - Contexto Local | core

> Utilitários globais do projeto Flutter. Leia antes de usar ou modificar configurações de API.

---

## Arquivos

| Arquivo         | Responsabilidade                                              |
|-----------------|---------------------------------------------------------------|
| `api_config.dart` | URL base da API e formatação de URLs de imagem              |

## ApiConfig

**Referência**: `lib/core/api_config.dart`

Dois membros estáticos:

- `baseUrl` — lê `API_URL` do `.env` via `flutter_dotenv`. Fallback: `http://localhost:8090/api`.
- `formatImageUrl(String? url)` — formata URLs de imagem vindas da API para funcionar em emuladores/dispositivos físicos Android.

## Regra de Imagens (CRÍTICO)

**Sempre** passe URLs de imagem por `ApiConfig.formatImageUrl()` antes de usar em `Image.network()`.

**Por quê**: O backend retorna URLs com `localhost`, que não resolve no emulador Android (deve ser o IP da máquina). `formatImageUrl` substitui `localhost` pelo host configurado no `.env` automaticamente.

**Referência de uso**: `lib/views/home_screen.dart`, `lib/views/building_rooms_screen.dart`.

## Gotcha

- No Flutter Web (`kIsWeb`), `formatImageUrl` retorna a URL sem modificação — o browser resolve `localhost` normalmente.
- Se o `API_URL` no `.env` usar IP em vez de `localhost`, a substituição ainda funciona porque usa `Uri.parse(baseUrl).host`.

## Quando Adicionar Aqui

- Constantes globais de configuração (timeouts, headers padrão, etc.).
- Novos utilitários que não pertencem a nenhum domínio de negócio.
- **Não coloque** lógica de negócio ou chamadas HTTP aqui.
