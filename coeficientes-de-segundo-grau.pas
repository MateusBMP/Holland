{
   Este é um programa do algoritmo genético de Holland
   para encontrar os coeficientes de uma função de 
   segundo grau.
   * a população é formada por 10 cromossomo 
   * o cromossomo é um vetor de 2 posições 
   * cruzamento de um ponto de corte e probabilidade de cruzamento maior que 60
   * mutação por complemento com probabilidade de mutação maior que 90
   * inversão com probabilidade de inversão de 90
   * seleção e substituição elitista 
}

Program CoeficientesDeSegundoGrau;

uses Math;

type pop= array[1..10,1..2,1..12] of integer;
     adapt= array[1..10] of real;
     des= array[1..30,1..2,1..12] of integer;
     adaptdes= array[1..30] of real;
     coeficiente= array[1..3] of integer;

var pA: pop;
    dA: des;
    f: adapt;
    fdes: adaptdes;
    i,j,k: integer;
    tamD: integer;
    coef: coeficiente;

function pop2int(p: pop; a, b: integer): integer;  // Exibe um binário da população em formato inteiro
var i,j,result: integer;
begin
    result := 0;
    j := 0;

    for i:= 12 downto 2 do                         // laço do binário ao contrário
    begin
        result := result + (p[a,b,i] * (2**j));    // Calcula o binário elevando a potência da posição
        j := j + 1;
    end;

    if (p[a,b,1] = 1) then                         // caso o primeiro digito seja 1
        result := (-1) * result;                   // inverte o sinal do número

    pop2int := result;
end;

function des2int(d: des; a, b: integer): integer;  // Exibe um binário do descendente em formato inteiro
var i,j,result: integer;
begin
    result := 0;
    j := 0;

    for i:= 12 downto 2 do                         // laço do binário ao contrário
    begin
        result := result + (d[a,b,i] * (2**j));    // Calcula o binário elevando a potência da posição
        j := j + 1;
    end;

    if (d[a,b,1] = 1) then                         // caso o primeiro digito seja 1
        result := (-1) * result;                   // inverte o sinal do número

    des2int := result;
end;

function int2real(a: integer): real;               // Exibe um inteiro com duas casas decimais
begin
    int2real := a / 100;
end;

function pop2real(p: pop; a,b: integer): real;     // Exibe um binário da população com duas casas decimais
begin
    pop2real := int2real(pop2int(p,a,b));
end;

function des2real(d: des; a,b: integer): real;     // Exibe um binário do descendente com duas casas decimais
begin
    des2real := int2real(des2int(d,a,b));
end;

procedure gera_pop_in(var p: pop);					// gera aleatoriamente a população inicial
begin
    for i:= 1 to 10 do								// laço do população
        for j:= 1 to 2 do							// laço do coeficiente
            for k:= 1 to 12 do                      // laço do binário
                p[i,j,k]:= random(2);
end;

procedure mostra_pop(p: pop);						// mostra a população atual
begin
    for i:= 1 to 10 do								// laço da população
        begin
            for j:= 1 to 2 do			            // laço do coeficiente
                write(pop2real(p,i,j):2:2, ' ');         // escreve numero real do binario
            writeln;    							// salta de linha  
        end;
end;

procedure adaptacao(var f1: adapt; p: pop; coef: coeficiente);			// calcula o valor da adaptação da população atual
begin
    for i:= 1 to 10 do								// laço do população
        begin										
            f1[i]:= 0;								// local onde a adaptação do coeficiente i será armazenada
            for j:= 1 to 2 do						// laço do coeficiente
                f1[i]:= f1[i] + abs((coef[1] * (pop2real(p,i,j)**2)) + (coef[2] * pop2real(p,i,j)) + (coef[3]));	 // incrementa o valor da adaptação a partir do resultado da equação
        end;    
end;

procedure mostra_pop_adapt(f1: adapt; p: pop); 		// mostra a população atual com sua adaptação
begin
    for i:= 1 to 10 do								// laço da população
        begin
            for j:= 1 to 2 do						// laço do coeficiente
                write(pop2real(p,i,j):2:2, ' ');	// escreve cada posição do coeficiente
            writeln('= ', f1[i]:10:0);    				// escreve a adaptação do coeficiente e salta de linha	
        end;    
end;

procedure ordena_pop(var f1: adapt; var p: pop);	// algoritmo bolha de ordenação
var a,b,c: integer;
    d: real;
begin
    for a:= 1 to 9 do								// laço do primeiro ponteiro
        for b:= a+1 to 10 do						// laço do segundo pondeiro
            begin
                if (f1[a] > f1[b])
                then begin
                        for i:= 1 to 2 do			// troca os coeficientes na população
                            for j:= 1 to 12 do
                            begin
                                c:= p[a,i,j];
                                p[a,i,j]:= p[b,i,j];
                                p[b,i,j]:= c;
                            end;
                        d:= f1[a];					// troca a adaptação
                        f1[a]:= f1[b];
                        f1[b]:= d;
                     end;
            end;
end;

procedure cruzamento(p: pop; var d: des; var tam: integer);		// cruzamento de 1 ponto de corte
var a,b,c,x,corte: integer;
begin
    for a:= 1 to 4 do											// laço do cromossomo pai
        for b:= (a + 1) to 5 do									// laço do cromossomo mãe
            begin
                x:= random(100) + 1;      						// probabilidade de cruzamento
                if (x>60) and (tam<=28) then 
                begin
                    for c:= 1 to 2 do
                    begin
                        corte:= random(12) + 1;				// geração do ponto de corte
                                                        
                        for x:= 1 to corte do				// copia a primeira parte da posição 1 até corte
                            begin
                                d[tam + 1,c,x]:= p[a,c,x];
                                d[tam + 2,c,x]:= p[b,c,x];
                            end;
                            
                        for x:= corte + 1 to 12 do			// copia a segunda parte da posição corte+1 até 8
                            begin
                                d[tam + 1,c,x]:= p[b,c,x];
                                d[tam + 2,c,x]:= p[a,c,x];
                            end;
                    end;
                            
                    tam:= tam + 2;
                end;
            end;
end;

procedure mostra_des(d: des;tam: integer);						// mostra a população de descendentes
begin
    for i:= 1 to tam do
        begin
            for j:= 1 to 2 do
                write(des2real(d,i,j):2:2, ' ');               // escreve numero real do binario
            writeln;    
        end;    
end;

procedure mutacao(p: pop; var d: des; var tam: integer);		// mutação por complemento
var a,b,c,x: integer;
begin
    for a:= 1 to 5 do											// laço do cromossomo a ser mutado
    begin
        x:= random(100) + 1;								    // probabilidade de mutação
        if (tam <=29) and (x>90) then 
        begin
            tam:= tam + 1;									
            for b:= 1 to 2 do
                for c:= 1 to 12 do
                begin
                    x:= random(2);	    						// verifica se deve mutar a atual posição do cromossomo
                    if (x = 0)
                    then if (p[a,b,c] = 0)
                        then d[tam,b,c]:= 1
                        else d[tam,b,c]:= 0
                    else d[tam,b,c]:= p[a,b,c];
                end;
        end;
    end;
end;

procedure inversao(p: pop; var d: des; var tam: integer);
var a,b,c,p1,p2,x,y: integer;
begin
    for a:= 1 to 5 do
        begin
            x:= random(100) + 1;									// probabilidade de inversão é maior do que 90
            if (x>90) and (tam<=29) then 
            begin
                tam:= tam + 1;
                for c:= 1 to 2 do
                begin
                    for b:= 1 to 12 do								// copia o cromossomo 
                        d[tam,c,b]:= p[a,c,b];

                    p1:= random(11) + 1;								// escolhe a primeira posição
                    p2:= random(12) + 1;						
                    while (p2<p1) do 								// escolhe a segunda posição, onde p1 < p2
                        p2:= random(12) + 1;						
                    
                    x:= (p2-p1) div 2;
                    
                    for b:= 0 to x do								// inverte o conteúdo do cromossomo entre p1 e p2
                    begin
                        y:= d[tam, c, p1 + b];
                        d[tam, c, p1 + b]:= d[tam, c, p2 - b ];
                        d[tam, c, p2 - b]:= y;
                    end;
                end;
            end;
        end;
end;

procedure adaptacaoD(var f2: adaptdes; d: des; coef: coeficiente; tam: integer);
begin
    for i:= 1 to tam do
        begin
            f2[i]:= 0;
            for j:= 1 to 2 do
                f2[i]:= f2[i] + abs((coef[1] * (des2real(d,i,j)**2)) + (coef[2] * (des2real(d,i,j)**2)) + (coef[3]));
        end;    
end;

procedure mostra_pop_adaptD(f2: adaptdes; d: des; tam: integer);
begin
    for i:= 1 to tam do
        begin
            for j:= 1 to 2 do						    // laço do coeficiente
                write(des2real(d,i,j):2:2, ' ');	    // escreve cada posição do coeficiente
            writeln('= ', f2[i]:10:0);    				// escreve a adaptação do coeficiente e salta de linha	  
        end;    
end;

procedure ordena_popD(var f2: adaptdes; var d: des; tam: integer);		// oedenação de bolha
var a,b,c: integer;
    x: real;
begin
    for a:= 1 to tam - 1 do
        for b:= a + 1 to tam do
            begin
                if (f2[a] > f2[b])							
                then begin
                
                        for i:= 1 to 2 do								// troca cromossomo
                            for j:= 1 to 12 do
                            begin
                                c:= d[a,i,j];
                                d[a,i,j]:= d[b,i,j];
                                d[b,i,j]:= c;
                            end;
                            
                        x:= f2[a];										// troca adaptação
                        f2[a]:= f2[b];
                        f2[b]:= x;
                        
                     end;
            end;
end;

// Esse algoritmo aqui tem um erro que não seleciona os melhores das duas populações.
// É preciso corrigir isso para se obter o resultado, ou até localizar outro erro, se
// for o caso.
procedure substituicao(var p: pop; d: des; var f1: adapt; f2: adaptdes; tam: integer);
var a,b,c,x: integer;
    pN: pop;
    f3: adaptdes;
begin
    b:= 1; 											// indice da população atual 
    c:= 1; 											// indice da população de descendentes
    for a:= 1 to 10 do 								// indice da nova população
        begin
			if (b<=10) and (c<=tam)  
			then 	if (f1[b] > f2[c])				// população é maior que descendente
					then begin 
                    		for i:= 1 to 2 do		// copia o cromossomo da população atual para a nova população
                                for j:= 1 to 12 do
                        		    pN[a,i,j]:= p[b,i,j];
                    		f3[a]:= f1[b];			// copia a adaptação desse cromossomo
                    		b:= b + 1;				// incrementa o indice da população atual
						 end
                    else begin
							for i:= 1 to 2 do		// copia o cromossomo da população de descendentes para a nova população
								for j:= 1 to 12 do
                                    pN[a,i,j]:= d[c,i,j];
							f3[a]:= f2[c];			// copia a adaptação desse cromossomo
							c:= c + 1;				// incrementa o indice da população de descendentes
						 end
						 
			else 	if (b<=10) and (c>tam)
					then begin 
							for i:= 1 to 2 do		// copia o cromossomo da população atual para a nova população
								for j:= 1 to 12 do
                                    pN[a,i,j]:= p[b,i,j];
                    		f3[a]:= f1[b];			// copia a adaptação desse cromossomo
                    		b:= b + 1;				// incrementa o indice da população atual
                 	      end
					else begin
							for i:= 1 to 2 do
								for j:= 1 to 12 do
                                    pN[a,i,j]:= d[c,i,j];
							f3[a]:= f2[c];
							c:= c + 1;
						 end    
        end;

    for a:= 1 to 10 do								// coloca a nova população no lugar da população atual
        begin
            for i:= 1 to 2 do
                for j:= 1 to 12 do
                    p[a,i,j]:= pN[a,i,j];
            f1[a]:= f3[a];							// coloca a nova adaptação no lugar da adaptação atual
        end;    
end;

begin
    Randomize;

    write('Escreva os coeficientes: 4 0 -16');
    // read(coef[1], coef[2], coef[3]);
    coef[1]:= 4;
    coef[2]:= 0;
    coef[3]:= -16;
    
    writeln; writeln('populacao atual gerada');
    gera_pop_in(pA);
    mostra_pop(pA);
    
    writeln; writeln('populacao atual com sua adaptacao');
    adaptacao(f,pA,coef);
    mostra_pop_adapt(f,pA);
    
    writeln; writeln('populacao atual na ordem crescente da adaptacao');
    ordena_pop(f,pA);
    mostra_pop_adapt(f,pA);

    while (f[1]>100) do
    begin
        {vou ficar com os 5 cromossomos mais adaptados, que são os 5 primeiros da minha população atual}

        tamD:= 0;

        writeln; writeln('cruzamento');
        cruzamento(pA,dA,tamD);
        mostra_des(dA,tamD);

        writeln; writeln('mutacao');
        mutacao(pA,dA,tamD);
        mostra_des(dA,tamD);

        writeln; writeln('inversao');
        inversao(pA,dA,tamD);
        mostra_des(dA,tamD);

        writeln; writeln('população descencente com sua adaptação');
        adaptacaoD(fdes,dA,coef,tamD);
        mostra_pop_adaptD(fdes,dA,tamD);

        writeln; writeln('população descendente na ordem crescente da adaptação');
        ordena_popD(fdes,dA,tamD);
        mostra_pop_adaptD(fdes,dA,tamD);

        writeln; writeln('população nova');
        substituicao(pA,dA,f,fdes,tamD);
        mostra_pop_adapt(f,pA);
        
    end;

end.
