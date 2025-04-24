# 📦 Análise de Classificação ABC-XYZ com SQL Server

Este projeto tem como objetivo aplicar técnicas de classificação **ABC-XYZ**, essenciais para a **gestão de estoques**, utilizando um **conjunto de dados sintético** extraído do [Kaggle](https://www.kaggle.com/). A análise foi feita com **SQL Server 2019**, sendo ideal para profissionais da cadeia de suprimentos, analistas de dados e estudantes que desejam praticar e entender essa abordagem.


##  Objetivo

O projeto simula cenários reais de demanda de produtos com o propósito de:

- Otimizar os níveis de estoque
- Reduzir custos operacionais
- Melhorar os níveis de serviço
- Apoiar a tomada de decisões baseadas em dados


##  Características da Base de Dados

- 1.000 itens únicos
- 5 categorias de produto:
  - Eletrônica
  - Mercado
  - Vestuário
  - Casa e Cozinha
  - Brinquedos
- 12 meses de dados de demanda (janeiro a dezembro)
- Valores de vendas anuais e preços unitários
- Classificações integradas:
  - **ABC** – priorização com base no valor das vendas
  - **XYZ** – estabilidade e variabilidade da demanda


##  Ferramentas Utilizadas

- **SQL Server 2019**
- **SQL Server Import and Export Wizard** (para extração dos dados)


##  Etapas do Projeto

### Script SQL - [**abc_xyz_analysis.sql**](https://github.com/WillianMonteiro23/projetos-sql/blob/main/projeto-05/abc_xyz_analysis.sql)


### 1. Extração dos Dados
Importação da base via **SQL Server Import and Export Wizard**, a partir da base de dados [**abc_xyz_dataset.txt**](https://github.com/WillianMonteiro23/projetos-sql/blob/main/projeto-05/abc_xyz_dataset.txt)


### 2. Análise Exploratória
- Verificação de valores nulos
- Remoção de duplicatas e espaços em branco
- Checagem de inconsistências gerais

### 3. Validação dos Dados
- Conferência da soma mensal de unidades vendidas com o total anual
- Validação do cálculo de faturamento (unidades \* preço unitário)

### 4. Classificação ABC
Utilizamos:
- CTEs (Common Table Expressions)
- Funções de janela
- Funções agregadoras

**Critérios:**
- Classe A: ~20% dos produtos responsáveis por ~80% do faturamento
- Classe B: ~30% dos produtos responsáveis por ~15% do faturamento
- Classe C: ~50% dos produtos responsáveis por ~5% do faturamento

### 5. Classificação XYZ
- Análise de variabilidade da demanda mensal
- Cálculo de desvio padrão e coeficiente de variação
- Técnicas como:
  - PIVOT
  - CTEs
  - Funções de janela e agregadoras

### 6. Análise Combinada ABC-XYZ
Integração das classificações para entender melhor:
- Quais produtos são críticos
- Quais produtos são estáveis ou imprevisíveis


