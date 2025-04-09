# Projeto de Vendas de café - Dados sujos para preparação e processamento de dados


## Descrição do Projeto
O dataset "Dirty Cafe Sales" reúne 10.000 registros fictícios de vendas realizadas em um café, com dados propositalmente desordenados. Ele foi projetado para refletir desafios reais enfrentados em projetos de análise de dados, apresentando lacunas, inconsistências e erros inseridos de forma intencional. Dentro desse projeto analisamos inconsistências, tratamos dados ausentes com inferências e correlações, reduzimos valores inválidos transformando-os em NULL, ajustamos tipos de dados para cálculos precisos, e eliminamos apenas registros irrelevantes para preservar a integridade e riqueza do conjunto.
Este conjunto de dados é uma excelente ferramenta para treinar habilidades como limpeza de informações, transformação de dados e criação de variáveis para análise aprofundada.

## Base de Dados
Este é um conjunto de dados que requer processamento e limpeza de dados, ideal para aperfeiçoamento de técnicas para uma das mais importantes tarefas no cotidiano trabalhando com dados. Temos um conjunto de dados com vendas de café, repleto de erros e inconsistências. A base de dados foi adquirida no [**Kaggle**](https://www.kaggle.com) e pode ser observada a seguir [**dirty_cafe_sales.csv**](https://github.com/WillianMonteiro23/projetos-sql/blob/main/projeto-03/dirty_cafe_sales.csv).

## Objetivos
- **Limpeza de Dados**: Substituir ou tratar valores ausentes, erros e demais inconsistências no conjunto de dados de forma cuidadosa e não agressiva, utilizando correlações e inferências para preencher informações e preservar a integridade dos dados. Apenas os registros irrelevantes, que não agregam valor, serão excluídos permanentemente.
- **Transformação de Dados**: Realizar alterações nos tipos de dados e aplicar outras transformações necessárias para que a base esteja pronta para uso em análises avançadas.
- **Exportação e Integração com Power BI**: Proporcionar uma base pronta para uso em ferramentas de análise, como Power BI, facilitando a visualização e interpretação dos dados financeiros.
- **Pre-Processamento em ferramentas distintas**: Utilizamos três ferramentas abrangentes no trabalho de processamento e limpeza de dados, Excel, SQLServer e PowerQuery.


## Etapas do Projeto

1. **Importação Inicial e Análise dos Dados**: Carregamento dos dados em SQL Server ou Obtenção de dados via Excel e identificação de inconsistências e elementos indesejados no conteúdo da base.

2. **Limpeza de Dados**:
   - Promoção dos cabeçalhos corretamente.
   - Remoção de valores ausentes, erros ou valores desconhecidos.
   - Padronização de tipos de dados.
   - Filtragem para obter dados limpos.
   - Condicionais para seleção de dados relevantes e combinação de colunas.
   - O script para do Pré-processamento e Limpeza dos dados se localiza aqui[**PreProcessing_FinancialsData.sql**](https://github.com/WillianMonteiro23/projetos-sql/blob/main/projeto-03/PreProcessing_DirtyCafeSales.sql).
   - O arquivo ChangeLog se encontra aqui [**changelog.xlsx**](https://github.com/WillianMonteiro23/projetos-sql/blob/main/projeto-03/changelog.xlsx).

3. **Exportação e Integração**:
   - Exportação dos dados tratados para um arquivo **.xlsx** [**processed_financial_data.xlsx**](https://github.com/WillianMonteiro23/projetos-sql/blob/main/projeto-03/dirty_cafe_sales.xlsx).
   - Conexão direta da base ao Power BI para análises e visualizações detalhadas.
   
## Conclusão
A limpeza de dados é uma etapa essencial em qualquer processo analítico, pois garante a integridade, precisão e confiabilidade das informações utilizadas para tomadas de decisão. Durante nosso trabalho, aprendemos a abordar inconsistências de forma estratégica e não destrutiva, utilizando correlações e inferências para recuperar informações valiosas, reduzindo significativamente os valores ausentes e erros sem comprometer o volume de dados.
Esse processo demonstrou que uma abordagem cuidadosa permite preservar a riqueza do conjunto de dados, extraindo insights úteis mesmo diante de limitações ou lacunas. Ao eliminar apenas registros irrelevantes e tratar inconsistências de maneira padronizada, asseguramos um conjunto coeso, preparado para análises precisas e decisões mais bem informadas. A limpeza de dados, portanto, não é apenas uma tarefa técnica, mas um investimento na qualidade e na confiabilidade dos resultados futuros.

