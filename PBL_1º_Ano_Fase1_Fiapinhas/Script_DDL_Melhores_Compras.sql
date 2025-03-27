CREATE TABLE t_mc_estado (
    sg_estado CHAR(2) NOT NULL,
    nm_estado VARCHAR2(30) NOT NULL,
    CONSTRAINT pk_mc_estado PRIMARY KEY (sg_estado)
);

COMMENT ON COLUMN t_mc_estado.sg_estado IS 'Sigla do estado (ex: MG, SP, BH), obrigatório.';
COMMENT ON COLUMN t_mc_estado.nm_estado IS 'Nome do estado (ex: Minas Gerais, São Paulo, Belo Horizonte), obrigatório.';

CREATE TABLE t_mc_cidade (
    cd_cidade NUMBER(10) NOT NULL,
    sg_estado CHAR(2) NOT NULL,
    nm_cidade VARCHAR2(50) NOT NULL,
    cd_ibge NUMBER(10),
    nr_ddd VARCHAR2(3),
    CONSTRAINT pk_mc_cidade PRIMARY KEY (cd_cidade),
    CONSTRAINT fk_mc_estado_cidade FOREIGN KEY (sg_estado) REFERENCES t_mc_estado(sg_estado)
);

COMMENT ON COLUMN t_mc_cidade.cd_cidade IS 'Código da cidade (ex: 123, 1234, 12345), obrigatório.';
COMMENT ON COLUMN t_mc_cidade.sg_estado IS 'Sigla do estado, referenciando t_mc_estado.sg_estado, obrigatório.';
COMMENT ON COLUMN t_mc_cidade.nm_cidade IS 'Nome da cidade (ex: São Paulo, Osasco, Guarulhos), obrigatório.';
COMMENT ON COLUMN t_mc_cidade.cd_ibge IS 'Código IBGE da cidade, opcional.';
COMMENT ON COLUMN t_mc_cidade.nr_ddd IS 'DDD da cidade (ex: 11, 12, 13), opcional.';

CREATE TABLE t_mc_bairro (
    cd_bairro NUMBER(10) NOT NULL,
    cd_cidade NUMBER(10) NOT NULL,
    nm_bairro VARCHAR2(50),
    nm_zona_bairro VARCHAR2(50),
    CONSTRAINT pk_mc_bairro PRIMARY KEY (cd_bairro),
    CONSTRAINT fk_mc_cidade_bairro FOREIGN KEY (cd_cidade) REFERENCES t_mc_cidade(cd_cidade)
);

COMMENT ON COLUMN t_mc_bairro.cd_bairro IS 'Código do bairro (ex: 123, 1234, 12345), obrigatório.';
COMMENT ON COLUMN t_mc_bairro.cd_cidade IS 'Código da cidade, referenciando t_mc_cidade.cd_cidade, obrigatório.';
COMMENT ON COLUMN t_mc_bairro.nm_bairro IS 'Nome do bairro (ex: Vila Mariana, Praça da Árvore, Santa Cruz), opcional.';
COMMENT ON COLUMN t_mc_bairro.nm_zona_bairro IS 'Zona do bairro (ex: Zona Norte, Zona Sul, Centro), opcional.';

CREATE TABLE t_mc_logradouro (
    cd_logradouro NUMBER(10) NOT NULL,
    cd_bairro NUMBER(10) NOT NULL,
    nm_logradouro VARCHAR2(100) NOT NULL,
    nr_cep VARCHAR2(8) NOT NULL,
    CONSTRAINT pk_mc_logradouro PRIMARY KEY (cd_logradouro),
    CONSTRAINT fk_mc_bairro_logradouro FOREIGN KEY (cd_bairro) REFERENCES t_mc_bairro(cd_bairro)
);

COMMENT ON COLUMN t_mc_logradouro.cd_logradouro IS 'Código do logradouro (ex: 123, 1234, 12345), obrigatório.';
COMMENT ON COLUMN t_mc_logradouro.cd_bairro IS 'Código do bairro, referenciando t_mc_bairro.cd_bairro, obrigatório.';
COMMENT ON COLUMN t_mc_logradouro.nm_logradouro IS 'Nome do logradouro (ex: Rua Jureia, Rua Isabel de Gois), obrigatório.';
COMMENT ON COLUMN t_mc_logradouro.nr_cep IS 'CEP do logradouro (ex: 04123030, 04129060), obrigatório.';

CREATE SEQUENCE seq_t_mc_cliente
INCREMENT BY 1
START WITH 1
MAXVALUE 9999999999
NOCACHE
NOCYCLE;

CREATE TABLE t_mc_cliente (
    cd_cliente NUMBER(10) NOT NULL,
    nm_cliente VARCHAR2(160) NOT NULL,
    tp_cliente CHAR(1) NOT NULL,
    tx_login VARCHAR2(50) NOT NULL,
    tx_senha VARCHAR2(50) NOT NULL,
    st_cliente CHAR(1) NOT NULL,
    qt_estrelas NUMBER(1),
    tx_email VARCHAR2(80),
    nr_telefone VARCHAR2(12),
    CONSTRAINT pk_mc_cliente PRIMARY KEY (cd_cliente),
    CONSTRAINT ck_mc_cliente_tipo CHECK (tp_cliente IN ('F', 'J')),
    CONSTRAINT ck_mc_cliente_status CHECK (st_cliente IN ('A', 'I'))
);

COMMENT ON COLUMN t_mc_cliente.cd_cliente IS 'Código único do cliente, gerado pela sequence seq_t_mc_cliente, obrigatório.';
COMMENT ON COLUMN t_mc_cliente.nm_cliente IS 'Nome do cliente (ex: Joana Silva, Marina Queiroz), obrigatório.';
COMMENT ON COLUMN t_mc_cliente.tp_cliente IS 'Tipo do cliente: F (físico) ou J (jurídico), obrigatório.';
COMMENT ON COLUMN t_mc_cliente.tx_login IS 'Login do cliente, único, obrigatório.';
COMMENT ON COLUMN t_mc_cliente.tx_senha IS 'Senha do cliente, obrigatória.';
COMMENT ON COLUMN t_mc_cliente.st_cliente IS 'Status do cliente: A (ativo) ou I (inativo), obrigatório.';
COMMENT ON COLUMN t_mc_cliente.qt_estrelas IS 'Quantidade de estrelas do cliente (1 a 5), opcional.';
COMMENT ON COLUMN t_mc_cliente.tx_email IS 'Email do cliente, opcional.';
COMMENT ON COLUMN t_mc_cliente.nr_telefone IS 'Telefone do cliente, opcional.';

CREATE OR REPLACE TRIGGER trg_t_mc_cliente_insert
BEFORE INSERT ON t_mc_cliente
FOR EACH ROW
BEGIN
    SELECT seq_t_mc_cliente.NEXTVAL INTO :NEW.cd_cliente FROM DUAL;
END;
/

CREATE TABLE t_mc_cli_juridica (
    cd_cliente NUMBER(10) NOT NULL,
    dt_fundacao DATE,
    nr_cnpj VARCHAR2(14) NOT NULL,
    nr_inscr_est VARCHAR2(9),
    CONSTRAINT pk_mc_cli_juridica PRIMARY KEY (cd_cliente, nr_cnpj),
    CONSTRAINT fk_mc_cli_juridica FOREIGN KEY (cd_cliente) REFERENCES t_mc_cliente(cd_cliente)
);

COMMENT ON COLUMN t_mc_cli_juridica.cd_cliente IS 'Código do cliente, referenciando t_mc_cliente.cd_cliente, obrigatório.';
COMMENT ON COLUMN t_mc_cli_juridica.dt_fundacao IS 'Data de fundação do cliente jurídico, opcional.';
COMMENT ON COLUMN t_mc_cli_juridica.nr_cnpj IS 'CNPJ do cliente jurídico, obrigatório.';
COMMENT ON COLUMN t_mc_cli_juridica.nr_inscr_est IS 'Inscrição estadual do cliente jurídico, opcional.';

CREATE TABLE t_mc_cli_fisica (
    cd_cliente NUMBER(10) NOT NULL,
    dt_nascimento DATE NOT NULL,
    nr_cpf VARCHAR2(11) NOT NULL,
    fl_sexo_biologico CHAR(1) NOT NULL,
    ds_genero VARCHAR2(50),
    CONSTRAINT pk_mc_cli_fisica PRIMARY KEY (cd_cliente, nr_cpf),
    CONSTRAINT fk_mc_cli_fisica FOREIGN KEY (cd_cliente) REFERENCES t_mc_cliente(cd_cliente)
);

COMMENT ON COLUMN t_mc_cli_fisica.cd_cliente IS 'Código do cliente, referenciando t_mc_cliente.cd_cliente, obrigatório.';
COMMENT ON COLUMN t_mc_cli_fisica.dt_nascimento IS 'Data de nascimento do cliente físico, obrigatória.';
COMMENT ON COLUMN t_mc_cli_fisica.nr_cpf IS 'CPF do cliente físico, obrigatório.';
COMMENT ON COLUMN t_mc_cli_fisica.fl_sexo_biologico IS 'Sexo biológico do cliente físico, obrigatório.';
COMMENT ON COLUMN t_mc_cli_fisica.ds_genero IS 'Gênero do cliente físico, opcional.';

CREATE TABLE t_mc_acesso (
    cd_acesso_usuario NUMBER(10) NOT NULL,
    ds_dispositivo_usuario VARCHAR2(50),
    dt_hr_acesso_usuario TIMESTAMP NOT NULL,
    cd_cliente NUMBER(10),
    CONSTRAINT pk_mc_acesso PRIMARY KEY (cd_acesso_usuario),
    CONSTRAINT fk_mc_acesso_cliente FOREIGN KEY (cd_cliente) REFERENCES t_mc_cliente(cd_cliente)
);

COMMENT ON COLUMN t_mc_acesso.cd_acesso_usuario IS 'Código de acesso do usuário, obrigatório.';
COMMENT ON COLUMN t_mc_acesso.ds_dispositivo_usuario IS 'Descrição do dispositivo utilizado pelo cliente, opcional.';
COMMENT ON COLUMN t_mc_acesso.dt_hr_acesso_usuario IS 'Data de acesso do usuário na plataforma, obrigatório.';
COMMENT ON COLUMN t_mc_acesso.cd_cliente IS 'Código do cliente, referenciando t_mc_cliente.cd_cliente, obrigatório.';

CREATE TABLE t_mc_depto (
    cd_depto NUMBER(10) NOT NULL,
    nm_depto VARCHAR2(100) NOT NULL,
    st_depto CHAR(1) NOT NULL,
    CONSTRAINT pk_mc_depto PRIMARY KEY (cd_depto),
    CONSTRAINT ck_mc_depto_status CHECK (st_depto IN ('A', 'I'))
);

COMMENT ON COLUMN t_mc_depto.cd_depto IS 'Código do departamento, obrigatório.';
COMMENT ON COLUMN t_mc_depto.nm_depto IS 'Nome do departamento, obrigatório.';
COMMENT ON COLUMN t_mc_depto.st_depto IS 'Status do departamento: A (ativo) ou I (inativo), obrigatório.';

CREATE TABLE t_mc_funcionario (
    cd_funcionario NUMBER(10) NOT NULL,
    nm_funcionario VARCHAR2(160) NOT NULL,
    nr_cpf VARCHAR2(11) NOT NULL UNIQUE,
    cd_depto NUMBER(10) NOT NULL,
    dt_nascimento DATE NOT NULL,
    nr_telefone VARCHAR2(12) NOT NULL,
    tx_email VARCHAR2(80) NOT NULL,
    ds_cargo VARCHAR2(100) NOT NULL,
    cd_gerente NUMBER(10),
    fl_sexo_biologico CHAR(1),
    ds_genero VARCHAR2(50),
    vl_salario NUMBER(10,2) NOT NULL,
    st_funcionario CHAR(1),
    dt_cadastramento DATE NOT NULL,
    dt_desligamento DATE,
    CONSTRAINT pk_mc_funcionario PRIMARY KEY (cd_funcionario),
    CONSTRAINT fk_mc_depto_funcionario  FOREIGN KEY (cd_depto) REFERENCES t_mc_depto(cd_depto),
    CONSTRAINT fk_mc_funcionario_gerente FOREIGN KEY (cd_gerente) REFERENCES t_mc_funcionario(cd_funcionario),
    CONSTRAINT ck_mc_funcionario_status CHECK (st_funcionario IN ('A', 'I')) 
);

COMMENT ON COLUMN t_mc_funcionario.cd_funcionario IS 'Código do funcionário, obrigatório.';
COMMENT ON COLUMN t_mc_funcionario.nr_cpf IS 'CPF do funcionário, único, obrigatório.';
COMMENT ON COLUMN t_mc_funcionario.cd_depto IS 'Código do departamento, referenciando t_mc_depto.cd_depto, obrigatório.';
COMMENT ON COLUMN t_mc_funcionario.nm_funcionario IS 'Nome do funcionário, obrigatório.';
COMMENT ON COLUMN t_mc_funcionario.dt_nascimento IS 'Data de nascimento do funcionário, obrigatória.';
COMMENT ON COLUMN t_mc_funcionario.nr_telefone IS 'Telefone do funcionário, obrigatório.';
COMMENT ON COLUMN t_mc_funcionario.tx_email IS 'Email do funcionário, opcional.';
COMMENT ON COLUMN t_mc_funcionario.ds_cargo IS 'Cargo do funcionário, opcional.';
COMMENT ON COLUMN t_mc_funcionario.cd_gerente IS 'Código do gerente do funcionário, referenciando t_mc_funcionario.cd_funcionario, opcional.';
COMMENT ON COLUMN t_mc_funcionario.fl_sexo_biologico IS 'Sexo biológico do funcionário: F (feminino) ou M (masculino), opcional.';
COMMENT ON COLUMN t_mc_funcionario.ds_genero IS 'Gênero do funcionário, opcional.';
COMMENT ON COLUMN t_mc_funcionario.vl_salario IS 'Salário do funcionário, opcional.';
COMMENT ON COLUMN t_mc_funcionario.st_funcionario IS 'Status do funcionário: A (ativo) ou I (inativo), opcional.';
COMMENT ON COLUMN t_mc_funcionario.dt_cadastramento IS 'Data de cadastramento do funcionário, obrigatório.';
COMMENT ON COLUMN t_mc_funcionario.dt_desligamento IS 'Data de desligamento do funcionário, opcional.';

CREATE TABLE t_mc_endereco (
    cd_endereco NUMBER(10) NOT NULL,
    cd_logradouro NUMBER(10) NOT NULL,
    cd_cliente NUMBER(10) NOT NULL,
    cd_funcionario NUMBER(10) NOT NULL,
    nr_endereco NUMBER(8) NOT NULL,
    st_endereco CHAR(1) NOT NULL,
    dt_inicio DATE NOT NULL,
    dt_termino DATE,
    ds_complemento VARCHAR2(80),
    CONSTRAINT pk_mc_endereco PRIMARY KEY (cd_endereco),
    CONSTRAINT fk_mc_logradouro_endereco FOREIGN KEY (cd_logradouro) REFERENCES t_mc_logradouro(cd_logradouro),
    CONSTRAINT fk_mc_cliente_endereco FOREIGN KEY (cd_cliente) REFERENCES t_mc_cliente (cd_cliente),
    CONSTRAINT fk_mc_funcionario_endereco FOREIGN KEY (cd_funcionario) REFERENCES t_mc_funcionario (cd_funcionario)
);

COMMENT ON COLUMN t_mc_endereco.cd_endereco IS 'Código do endereço, obrigatório.';
COMMENT ON COLUMN t_mc_endereco.cd_logradouro IS 'Código do logradouro, referenciando t_mc_logradouro.cd_logradouro, obrigatório.';
COMMENT ON COLUMN t_mc_endereco.cd_cliente IS 'Código do cliente, referenciando t_mc_cliente.cd_cliente, obrigatório.';
COMMENT ON COLUMN t_mc_endereco.cd_funcionario IS 'Código do funcionário, referenciando t_mc_funcionario.cd_funcionario, obrigatório.';
COMMENT ON COLUMN t_mc_endereco.nr_endereco IS 'Número do endereço, obrigatório.';
COMMENT ON COLUMN t_mc_endereco.st_endereco IS 'Status do endereço: A (ativo) ou I (inativo), obrigatório.';
COMMENT ON COLUMN t_mc_endereco.dt_inicio IS 'Data de início do endereço, obrigatória.';
COMMENT ON COLUMN t_mc_endereco.dt_termino IS 'Data de término do endereço, opcional.';
COMMENT ON COLUMN t_mc_endereco.ds_complemento IS 'Complemento do endereço, opcional.';

CREATE SEQUENCE seq_t_mc_categoria_prod
INCREMENT BY 1  
START WITH 1  
MAXVALUE 9999999999  
NOCACHE 
NOCYCLE;

CREATE TABLE t_mc_categoria_prod (
    cd_categoria NUMBER(10) NOT NULL,
    ds_categoria VARCHAR2(100) NOT NULL UNIQUE,
    st_categoria CHAR(1) NOT NULL,
    tp_categoria CHAR(1) NOT NULL,
    dt_inicio DATE NOT NULL,
    dt_termino DATE,
    CONSTRAINT pk_mc_categoria_prod PRIMARY KEY (cd_categoria),
    CONSTRAINT ck_mc_categoria_status CHECK (st_categoria IN ('A', 'I'))
);

COMMENT ON COLUMN t_mc_categoria_prod.cd_categoria IS 'Código único da categoria, gerado pela sequence seq_t_mc_categoria_prod, obrigatório.';
COMMENT ON COLUMN t_mc_categoria_prod.ds_categoria IS 'Descrição da categoria, única, obrigatória.';
COMMENT ON COLUMN t_mc_categoria_prod.st_categoria IS 'Status da categoria: A (ativo) ou I (inativo), obrigatório.';
COMMENT ON COLUMN t_mc_categoria_prod.tp_categoria IS 'Tipo da categoria: V (vídeo) ou P (produto), obrigatório.';
COMMENT ON COLUMN t_mc_categoria_prod.dt_inicio IS 'Data de início da categoria (DD/MM/YYYY), obrigatória.';
COMMENT ON COLUMN t_mc_categoria_prod.dt_termino IS 'Data de término da categoria (DD/MM/YYYY), opcional. Se preenchida, indica categoria encerrada.';

CREATE OR REPLACE TRIGGER trg_t_mc_categoria_prod_insert
BEFORE INSERT ON t_mc_categoria_prod
FOR EACH ROW
BEGIN
    SELECT seq_t_mc_categoria_prod.NEXTVAL INTO :NEW.cd_categoria FROM DUAL;
END;
/

CREATE SEQUENCE seq_t_mc_produto
INCREMENT BY 1
START WITH 1
MAXVALUE 9999999999
NOCACHE
NOCYCLE;

CREATE TABLE t_mc_produto (
    cd_produto NUMBER(10) NOT NULL,
    ds_produto VARCHAR2(100) NOT NULL UNIQUE,
    cd_categoria NUMBER(10) NOT NULL,
    ds_completa_produto VARCHAR2(4000) NOT NULL,
    vl_unitario_produto NUMBER(8,2) NOT NULL,
    cd_barras_produto VARCHAR2(13),
    st_produto CHAR(1),
    CONSTRAINT pk_mc_produto PRIMARY KEY (cd_produto),
    CONSTRAINT fk_mc_categoria_produto FOREIGN KEY (cd_categoria) REFERENCES t_mc_categoria_prod (cd_categoria),
    CONSTRAINT ck_mc_produto_status CHECK (st_produto in ('A', 'I')) 
);

COMMENT ON COLUMN t_mc_produto.cd_produto IS 'Código único do produto, gerado pela sequence seq_t_mc_produto, obrigatório.';
COMMENT ON COLUMN t_mc_produto.cd_categoria IS 'Código da categoria do produto, referenciando t_mc_categoria_prod.cd_categoria, obrigatório.';
COMMENT ON COLUMN t_mc_produto.ds_produto IS 'Descrição principal do produto, única, obrigatória.';
COMMENT ON COLUMN t_mc_produto.vl_unitario_produto IS 'Valor unitário do produto, maior que 0, obrigatório.';
COMMENT ON COLUMN t_mc_produto.ds_completa_produto IS 'Descrição completa do produto, obrigatória.';
COMMENT ON COLUMN t_mc_produto.cd_barras_produto IS 'Código de barras do produto (padrão EAN13), opcional.';
COMMENT ON COLUMN t_mc_produto.st_produto IS 'Status do produto: A (ativo) ou I (inativo).';

CREATE OR REPLACE TRIGGER trg_t_mc_produto_insert
BEFORE INSERT ON t_mc_produto
FOR EACH ROW
BEGIN
    SELECT seq_t_mc_produto.NEXTVAL INTO :NEW.cd_produto FROM DUAL;
END;
/

CREATE SEQUENCE seq_t_mc_sac
INCREMENT BY 1
START WITH 1
MAXVALUE 9999999999
NOCACHE
NOCYCLE;

CREATE TABLE t_mc_sac (
    cd_sac NUMBER(10) NOT NULL,
    cd_cliente NUMBER(10) NOT NULL,
    cd_produto NUMBER(10) NOT NULL,
    cd_funcionario NUMBER(10),
    tx_sac VARCHAR2(4000) NOT NULL,
    dt_hr_abertura_sac TIMESTAMP NOT NULL,
    nr_tempo_total_sac NUMBER(3),
    tp_sac CHAR(1) NOT NULL,
    st_sac CHAR(1) NOT NULL,
    ds_det_sac VARCHAR2(100),
    dt_hr_atendimento_sac DATE,
    ds_det_retorno_sac VARCHAR2(100),
    nr_ind_satisfacao_sac NUMBER(3),
    CONSTRAINT pk_mc_sac PRIMARY KEY (cd_sac),
    CONSTRAINT fk_mc_cliente_sac FOREIGN KEY (cd_cliente) REFERENCES t_mc_cliente(cd_cliente),
    CONSTRAINT fk_mc_produto_sac FOREIGN KEY (cd_produto) REFERENCES t_mc_produto(cd_produto),
    CONSTRAINT fk_mc_funcionario_sac FOREIGN KEY (cd_funcionario) REFERENCES t_mc_funcionario(cd_funcionario),
    CONSTRAINT ck_mc_sac_status CHECK (st_sac IN ('A', 'I', 'P')) 
);

COMMENT ON COLUMN t_mc_sac.cd_sac IS 'Número único do chamado SAC feito pelo cliente, gerado pela sequence seq_t_mc_sac.';
COMMENT ON COLUMN t_mc_sac.cd_cliente IS 'Código único do cliente na plataforma e-commerce da Melhores Compras, referenciando t_mc_cliente.cd_cliente.';
COMMENT ON COLUMN t_mc_sac.cd_produto IS 'Código do produto relacionado ao SAC, referenciando t_mc_produto.cd_produto.';
COMMENT ON COLUMN t_mc_sac.cd_funcionario IS 'Código do funcionário responsável pelo atendimento do SAC, referenciando t_mc_funcionario.cd_funcionario.';
COMMENT ON COLUMN t_mc_sac.tx_sac IS 'Texto do SAC escrito pelo cliente, máximo de 4000 caracteres, obrigatório.';
COMMENT ON COLUMN t_mc_sac.dt_hr_abertura_sac IS 'Data e hora de abertura do SAC pelo cliente, obrigatório.';
COMMENT ON COLUMN t_mc_sac.nr_tempo_total_sac IS 'Tempo total em horas (HH24) desde a abertura até a conclusão do SAC.';
COMMENT ON COLUMN t_mc_sac.tp_sac IS 'Tipo do SAC: 1 (Sugestão) ou 2 (Reclamação).';
COMMENT ON COLUMN t_mc_sac.st_sac IS 'Status do SAC: A (aberto), E (em atendimento), C (cancelado), F (fechado com sucesso), X (fechado com insatisfação).';
COMMENT ON COLUMN t_mc_sac.ds_det_sac IS 'Descrição det do SAC aberta pelo cliente, opcional.';
COMMENT ON COLUMN t_mc_sac.dt_hr_atendimento_sac IS 'Data e hora do atendimento do SAC pelo funcionário, opcional.';
COMMENT ON COLUMN t_mc_sac.ds_det_retorno_sac IS 'Descrição det do retorno do funcionário ao cliente, opcional.';
COMMENT ON COLUMN t_mc_sac.nr_ind_satisfacao_sac IS 'Índice de satisfação do cliente (1 a 100), opcional.';

CREATE OR REPLACE TRIGGER trg_t_mc_sac_insert
BEFORE INSERT ON t_mc_sac
FOR EACH ROW
BEGIN
    SELECT seq_t_mc_sac.NEXTVAL INTO :NEW.cd_sac FROM DUAL;
END;
/

CREATE TABLE t_mc_video ( 
    cd_video NUMBER(10) NOT NULL, 
    cd_produto NUMBER(10) NOT NULL, 
    st_video CHAR (1), 
    ds_video VARCHAR2(100) NOT NULL, 
    dt_cadastro_video DATE, 
    CONSTRAINT pk_mc_video PRIMARY KEY (cd_video),
    CONSTRAINT fk_mc_produto_video FOREIGN KEY (cd_produto) REFERENCES t_mc_produto(cd_produto),
    CONSTRAINT ck_mc_video_status CHECK (st_video IN ('A', 'I')) 
);

COMMENT ON COLUMN t_mc_video.cd_video IS 'Código único do vídeo, obrigatório.';
COMMENT ON COLUMN t_mc_video.cd_produto IS 'Código do produto relacionado ao vídeo, referenciando t_mc_produto.cd_produto, obrigatório.';
COMMENT ON COLUMN t_mc_video.st_video IS 'Status do vídeo: A (ativo) ou I (inativo).';
COMMENT ON COLUMN t_mc_video.ds_video IS 'Descrição det do vídeo, opcional.';
COMMENT ON COLUMN t_mc_video.dt_cadastro_video IS 'Data de cadastro do vídeo na plataforma, opcional.';

CREATE TABLE t_mc_video_classificacao (
    cd_classificacao NUMBER(10) NOT NULL,
    cd_video NUMBER(10) NOT NULL,
    ds_classificacao VARCHAR2(100) NOT NULL,
    CONSTRAINT pk_mc_video_classificacao PRIMARY KEY (cd_classificacao),
    CONSTRAINT fk_mc_video_classificacao FOREIGN KEY (cd_video) REFERENCES t_mc_video(cd_video)
);

COMMENT ON COLUMN t_mc_video_classificacao.cd_classificacao IS 'Código da classificação do vídeo, obrigatório.';
COMMENT ON COLUMN t_mc_video_classificacao.cd_video IS 'Código do vídeo, referenciando t_mc_video.cd_video, obrigatório.';
COMMENT ON COLUMN t_mc_video_classificacao.ds_classificacao IS 'Descrição da classificação do vídeo (ex: Instalação, Uso Diário, Comercial), obrigatória.';

CREATE TABLE t_mc_visualizacao (
    cd_visualizacao NUMBER(10) NOT NULL,
    cd_acesso_usuario NUMBER(10) NOT NULL,
    cd_video NUMBER(10) NOT NULL,
    dt_hr_visualizacao TIMESTAMP NOT NULL,
    CONSTRAINT pk_mc_visualizacao PRIMARY KEY (cd_visualizacao),
    CONSTRAINT fk_mc_video_visualizacao FOREIGN KEY (cd_video) REFERENCES t_mc_video(cd_video),
    CONSTRAINT fk_mc_acesso_visualizacao FOREIGN KEY (cd_acesso_usuario) REFERENCES t_mc_acesso(cd_acesso_usuario)
);

COMMENT ON COLUMN t_mc_visualizacao.cd_visualizacao IS 'Código da visualização, obrigatório.';
COMMENT ON COLUMN t_mc_visualizacao.cd_video IS 'Código do vídeo, referenciando t_mc_video.cd_video, obrigatório.';
COMMENT ON COLUMN t_mc_visualizacao.dt_hr_visualizacao IS 'Data hora da visualização, obrigatória.';
COMMENT ON COLUMN t_mc_visualizacao.cd_acesso_usuario IS 'Código de acesso do usuário, obrigatório.';


DROP TABLE t_mc_visualizacao CASCADE CONSTRAINTS PURGE;
DROP TABLE t_mc_video_classificacao CASCADE CONSTRAINTS PURGE;
DROP TABLE t_mc_video CASCADE CONSTRAINTS PURGE;
DROP TABLE t_mc_sac CASCADE CONSTRAINTS PURGE;
DROP TABLE t_mc_produto CASCADE CONSTRAINTS PURGE;
DROP TABLE t_mc_categoria_prod CASCADE CONSTRAINTS PURGE;
DROP TABLE t_mc_cli_fisica CASCADE CONSTRAINTS PURGE;
DROP TABLE t_mc_cli_juridica CASCADE CONSTRAINTS PURGE;
DROP TABLE t_mc_cliente CASCADE CONSTRAINTS PURGE;
DROP TABLE t_mc_acesso CASCADE CONSTRAINTS PURGE;
DROP TABLE t_mc_funcionario CASCADE CONSTRAINTS PURGE;
DROP TABLE t_mc_depto CASCADE CONSTRAINTS PURGE;
DROP TABLE t_mc_endereco CASCADE CONSTRAINTS PURGE;
DROP TABLE t_mc_logradouro CASCADE CONSTRAINTS PURGE;
DROP TABLE t_mc_bairro CASCADE CONSTRAINTS PURGE;
DROP TABLE t_mc_estado CASCADE CONSTRAINTS PURGE;
DROP TABLE t_mc_cidade CASCADE CONSTRAINTS PURGE;
DROP SEQUENCE seq_t_mc_categoria_prod;
DROP SEQUENCE seq_t_mc_sac;
DROP SEQUENCE seq_t_mc_cliente;
DROP SEQUENCE seq_t_mc_produto;