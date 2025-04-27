# 📈 MARKETX - Análise e Extração de Dados

Projeto de análise de vendas da MARKETX, abrangendo desde a extração dos dados até o tratamento, validação e análise.
Durante o processo, foram realizadas verificações de inconsistências, ajustes e validações importantes para garantir a qualidade dos dados.
Ao final, obtivemos uma visão geral do desempenho da empresa, incluindo:

- Faturamento total
- Total de unidades vendidas
- Principais vendedores
- Desempenho por equipe de vendas (canais)

Além disso, foi realizada uma Análise ABC para identificar os produtos críticos que mais impactam o faturamento, utilizando o conceito de Pareto (80/20) — focando nos itens que representam a maior parcela da receita.


## 📄 Descrição

Este projeto visa estruturar um ambiente SQL para análise de dados de vendas, incluindo:

- Criação de database
- Extração de dados a partir de planilhas Excel
- Renomeação e limpeza de tabelas
- Análises estatísticas simples de faturamento e vendas
- Análise ABC por grupo de produtos
- **Conjunto dos Dados** [**Vendas.xlsx**](https://github.com/WillianMonteiro23/projetos-sql/blob/main/projeto-06/Vendas.xlsx)
- **Script Completo SQL** [**analysis_MARKETX.sql**](https://github.com/WillianMonteiro23/projetos-sql/blob/main/projeto-06/analysis_MARKETX.sql)
- **Roadmap EDA** [**roadmap_EDA.md**](https://github.com/WillianMonteiro23/projetos-sql/blob/main/projeto-06/roadmap_EDA.md)
- **Roadmap Analysis** [**roadmap_ANALYSIS.md**](https://github.com/WillianMonteiro23/projetos-sql/blob/main/projeto-06/roadmap_ANALYSIS.md)


## 🛠️ Tecnologias Utilizadas

- **SQL Server** (Microsoft SQL Server Management Studio - SSMS)
- **SQL** (Structured Query Language)
- **Excel (.xls)** para importação de dados


## ⚙️ Processo de Criação

### 1. Criação do Banco de Dados

```
CREATE DATABASE MARKETX;
USE MARKETX;
```

### 2. Extração dos Dados

- Utilização do SQL Server Import and Export Wizard.

- Conversão dos arquivos de .xlsx para .xls para compatibilidade com o driver OLEDB.

### 3. Renomeação da Tabela Importada

```
EXEC sp_rename 'Planilha1$', 'Vendas';
```

### 4. Análise Exploratória dos Dados (EDA)

- Verificação dos tipos de dados

- Identificação de inconsistências nos campos

- Validação de campos como Produto e CdProduto

- Checagem de dados categóricos como Grupo Produto, Linha Produto, Vendedor, Supervisor, Gerente, e Equipe Vendas

### 5.  Análises de Vendas

- Faturamento total

- Quantidade total de itens vendidos

- Faturamento e quantidade de vendas por vendedor

- Faturamento por equipe de vendas

### 6.  Análise ABC

- Classificação dos grupos de produtos em A, B e C com base no faturamento acumulado.

##  Observações

- Devido a limitações do driver OLEDB do SQL Server, foi necessário converter os arquivos de Excel de .xlsx para .xls.
 [**Vendas.xls**](https://github.com/WillianMonteiro23/projetos-sql/blob/main/projeto-06/Vendas.xls)

- As análises e validações são baseadas nos dados disponíveis no momento da importação.
