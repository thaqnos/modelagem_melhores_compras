CREATE TABLE t_mc_estado (
    sg_estado CHAR(2) NOT NULL,
    nm_estado VARCHAR2(30) NOT NULL,
    CONSTRAINT pk_t_mc_estado PRIMARY KEY (sg_estado)
);

COMMENT ON COLUMN t_mc_estado.sg_estado IS 'Sigla do estado (ex: MG, SP, BH), obrigatório.';
COMMENT ON COLUMN t_mc_estado.nm_estado IS 'Nome do estado (ex: Minas Gerais, São Paulo, Belo Horizonte), obrigatório.';

CREATE TABLE t_mc_cidade (
    cd_cidade NUMBER(10) NOT NULL,
    sg_estado CHAR(2) NOT NULL,
    nm_cidade VARCHAR2(50) NOT NULL,
    cd_ibge NUMBER(10),
    nr_ddd NUMBER(3),
    CONSTRAINT pk_t_mc_cidade PRIMARY KEY (cd_cidade),
    CONSTRAINT fk_t_mc_cidade_estado FOREIGN KEY (sg_estado) REFERENCES t_mc_estado(sg_estado)
);

COMMENT ON COLUMN t_mc_cidade.cd_cidade IS 'Código da cidade (ex: 123, 1234, 12345), obrigatório.';
COMMENT ON COLUMN t_mc_cidade.sg_estado IS 'Sigla do estado, referenciando t_mc_estado.sg_estado, obrigatório.';
COMMENT ON COLUMN t_mc_cidade.nm_cidade IS 'Nome da cidade (ex: São Paulo, Osasco, Guarulhos), obrigatório.';
COMMENT ON COLUMN t_mc_cidade.cd_ibge IS 'Código IBGE da cidade, opcional.';
COMMENT ON COLUMN t_mc_cidade.nr_ddd IS 'DDD da cidade (ex: 11, 12, 13), opcional.';

CREATE TABLE t_mc_bairro (
    cd_bairro NUMBER(10) NOT NULL,
    cd_cidade NUMBER(10) NOT NULL,
    nm_bairro VARCHAR2(50) NOT NULL,
    nm_zona_bairro VARCHAR2(50),
    CONSTRAINT pk_t_mc_bairro PRIMARY KEY (cd_bairro),
    CONSTRAINT fk_t_mc_bairro_cidade FOREIGN KEY (cd_cidade) REFERENCES t_mc_cidade(cd_cidade)
);

COMMENT ON COLUMN t_mc_bairro.cd_bairro IS 'Código do bairro (ex: 123, 1234, 12345), obrigatório.';
COMMENT ON COLUMN t_mc_bairro.cd_cidade IS 'Código da cidade, referenciando t_mc_cidade.cd_cidade, obrigatório.';
COMMENT ON COLUMN t_mc_bairro.nm_bairro IS 'Nome do bairro (ex: Vila Mariana, Praça da Árvore, Santa Cruz), obrigatório.';
COMMENT ON COLUMN t_mc_bairro.nm_zona_bairro IS 'Zona do bairro (ex: Zona Norte, Zona Sul, Centro), opcional.';

CREATE TABLE t_mc_logradouro (
    cd_logradouro NUMBER(10) NOT NULL,
    cd_bairro NUMBER(10) NOT NULL,
    nm_logradouro VARCHAR2(100) NOT NULL,
    nr_cep NUMBER(8) NOT NULL,
    CONSTRAINT pk_t_mc_logradouro PRIMARY KEY (cd_logradouro),
    CONSTRAINT fk_t_mc_logradouro_bairro FOREIGN KEY (cd_bairro) REFERENCES t_mc_bairro(cd_bairro)
);

COMMENT ON COLUMN t_mc_logradouro.cd_logradouro IS 'Código do logradouro (ex: 123, 1234, 12345), obrigatório.';
COMMENT ON COLUMN t_mc_logradouro.cd_bairro IS 'Código do bairro, referenciando t_mc_bairro.cd_bairro, obrigatório.';
COMMENT ON COLUMN t_mc_logradouro.nm_logradouro IS 'Nome do logradouro (ex: Rua Jureia, Rua Isabel de Gois), obrigatório.';
COMMENT ON COLUMN t_mc_logradouro.nr_cep IS 'CEP do logradouro (ex: 04123030, 04129060), obrigatório.';

CREATE TABLE t_mc_cliente (
    cd_cliente NUMBER(10) NOT NULL,
    nm_cliente VARCHAR2(160) NOT NULL UNIQUE,
    tp_cliente CHAR(1) NOT NULL,
    nm_login VARCHAR2(50) NOT NULL,
    ds_senha VARCHAR2(50) NOT NULL,
    st_cliente CHAR(1) NOT NULL,
    qt_estrelas NUMBER(1),
    ds_email VARCHAR2(80),
    nr_tel NUMBER(11),
    CONSTRAINT pk_t_mc_cliente PRIMARY KEY (cd_cliente)
);

COMMENT ON COLUMN t_mc_cliente.cd_cliente IS 'Código único do cliente, gerado pela sequence SQ_MC_CLIENTE, obrigatório.';
COMMENT ON COLUMN t_mc_cliente.nm_cliente IS 'Nome do cliente (ex: Joana Silva, Marina Queiroz), obrigatório.';
COMMENT ON COLUMN t_mc_cliente.tp_cliente IS 'Tipo do cliente: F (físico) ou J (jurídico), obrigatório.';
COMMENT ON COLUMN t_mc_cliente.nm_login IS 'Login do cliente, único, obrigatório.';
COMMENT ON COLUMN t_mc_cliente.ds_senha IS 'Senha do cliente, obrigatória.';
COMMENT ON COLUMN t_mc_cliente.st_cliente IS 'Status do cliente: A (ativo) ou I (inativo), obrigatório.';
COMMENT ON COLUMN t_mc_cliente.qt_estrelas IS 'Quantidade de estrelas do cliente (1 a 5), opcional.';
COMMENT ON COLUMN t_mc_cliente.ds_email IS 'Email do cliente, opcional.';
COMMENT ON COLUMN t_mc_cliente.nr_tel IS 'Telefone do cliente, opcional.';

CREATE TABLE t_mc_cli_juridica (
    cd_cliente NUMBER(10) NOT NULL,
    dt_fundacao DATE,
    nr_cnpj VARCHAR2(14),
    nr_inscr_est VARCHAR2(9),
    CONSTRAINT pk_t_mc_cli_juridica PRIMARY KEY (cd_cliente),
    CONSTRAINT fk_t_mc_cli_juridica_cliente FOREIGN KEY (cd_cliente) REFERENCES t_mc_cliente(cd_cliente)
);

COMMENT ON COLUMN t_mc_cli_juridica.cd_cliente IS 'Código do cliente, referenciando t_mc_cliente.cd_cliente, obrigatório.';
COMMENT ON COLUMN t_mc_cli_juridica.dt_fundacao IS 'Data de fundação do cliente jurídico, opcional.';
COMMENT ON COLUMN t_mc_cli_juridica.nr_cnpj IS 'CNPJ do cliente jurídico, opcional.';
COMMENT ON COLUMN t_mc_cli_juridica.nr_inscr_est IS 'Inscrição estadual do cliente jurídico, opcional.';

CREATE TABLE t_mc_cli_fisica (
    cd_cliente NUMBER(10) NOT NULL,
    dt_nasc DATE NOT NULL,
    nr_cpf NUMBER(11) NOT NULL,
    fl_sexo_biologico CHAR(1) NOT NULL,
    ds_genero VARCHAR2(50),
    CONSTRAINT pk_t_mc_cli_fisica PRIMARY KEY (cd_cliente),
    CONSTRAINT fk_t_mc_cli_fisica_cliente FOREIGN KEY (cd_cliente) REFERENCES t_mc_cliente(cd_cliente)
);

COMMENT ON COLUMN t_mc_cli_fisica.cd_cliente IS 'Código do cliente, referenciando t_mc_cliente.cd_cliente, obrigatório.';
COMMENT ON COLUMN t_mc_cli_fisica.dt_nasc IS 'Data de nascimento do cliente físico, obrigatória.';
COMMENT ON COLUMN t_mc_cli_fisica.nr_cpf IS 'CPF do cliente físico, obrigatório.';
COMMENT ON COLUMN t_mc_cli_fisica.fl_sexo_biologico IS 'Sexo biológico do cliente físico, obrigatório.';
COMMENT ON COLUMN t_mc_cli_fisica.ds_genero IS 'Gênero do cliente físico, opcional.';

CREATE TABLE t_mc_depto (
    cd_depto NUMBER(3) NOT NULL,
    nm_depto VARCHAR2(100) NOT NULL,
    st_depto CHAR(1) NOT NULL,
    CONSTRAINT pk_t_mc_depto PRIMARY KEY (cd_depto)
);

COMMENT ON COLUMN t_mc_depto.cd_depto IS 'Código do departamento, obrigatório.';
COMMENT ON COLUMN t_mc_depto.nm_depto IS 'Nome do departamento, obrigatório.';
COMMENT ON COLUMN t_mc_depto.st_depto IS 'Status do departamento: A (ativo) ou I (inativo), obrigatório.';

CREATE TABLE t_mc_funcionario (
    cd_func NUMBER(10) NOT NULL,
    nm_func VARCHAR2(160) NOT NULL,
    nr_cpf NUMBER(11) NOT NULL UNIQUE,
    cd_depto NUMBER(3) NOT NULL,
    nm_funcionario VARCHAR2(150) NOT NULL,
    dt_nasc DATE NOT NULL,
    nr_tel NUMBER(11) NOT NULL,
    ds_email VARCHAR2(80) NOT NULL,
    ds_cargo VARCHAR2(100) NOT NULL,
    cd_gerente NUMBER(10),
    fl_sexo_biologico CHAR(1),
    ds_genero VARCHAR2(50),
    vl_salario NUMBER(10,2),
    st_func CHAR(1),
    dt_cadastramento DATE,
    dt_desligamento DATE,
    CONSTRAINT pk_t_mc_funcionario PRIMARY KEY (cd_func),
    CONSTRAINT fk_t_mc_funcionario_depto FOREIGN KEY (cd_depto) REFERENCES t_mc_depto(cd_depto),
    CONSTRAINT fk_t_mc_funcionario_gerente FOREIGN KEY (cd_gerente) REFERENCES t_mc_funcionario(cd_func)
);

COMMENT ON COLUMN t_mc_funcionario.cd_func IS 'Código do funcionário, obrigatório.';
COMMENT ON COLUMN t_mc_funcionario.nm_func IS 'Nome do funcionário, obrigatório.';
COMMENT ON COLUMN t_mc_funcionario.nr_cpf IS 'CPF do funcionário, único, obrigatório.';
COMMENT ON COLUMN t_mc_funcionario.cd_depto IS 'Código do departamento, referenciando t_mc_depto.cd_depto, obrigatório.';
COMMENT ON COLUMN t_mc_funcionario.nm_funcionario IS 'Nome do funcionário, obrigatório.';
COMMENT ON COLUMN t_mc_funcionario.dt_nasc IS 'Data de nascimento do funcionário, obrigatória.';
COMMENT ON COLUMN t_mc_funcionario.nr_tel IS 'Telefone do funcionário, obrigatório.';
COMMENT ON COLUMN t_mc_funcionario.ds_email IS 'Email do funcionário, opcional.';
COMMENT ON COLUMN t_mc_funcionario.ds_cargo IS 'Cargo do funcionário, opcional.';
COMMENT ON COLUMN t_mc_funcionario.cd_gerente IS 'Código do gerente do funcionário, referenciando t_mc_funcionario.cd_func, opcional.';
COMMENT ON COLUMN t_mc_funcionario.fl_sexo_biologico IS 'Sexo biológico do funcionário: F (feminino) ou M (masculino), opcional.';
COMMENT ON COLUMN t_mc_funcionario.ds_genero IS 'Gênero do funcionário, opcional.';
COMMENT ON COLUMN t_mc_funcionario.vl_salario IS 'Salário do funcionário, opcional.';
COMMENT ON COLUMN t_mc_funcionario.st_func IS 'Status do funcionário: A (ativo) ou I (inativo), opcional.';
COMMENT ON COLUMN t_mc_funcionario.dt_cadastramento IS 'Data de cadastramento do funcionário, opcional.';
COMMENT ON COLUMN t_mc_funcionario.dt_desligamento IS 'Data de desligamento do funcionário, opcional.';

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

COMMENT ON COLUMN t_mc_endereco.cd_end IS 'Código do endereço, obrigatório.';
COMMENT ON COLUMN t_mc_endereco.cd_logradouro IS 'Código do logradouro, referenciando t_mc_logradouro.cd_logradouro, obrigatório.';
COMMENT ON COLUMN t_mc_endereco.cd_cliente IS 'Código do cliente, referenciando t_mc_cliente.cd_cliente, obrigatório.';
COMMENT ON COLUMN t_mc_endereco.cd_func IS 'Código do funcionário, referenciando t_mc_funcionario.cd_func, obrigatório.';
COMMENT ON COLUMN t_mc_endereco.nr_end IS 'Número do endereço, obrigatório.';
COMMENT ON COLUMN t_mc_endereco.st_end IS 'Status do endereço: A (ativo) ou I (inativo), obrigatório.';
COMMENT ON COLUMN t_mc_endereco.dt_inicio IS 'Data de início do endereço, obrigatória.';
COMMENT ON COLUMN t_mc_endereco.dt_termino IS 'Data de término do endereço, opcional.';
COMMENT ON COLUMN t_mc_endereco.ds_complemento IS 'Complemento do endereço, opcional.';

CREATE TABLE t_mc_categoria_prod (
    cd_categoria NUMBER(10) NOT NULL,
    ds_categoria VARCHAR2(100) NOT NULL UNIQUE,
    st_categoria CHAR(1) NOT NULL,
    tp_categoria CHAR(1) NOT NULL,
    dt_inicio DATE NOT NULL,
    dt_termino DATE,
    CONSTRAINT pk_t_mc_categoria_prod PRIMARY KEY (cd_categoria)
);

COMMENT ON COLUMN t_mc_categoria_prod.cd_categoria IS 'Código único da categoria, gerado pela sequence T_MC_CATEGORIA, obrigatório.';
COMMENT ON COLUMN t_mc_categoria_prod.ds_categoria IS 'Descrição da categoria, única, obrigatória.';
COMMENT ON COLUMN t_mc_categoria_prod.st_categoria IS 'Status da categoria: A (ativo) ou I (inativo), obrigatório.';
COMMENT ON COLUMN t_mc_categoria_prod.tp_categoria IS 'Tipo da categoria: V (vídeo) ou P (produto), obrigatório.';
COMMENT ON COLUMN t_mc_categoria_prod.dt_inicio IS 'Data de início da categoria (DD/MM/YYYY), obrigatória.';
COMMENT ON COLUMN t_mc_categoria_prod.dt_termino IS 'Data de término da categoria (DD/MM/YYYY), opcional. Se preenchida, indica categoria encerrada.';

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

COMMENT ON COLUMN t_mc_produto.cd_produto IS 'Código único do produto, gerado pela sequence T_MC_PRODUTO, obrigatório.';
COMMENT ON COLUMN t_mc_produto.cd_categoria IS 'Código da categoria do produto, referenciando t_mc_categoria_prod.cd_categoria, obrigatório.';
COMMENT ON COLUMN t_mc_produto.ds_produto IS 'Descrição principal do produto, única, obrigatória.';
COMMENT ON COLUMN t_mc_produto.vl_unitario_produto IS 'Valor unitário do produto, maior que 0, obrigatório.';
COMMENT ON COLUMN t_mc_produto.ds_completa_produto IS 'Descrição completa do produto, obrigatória.';
COMMENT ON COLUMN t_mc_produto.nr_cd_barras_produto IS 'Código de barras do produto (padrão EAN13), opcional.';
COMMENT ON COLUMN t_mc_produto.st_produto IS 'Status do produto: A (ativo) ou I (inativo), padrão A.';

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

COMMENT ON COLUMN t_mc_sgv_sac.nr_sac IS 'Número único do chamado SAC feito pelo cliente, gerado pela sequence SQ_MC_SGV_SAC.';
COMMENT ON COLUMN t_mc_sgv_sac.cd_cliente IS 'Código único do cliente na plataforma e-commerce da Melhores Compras, referenciando t_mc_cliente.cd_cliente.';
COMMENT ON COLUMN t_mc_sgv_sac.cd_produto IS 'Código do produto relacionado ao SAC, referenciando t_mc_produto.cd_produto.';
COMMENT ON COLUMN t_mc_sgv_sac.cd_func IS 'Código do funcionário responsável pelo atendimento do SAC, referenciando t_mc_funcionario.cd_func.';
COMMENT ON COLUMN t_mc_sgv_sac.tx_sac IS 'Texto do SAC escrito pelo cliente, máximo de 4000 caracteres, obrigatório.';
COMMENT ON COLUMN t_mc_sgv_sac.dt_abertura_sac IS 'Data e hora de abertura do SAC pelo cliente, obrigatório.';
COMMENT ON COLUMN t_mc_sgv_sac.hr_abertura_sac IS 'Hora de abertura do SAC pelo cliente, obrigatório.';
COMMENT ON COLUMN t_mc_sgv_sac.nr_tempo_total_sac IS 'Tempo total em horas (HH24) desde a abertura até a conclusão do SAC.';
COMMENT ON COLUMN t_mc_sgv_sac.tp_sac IS 'Tipo do SAC: 1 (Sugestão) ou 2 (Reclamação).';
COMMENT ON COLUMN t_mc_sgv_sac.st_sac IS 'Status do SAC: A (aberto), E (em atendimento), C (cancelado), F (fechado com sucesso), X (fechado com insatisfação).';
COMMENT ON COLUMN t_mc_sgv_sac.ds_detalhada_sac IS 'Descrição detalhada do SAC aberta pelo cliente, opcional.';
COMMENT ON COLUMN t_mc_sgv_sac.dt_atendimento_sac IS 'Data e hora do atendimento do SAC pelo funcionário, opcional.';
COMMENT ON COLUMN t_mc_sgv_sac.hr_atendimento_sac IS 'Hora do atendimento do SAC pelo funcionário, opcional.';
COMMENT ON COLUMN t_mc_sgv_sac.ds_detalhada_retorno_sac IS 'Descrição detalhada do retorno do funcionário ao cliente, opcional.';
COMMENT ON COLUMN t_mc_sgv_sac.nr_indice_satisfacao_sac IS 'Índice de satisfação do cliente (1 a 100), opcional.';

CREATE TABLE t_mc_video ( 
    cd_video NUMBER(10) NOT NULL, 
    cd_produto NUMBER(10) NOT NULL, 
    st_video CHAR (1), 
    ds_video VARCHAR2(100), 
    dt_cadastro_video DATE, 
    CONSTRAINT pk_t_mc_video PRIMARY KEY (cd_video),
    CONSTRAINT fk_t_mc_video_produto FOREIGN KEY (cd_produto) REFERENCES t_mc_produto(cd_produto)
);

COMMENT ON COLUMN t_mc_video.cd_video IS 'Código único do vídeo, obrigatório.';
COMMENT ON COLUMN t_mc_video.cd_produto IS 'Código do produto relacionado ao vídeo, referenciando t_mc_produto.cd_produto, obrigatório.';
COMMENT ON COLUMN t_mc_video.st_video IS 'Status do vídeo: A (ativo) ou I (inativo).';
COMMENT ON COLUMN t_mc_video.ds_video IS 'Descrição detalhada do vídeo, opcional.';
COMMENT ON COLUMN t_mc_video.dt_cadastro_video IS 'Data de cadastro do vídeo na plataforma, opcional.';

CREATE TABLE t_mc_video_classificacao (
    cd_classificacao NUMBER(10) NOT NULL,
    cd_video NUMBER(10) NOT NULL,
    ds_classificacao VARCHAR2(100) NOT NULL,
    CONSTRAINT pk_t_mc_video_classificacao PRIMARY KEY (cd_classificacao),
    CONSTRAINT fk_t_mc_video_classificacao_video FOREIGN KEY (cd_video) REFERENCES t_mc_video(cd_video)
);

COMMENT ON COLUMN t_mc_video_classificacao.cd_classificacao IS 'Código da classificação do vídeo, obrigatório.';
COMMENT ON COLUMN t_mc_video_classificacao.cd_video IS 'Código do vídeo, referenciando t_mc_video.cd_video, obrigatório.';
COMMENT ON COLUMN t_mc_video_classificacao.ds_classificacao IS 'Descrição da classificação do vídeo (ex: Instalação, Uso Diário, Comercial), obrigatória.';

CREATE TABLE t_mc_visualizacao (
    cd_visualizacao NUMBER(10) NOT NULL,
    cd_video NUMBER(10) NOT NULL,
    cd_cliente NUMBER(10) NOT NULL,
    dt_visualizacao DATE NOT NULL,
    hr_visualizacao NUMBER(2) NOT NULL,
    min_visualizacao NUMBER(2),
    seg_visualizacao NUMBER(2),
    CONSTRAINT pk_t_mc_visualizacao PRIMARY KEY (cd_visualizacao),
    CONSTRAINT fk_t_mc_visualizacao_video FOREIGN KEY (cd_video) REFERENCES t_mc_video(cd_video),
    CONSTRAINT fk_t_mc_visualizacao_cliente FOREIGN KEY (cd_cliente) REFERENCES t_mc_cliente(cd_cliente)
);

COMMENT ON COLUMN t_mc_visualizacao.cd_visualizacao IS 'Código da visualização, obrigatório.';
COMMENT ON COLUMN t_mc_visualizacao.cd_video IS 'Código do vídeo, referenciando t_mc_video.cd_video, obrigatório.';
COMMENT ON COLUMN t_mc_visualizacao.cd_cliente IS 'Código do cliente, referenciando t_mc_cliente.cd_cliente, obrigatório.';
COMMENT ON COLUMN t_mc_visualizacao.dt_visualizacao IS 'Data da visualização, obrigatória.';
COMMENT ON COLUMN t_mc_visualizacao.hr_visualizacao IS 'Hora da visualização, obrigatória.';
COMMENT ON COLUMN t_mc_visualizacao.min_visualizacao IS 'Minuto da visualização, opcional.';
COMMENT ON COLUMN t_mc_visualizacao.seg_visualizacao IS 'Segundo da visualização, opcional.';

-- DELEÇÃO DE TABELAS
DROP TABLE t_mc_visualizacao CASCADE CONSTRAINTS PURGE;
DROP TABLE t_mc_video_classificacao CASCADE CONSTRAINTS PURGE;
DROP TABLE t_mc_video CASCADE CONSTRAINTS PURGE;
DROP TABLE t_mc_sgv_sac CASCADE CONSTRAINTS PURGE;
DROP TABLE t_mc_produto CASCADE CONSTRAINTS PURGE;
DROP TABLE t_mc_categoria_prod CASCADE CONSTRAINTS PURGE;
DROP TABLE t_mc_cli_fisica CASCADE CONSTRAINTS PURGE;
DROP TABLE t_mc_cli_juridica CASCADE CONSTRAINTS PURGE;
DROP TABLE t_mc_cliente CASCADE CONSTRAINTS PURGE;
DROP TABLE t_mc_funcionario CASCADE CONSTRAINTS PURGE;
DROP TABLE t_mc_depto CASCADE CONSTRAINTS PURGE;
DROP TABLE t_mc_endereco CASCADE CONSTRAINTS PURGE;
DROP TABLE t_mc_logradouro CASCADE CONSTRAINTS PURGE;
DROP TABLE t_mc_bairro CASCADE CONSTRAINTS PURGE;
DROP TABLE t_mc_cidade CASCADE CONSTRAINTS PURGE;
DROP TABLE t_mc_estado CASCADE CONSTRAINTS PURGE;