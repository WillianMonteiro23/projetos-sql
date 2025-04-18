# Tratamento de Dados: Passo a Passo

## 1. Criação do Banco de Dados
O primeiro passo foi criar e conectar nesse banco de dados para receber a tabela com os dados a serem tratados.

```
CREATE DATABASE LOCADORA_VEICULOS;
USE LOCADORA_VEICULOS;
```

## 2. Extração por forma visual do SQL Server 2019
O primeiro passo foi criar e conectar nesse banco de dados para receber a tabela com os dados a serem tratados.
A extração dos dados possui inconveniências devido à instalação do SQL Server. Quando tentamos importar uma planilha Excel, ocorre um problema pois o SQL Server não consegue encontrar o **engine OLEDB.12** para importação.  
Isso ocorre porque o SQL Server depende de drivers OLEDB para abrir arquivos Excel, e o driver padrão instalado não entende o formato novo `.xlsx`.
Como solução rápida, o arquivo Excel foi salvo em uma versão antiga (**Excel 97-2003 (.xls)**), o que permitiu a extração dos dados sem problemas.

### Passo a Passo da Extração

#### - Botão direito no banco desejado > Tasks > Import Data

<div align='center'>
  <img src="https://github.com/WillianMonteiro23/projetos-sql/blob/main/projeto-04/images/1.png" width="70%"/>
</div>

#### - Clicar em Next
<div align='center'>
  <img src="https://github.com/WillianMonteiro23/projetos-sql/blob/main/projeto-04/images/2.png" width="70%"/>
</div>

#### - Selecionar o DataSource para Excel > Buscar pelo `locacao_veiculos.xlsx` 
#### - Apresenta um erro pois o SQL Server não consegue encontrar o **engine OLEDB.12**

<div align='center'>
  <img src="https://github.com/WillianMonteiro23/projetos-sql/blob/main/projeto-04/images/3.png" width="70%"/>
</div>

#### - Abra o arquivo .xlsx e salve em **Excel 97-2003 (.xls)** > nomear como `locacao_veiculos_copy.xls`

<div align='center'>
  <img src="https://github.com/WillianMonteiro23/projetos-sql/blob/main/projeto-04/images/4.png" width="70%"/>
</div>

#### - Execute os 3 primeiros passos mas agora selecione o arquivo `locacao_veiculos_copy.xls`

<div align='center'>
  <img src="https://github.com/WillianMonteiro23/projetos-sql/blob/main/projeto-04/images/5.png" width="70%"/>
</div>

#### - Selecione como destino `SQL Server Native Client 11.0` > Autenticação Windows > LOCADORA_VEICULOS > Next

<div align='center'>
  <img src="https://github.com/WillianMonteiro23/projetos-sql/blob/main/projeto-04/images/6.png" width="70%"/>
</div>

#### - Selecione a opção de copiar todos os dados da fonte > Next

<div align='center'>
  <img src="https://github.com/WillianMonteiro23/projetos-sql/blob/main/projeto-04/images/7.png" width="70%"/>
</div>

#### - Selecione a tabela de interesse, `RASTREADOR$` nesse caso > Next

<div align='center'>
  <img src="https://github.com/WillianMonteiro23/projetos-sql/blob/main/projeto-04/images/8.png" width="70%"/>
</div>

#### - Run Imediately, sem usar os pacotes do SSIS > Next

<div align='center'>
  <img src="https://github.com/WillianMonteiro23/projetos-sql/blob/main/projeto-04/images/9.png" width="70%"/>
</div>

#### - Finish

<div align='center'>
  <img src="https://github.com/WillianMonteiro23/projetos-sql/blob/main/projeto-04/images/10.png" width="70%"/>
</div>

#### - Os dados estão prontos para uso

<div align='center'>
  <img src="https://github.com/WillianMonteiro23/projetos-sql/blob/main/projeto-04/images/11.png" width="70%"/>
</div>

#### - Refaça os mesmos passos para extrair a tabela `Planilha1$` de `clientes.xlsx`

## 3. Tratando planilha locacao_veiculos_copy.xls

### Renomeando tabela "RASTREADOR$" -> Rastreador

```
EXEC sp_rename 'RASTREADOR', 'Rastreador';
```

### Explorando os dados

```
SELECT 
	* 
FROM 
	[LOCADORA_VEICULOS].[dbo].[Rastreador];
```


### Valores Nulos e Colunas desnecessárias estão poluindo os dados

```
SELECT
	ID_CLIENTE,
	MARCA,
	PLACA,
	KILOMETRO_PERCORRIDO,
	ANO,
	[VALOR POR KM],
	[SITUAÇÃO CADASTRAL]
FROM
	[LOCADORA_VEICULOS].[dbo].[Rastreador]
WHERE
	ID_CLIENTE IS NOT NULL;
```

### Analisando os tipos das colunas

```
EXEC sp_help 'Rastreador';
```

### Enriquecimento dos dados criando coluna para valor da locação (KM_PERCORRIDO * VALOR POR KM).
### Além de fazer o De -> PARA da situação cdastral 1 é PAGO e 2 é NÃO PAGO, de acordo com a documentação que nos informaram

```
SELECT
	ID_CLIENTE,
	SUBSTRING(TRIM(MARCA), 1, CHARINDEX(' ', TRIM(MARCA)) - 1) AS MARCA,
	SUBSTRING(TRIM(MARCA), CHARINDEX(' ', TRIM(MARCA)) + 1, LEN(TRIM(MARCA))) AS MODELO,
	PLACA,
	KILOMETRO_PERCORRIDO,
	ANO,
	[VALOR POR KM],
	(KILOMETRO_PERCORRIDO * [VALOR POR KM]) AS VALOR_LOCAÇAO,
	(CASE
	WHEN [SITUAÇÃO CADASTRAL] = 1 THEN 'PAGO'
	ELSE 'NÃO PAGO' -- COMO DENTRO DO CONJUNTO SÓ EXISTEM ESSAS DUAS POSSIBILIDADES TRATAMOS COM ELSE
	END) AS SITUAÇAO_CADASTRAL
FROM
	[LOCADORA_VEICULOS].[dbo].[Rastreador]
WHERE
	ID_CLIENTE IS NOT NULL;
```


### Criando VIEW para tabela tratada

```
CREATE VIEW VW_Rastreador AS
SELECT
	ID_CLIENTE,
	SUBSTRING(TRIM(MARCA), 1, CHARINDEX(' ', TRIM(MARCA)) - 1) AS MARCA,
	SUBSTRING(TRIM(MARCA), CHARINDEX(' ', TRIM(MARCA)) + 1, LEN(TRIM(MARCA))) AS MODELO,
	PLACA,
	KILOMETRO_PERCORRIDO,
	ANO,
	[VALOR POR KM],
	(KILOMETRO_PERCORRIDO * [VALOR POR KM]) AS VALOR_LOCAÇAO,
	(CASE
	WHEN [SITUAÇÃO CADASTRAL] = 1 THEN 'PAGO'
	ELSE 'NÃO PAGO' -- COMO DENTRO DO CONJUNTO SÓ EXISTEM ESSAS DUAS POSSIBILIDADES TRATAMOS COM ELSE
	END) AS SITUAÇAO_CADASTRAL
FROM
	[LOCADORA_VEICULOS].[dbo].[Rastreador]
WHERE
	ID_CLIENTE IS NOT NULL;
```

## 4. Tratando planilha clientes_copy.xls

### Renomeando tabela "Planilha1$" -> Clientes

```
EXEC sp_rename 'RASTREADOR', 'Clientes';
```

### Explorando os dados

```
SELECT
	*
FROM
	[LOCADORA_VEICULOS].[dbo].[Clientes];
```

### É uma tabela dimensão, logo não pode existir duplicidade no conjunto
### Analisando se há duplicidade nos dados

```
SELECT
	ID,
	COUNT(ID) AS TOTAL_ID
FROM
	[LOCADORA_VEICULOS].[dbo].[Clientes]	
GROUP BY
	ID
HAVING
	COUNT(ID) > 1;

/* NAO HÁ DUPLICIDADE NOS DADOS*/
```

### Existem dados com formatos diferentes, vamos padronizar os dados

```
SELECT
	ID,
	UPPER(LEFT(NOME, 1)) + LOWER(SUBSTRING(NOME, 2, LEN(NOME))) AS NOME, -- TRATANDO COM UPPER
	LEFT(CARGO, 1) + LOWER(SUBSTRING(CARGO, 2, LEN(CARGO))) AS CARGO, -- TRATANDO SEM UPPER (AMBOS RETORNAM O MESMO RESULTADO)
	SALARIO,
	CIDADE
FROM 
	[LOCADORA_VEICULOS].[dbo].[Clientes];
```

### Criando VIEW para tabela tratada

```
CREATE VIEW VW_Clients AS
SELECT
	ID,
	UPPER(LEFT(NOME, 1)) + LOWER(SUBSTRING(NOME, 2, LEN(NOME))) AS NOME,
	LEFT(CARGO, 1) + LOWER(SUBSTRING(CARGO, 2, LEN(CARGO))) AS CARGO,
	SALARIO,
	CIDADE
FROM
	[LOCADORA_VEICULOS].[dbo].[Clientes];
```

