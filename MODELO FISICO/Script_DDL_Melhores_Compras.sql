/*
Arquivo Script_DDL_Melhores_Compras.sql, contendo:
- os comandos DDL de criação das estruturas de armazenamento, 
 oriundos da ferramenta CASE utilizada pelo grupo. 
 
 Nesse arquivo, também disponibilize os comandos para 
 eliminar fisicamente o projeto de banco de dados por meio do comando DROP.
*/

-- cria tabela 'Estado'
CREATE TABLE t_mc_estado (
    sg_estado CHAR(2) NOT NULL,
    nm_estado VARCHAR2(30) NOT NULL,
    CONSTRAINT pk_t_mc_estado PRIMARY KEY (sg_estado)
);

-- cria tabela 'Cidade'
CREATE TABLE t_mc_cidade (
    cd_cidade NUMBER(10) NOT NULL,
    sg_estado CHAR(2) NOT NULL,
    nm_cidade VARCHAR2(50) NOT NULL,
    cd_ibge NUMBER(10),
    nr_ddd NUMBER(3)
    CONSTRAINT pk_t_mc_cidade PRIMARY KEY (cd_cidade),
    CONSTRAINT fk_t_mc_cidade_estado FOREIGN KEY (sg_estado) REFERENCES t_mc_estado(sg_estado)
);

-- cria tabela 'Bairro'
CREATE TABLE t_mc_bairro (
    cd_bairro NUMBER(10) NOT NULL,
    cd_cidade NUMBER(10) NOT NULL,
    nm_bairro VARCHAR2(50),
    nm_zona_bairro VARCHAR2(50),
    CONSTRAINT pk_t_mc_bairro PRIMARY KEY (cd_bairro),
    CONSTRAINT fk_t_mc_bairro_cidade FOREIGN KEY (cd_cidade) REFERENCES t_mc_cidade(cd_cidade)
);

-- cria tabela 'Logradouro'
CREATE TABLE t_mc_logradouro (
    cd_logradouro NUMBER(10) NOT NULL,
    cd_bairro NUMBER(10) NOT NULL,
    nm_logradouro VARCHAR2(100) NOT NULL,
    nr_cep NUMBER(8),
    CONSTRAINT pk_t_mc_logradouro PRIMARY KEY (cd_logradouro),
    CONSTRAINT fk_t_mc_logradouro_bairro FOREIGN KEY (cd_bairro) REFERENCES t_mc_bairro(cd_bairro)
);

-- cria tabela 'Pessoa Juridica'
CREATE TABLE t_mc_cli_juridica (
    nr_cliente NUMBER(10) NOT NULL,
    dt_fundacao DATE,
    nr_cnpj VARCHAR2(14),
    nr_inscr_est VARCHAR2(20),
    CONSTRAINT pk_t_mc_cli_juridica PRIMARY KEY (nr_cliente)
);

-- cria tabeela 'Pessoa Física'
CREATE TABLE t_mc_cli_fisica (
    nr_cliente NUMBER(10) NOT NULL,
    dt_nascimento DATE NOT NULL,
    nr_cpf NUMBER(11) NOT NULL,
    fl_sexo_biologico CHAR(1) NOT NULL,
    ds_genero VARCHAR2(50),
    CONSTRAINT pk_t_mc_cli_fisica PRIMARY KEY (nr_cliente)
);


