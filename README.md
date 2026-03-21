# 📊 LH Nautical — Data Analytics Project

## 📌 Visão Geral

Projeto de Analytics Engineering desenvolvido para estruturar um pipeline de dados completo, transformando dados brutos em informações confiáveis para tomada de decisão.

O cenário simula a empresa LH Nautical, que enfrentava problemas de qualidade de dados e decisões baseadas em "feeling".

---

## 🧱 Arquitetura

![Arquitetura](./imagens/arquitetura.jpg)

Pipeline estruturado com arquitetura Medallion:

- **Raw** → ingestão de dados (CSV e JSON)  
- **Bronze** → limpeza e padronização  
- **Silver** → tratamento e validação  
- **Gold** → modelagem analítica e regras de negócio  

**Stack:**
Databricks (Delta Lake) • dbt • AWS S3 (conceitual) • Power BI • GitHub

---

## 📊 Modelo de Dados

### Fato

- **fct_vendas** (grão: 1 linha por venda)

  - sale_id  
  - customer_id  
  - product_id  
  - sale_date  
  - quantity  
  - receita_transacao_brl  
  - custo_unitario_brl  
  - custo_total_brl  
  - prejuizo_brl  
  - teve_prejuizo  

### Dimensões

- dim_cliente  
- dim_produto  
- dim_data  

### Marts

- fct_prejuizo_produto  
- mart_clientes_fieis  
- mart_categoria_top10_clientes  

---

## 📊 Principais Insights

### 💸 Prejuízo por falha de precificação

Produtos estavam sendo vendidos abaixo do custo real.

Cálculo baseado em:
- preço de venda (BRL)  
- custo histórico (USD)  
- câmbio da data da venda  

Regra aplicada:
- **última cotação válida anterior à venda**

**Impacto:**
- identificação de prejuízo real  
- evidência de falha operacional  
- suporte à tomada de decisão  

---

### 🧹 Inconsistência de categorias

Foram identificadas variações como:

- Eletrunicos, Eletronicoz, E L E T R Ô N I C O S  
- Prop, Propulçao, Propução  

Após padronização:

- eletrônicos  
- propulsão  
- ancoragem  

**Impacto:** garantiu consistência nas análises e evitou distorções.

---

### 📅 Viés por ausência de dados

Dias sem vendas não estavam sendo considerados, gerando médias infladas.

**Solução:**
- criação de dimensão de datas  
- inclusão de dias com venda = 0  

---

### 🧠 Limitação do modelo de recomendação

O modelo baseado em coocorrência:

- não considera ordem temporal  
- não considera quantidade  
- não considera perfil do cliente  

👉 Funciona como baseline, mas limitado para produção.

---

## 📊 Dashboard

![Visão Geral](./imagens/lh_1.png)

Principais análises:

- Receita ao longo do tempo  
- Ticket médio  
- Volume de vendas  
- Análise por cliente  

---

### 💸 Análise de Prejuízo

![Prejuízo](./imagens/lh_2.png)

Identificação de produtos com maior impacto financeiro negativo, tanto em valor absoluto quanto proporcional.

---

## 🧪 Notebooks

- Ingestão de dados  
- Transformações (Bronze)  
- Integração com API de câmbio  
- Cálculo de custos e prejuízo  
- Análises exploratórias  

---

## 📁 Estrutura do Projeto


```
📦 projeto
 ┣ 📂 dbt/           # Transformações e modelagem
 ┣ 📂 notebooks/     # Análises e etapas exploratórias
 ┣ 📂 data/          # Dados brutos
 ┣ 📂 docs/          # Documentação e relatórios
 ┣ 📂 powerbi/       # Dashboard
 ┗ 📂 imagens/       # Imagens utilizadas no README
```


---


---

## 🚀 Conclusão

O projeto resultou em um pipeline completo, confiável e escalável, permitindo:

- identificação de prejuízo real por produto  
- análises consistentes de vendas  
- suporte a decisões estratégicas  

E abre caminho para evoluções como:

- previsão de demanda  
- recomendação de produtos  
- análises avançadas  
