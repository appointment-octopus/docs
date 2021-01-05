Entidades ->

Paciente (idPaciente, cpf, nome, { telefone }, email, data_nascimento, senha, foto_de_perfil: url)
Cartão (fk_idPaciente, idCartão, numero, cvv, data_validade, nome_titular)
Dia (idDia, lotado)
Horario (idHorario, fk_idDia, agendado)
ConsultasRealizadas (fk_idPaciente, fk_idHorario)


Relacionamentos ->

1 paciente --possui--> N cartões
1 paciente --marca--> N horários
1 dia --contem--> N horários
N pacientes --participam--> de M consultas