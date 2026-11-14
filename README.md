# ecogestao-movel-mvp
MVP do aplicativo EcoGestão Móvel para triagem e pesagem offline de resíduos recicláveis (ODS 12 / Meta 12.5).
# EcoGestão Móvel — MVP (ODS 12)

Aplicativo móvel desenvolvido em **Flutter/Dart** para registro de triagem e pesagem de resíduos recicláveis em cooperativas, focado em operação *offline-first* e acessibilidade severa no chão de fábrica.

## Alinhamento e Requisitos
* **ODS 12 (Meta 12.5):** Precisão nos dados locais de pesagem e transparência no rateio da cooperativa.
* **RNF01 (Offline-First):** Persistência local sem dependência de conexão ativa no galpão.
* **RNF02 (Desempenho):** Gravação local SQLite em $< 30\text{ ms}$ e resposta de interface $< 1,5\text{ s}$.
* **RNF03 (Imutabilidade e Segurança):** Geração de comprovante sequencial (`#00459`) e hash local.
* **RNF04 (Acessibilidade):** Áreas de toque mínimas de $80 \times 80\text{ dp}$, contraste WCAG AA ($\ge 4,5:1$) e feedback háptico/multimodal para operadores com luvas de proteção.
