/*
DROP TABLE t_mc_video_classificacao CASCADE CONSTRAINTS;
DROP TABLE t_mc_video CASCADE CONSTRAINTS;
DROP TABLE t_mc_sgv_sac CASCADE CONSTRAINTS;
DROP TABLE t_mc_produto CASCADE CONSTRAINTS;
DROP TABLE t_mc_categoria_prod CASCADE CONSTRAINTS;
DROP TABLE t_mc_cli_fisica CASCADE CONSTRAINTS;
DROP TABLE t_mc_cli_juridica CASCADE CONSTRAINTS;
DROP TABLE t_mc_cliente CASCADE CONSTRAINTS;
DROP TABLE t_mc_funcionario CASCADE CONSTRAINTS;
DROP TABLE t_mc_depto CASCADE CONSTRAINTS;
DROP TABLE t_mc_endereco CASCADE CONSTRAINTS;
DROP TABLE t_mc_logradouro CASCADE CONSTRAINTS;
DROP TABLE t_mc_bairro CASCADE CONSTRAINTS;
DROP TABLE t_mc_cidade CASCADE CONSTRAINTS;
DROP TABLE t_mc_estado CASCADE CONSTRAINTS;
*/

CREATE TABLE t_mc_estado (
    sg_estado CHAR(2) NOT NULL,
    nm_estado VARCHAR2(30) NOT NULL,
    CONSTRAINT pk_t_mc_estado PRIMARY KEY (sg_estado)
);

CREATE TABLE t_mc_cidade (
    cd_cidade NUMBER(10) NOT NULL,
    sg_estado CHAR(2) NOT NULL,
    nm_cidade VARCHAR2(50) NOT NULL,
    cd_ibge NUMBER(10),
    nr_ddd NUMBER(3),
    CONSTRAINT pk_t_mc_cidade PRIMARY KEY (cd_cidade),
    CONSTRAINT fk_t_mc_cidade_estado FOREIGN KEY (sg_estado) REFERENCES t_mc_estado(sg_estado)
);

CREATE TABLE t_mc_bairro (
    cd_bairro NUMBER(10) NOT NULL,
    cd_cidade NUMBER(10) NOT NULL,
    nm_bairro VARCHAR2(50) NOT NULL,
    nm_zona_bairro VARCHAR2(50),
    CONSTRAINT pk_t_mc_bairro PRIMARY KEY (cd_bairro),
    CONSTRAINT fk_t_mc_bairro_cidade FOREIGN KEY (cd_cidade) REFERENCES t_mc_cidade(cd_cidade)
);

CREATE TABLE t_mc_logradouro (
    cd_logradouro NUMBER(10) NOT NULL,
    cd_bairro NUMBER(10) NOT NULL,
    nm_logradouro VARCHAR2(100) NOT NULL,
    nr_cep NUMBER(8) NOT NULL,
    CONSTRAINT pk_t_mc_logradouro PRIMARY KEY (cd_logradouro),
    CONSTRAINT fk_t_mc_logradouro_bairro FOREIGN KEY (cd_bairro) REFERENCES t_mc_bairro(cd_bairro)
);

CREATE TABLE t_mc_cliente (
    cd_cliente NUMBER(10) NOT NULL,
    nm_cliente VARCHAR2(160) NOT NULL UNIQUE,
    tp_cliente CHAR(1) NOT NULL,
    nm_login VARCHAR2(50) NOT NULL,
    ds_senha VARCHAR2(50) NOT NULL,
    st_cliente CHAR(1) NOT NULL,
    qt_estrelas NUMBER(1),
    ds_email VARCHAR2(80),
    nr_telef NUMBER(11),
    CONSTRAINT pk_t_mc_cliente PRIMARY KEY (cd_cliente)
);

CREATE TABLE t_mc_cli_juridica (
    cd_cliente NUMBER(10) NOT NULL,
    dt_fundacao DATE,
    nr_cnpj VARCHAR2(14),
    nr_inscr_est VARCHAR2(9),
    CONSTRAINT pk_t_mc_cli_juridica PRIMARY KEY (cd_cliente),
    CONSTRAINT fk_t_mc_cli_juridica_cliente FOREIGN KEY (cd_cliente) REFERENCES t_mc_cliente(cd_cliente)
);

CREATE TABLE t_mc_cli_fisica (
    cd_cliente NUMBER(10) NOT NULL,
    dt_nasc DATE NOT NULL,
    nr_cpf NUMBER(11) NOT NULL,
    fl_sexo_biologico CHAR(1) NOT NULL,
    ds_genero VARCHAR2(50),
    CONSTRAINT pk_t_mc_cli_fisica PRIMARY KEY (cd_cliente),
    CONSTRAINT fk_t_mc_cli_fisica_cliente FOREIGN KEY (cd_cliente) REFERENCES t_mc_cliente(cd_cliente)
);

CREATE TABLE t_mc_funcionario (
    cd_func NUMBER(10) NOT NULL,
    nm_func VARCHAR2(160) NOT NULL,
    nr_cpf NUMBER(11) NOT NULL UNIQUE,
    cd_depto NUMBER(3) NOT NULL,
    nm_funcionario VARCHAR2(150) NOT NULL,
    dt_nasc DATE NOT NULL,
    nr_tel NUMBER(11) NOT NULL,
    ds_email VARCHAR2(80) NOT NULL,
    ds_cargo VARCHAR2(80) NOT NULL,
    cd_gerente NUMBER(10),
    fl_sexo_biologico CHAR(1),
    ds_genero VARCHAR2(100),
    vl_salario NUMBER(10,2),
    st_func CHAR(1),
    dt_cadastramento DATE,
    dt_desligamento DATE,
    CONSTRAINT pk_t_mc_funcionario PRIMARY KEY (cd_func),
    CONSTRAINT fk_t_mc_funcionario_depto FOREIGN KEY (cd_depto) REFERENCES t_mc_depto(cd_depto),
    CONSTRAINT fk_t_mc_funcionario_gerente FOREIGN KEY (cd_gerente) REFERENCES t_mc_funcionario(cd_func)
);

CREATE TABLE t_mc_endereco (
    cd_end NUMBER(10) NOT NULL,
    cd_logradouro NUMBER(10) NOT NULL,
    cd_cliente NUMBER(10) NOT NULL,
    cd_func NUMBER(10) NOT NULL,
    nr_end NUMBER(8) NOT NULL,
    st_end CHAR(1) NOT NULL,
    dt_inicio DATE NOT NULL,
    dt_termino DATE,
    ds_complemento VARCHAR2(80),
    CONSTRAINT pk_t_mc_endereco PRIMARY KEY (cd_end),
    CONSTRAINT fk_t_mc_endereco_logradouro FOREIGN KEY (cd_logradouro) REFERENCES t_mc_logradouro(cd_logradouro),
    CONSTRAINT fk_t_mc_endereco_cliente FOREIGN KEY (cd_cliente) REFERENCES t_mc_cliente (cd_cliente),
    CONSTRAINT fk_t_mc_endereco_funcionario FOREIGN KEY (cd_func) REFERENCES t_mc_funcionario (cd_func)
);

CREATE TABLE t_mc_depto (
    cd_depto NUMBER(3) NOT NULL,
    nm_depto VARCHAR2(100) NOT NULL,
    st_depto CHAR(1) NOT NULL,
    CONSTRAINT pk_t_mc_depto PRIMARY KEY (cd_depto)
);

CREATE TABLE t_mc_categoria_prod ( 
    cd_categoria NUMBER(10) NOT NULL,
    ds_categoria VARCHAR2(100) NOT NULL UNIQUE,
    st_categoria CHAR(1) NOT NULL,
    tp_categoria CHAR(1) NOT NULL,
    dt_inicio DATE NOT NULL,
    dt_termino DATE,
    CONSTRAINT pk_t_mc_categoria_prod PRIMARY KEY (cd_categoria)
);

CREATE TABLE t_mc_produto (
    cd_produto NUMBER(10) NOT NULL,
    cd_categoria NUMBER(10) NOT NULL,
    ds_produto VARCHAR2(100) NOT NULL UNIQUE,
    vl_unitario_produto NUMBER(8,2) NOT NULL,
    ds_completa_produto VARCHAR2(4000) NOT NULL,
    nr_cd_barras_produto VARCHAR2(50),
    st_produto CHAR(1) DEFAULT 'A',
    CONSTRAINT pk_t_mc_produto PRIMARY KEY (cd_produto),
    CONSTRAINT fk_t_mc_produto_categoria_prod FOREIGN KEY (cd_categoria) REFERENCES t_mc_categoria_prod (cd_categoria)
);

CREATE TABLE t_mc_sgv_sac (
    nr_sac NUMBER(10) NOT NULL,
    cd_cliente NUMBER(10) NOT NULL,
    cd_produto NUMBER(10) NOT NULL,
    cd_func NUMBER(10) NOT NULL,
    tx_sac VARCHAR2(4000) NOT NULL,
    dt_abertura_sac DATE NOT NULL,
    hr_abertura_sac NUMBER(2) NOT NULL,
    nr_tempo_total_sac NUMBER(3) NOT NULL,
    tp_sac CHAR(1) NOT NULL,
    st_sac CHAR(1) NOT NULL,
    ds_detalhada_sac VARCHAR2(100),
    dt_atendimento_sac DATE,
    hr_atendimento_sac NUMBER(2),
    ds_detalhada_retorno_sac VARCHAR2(100),
    nr_indice_satisfacao_sac NUMBER(3),
    CONSTRAINT pk_t_mc_sgv_sac PRIMARY KEY (nr_sac),
    CONSTRAINT fk_t_mc_sgv_sac_cliente FOREIGN KEY (cd_cliente) REFERENCES t_mc_cliente(cd_cliente),
    CONSTRAINT fk_t_mc_sgv_sac_produto FOREIGN KEY (cd_produto) REFERENCES t_mc_produto(cd_produto),
    CONSTRAINT fk_t_mc_sgv_sac_func FOREIGN KEY (cd_func) REFERENCES t_mc_funcionario(cd_func)
);

CREATE TABLE t_mc_video ( 
    cd_video NUMBER(10) NOT NULL, 
    cd_produto NUMBER(10) NOT NULL, 
    st_video CHAR (1), 
    ds_video VARCHAR2(100), 
    dt_cadastro_video DATE, 
    CONSTRAINT pk_t_mc_video PRIMARY KEY (cd_video),
    CONSTRAINT fk_t_mc_video_produto FOREIGN KEY (cd_produto) REFERENCES t_mc_produto(cd_produto)
);

CREATE TABLE t_mc_video_classificacao ( 
    cd_classificacao  NUMBER(10) NOT NULL,  
    cd_video  NUMBER(10) NOT NULL,  
    ds_classificacao VARCHAR2(100) NOT NULL, 
    CONSTRAINT pk_t_mc_video_classificacao PRIMARY KEY (cd_classificacao),
    CONSTRAINT fk_t_mc_video_classificacao_video FOREIGN KEY (cd_video) REFERENCES t_mc_video(cd_video)
);

CREATE TABLE t_mc_visualizacao ( 
    cd_visualizacao  NUMBER(10) NOT NULL, 
    cd_video  NUMBER(10) NOT NULL, 
    cd_cliente  NUMBER(10) NOT NULL,  
    dt_visualizacao DATE NOT NULL, 
    hr_visualizacao  NUMBER(2) NOT NULL, 
    min_visualizacao  NUMBER(2), 
    seg_visualizacao  NUMBER(2), 
    CONSTRAINT pk_t_mc_visualizacao PRIMARY KEY (cd_visualizacao),
    CONSTRAINT fk_t_mc_visualizacao_video FOREIGN KEY (cd_video) REFERENCES t_mc_video(cd_video),
    CONSTRAINT fk_t_mc_visualizacao_cliente FOREIGN KEY (cd_cliente) REFERENCES t_mc_cliente(cd_cliente)
);
