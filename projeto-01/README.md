

<div align='center'>
  <img src="https://github.com/WillianMonteiro23/projetos-sql/blob/main/projeto-01/images/image-01.png" width="100%"/>
</div>

&nbsp;

## Introdução

Este projeto é parte do [**8 Week SQL Challenge**](https://8weeksqlchallenge.com/) promovido pelo [**Data With Danny**](https://www.datawithdanny.com/).

A apresentação do problema bem como o conjunto dos dados foram obtidos no [**Case Study #1 - Danny's Diner**](https://8weeksqlchallenge.com/case-study-1/), as análises foram feitas com linguagem SQL como foi proposto pelo desafio.

## Problema

Danny é um grande fã de comida japonesa e, no início de 2021, decidiu abrir um restaurante que oferece seus três pratos favoritos: **sushi**, **curry** e **ramen**.

O **Danny's Diner** precisa da sua ajuda para operar de forma eficaz. Ele coletou dados básicos nos primeiros meses de funcionamento, mas não sabe como utilizá-los para gerir o negócio.

Danny deseja utilizar os dados para responder a algumas perguntas simples sobre seus clientes, especialmente no que diz respeito aos seus padrões de visita, gastos e itens preferidos do cardápio. Compreender melhor seus clientes ajudará a oferecer uma experiência mais personalizada e satisfatória.

Ele planeja **usar essas informações para avaliar a possibilidade de expandir seu programa de fidelidade**. Além disso, precisa de assistência para gerar conjuntos de dados que sua equipe possa analisar facilmente, **sem precisar usar SQL**.

Danny forneceu uma amostra dos dados de seus clientes, mantendo em mente a privacidade, mas acredita que essas amostras são suficientes para que você **escreva consultas SQL eficazes para ajudá-lo**.

Os três conjuntos de dados principais para este estudo de caso são: **SALES**, **MENU** e **MEMBERS**.

## Conjunto de Dados

Os scripts responsáveis pela criação e inserção dos dados necessários para a análise podem ser encontrados no arquivo designado como [**tabelas.sql**](https://github.com/WillianMonteiro23/projetos-sql/blob/main/projeto-01/script-tabelas.sql).

Esse arquivo contém todas as instruções SQL essenciais que permitem estruturar as tabelas e preencher os dados, oferecendo uma base sólida para as consultas e análises subsequentes. 

## Visualização das Tabelas

**Tabela SALES**

<div align='center'>
  <img src="https://github.com/WillianMonteiro23/projetos-sql/blob/main/projeto-01/images/image-03.png" width="50%"/>
</div>

**Tabela MENU**

<div align='center'>
  <img src="https://github.com/WillianMonteiro23/projetos-sql/blob/main/projeto-01/images/image-04.png" width="50%"/>
</div>

**Tabela MEMBERS**

<div align='center'>
  <img src="https://github.com/WillianMonteiro23/projetos-sql/blob/main/projeto-01/images/image-05.png" width="50%"/>
</div>

## Dicionário de Variáveis

**Tabela SALES**
- **customer_id**: Identificação do cliente.
- **order_date**: Data da compra.
- **product_id**: Identificação do produto solicitado.

**Tabela 2: MENU**
- **product_id**: Identificação do produto.
- **product_name**: Nome do produto.
- **price**: Preço do produto.

**Tabela 3: MEMBERS**
- **customer_id**: Identificação do cliente.
- **join_date**: Data de adesão ao programa de fidelidade.

### Diagrama de Relacionamento de Entidades

&nbsp;

<div align='center'>
  <img src="https://github.com/WillianMonteiro23/projetos-sql/blob/main/projeto-01/images/image-02.png" width="50%"/>
</div>

&nbsp;

## Análises

A análise foi realizada com **SQL Server 2014** utilizando o **SQL Server 2014 Management Studio**

Os scripts das análises podem ser encontrados no arquivo [**analise.sql**](https://github.com/WillianMonteiro23/projetos-sql/blob/main/projeto-01/script-analise.sql).

* **Qual é o valor total gasto por cada cliente no restaurante?**

  > Os gastos dos clientes A, B e C foram respectivamnte, $76, $74 e $34. Onde podemos observar que os clientes A e B representaram mais de 80% do faturamento da Danny's Dinner.

&nbsp;

<div align='center'>
  <img src="https://github.com/WillianMonteiro23/projetos-sql/blob/main/projeto-01/images/image-06.png" width="60%"/>
</div>

**A partir da pergunta anterior, podemos ver a influência de cada cliente no faturamento**

  > Podemos observar que os clientes A e B representaram mais de 80% do faturamento da Danny's Dinner.

&nbsp;

<div align='center'>
  <img src="https://github.com/WillianMonteiro23/projetos-sql/blob/main/projeto-01/images/image-07.png" width="80%"/>
</div>

&nbsp;

* **Quantos dias cada cliente visitou o restaurante?**

  > O cliente C foi em apenas dois dias ao restaurante, enquanto o cliente A, que mais comprou, foi 4 vezes e o cliente B foi o que mais visitou o restaurante com 6 vezes.

&nbsp;

<div align='center'>
  <img src="https://github.com/WillianMonteiro23/projetos-sql/blob/main/projeto-01/images/image-08.png" width="60%"/>
</div>

&nbsp;

* **Qual foi o primeiro item do cardápio comprado por cada cliente?**

  > As primeiras opções de compra por cliente foram: Cliente A escolheu sushi e curry, Cliente B solicitou curry e o Cliente C pediu ramen.

&nbsp;

<div align='center'>
  <img src="https://github.com/WillianMonteiro23/projetos-sql/blob/main/projeto-01/images/image-09.png" width="70%"/>
</div>

&nbsp;

* **Qual é o item mais comprado no cardápio e quantas vezes foi pedido por todos os clientes?**

  > Com 8 pedidos, ramen é o item mais pedido no menu.

&nbsp;

<div align='center'>
  <img src="https://github.com/WillianMonteiro23/projetos-sql/blob/main/projeto-01/images/image-10.png" width="60%"/>
</div>

&nbsp;

* **Qual item foi mais popular para cada cliente?**

  > O cliente B escolheu todas as opções do menu 2 vezes, logo todas as opções foram populares para esse cliente, caso totalmente oposto em comparação para os clientes A e C que simpatizaram mais com a escolha de ramen, onde cada um pediu 3 vezes esse item.

&nbsp;

<div align='center'>
  <img src="https://github.com/WillianMonteiro23/projetos-sql/blob/main/projeto-01/images/image-11.png" width="70%"/>
</div>

&nbsp;

* **Qual foi o primeiro item adquirido por cada cliente após se tornarem membros?**

  > O cliente C não é fidelizado, o cliente A pediu curry no mesmo dia em que se fidelizou enquanto o cliente B pediu sushi.

&nbsp;

<div align='center'>
  <img src="https://github.com/WillianMonteiro23/projetos-sql/blob/main/projeto-01/images/image-12.png" width="70%"/>
</div>

&nbsp;

* **Qual item foi adquirido antes de o cliente se tornar membro?**

  > Antes de se tornarem membros, o cliente A fez pedidos de sushi e curry, enquanto o cliente B escolheu somente sushi.

&nbsp;

<div align='center'>
  <img src="https://github.com/WillianMonteiro23/projetos-sql/blob/main/projeto-01/images/image-13.png" width="70%"/>
</div>

&nbsp;

* **Qual é o total de itens e valor gasto por cada membro antes de se tornarem membros?**

  > O cliente A comprou dois produtos, totalizando $25, enquanto o cliente B fez três pedidos, que somaram $40.

&nbsp;

<div align='center'>
  <img src="https://github.com/WillianMonteiro23/projetos-sql/blob/main/projeto-01/images/image-14.png" width="60%"/>
</div>

&nbsp;

* **Com a última pergunta podemos observar a diferença entre gastos antes e depois de se tornar membro**

  > O cliente A mais que dobrou os gastos no restaurante após se fidelizar, enquanto houve uma pequena queda em gastos do cliente B após se tornar membro.

&nbsp;

<div align='center'>
  <img src="https://github.com/WillianMonteiro23/projetos-sql/blob/main/projeto-01/images/image-20.png" width="70%"/>
</div>

* **Se cada $1 gasto equivale a 10 pontos e o sushi tem um multiplicador de pontos de 2x, quantos pontos cada cliente teria?**

  > O cliente A alcançaria 860 pontos, enquanto o cliente B teria um total de 940 pontos e o cliente C chegaria a 360 pontos. Nesse cenário, o cliente B é o que possui a maior quantidade de pontos, enquanto o cliente C é aquele com a pontuação mais baixa.


&nbsp;

<div align='center'>
<img src="https://github.com/WillianMonteiro23/projetos-sql/blob/main/projeto-01/images/image-15.png" width="80%"/>
</div>

&nbsp;

* Durante a primeira semana após a adesão de um cliente ao programa (incluindo a data de inscrição), eles recebem pontos em dobro em todos os itens, não se limitando ao sushi. Ao considerar essa promoção, quantos pontos os clientes A e B acumulariam no final de janeiro?

> Considerando essas condições, ao término de janeiro, o cliente A teria acumulado um total de 1370 pontos, enquanto o cliente B chegaria a 820 pontos.

&nbsp;

<div align='center'>
<img src="https://github.com/WillianMonteiro23/projetos-sql/blob/main/projeto-01/images/image-16.png" width="70%"/>
</div>

&nbsp;


### Questões Bônus

As questões a seguir estão relacionadas à criação de tabelas de dados que Danny e sua equipe podem usar para obter insights rapidamente sem a necessidade de unir as tabelas subjacentes usando SQL.

* Organização das Informações

Para organizar todas as informações de forma clara, vamos elaborar uma tabela que reúna dados fundamentais sobre cada transação. Essa tabela incluirá as seguintes colunas: ID do Cliente, Data do Pedido, Produto Comprado, Valor da Compra e Indicação de Participação no Programa de Fidelidade.

&nbsp;

<div align='center'>
<img src="https://github.com/WillianMonteiro23/projetos-sql/blob/main/projeto-01/images/image-18.png" width="70%"/>
</div>

&nbsp;

* Classificação dos Produtos

Para enriquecer a análise, Danny precisa obter mais detalhes sobre como os clientes classificam os produtos. Contudo, ele não requer classificações para as compras feitas por não membros, e, por isso, espera que os registros mostrem valores nulos para esses casos em que os clientes ainda não estão no programa de fidelidade.

&nbsp;

<div align='center'>
<img src="https://github.com/WillianMonteiro23/projetos-sql/blob/main/projeto-01/images/image-19.png" width="70%"/>
</div>
