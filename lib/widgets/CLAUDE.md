# Claude - Contexto Local | widgets

> Componentes reutilizáveis da aplicação. Leia antes de criar novos widgets ou modificar os existentes.

---

## Arquivos

| Arquivo                 | Classe            | Responsabilidade                        |
|-------------------------|-------------------|-----------------------------------------|
| `custom_text_field.dart`| `CustomTextField` | Campo de texto com label uppercase e estilo visual padrão do app |

## CustomTextField

**Referência**: `lib/widgets/custom_text_field.dart`

Props:
- `controller` (obrigatório) — `TextEditingController`
- `label` (obrigatório) — exibido em uppercase com `letterSpacing: 1.2` acima do campo
- `isPassword` — default `false`; ativa `obscureText`
- `keyboardType` — default `TextInputType.text`
- `prefixIcon` — `IconData?`; ícone colorido com `theme.colorScheme.primary`

**Uso**: `lib/views/edit_building_screen.dart`, `lib/views/edit_room_screen.dart`, `lib/views/login_screen.dart`, `lib/views/register_screen.dart`.

## Convenções Visuais

Todos os widgets seguem o design system do app:
- Fundo branco `Colors.white` com `BoxShadow` sutil (`Colors.black.withOpacity(0.03-0.05)`)
- `BorderRadius.circular(12)` ou `circular(16)` para cards e inputs
- Cor primária (ouro `#D4AF37`) obtida de `Theme.of(context).colorScheme.primary`
- Textos escuros: `Color(0xFF1A1A1A)`
- Textos secundários: `Colors.grey[600]`

## Quando Adicionar Aqui

- Componentes usados em **mais de uma tela**.
- Widgets puramente visuais, sem estado de negócio.
- Não registre providers nem faça chamadas HTTP dentro de widgets.
- Siga o padrão visual de `CustomTextField` para manter consistência.
