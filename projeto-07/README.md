# 🛍️ Análise de E-commerce (Olist Store) — Projeto de BI

Este projeto faz parte do meu portfólio e tem como objetivo demonstrar todas as etapas do processo de Business Intelligence (BI) aplicadas a um conjunto de dados reais de e-commerce brasileiro, disponibilizado de forma open-source pela Olist, a maior loja de departamentos do marketplace brasileiro.


## Sobre o Conjunto de Dados

Este conjunto de dados contém informações sobre **100 mil pedidos realizados entre 2016 e 2018** em diversos marketplaces no Brasil. Os dados foram gentilmente fornecidos pela **Olist**, que conecta pequenos lojistas a canais de venda online.

- Fonte: [Kaggle - Olist Store Dataset](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce)
- Formato original: `.csv`
- Período abrangido: **2016 a 2018**


## Tecnologias Utilizadas

- **SQL Server** — para carga, limpeza e modelagem dos dados
- **Power BI** — para criação do modelo analítico e visualizações
- **Linguagem SQL** — para tratamento e criação de views com o Modelo Estrela
- **Modelo Star Schema (Modelo Estrela)** — para estruturação do modelo dimensional


## Processo de BI Aplicado

Este projeto segue todas as etapas do processo de Business Intelligence:

### 1. Extração
- Dados extraídos do Kaggle em formato `.csv`. Acesse para obter os dados [**datasets**](https://github.com/WillianMonteiro23/projetos-sql/tree/main/projeto-07/datasets) 

### 2. Transformação 
- Importação dos arquivos via `Import Flat File` para o SQL Server.
- Script das etapas abaixo : [**DataProfiling_OLIST.sql**](https://github.com/WillianMonteiro23/projetos-sql/blob/master/projeto-07/DataProfiling_OLIST.sql)
    - Limpeza dos dados:
        - Remoção de valores nulos
        - Tratamento de duplicatas
        - Correção de espaços desnecessários
        - Padronização de tipos de dados
        - Ajustes em erros de digitação

### 3. Carga
- Criação das Views no banco com base no **modelo dimensional Star Schema**. [**StarSchema.sql**](https://github.com/WillianMonteiro23/projetos-sql/blob/master/projeto-07/StarSchema.sql)

## Modelagem e Visualização

A modelagem de dados seguiu o **modelo estrela**, com foco em desempenho analítico e clareza para construção dos dashboards no Power BI, extraímos views do SQLServer que continham as tabelas dimensões e a tabela fato. 

<div align='center'>
  <img src="https://github.com/WillianMonteiro23/projetos-sql/blob/main/projeto-07/starschema.png" width="50%"/>
</div>

### Principais Análises Desenvolvidas:

- As análises podem ser vistas no arquivo [**DashOlistEcommerce.pbix**](https://github.com/WillianMonteiro23/projetos-sql/blob/master/projeto-07/DashOlistEcommerce.pbix)
- 📈 **KPIs principais**: Faturamento Total, Ticket Médio, Volume de Vendas, Média de Satisfação do Cliente, Percentual de Entregas Antes do Prazo e Média de Dias entre Compra e Entrega dos Produtos.
- 🧮 **Classificação ABC** de produtos e clientes
- 🎯 **Análise de Pareto (80/20)** aplicada às vendas e faturamento
- 🧠 **Correlação de variáveis** para investigar a satisfação do cliente
- 📆 Evolução dos indicadores ao longo dos anos: **2016, 2017 e 2018**


## Esquema de Dados

Os dados foram organizados em tabelas relacionais para melhor entendimento e consistência nas análises.

<div align='center'>
  <img src="https://github.com/WillianMonteiro23/projetos-sql/blob/main/projeto-07/data_model.png" width="50%"/>
</div>


