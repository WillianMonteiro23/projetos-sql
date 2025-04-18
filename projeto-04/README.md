# 📊 Projeto de ETL e Análise com SQL — Locadora de Veículos

Este projeto consiste em um processo de ETL (Extração, Transformação e Carga) utilizando SQL Server sobre dados de uma locadora de veículos. Os dados são originalmente extraídos de planilhas Excel, tratados e carregados em um banco relacional para posterior análise.

Após a carga dos dados tratados, foram criadas *views* específicas para facilitar e padronizar as análises, permitindo responder perguntas relevantes do negócio com mais clareza, assertividade e agilidade.


## ❓ Perguntas Respondidas na Análise

A partir das *views* construídas no banco de dados, foram realizadas análises para responder as seguintes perguntas:

-  **Total de clientes?**
-  **Existem clientes não cadastrados? Se sim quais?**
-  **Faturamento total?**
-  **Percentual de clientes inadimplentes?**
-  **Recebíveis inadimplentes?**
-  **Faturamento ao longo dos anos?**
-  **Marcas mais locadas?**
-  **Cidades mais locatárias?**
-  **Top 5 clientes (com maior valor total de locação)?**
-  **Tabela com nome, marca, modelo, valor de locação e ano?**

## 📁 Estrutura do Projeto

- **Script SQL:** [**LocadoraVeiculosETL_Analisys.sql**](https://github.com/WillianMonteiro23/projetos-sql/blob/main/projeto-04/LocadoraVeiculosETL_Analisys.sql)
- **Banco de Dados:** `LOCADORA_VEICULOS`
- **Fonte dos Dados:** [**locacao_veiculos_copy.xls**](https://github.com/WillianMonteiro23/projetos-sql/blob/main/projeto-04/locacao_veiculos_copy.xls)


## ⚙️ Tecnologias Utilizadas

- SQL Server
- Transact-SQL (T-SQL)
- Excel (.xls)
- Ambiente de desenvolvimento: SSMS (SQL Server Management Studio)

## 🔄 Etapas do Processo ETL

###  Extração

Devido a limitações do driver OLEDB, o arquivo Excel foi salvo no formato antigo `.xls` (Excel 97-2003) para permitir a importação correta no SQL Server.

###  Transformação

As principais transformações aplicadas foram:

- Renomeação de tabelas com `sp_rename`
- Remoção de colunas desnecessárias
- Tratamento de valores nulos
- Criação de views auxiliares para análise
- Conversões de tipo e normalizações

###  Carga

Os dados tratados foram carregados em *views* que podem posteriormente serem usadas no PowerBi para análises gráficas por exemplo, com inserções limpas e colunas estruturadas.


## Observações

- A extração dos dados possui inconveniências devido à instalação do SQL Server. Quando tentamos importar uma planilha Excel, ocorre um problema pois o SQL Server não consegue encontrar o **engine OLEDB.12** para importação.  
- Isso ocorre porque o SQL Server depende de drivers OLEDB para abrir arquivos Excel, e o driver padrão instalado não entende o formato novo `.xlsx`.
- Como solução rápida, o arquivo Excel foi salvo em uma versão antiga (**Excel 97-2003 (.xls)**), o que permitiu a extração dos dados sem problemas.
- O processo foi desenvolvido com foco em ambientes locais com SQL Server instalado.


## Como Executar

1. Abra o SQL Server Management Studio (SSMS) - *Utilizamos o SQLSERVER 2019*
2. Execute o script `LocadoraVeiculosETL_Analisys.sql`
3. Siga os comentários no script para entender cada etapa do processo
4. Execute com os roadmaps abertos para compreensão das soluções [**roadmap_Analysis_Locadora_Veiculos.md**](https://github.com/WillianMonteiro23/projetos-sql/blob/main/projeto-04/roadmap_Analysis_Locadora_Veiculos.md) e [**roadmap_ETL_Locadora_Veiculos.md**](https://github.com/WillianMonteiro23/projetos-sql/blob/main/projeto-04/roadmap_ETL_Locadora_Veiculos.md)


## Possibilidades de Expansão

- Criação de dashboards com Power BI
- Integração com Python para análises automatizadas


## Autor

Este projeto foi desenvolvido com fins educacionais para explorar processos de ETL e análise de dados com SQL.


