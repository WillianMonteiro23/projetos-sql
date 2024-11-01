# Projeto de Pré-Processamento e Tratamento de Dados Financeiros

## Descrição do Projeto
Este projeto tem como objetivo realizar o pré-processamento e tratamento de uma base de dados financeiros, com o foco em corrigir inconsistências e padronizar os dados para análises confiáveis e eficientes. A base foi importada de um arquivo CSV, processada e transformada no SQL Server para a remoção de caracteres indesejados, espaços extras e para ajustes nos tipos de dados. Em seguida, a base tratada foi exportada para um XLSX e também para um TXT além de ser integrada ao Power BI, potencializando o processo de obtenção de insights.

## Base de Dados
Este é um conjunto de dados que requer muito pré-processamento com insights EDA incríveis para uma empresa. Um conjunto de dados que consiste em dados de vendas e lucros classificados por segmento de mercado e país/região .A base de dados foi adquirida no [**Kaggle**](https://www.kaggle.com) e pode ser observada a seguir [**Financials.csv**](https://github.com/WillianMonteiro23/projetos-sql/blob/main/projeto-02/Financials.csv).

## Objetivos
- **Limpeza de Dados**: Remover espaços e caracteres que poluem os dados e prejudicam a análise, assegurando a consistência das informações.
- **Transformação de Dados**: Realizar alterações nos tipos de dados e aplicar outras transformações necessárias para que a base esteja pronta para uso em análises avançadas.
- **Exportação e Integração com Power BI**: Proporcionar uma base pronta para uso em ferramentas de análise, como Power BI, facilitando a visualização e interpretação dos dados financeiros.

## Importância do Pré-Processamento e Tratamento de Dados Financeiros
A preparação de dados é essencial para garantir a qualidade, precisão e consistência dos relatórios financeiros. Dados mal processados podem levar a interpretações incorretas e a decisões inadequadas. Tratar adequadamente a base de dados financeiros ajuda a:
1. **Evitar Erros de Interpretação**: Bases limpas e organizadas reduzem o risco de análises equivocadas.
2. **Facilitar o Compliance**: Bases tratadas tornam-se mais adequadas para auditorias e verificações de conformidade com normas.
3. **Agilizar a Análise de Dados**: Uma base organizada permite que os analistas dediquem mais tempo às decisões estratégicas.
4. **Automatizar Processos**: Dados bem estruturados são ideais para automação de relatórios e criação de dashboards dinâmicos.

## Etapas do Projeto

1. **Importação Inicial e Análise dos Dados**: Carregamento dos dados em SQL Server e identificação de inconsistências e elementos indesejados no conteúdo da base.
2. **Limpeza de Dados**:
   - Remoção de espaços extras e caracteres indesejados.
   - Padronização de tipos de dados para adequação às exigências de análise financeira.
3. **Exportação e Integração**:
   - Exportação dos dados tratados para um arquivo **.xlsx** [**processed_financial_data.xlsx**](https://github.com/WillianMonteiro23/projetos-sql/blob/main/projeto-02/processed_financial_data.xlsx) e também em arquivo **.txt** [**processed_financial_data.txt**](https://github.com/WillianMonteiro23/projetos-sql/blob/main/projeto-02/processed_financial_data.txt).
   - Conexão direta da base ao Power BI para análises e visualizações detalhadas.
   
## Conclusão
Esse processo de tratamento de dados financeiros é fundamental para a construção de uma base confiável, facilitando análises precisas e decisões bem informadas. O uso do Power BI como ferramenta de visualização maximiza o potencial da base de dados e otimiza o processo de obtenção de insights.
