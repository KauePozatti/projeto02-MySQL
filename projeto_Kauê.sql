create database Logística_e_Entregas;
use Logística_e_Entregas;

create table clientes
(
id_cliente int primary key,
nome varchar(120),
email varchar(50) unique,
telefone int(9),
endereço varchar(40)
);

create table pedidos
(
id_pedido int primary key,
id_cliente int,
data_pedido date,
statuss enum('Aguardando Pagamento', 'Processando', 'Pronto para Envio', 'Em Trânsito', 'Entregue', 'Cancelado') not null,
valor_total decimal(10, 2)
);

alter table pedidos add foreign key (id_cliente) references clientes(id_cliente);

create table Armazéns
(
id_Armazem int primary key,
nome varchar(50),
rua varchar(100),
numero varchar(10),
bairro varchar(100),
cidade varchar(100),
estado varchar(50),
cep varchar(20)
);

create table motorista
(
id_motorista int primary key,
nome varchar(100),
cnh char(1),
telefone int(9)
);

create table frota
(
id_veiculo int primary key,
modelo varchar(10),
placa char(7),
capacidade decimal,
id_motorista int
);

alter table frota add foreign key (id_motorista) references motorista(id_motorista);

create table rotas
(
id_rota int primary key,
id_armazem int,
id_pedidos int,
id_veiculo int,
status_rota enum('Aguardando Pagamento', 'Processando', 'Pronto para Envio', 'Em Trânsito', 'Entregue', 'Cancelado') not null
);

alter table rotas add foreign key (id_armazem) references Armazéns(id_armazem);
alter table rotas add foreign key (id_pedido) references pedidos(id_pedido);     #não funcionou
alter table rotas add foreign key (id_veiculo) references frota(Id_veiculo);

create table Rastreamento
(
id_rastreamento int primary key,
id_rota int,
localizacao_atual varchar(255),
horario_atualizacao datetime not null
);
alter table rastreamento modify column horario_atualizacao time;     #para localização ex: 18:00:00 ou 06:00:00

insert into Clientes (id_cliente, nome, email, telefone, endereço)
values
(1, 'Ana Silva', 'ana.silva@email.com', 912345678, 'Rua das Flores, 123'),
(2, 'Carlos Souza', 'carlos.souza@email.com', 987654321, 'Avenida Central, 456'),
(3, 'Mariana Oliveira', 'mariana.oliveira@email.com', 998877665, 'Praça das Árvores, 789'),
(4, 'João Pereira', 'joao.pereira@email.com', 911223344, 'Rua do Sol, 321'),
(5, 'Fernanda Costa', 'fernanda.costa@email.com', 922334455, 'Travessa do Norte, 654');
select * from clientes;

insert into Pedidos (id_pedido, id_cliente, data_pedido, statuss, valor_total)
values
(1, 1, '2024-12-01', 'Aguardando Pagamento', 150.50),
(2, 2, '2024-12-02', 'Processando', 300.75),
(3, 3, '2024-12-03', 'Pronto para Envio', 89.90),
(4, 4, '2024-12-04', 'Em Trânsito', 120.00),
(5, 5, '2024-12-05', 'Entregue', 250.00);
select * from pedidos;

insert into Motorista (id_motorista, nome, cnh, telefone)
values
(1, 'Roberto Lima', 'A', 912345678),
(2, 'Juliana Santos', 'B', 987654321),
(3, 'Carlos Pereira', 'C', 998877665),
(4, 'Fernanda Alves', 'B', 911223344),
(5, 'José Costa', 'A', 922334455);
select * from motorista;

insert into Armazéns (id_armazem, nome, rua, numero, bairro, cidade, estado, cep)
values
(1, 'Armazém Central', 'Rua das Indústrias', '100', 'Industrial', 'São Paulo', 'SP', '01010-000'),
(2, 'Armazém Norte', 'Avenida Brasil', '2500', 'Vila Nova', 'Rio de Janeiro', 'RJ', '20000-000'),
(3, 'Armazém Sul', 'Rua do Comércio', '500', 'Centro', 'Belo Horizonte', 'MG', '30000-000'),
(4, 'Armazém Oeste', 'Travessa dos Trabalhadores', '700', 'São João', 'Curitiba', 'PR', '80000-000'),
(5, 'Armazém Leste', 'Avenida Atlântica', '1200', 'Jardim América', 'Fortaleza', 'CE', '60000-000');
select * from armazéns;

insert into Frota (id_veiculo, modelo, placa, capacidade, id_motorista)
values
(1, 'Furgão', 'ABC1234', 1500.50, 1),
(2, 'Caminhão', 'XYZ5678', 3000.00, 2),
(3, 'Van', 'DEF9876', 1000.00, 3),
(4, 'Carreta', 'LMN5432', 5000.00, 4),
(5, 'Pickup', 'PQR6789', 1200.00, 5);
select * from frota;

insert into Rotas (id_rota, id_armazem, id_pedidos, id_veiculo, status_rota)
values
(1, 1, 1, 1, 'Aguardando Pagamento'),
(2, 2, 2, 2, 'Processando'),
(3, 3, 3, 3, 'Pronto para Envio'),
(4, 4, 4, 4, 'Em Trânsito'),
(5, 5, 5, 5, 'Entregue');
select * from rotas;

insert into Rastreamento (id_rastreamento, id_rota, localizacao_atual, horario_atualizacao)
values
(1, 1, 'Avenida Paulista, próximo ao número 1000', '08:00:00'),
(2, 2, 'Rua das Indústrias, esquina com a Avenida Central', '09:30:00'),
(3, 3, 'Praça das Árvores, próximo ao ponto de ônibus', '11:00:00'),
(4, 4, 'Rua do Sol, esquina com a Travessa do Norte', '14:00:00'),
(5, 5, 'Travessa do Norte, próximo ao número 654', '16:30:00');
select * from rastreamento;

select * from motorista M
inner join frota F
on M.id_motorista = F.id_veiculo;

create view vw_Dados_principais as
select * from rastreamento R
inner join pedidos P
on R.id_rastreamento = P.id_pedido;

select * from vw_Dados_principais;






