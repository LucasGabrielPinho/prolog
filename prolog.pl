parametro(ana, pressaoArterial, 95).
parametro(mauricio, temperatura, 38).

estado(Paciente, gravissimo) :-
    parametro(Paciente, frequenciaRespiratoria, Valor), Valor>30;
    parametro(Paciente, pressaoArterial, Valor), Valor<90;
    parametro(Paciente, saturacao, Valor), Valor<95;
    parametro(Paciente, dispneia, Valor), (Valor="s";Valor="S").

estado(Paciente, grave) :-
    parametro(Paciente, temperatura, Valor), Valor>=39;
    parametro(Paciente, idade, Valor), Valor>=80;
    parametro(Paciente, pressaoArterial, Valor), Valor>=90,Valor=<100;
    parametro(Paciente, comorbidades, Valor), Valor>=2.

estado(Paciente, medio) :-
    parametro(Paciente, temperatura, Valor), Valor=<35;
    parametro(Paciente, temperatura, Valor), Valor>=37, Valor=<39;
    parametro(Paciente, frequenciaCardiaca, Valor), Valor>=100;
    parametro(Paciente, frequenciaRespiratoria, Valor), Valor>=19, Valor=<30;
    parametro(Paciente, idade, Valor), Valor>=60, Valor=<79;
    parametro(Paciente, comorbidades, Valor), Valor=:=1.

estado(Paciente, leve) :-
    parametro(Paciente, temperatura, Valor), Valor>35, Valor<37;
    parametro(Paciente, frequenciaCardiaca, Valor), Valor<100;
    parametro(Paciente, frequenciaRespiratoria, Valor), Valor=<18;
    parametro(Paciente, pressaoArterial, Valor), Valor>100;
    parametro(Paciente, saturacao, Valor), Valor>=95;
    parametro(Paciente, dispneia, Valor), (Valor="n"; Valor="N");
    parametro(Paciente, idade, Valor), Valor<60;
    parametro(Paciente, comorbidades, Valor), Valor=:=0.

:- dynamic parametro/3.

main :- carrega('banco.bd'),
    format('~n - INICIO DO SISTEMA - ~n'),
    repeat,
    pergunta(Nome),
    responde(Nome),
    continua(R),
    R=n,
    !,
    salva(parametro, 'banco.bd').

carrega(A) :-
    exists_file(A),
    consult(A)
    ;
    true.

pergunta(Nome) :-
    format('~nQual o nome do paciente?  '),
    gets(Nome),

    format('~nQual a temperatura?  '),
    gets(Temperatura),
    asserta(parametro(Nome, temperatura, Temperatura)),

    format('~nQual a frequência cardíaca?  '),
    gets(FrequenciaCardiaca),
    asserta(parametro(Nome, frequenciaCardiaca, FrequenciaCardiaca)),

    format('~nQual a frequência respiratória?  '),
    gets(FrequenciaRespiratoria),
    asserta(parametro(Nome, frequenciaRespiratoria, FrequenciaRespiratoria)),
    format('~nQual a Pressao Arterial Sistólica?  '),
    gets(PressaoArterial),
    asserta(parametro(Nome, pressaoArterial, PressaoArterial)),
    format('~nQual a saturação?  '),
    gets(Saturacao),
    asserta(parametro(Nome, saturacao, Saturacao)),
    format('~nTem dispnéia?(s/n)  '),
    gets(Dispneia),
    asserta(parametro(Nome, dispneia, Dispneia)),
    format('~nQual a idade?  '),
    gets(Idade),
    asserta(parametro(Nome, idade, Idade)),
    format('~nPossui quantas comorbidades?  '),
    gets(Comorbidades),
    asserta(parametro(Nome, comorbidades, Comorbidades)).

responde(Nome) :-
    estado(Nome, X),
    !,
    format('~n O Estado de ~w é ~w.~n', [Nome, X]).

continua(R) :-
    format('~nDeseja informar outro paciente?(s/n)'),
    get_char(R),
    get_char('\n').

gets(S) :-
    read_line_to_codes(user_input,C),
    name(S,C).

salva(P,A) :-
    tell(A),
    listing(P),
    told.
