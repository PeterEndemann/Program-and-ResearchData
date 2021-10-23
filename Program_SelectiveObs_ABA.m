clear all
close all
%% Controle discriminativo da resposta de observação -
% procedimento SUCESSIVO
%% Preparar a sessao
%dados do participante
nom_expe='PD';
num_suj=input('Numero de sujeto ? \n');
sessao=input('Numero da sessao ? \n');
if sessao==1
    fase=1;% iniciar pela fase
else
    fase=input('Numero da fase? \n');
end
grupo=1;
nom_du_fichier=sprintf('%s_%d_%d.edf',nom_expe,num_suj,sessao);
nome=sprintf('%s_%d_%d',nom_expe,num_suj,sessao);
%%
teste=0;
%% decisoes mportantes!
supertreino=0; %para criterio_controle = 2
criterio_extincao=2 ; % se = 1, numero de tentatva. se =2, criterio de desempenho.
col_Disc=1; % se =1, abolicao pelo S. se = 2, abolicao pelo reforco
%% Parametros uteis
tentativa=3000; % numero de tentativas#
tempodespedida=6;
corteInd=20;
corteFim=160;
crit=6;
int=1;
ID=0;
indiceD=.75;
indicenD=.25;
jorn=[];
jornal=[];
tval_resp=0;
%% variaveis provisorias
nf=1;
cp=0;
amostraCrit=crit;
jornal_ID=[];
%% tempo dos componentes e Esquema de reforço VI
ii=16;
if teste==1
    tempocomponente=[3 2 3 4 4 5 2 6 6 7 8 7 8 9 10 12]/100; % media = 0.06s/60ms de componente
    valorRe_Exp=.3; %.3s / 300ms
else
    tempocomponente=[3 2 3 4 4 5 2 6 6 7 8 7 8 9 10 12]*1000; % media = 6s de componente
    valorRe_Exp=3000; % 3 segundos
end
VI_Re_Exp=fleshoff(ii, valorRe_Exp);% esquema de reforço VI para produção dos sons_Sr
%% Parâmetros de audio
nrchannels = 2;
freq = 5000;
repetitions = 0;
beepLengthSecs = 0.2;
startCue = 0;
waitForDeviceStart = 1;
%% cores
branco=[220 220 220];
preto=[20 20 20];
vermelho=[140 0 0];
amarelo=[140 140 0];
cinza1=[128 128 128];
cinza2=[100 100 100];
verde=[0 140 0];
cordotexto=[0 0 0];
cor1=cinza2;
A=cor1;
B=cor1;
C=cor1;
D=cor1;
%% textso
t0='_ Bem-vindo! _';
t20='Este experimento é composto por 3 fases. \n \n A passagem pelas fases dependerá do seu desempenho.\n \n  Na tela serão apresentados quatro círculos. \n Você poderá olhar para eles livremente. \n Algum destes círculos poderá lhe passar informações relevantes.  \n \n Ao longo da tarefa você poderá ganhar pontos apertando livremente a barra de espaço.  \n Em alguns momentos, Você irá ganhar e acumular pontos.  \n Um som indicará quando um ponto for ganho.  \n  \n Seu objetivo é ganhar o maior número de pontos, da forma mais eficiente possível e chegar ao final da fase 3.';
t10='Leia as Instruções abaixo e quando estiver pronto, clique em qualquer tecla para começar!';

t1='Vamos para a primeira fase! \n Quando estiver pronto, clique em qualquer tecla para começar \n \n \n Lembre-se, você deve ganhar e acumular o maior número de pontos possíveis \n e chegar no final dessa fase para avançar no experimento \n \n Obtenha informações olhando à vontade para o que tem atrás dos círculos \n e ganhe os pontos da formais eficiente possível!';
t2='Muito bom! \n \n Agora continue a ganhar o máximo de pontos possíveis!!';
t3='Vamos para última etapa da primera fase! \n \n Essa etapa é semelhante à primeira. \n \n Ganhe o máximo de pontos da forma mais eficiente possível ';
t4='Parabéns! Você passou para a fase 2 do experimento! \n \n Haverá uma simples diferença nessa fase. Em alguns momentos, os círculos irão se fechar. Para ter acesso às informações novamente, \n você deverá olhar para o centro da tela, onde haverá um pequeno círculo. \n \n \n \n Você está indo bem, continue assim!';
t5='Muito bom! \n \n Agora continue a ganhar o máximo de pontos possíveis!!';
t6='Vamos para última etapa da segunda fase! \n \n Essa etapa é semelhante à primeira. \n \n Ganhe o máximo de pontos da forma mais eficiente possível ';
t7='Parabéns! Você irá começa a terceira e última fase do experimento! \n \n  \n \n \n \n \n Seu objetivo continua o mesmo. \n \n Ganhe o máximo de pontos da forma mais eficiente possível!';


%% variaveis diversas
pause=0;
fim=0;
cal=0;
cal1=0;
raio=15; %raio do ponto de fixacao
est=1;
div2=30;
div=55;
pontos=0;
ponto=0;
fp1=1;
fp2=1;
freqmais=0;
freqmenos=0;
fo1=1;
fo2=1;
tm1=0;
tm2=0;
freqdisc=0;
freqNdisc=0;
fd=1;
fnd=1;
nt=0;
pp=1;
pp1=1;
vi=0;
ct=0;
Condicao=[];
Varie={' fase ' ' tent_fase '  ' cond(1)_S '  ' cond(2)_Sr ' ' cor_bolota1 ' ' cor_bolota2 ' ' T0_component ' ' T0_pontFix '  ' Qual_1ofx ' ' T0_1ofx ' ...
    ' freqFix1 ' 'durFix1'  ' freqFix2 ' 'durFix2'  ' freqFix3 ' 'durFix3'  ' freqFix4 ' 'durFix4'  ' T0_Re1 ' ' freq_Re ' ' media_VI' ' media_Intervalos ' ' Inter_resp ' ' pontos' ' grupo '};
try
    WhichScreen = 1;
    [window, screenRect]=Screen('OpenWindow',0, cinza1,[],32,2); % open screen
    HideCursor;
    try
        Eyelink('Shutdown')
    catch
    end
    if (Eyelink('Initialize')~=0)
        Eyelink('Shutdown')
        Eyelink('Initialize')
        return
    end
    EyelinkInit(0,1)
    el=EyelinkInitDefaults(window);
    %SET UP TRACKER CONFIGURATION
    Eyelink('command', 'sample_rate = 1000');
    Eyelink('command', 'calibration_type = HV13');
    %set parser (psychophysical saccade thresholds)
    Eyelink('command', 'recording_parse_type = GAZE');
    Eyelink('command', 'saccade_velocity_threshold = 30');
    Eyelink('command', 'saccade_acceleration_threshold = 8000');
    Eyelink('command', 'saccade_motion_threshold = 0');
    Eyelink('command', 'fixation_update_interval = 0');
    % make sure that data and event are stored in the EDF files
    Eyelink('command', 'file_sample_data  = GAZE,AREA,STATUS');
    Eyelink('command', 'file_event_data = GAZE,GAZERES,AREA,VELOCITY,STATUS');
    Eyelink('command', 'file_event_filter = LEFT,RIGHT,SACCADE,FIXATION, BLINK,MESSAGE');
    % make sure that we get event data from the Eyelink
    Eyelink('command', 'link_sample_data  = LEFT,RIGHT,GAZE,AREA,STATUS');
    Eyelink('command', 'link_event_data = GAZE,GAZERES,AREA,VELOCITY');
    Eyelink('command', 'link_event_filter = LEFT,RIGHT,BLINK,SACCADE,FIXATION,');
    Eyelink('command', 'add_file_preamble_text ''Recorded by EyelinkToolbox''');
    [width,height]=Screen('WindowSize',window);
    Eyelink('command','screen_pixel_coords= %ld %ld %ld %ld', 0,0,width-1,height-1);
    Eyelink('command','button_function 5 "accept_target_fixation"');
    el.backgroundcolour=preto(1);
    el.foregroundcolour=branco(1);
    Eyelink('StartSetup');
    WaitSecs(0.01);
    priorityLevel=MaxPriority(window);
    Priority(priorityLevel);
    WaitSecs(0.01);
    %% Caliobragem
    if teste==0
        EyelinkDoTrackerSetup(el,'c');
        WaitSecs(0.01);
    end
    %%
    Eyelink('openfile',nom_du_fichier)
    %% coordenadas para a apresentacao dos estímulos
    XYtotal=screenRect(3:4);
    XYcentral=XYtotal/2;
    Xc=XYcentral(1);
    Yc=XYcentral(2);
    dist=XYtotal(2)/4;
    XYpontfix=XYtotal/2;
    b1=[Xc-240 Yc-105 ];
    b2=[Xc-240 Yc+15];
    b3=[Xc-240 Yc+135];
    vect1=[XYcentral(1)+dist XYcentral(2)-dist];
    vect2=[XYcentral(1)+dist XYcentral(2)+dist];
    vect3=[XYcentral(1)-dist XYcentral(2)+dist];
    vect4=[XYcentral(1)-dist XYcentral(2)-dist];
    %% TREINO - fase1 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    start = 1;
    if fase==1
        while start
            Screen ('TextSize',window,30);
            Screen ('TextFont',window,'Arial');
            DrawFormattedText(window,t20, 'center' , 'center' , [240 240 240], 109,[],[],1.63);
            Screen('DrawText', window, t10, Xc/4, Yc/3,[0 0 0], [0 0 0]);
            Screen('DrawText', window, t0, Xc/4, Yc/5,[0 0 0], [0 0 0]);Screen('Flip', window);
            [keyIsDown, secs, keyCode] = KbCheck;
            KD=keyIsDown;
            if KD>0
                start = 0;
            end
        end
        Screen('Flip', window);
        WaitSecs(.5)
    end
    vi=0;
    
    if fase==1 || fase==4
        fundo=preto;
        for j=128:-.5:preto(1)
            Screen(window, 'FillRect',j,screenRect);
            Screen(window, 'Flip');
        end
    elseif fase==7
        fundo=cinza1;
    end
    Screen(window, 'FillRect', fundo,  screenRect);
    Screen(window, 'FillOval', cor1,[vect1(1)-div vect1(2)-div vect1(1)+div vect1(2)+div]);
    Screen(window, 'FillOval', cor1,[vect2(1)-div vect2(2)-div vect2(1)+div vect2(2)+div]);
    Screen(window, 'FillOval', cor1,[vect3(1)-div vect3(2)-div vect3(1)+div vect3(2)+div]);
    Screen(window, 'FillOval', cor1,[vect4(1)-div vect4(2)-div vect4(1)+div vect4(2)+div]);
    Screen(window, 'Flip');
    %% INICIO DAS TENTATIVAS
    for r=1:tentativa
        if cal==1
            if teste==0
                EyelinkDoDriftCorrection(el);
                cal=0;
                WaitSecs(0.8);
                Screen ('TextSize',window,48);
                Screen ('TextFont',window,'Arial');
                DrawFormattedText(window,['Você já acumulou ',num2str(ponto),' pontos'], 'center' , 'center' , [240 240 240], 29,[],[],1.63);
                Screen('Flip', window);
                WaitSecs(3);
                Screen('Flip', window);
                WaitSecs(.5);
            end
        end
        if cal1==1
            if teste==0
                ShowCursor(3);
                txt1='Continuar';
                txt2='Pausar';
                txt3='Retornar outro dia';
                tt='Você deseja continuar? Cique com o mouse em uma das opções';
                Screen(window, 'Flip');
                cal1=0;
                WaitSecs(0.8);
                Screen ('TextSize',window,38);
                Screen ('TextFont',window,'Arial');
                Screen('DrawText', window, tt, Xc-700, Yc-420,cordotexto, [0, 0, 0]);
                Screen('DrawText', window, txt1, Xc-180, Yc-140,cordotexto, [0 0 0]);
                Screen('DrawText', window, txt2, Xc-180, Yc-10,cordotexto, [0 0 0]);
                Screen('DrawText', window, txt3, Xc-180, Yc+110,cordotexto, [0 0 0]);
                Screen(window, 'FillOval', cor1,[b1(1)-div2 b1(2)-div2 b1(1)+div2 b1(2)+div2]);
                Screen(window, 'FillOval', cor1,[b2(1)-div2 b2(2)-div2 b2(1)+div2 b2(2)+div2]);
                Screen(window, 'FillOval', cor1,[b3(1)-div2 b3(2)-div2 b3(1)+div2 b3(2)+div2]);
                Screen(window, 'Flip');
                start = 1;
                D11=10000;
                D21=10000;
                D31=10000;
                D1=10000;
                D2=10000;
                D3=10000;
                while start
                    [clicks,x,y] = GetClicks;
                    [xm,ym,buttons] = GetMouse;
                    D1=sqrt(sum((b1-[x y]).^2));
                    D2=sqrt(sum((b2-[x y]).^2));
                    D3=sqrt(sum((b3-[x y]).^2));
                    if D1<div2
                        WaitSecs(.5);
                        Screen('Flip', window);
                        WaitSecs(.5);
                        start = 0;
                    elseif D2<div2
                        pause=1;
                        start = 0;
                    elseif D3<div2
                        fim = 1;
                        start = 0;
                    end
                    D11=sqrt(sum((b1-[xm ym]).^2));
                    D21=sqrt(sum((b2-[xm ym]).^2));
                    D31=sqrt(sum((b3-[xm ym]).^2));
                    if D11<div2
                        ShowCursor(1);
                    elseif D21<div2
                        ShowCursor(1);
                    elseif D31<div2
                        ShowCursor(1);
                    else
                        ShowCursor(3);
                    end
                end
                if fim==1
                    break
                end
                if pause==1
                    for j=128:-0.8:100
                        Screen(window, 'FillRect',j,screenRect);
                        Screen(window, 'Flip');
                    end
                    Screen ('TextSize',window,38);
                    Screen ('TextFont',window,'Arial');
                    tt1='Cique com o mouse na opção continuar';
                    txt='Continuar';
                    Screen('DrawText', window, tt1, Xc-680, Yc-400,cordotexto, [0, 0, 0]);
                    Screen('DrawText', window, txt, Xc-180, Yc-140,cordotexto, [0 0 0]);
                    Screen(window, 'FillOval',cinza1 ,[b1(1)-div2 b1(2)-div2 b1(1)+div2 b1(2)+div2]);
                    Screen(window, 'Flip');
                    start=1;
                    D1=10000;
                    while start
                        [clicks,x,y] = GetClicks;
                        D1=sqrt(sum((b1-[x y]).^2));
                        if  D1<div2
                            WaitSecs(.5);
                            Screen('Flip', window);
                            WaitSecs(.5);
                            start=0;
                        end
                    end
                end
                WaitSecs(2);
                for jj=100:0.8:128
                    Screen(window, 'FillRect',jj,screenRect);
                    Screen(window, 'Flip');
                end
                HideCursor;
            end
        end
        %% FASES E CONDICOES EXPERIMENTAIS
        if fase==1 %condicionamento - fixacao
            Condicao=[1 1;2 0;1 1;2 0;1 1;2 0;1 1;2 0];
            fundo=preto;
        elseif fase==2 %extincao fixacao
            Condicao=[1 1;2 0;1 1;2 0;1 0;2 1;1 0;2 1];
            fundo=branco;
        elseif fase==3 %condicionamento movimento ocular
            Condicao=[1 1;2 0;1 1;2 0;1 1;2 0;1 1;2 0];
            fundo=preto;
        elseif fase==4 %extincao movimento ocylar
            Condicao=[1 1;2 0;1 1;2 0;1 1;2 0;1 1;2 0];
            fundo=preto;
        elseif fase==5 %discriminacao da ro
            Condicao=[1 1;2 0;1 1;2 0;1 0;2 1;1 0;2 1];
            fundo=branco;
        elseif fase==6 %extincao movimento ocylar
            Condicao=[1 1;2 0;1 1;2 0;1 1;2 0;1 1;2 0];
            fundo=preto;
        elseif fase==7 %discriminacao da ro
            Condicao=[1 1;2 0;1 1;2 0;1 1;2 0;1 1;2 0];
            fundo=cinza1;
        elseif fase==8 % reversao
            if grupo==1 %reversao
                Condicao=[1 1;2 0;1 1;2 0;1 1;2 0;1 1;2 0];
                fundo=cinza1;
            else %extncao abolcao da discrimnacao
                Condicao=[1 1;2 0;1 1;2 0;1 0;2 1;1 0;2 1];
                fundo=cinza1;
            end
        end
        if(nt<1 || nt>size(Condicao,1));
            nt=1;
            T_cond=randperm(size(Condicao,1));
        end
        cond=Condicao(T_cond(nt),:);
        nt=nt+1;
        jorn=[];
        jorn(1)=fase;
        jorn(2)=est;
        jorn(3)=cond(1);
        jorn(4)=cond(2);
        jorn(5)=0;
        jorn(6)=0;
        %% Instrucoes
        if est==1
            largura_texto=109;
            tamanho_letra=30;
            if teste==0
                switch fase
                    case 1
                        start = 1;
                        while start
                            Screen ('TextSize',window,tamanho_letra);
                            Screen ('TextFont',window,'Arial');
                            DrawFormattedText(window,t1, 'center' , 'center' , [240 240 240], largura_texto,[],[],1.63);
                            Screen('Flip', window);
                            [keyIsDown, secs, keyCode] = KbCheck;
                            KD=keyIsDown;
                            if KD>0
                                start = 0;
                            end
                        end
                    case 2
                        start = 1;
                        while start
                            Screen ('TextSize',window,tamanho_letra);
                            Screen ('TextFont',window,'Arial');
                            DrawFormattedText(window,t2, 'center' , 'center' , [240 240 240], largura_texto,[],[],1.63);
                            Screen('Flip', window);
                            [keyIsDown, secs, keyCode] = KbCheck;
                            KD=keyIsDown;
                            if KD>0
                                start = 0;
                            end
                        end
                    case 3
                        start = 1;
                        while start
                            Screen ('TextSize',window,tamanho_letra);
                            Screen ('TextFont',window,'Arial');
                            DrawFormattedText(window,t3, 'center' , 'center' , [240 240 240], largura_texto,[],[],1.63);
                            Screen('Flip', window);
                            [keyIsDown, secs, keyCode] = KbCheck;
                            KD=keyIsDown;
                            if KD>0
                                start = 0;
                            end
                        end
                    case 4
                        start = 1;
                        while start
                            Screen ('TextSize',window,tamanho_letra);
                            Screen ('TextFont',window,'Arial');
                            DrawFormattedText(window,t4, 'center' , 'center' , [240 240 240], largura_texto,[],[],1.63);
                            Screen('Flip', window);
                            [keyIsDown, secs, keyCode] = KbCheck;
                            KD=keyIsDown;
                            if KD>0
                                start = 0;
                            end
                        end
                    case 5
                        start = 1;
                        while start
                            Screen ('TextSize',window,tamanho_letra);
                            Screen ('TextFont',window,'Arial');
                            DrawFormattedText(window,t5, 'center' , 'center' , [240 240 240], largura_texto,[],[],1.63);
                            Screen('Flip', window);
                            [keyIsDown, secs, keyCode] = KbCheck;
                            KD=keyIsDown;
                            if KD>0
                                start = 0;
                            end
                        end
                    case 6
                        start = 1;
                        while start
                            Screen ('TextSize',window,tamanho_letra);
                            Screen ('TextFont',window,'Arial');
                            DrawFormattedText(window,t6, 'center' , 'center' , [240 240 240], largura_texto,[],[],1.63);
                            Screen('Flip', window);
                            [keyIsDown, secs, keyCode] = KbCheck;
                            KD=keyIsDown;
                            if KD>0
                                start = 0;
                            end
                        end
                    case 7
                        start = 1;
                        while start
                            Screen ('TextSize',window,tamanho_letra);
                            Screen ('TextFont',window,'Arial');
                            DrawFormattedText(window,t7, 'center' , 'center' , [240 240 240], largura_texto,[],[],1.63);
                            Screen('Flip', window);
                            [keyIsDown, secs, keyCode] = KbCheck;
                            KD=keyIsDown;
                            if KD>0
                                start = 0;
                            end
                        end
                end
                WaitSecs(0.5)
                Screen('Flip', window);
                WaitSecs(0.5)
            end
        end
        %% Imagens
        if cond(1)==1
            if fase==1 || fase==3 || fase==4 || fase==6
                m1=sprintf('1.jpg');
                m3=sprintf('3.jpg');
                m4=m3;
            elseif fase==2 || fase==5
                m1=sprintf('4.jpg');
                m3=sprintf('6.jpg');
                m4=m3;
            elseif fase==7 || fase==8
                m1=sprintf('7.jpg');
                m3=sprintf('9.jpg');
                m4=m3;
                if rand>.5
                    m2=m1;
                else
                    m2=sprintf('8.jpg');
                end
            end
        else
            if fase==1 || fase==3 || fase==4 || fase==6
                m1=sprintf('2.jpg');
                m3=sprintf('3.jpg');
                m4=m3;
            elseif fase==2 || fase==5
                m1=sprintf('5.jpg');
                m3=sprintf('6.jpg');
                m4=m3;
            elseif fase==7 || fase==8
                m1=sprintf('8.jpg');
                m3=sprintf('9.jpg');
                m4=m3;
                if rand>.5
                    m2=m1;
                else
                    m2=sprintf('7.jpg');
                end
            end
        end
        div1=26;
        %% FASE DE CONTROLE DE EST´MULOS
        CondCor=[1 2 3 4; 1 3 2 4; 1 4 2 3;2 1 3 4; 2 3 1 4;2 4 1 3;3 1 2 4;...
            3 2 1 4;3 4 1 2; 4 1 2 3;4 2 1 3;4 3 1 2];
        if ct<1 || ct> size(CondCor,1)
            ct=1;
            ctrand=randperm(size(CondCor,1));
        end
        CCor=CondCor(ctrand(ct),:);
        ct=ct+1;
        jorn(5)=CCor(1);
        jorn(6)=CCor(2);
        if fase==7
            switch CCor(1)
                case 1
                    A=preto;
                case 2
                    B=preto;
                case 3
                    C=preto;
                case 4
                    D=preto;
            end
            switch CCor(2)
                case 1
                    A=branco;
                case 2
                    B=branco;
                case 3
                    C=branco;
                case 4
                    D=branco;
            end
        elseif fase==8
            switch CCor(1)
                case 1
                    if grupo==2
                        A=preto;
                    else
                        A=branco;
                    end
                case 2
                    if grupo==2
                        B=preto;
                    else
                        B=branco;
                    end
                case 3
                    if grupo==2
                        C=preto;
                    else
                        C=branco;
                    end
                case 4
                    if grupo==2
                        D=preto;
                    else
                        D=branco;
                    end
            end
            switch CCor(2)
                case 1
                    if grupo==2
                        A=branco;
                    else
                        A=preto;
                    end
                case 2
                    if grupo==2
                        B=branco;
                    else
                        B=preto;
                    end
                case 3
                    if grupo==2
                        C=branco;
                    else
                        C=preto;
                    end
                case 4
                    if grupo==2
                        D=branco;
                    else
                        D=preto;
                    end
            end
        end
        switch CCor(3)
            case 1
                A=cor1;
            case 2
                B=cor1;
            case 3
                C=cor1;
            case 4
                D=cor1;
        end
        switch CCor(4)
            case 1
                A=cor1;
            case 2
                B=cor1;
            case 3
                C=cor1;
            case 4
                D=cor1;
        end
        %% imagens da fase 7 e 8
        if fase==7 || fase==8
            for vv=1:4
                vet(vv)=find(CCor==vv);
            end
            switch vet(1)
                case 1
                    imem1=m1;
                case 2
                    imem1=m2;
                case 3
                    imem1=m3;
                case 4
                    imem1=m4;
            end
            switch vet(2)
                case 1
                    imem2=m1;
                case 2
                    imem2=m2;
                case 3
                    imem2=m3;
                case 4
                    imem2=m4;
            end
            switch vet(3)
                case 1
                    imem3=m1;
                case 2
                    imem3=m2;
                case 3
                    imem3=m3;
                case 4
                    imem3=m4;
            end
            switch vet(4)
                case 1
                    imem4=m1;
                case 2
                    imem4=m2;
                case 3
                    imem4=m3;
                case 4
                    imem4=m4;
            end
        end
        %% imagens
        if fase<=6
            ima1=imread(m1);
            ima2=imread(m3);
            ima3=imread(m3);
            ima4=imread(m4);
        else
            ima1=imread(imem1);
            ima2=imread(imem2);
            ima3=imread(imem3);
            ima4=imread(imem4);
        end
        %%
        T_1oresp=0;
        freqRo1=0;
        freqRo2=0;
        freqRo3=0;
        freqRo4=0;
        u=0;
        D0=10000;
        D1=10000;
        D2=10000;
        D3=10000;
        D4=10000;
        stm1=0;
        stm=0;
        tempoRo1=0;
        tempoRo2=0;
        tempoRo3=0;
        tempoRo4=0;
        Freq_respManual=0;
        f1=0;
        tval=0;
        Inter_resp=0;
        pontos=0;
        tPtS=0;
        ve=0;
        M_re=[];
        intervalo=0;
        vi_Re=0;
        if cp<1 || cp> size(tempocomponente,2)
            cp=1;
            cp_rand=randperm(size(tempocomponente,2));
        end
        Tcomp=tempocomponente(cp_rand(cp));
        cp=cp+1;
        if (fase==2 || fase==5 || (fase==8 && grupo==2))
            if est<=4
                if cond(1)==1
                    cond(2)=0;
                elseif cond(1)==2
                    cond(2)=1;
                end
            end
            jorn(3)=cond(1);
            jorn(4)=cond(2);
        end
        lib=1;
        f3=1;
        k=0;
        m=1;
        M_vi=0;
        M_Sr=0;
        if fase>=4
            lib=0;
            f3=0;
        end
        %% INICIO DO REGISTRO OCULAR E APRESENTACAO DO PONTO DE FIXAÇAO
        eye_used = Eyelink('EyeAvailable'); % get eye that's tracked
        if eye_used == el.BINOCULAR; % if both eyes are tracked
            eye_used = el.LEFT_EYE; % use left eye
        end
        WaitSecs(.02)
        Eyelink('startrecording')
        WaitSecs(.02)
        Eyelink('Message','trial%d',r);
        
        %%
        tCur=Eyelink('TrackerTime')*1000;
        jorn(7)=tCur;
        jorn(8)=0;
        jorn(9)=0;
        jorn(10)=0;
        jorn(11)=0;
        jorn(12)=0;
        jorn(13)=0;
        jorn(14)=0;
        jorn(15)=0;
        jorn(16)=0;
        jorn(17)=0;
        jorn(18)=0;
        jorn(19)=0;
        jorn(20)=0;
        if r==1
            Tcomp=800;
        end
        if f3==0
            Screen(window, 'FillRect', fundo,screenRect);
            Screen(window, 'FillOval', cor1,[XYcentral(1)-div1 XYcentral(2)-div1 XYcentral(1)+div1 XYcentral(2)+div1]);
            Screen(window, 'FillOval', A,[vect1(1)-div vect1(2)-div vect1(1)+div vect1(2)+div]);
            Screen(window, 'FillOval', B,[vect2(1)-div vect2(2)-div vect2(1)+div vect2(2)+div]);
            Screen(window, 'FillOval', C,[vect3(1)-div vect3(2)-div vect3(1)+div vect3(2)+div]);
            Screen(window, 'FillOval', D,[vect4(1)-div vect4(2)-div vect4(1)+div vect4(2)+div]);
            Screen(window, 'Flip');
        end
        %% componentes!!!
        while tPtS<=Tcomp
            tPrec = tCur;
            tCur = Eyelink('TrackerTime')*1000;
            tPtS = tPtS + tCur - tPrec;
            mx=0;
            my=0;
            if Eyelink('NewFloatSampleAvailable') > 0
                evt = Eyelink('NewestFloatSample');
                if eye_used ~= -1 % do we know which eye to use yet?
                    x = evt.gx(eye_used+1); % +1 as we're accessing MATLAB array
                    y = evt.gy(eye_used+1);
                    if x~=el.MISSING_DATA & y~=el.MISSING_DATA & evt.pa(eye_used+1)>0
                        mx=x;
                        my=y;
                        D0=sqrt(sum((XYcentral-[mx my]).^2));
                        D1=sqrt(sum((vect1-[mx my]).^2));
                        D2=sqrt(sum((vect2-[mx my]).^2));
                        D3=sqrt(sum((vect3-[mx my]).^2));
                        D4=sqrt(sum((vect4-[mx my]).^2));
                    end
                end
            end
            evtype=Eyelink('GetNextDataType');
            if sum(evtype==[3 4 5 6])
                Eyelink('GetFloatData',evtype);
            end
            if f3==0;
                if D0<div
                    jorn(8)=Eyelink('TrackerTime')*1000;% momento da fxacao no ponto de Fix
                    Screen(window, 'FillRect', fundo,screenRect);
                    Screen(window, 'FillOval', A,[vect1(1)-div vect1(2)-div vect1(1)+div vect1(2)+div]);
                    Screen(window, 'FillOval', B,[vect2(1)-div vect2(2)-div vect2(1)+div vect2(2)+div]);
                    Screen(window, 'FillOval', C,[vect3(1)-div vect3(2)-div vect3(1)+div vect3(2)+div]);
                    Screen(window, 'FillOval', D,[vect4(1)-div vect4(2)-div vect4(1)+div vect4(2)+div]);
                    Screen(window, 'Flip');
                    lib=1;
                end
            end
            if lib==1
                if D1<div+40
                    if f1==0 %qual a primera fxacao
                        jorn(9)=1;
                        jorn(10)=Eyelink('TrackerTime')*1000;% momento da primera fxacao
                        f1=1;
                    end
                    if stm==0
                        freqRo1=freqRo1+1; %frequenca da fixacao no V1
                        jorn(11)=freqRo1;
                        stm=1;
                    end
                    tempoRo1=tempoRo1+tCur - tPrec;
                    jorn(12)=tempoRo1;
                    Screen(window, 'FillRect', fundo,screenRect);
                    Screen(window, 'FillOval', B,[vect2(1)-div vect2(2)-div vect2(1)+div vect2(2)+div]);
                    Screen(window, 'FillOval', C,[vect3(1)-div vect3(2)-div vect3(1)+div vect3(2)+div]);
                    Screen(window, 'FillOval', D,[vect4(1)-div vect4(2)-div vect4(1)+div vect4(2)+div]);
                    Screen('PutImage',window, ima1, [vect1(1)-div1 vect1(2)-div1 vect1(1)+div1 vect1(2)+div1]);
                    Screen(window, 'Flip');
                elseif D2<div+40
                    if f1==0
                        jorn(9)=2;
                        jorn(10)=Eyelink('TrackerTime')*1000;%momento da observ
                        f1=1;
                    end
                    if stm1==0;
                        freqRo2=freqRo2+1;
                        jorn(13)=freqRo1;
                        stm1=1;
                    end
                    tempoRo2=tempoRo2+tCur - tPrec;
                    jorn(14)=tempoRo2;
                    Screen(window, 'FillRect', fundo,screenRect);
                    Screen(window, 'FillOval', A,[vect1(1)-div vect1(2)-div vect1(1)+div vect1(2)+div]);
                    Screen(window, 'FillOval', C,[vect3(1)-div vect3(2)-div vect3(1)+div vect3(2)+div]);
                    Screen(window, 'FillOval', D,[vect4(1)-div vect4(2)-div vect4(1)+div vect4(2)+div]);
                    Screen('PutImage',window, ima2, [vect2(1)-div1 vect2(2)-div1 vect2(1)+div1 vect2(2)+div1]);
                    Screen(window, 'Flip');
                elseif D3<div+40
                    if f1==0
                        jorn(9)=3;
                        jorn(10)=Eyelink('TrackerTime')*1000;%momento da observ
                        f1=1;
                    end
                    if stm1==0;
                        freqRo3=freqRo3+1;
                        jorn(15)=freqRo1;
                        stm1=1;
                    end
                    tempoRo3=tempoRo3+tCur - tPrec;
                    jorn(16)=tempoRo3;
                    Screen(window, 'FillRect', fundo,screenRect);
                    Screen(window, 'FillOval', A,[vect1(1)-div vect1(2)-div vect1(1)+div vect1(2)+div]);
                    Screen(window, 'FillOval', B,[vect2(1)-div vect2(2)-div vect2(1)+div vect2(2)+div]);
                    Screen(window, 'FillOval', D,[vect4(1)-div vect4(2)-div vect4(1)+div vect4(2)+div]);
                    Screen('PutImage',window, ima3, [vect3(1)-div1 vect3(2)-div1 vect3(1)+div1 vect3(2)+div1]);
                    Screen(window, 'Flip');
                elseif D4<div+40
                    if f1==0
                        jorn(9)=4;
                        jorn(10)=Eyelink('TrackerTime')*1000;%momento da observ
                        f1=1;
                    end
                    if stm1==0;
                        freqRo4=freqRo4+1;
                        jorn(17)=freqRo4;
                        stm1=1;
                    end
                    tempoRo4=tempoRo4+tCur - tPrec;
                    jorn(18)=tempoRo4;
                    Screen(window, 'FillRect', fundo,screenRect);
                    Screen(window, 'FillOval', A,[vect1(1)-div vect1(2)-div vect1(1)+div vect1(2)+div]);
                    Screen(window, 'FillOval', B,[vect2(1)-div vect2(2)-div vect2(1)+div vect2(2)+div]);
                    Screen(window, 'FillOval', C,[vect3(1)-div vect3(2)-div vect3(1)+div vect3(2)+div]);
                    Screen('PutImage',window, ima4, [vect4(1)-div1 vect4(2)-div1 vect4(1)+div1 vect4(2)+div1]);
                    Screen(window, 'Flip');
                else
                    Screen(window, 'FillRect', fundo,screenRect);
                    Screen(window, 'FillOval', A,[vect1(1)-div vect1(2)-div vect1(1)+div vect1(2)+div]);
                    Screen(window, 'FillOval', B,[vect2(1)-div vect2(2)-div vect2(1)+div vect2(2)+div]);
                    Screen(window, 'FillOval', C,[vect3(1)-div vect3(2)-div vect3(1)+div vect3(2)+div]);
                    Screen(window, 'FillOval', D,[vect4(1)-div vect4(2)-div vect4(1)+div vect4(2)+div]);
                    Screen(window, 'Flip');
                    stm1=0;
                    stm=0;
                end
            end
            tval=tval+tCur - tPrec;
            tval_resp=tval_resp+tCur - tPrec;
            if cond(2)==1
                if int==1
                    if ve<1 || ve>size(VI_Re_Exp,1)
                        vi_r=randperm(size(VI_Re_Exp,1) ) ;
                        ve=1;
                    end
                    vi_Resp=vi_r(ve);
                    if  VI_Re_Exp(vi_Resp)>Tcomp
                        h=find(vi_r==1);
                        h1=find(vi_r==vi_Resp);
                        vi_r(h)=vi_r(h1);
                        vi_r(h1)=1;
                        vi_Re=VI_Re_Exp(1);
                    else
                        vi_Re=VI_Re_Exp(vi_Resp);
                    end
                    int=3;
                    ve=ve+1;
                elseif int==2
                    vi_Re=0;
                    int=3;
                elseif int==0
                    if restodeintervalo>Tcomp;
                        busc=find(VI_Re_Exp<Tcomp);
                        busca=randperm(length(busc));
                        vi_Re=VI_Re_Exp(busca(1));
                        intervalo=restodeintervalo-vi_Re;
                    end
                    int=3;
                end
            end
            [keyIsDown, secs, keycode, deltaSecs] = KbCheck; %função para respostas manuais
            KD=keyIsDown;
            if teste==1
                %if cond(1)==1
                %   KD=1;
                %else
                %   KD=0;
                %end
                if rand>.5
                    KD=1;
                else
                    KD=0;
                end
            end
            if KD>0
                if k==0
                    T_1oresp=Eyelink('TrackerTime')*1000;
                    jorn(19)=T_1oresp;
                    k=1;
                end
                if u==0
                    Freq_respManual= Freq_respManual+1;
                    jorn(20)=Freq_respManual;
                    Inter_resp(Freq_respManual)=tval_resp;
                    tval_resp=0;
                    u=1;
                    if cond(2)==1
                        if (tval >=vi_Re)
                            InitializePsychSound(1);
                            pahandle = PsychPortAudio('Open', [], 1, 1, freq, nrchannels);
                            PsychPortAudio('Volume', pahandle, 0.5);
                            myBeep = MakeBeep(500, beepLengthSecs, freq);
                            PsychPortAudio('FillBuffer', pahandle, [myBeep; myBeep]);
                            PsychPortAudio('Start', pahandle, repetitions, startCue, waitForDeviceStart);
                            WaitSecs(beepLengthSecs)
                            PsychPortAudio('Stop', pahandle);
                            PsychPortAudio('Close', pahandle);
                            pontos=pontos+1;
                            ponto=ponto+1;
                            if ve<1 || ve>size(VI_Re_Exp,1)
                                vi_r=randperm(size(VI_Re_Exp,1) ) ;
                                ve=1;
                            end
                            vi_Resp=vi_r(ve);
                            ve=ve+1;
                            vi_Re=VI_Re_Exp(vi_Resp)+intervalo;
                            intervalo=0;
                            M_vi(m)=vi_Re;
                            M_Sr(m)=tval;
                            m=m+1;
                            tval=0;
                        end
                    end
                end
            else
                u=0;
            end
        end
        if cond(2)==1
            restodeintervalo=vi_Re-tval;
            if restodeintervalo<=0
                int=2;
            elseif restodeintervalo>0
                int=0;
            end
        end
        jorn(21)=mean(M_vi);
        jorn(22)=mean(M_Sr);
        jorn(23)=mean(Inter_resp);
        jorn(24)=pontos;
        jorn(25)=grupo;
        Eyelink('Message','fin%d',r);
        WaitSecs(0.02);
        if teste==0
            Eyelink('stoprecording');
        end
        %% CALCULOS dos criterios
        jornal(r,:)=jorn;
        i_id=[];
        switch fase
            case 1
                if cond(2)==1
                    freqmais(fo1,1)=Freq_respManual;
                    fo1=fo1+1;
                else
                    freqmenos(fo2,1)=Freq_respManual;
                    fo2=fo2+1;
                end
                if est>=corteInd
                    if (size(freqmais,1)>nf && size(freqmenos,1)>nf)
                        if freqmais(nf,1)+ freqmenos(nf,1)~=0
                            ID_d=freqmais(nf,1)/(freqmais(nf,1)+ freqmenos(nf,1));
                            ID(pp,1)=ID_d;
                            pp=pp+1;
                            nf=nf+1;
                        else
                            ID_d=.5;
                            ID(pp,1)=ID_d;
                            pp=pp+1;
                            nf=nf+1;
                        end
                    end
                    if size(ID,1)>crit
                        i_id=find(ID(end-crit:end,1)<indiceD);
                        if  isempty(i_id)
                            if size(freqmais,1)==size(freqmenos,1)
                                est=0;
                                fase=2;
                            end
                        end
                    end
                end
                if est==corteFim
                    if teste==1
                        fase=2;
                        est=0;
                    else
                        break
                    end
                end
            case 2
                if cond(col_Disc)==1
                    freqdisc(fd,1)=Freq_respManual;
                    fd=fd+1;
                else
                    freqNdisc(fnd,1)=Freq_respManual;
                    fnd=fnd+1;
                end
                if est>=corteInd
                    if (size(freqdisc,1)>nf && size(freqNdisc,1)>nf)
                        if freqdisc(nf,1)+ freqNdisc(nf,1)~=0
                            ID_d=freqdisc(nf,1)/(freqdisc(nf,1)+ freqNdisc(nf,1));
                            ID(pp,1)= ID_d;
                            pp=pp+1;
                            nf=nf+1;
                        else
                            ID_d=.5;
                            ID(pp,1)=ID_d;
                            pp=pp+1;
                            nf=nf+1;
                        end
                    end
                    if size(ID,1)>amostraCrit
                        i_id=find(ID(end-crit:end,1)<indicenD | ID(end-crit:end,1)>indiceD);
                        if  isempty(i_id)
                            if size(freqdisc,1)==size(freqNdisc,1)
                                est=0;
                                fase=3;
                            end
                        end
                    end
                end
                if est==corteFim
                    if teste==1
                        est=0;
                        fase=3;
                    else
                        break
                    end
                end
                
            case 3
                if cond(2)==1
                    freqmais(fo1,1)=Freq_respManual;
                    fo1=fo1+1;
                else
                    freqmenos(fo2,1)=Freq_respManual;
                    fo2=fo2+1;
                end
                if est>=corteInd
                    if (size(freqmais,1)>nf && size(freqmenos,1)>nf)
                        if freqmais(nf,1)+ freqmenos(nf,1)~=0
                            ID_d=freqmais(nf,1)/(freqmais(nf,1)+ freqmenos(nf,1));
                            ID(pp,1)=ID_d;
                            pp=pp+1;
                            nf=nf+1;
                        else
                            ID_d=.5;
                            ID(pp,1)=ID_d;
                            pp=pp+1;
                            nf=nf+1;
                        end
                    end
                    if size(ID,1)>crit
                        i_id=find(ID(end-crit:end,1)<indiceD);
                        if  isempty(i_id)
                            if size(freqmais,1)==size(freqmenos,1)
                                est=0;
                                cal1=1;
                                fase=4;
                            end
                        end
                    end
                end
                if est==corteFim
                    if teste==1
                        fase=4;
                        est=0;
                    else
                        break
                    end
                end
            case 4
                if cond(2)==1
                    freqmais(fo1,1)=Freq_respManual;
                    fo1=fo1+1;
                else
                    freqmenos(fo2,1)=Freq_respManual;
                    fo2=fo2+1;
                end
                if est>=corteInd
                    if (size(freqmais,1)>nf && size(freqmenos,1)>nf)
                        if freqmais(nf,1)+ freqmenos(nf,1)~=0
                            ID_d=freqmais(nf,1)/(freqmais(nf,1)+ freqmenos(nf,1));
                            ID(pp,1)=ID_d;
                            pp=pp+1;
                            nf=nf+1;
                        else
                            ID_d=.5;
                            ID(pp,1)=ID_d;
                            pp=pp+1;
                            nf=nf+1;
                        end
                    end
                    if size(ID,1)>amostraCrit
                        i_id=find(ID(end-crit:end,1)<indiceD);
                        if  isempty(i_id)
                            if size(freqmais,1)==size(freqmenos,1)
                                est=0;
                                fase=5;
                            end
                        end
                    end
                end
                if est==corteFim
                    if teste==1
                        est=0;
                        fase=5;
                    else
                        break
                    end
                end
            case 5
                if cond(col_Disc)==1
                    freqdisc(fd,1)=Freq_respManual;
                    fd=fd+1;
                else
                    freqNdisc(fnd,1)=Freq_respManual;
                    fnd=fnd+1;
                end
                if est>=corteInd
                    if (size(freqdisc,1)>nf && size(freqNdisc,1)>nf)
                        if freqdisc(nf,1)+ freqNdisc(nf,1)~=0
                            ID_d=freqdisc(nf,1)/(freqdisc(nf,1)+ freqNdisc(nf,1));
                            ID(pp,1)= ID_d;
                            pp=pp+1;
                            nf=nf+1;
                        else
                            ID_d=.5;
                            ID(pp,1)=ID_d;
                            pp=pp+1;
                            nf=nf+1;
                        end
                    end
                    if size(ID,1)>amostraCrit
                        i_id=find(ID(end-crit:end,1)<indicenD | ID(end-crit:end,1)>indiceD);
                        if  isempty(i_id)
                            if size(freqdisc,1)==size(freqNdisc,1)
                                est=0;
                                fase=6;
                            end
                        end
                    end
                end
                if est==corteFim
                    if teste==1
                        est=0;
                        fase=6;
                    else
                        break
                    end
                end
            case 6
                if cond(2)==1
                    freqmais(fo1,1)=Freq_respManual;
                    fo1=fo1+1;
                else
                    freqmenos(fo2,1)=Freq_respManual;
                    fo2=fo2+1;
                end
                if est>=corteInd
                    if (size(freqmais,1)>nf && size(freqmenos,1)>nf)
                        if freqmais(nf,1)+ freqmenos(nf,1)~=0
                            ID_d=freqmais(nf,1)/(freqmais(nf,1)+ freqmenos(nf,1));
                            ID(pp,1)=ID_d;
                            pp=pp+1;
                            nf=nf+1;
                        else
                            ID_d=.5;
                            ID(pp,1)=ID_d;
                            pp=pp+1;
                            nf=nf+1;
                        end
                    end
                    if size(ID,1)>crit
                        i_id=find(ID(end-crit:end,1)<indiceD);
                        if  isempty(i_id)
                            if size(freqmais,1)==size(freqmenos,1)
                                est=0;
                                fase=7;
                                cal1=1;
                            end
                        end
                    end
                end
                if est==corteFim
                    if teste==1
                        fase=7;
                        est=0;
                    else
                        break
                    end
                end
            case 7
                if cond(2)==1
                    freqmais(fo1,1)=Freq_respManual;
                    fo1=fo1+1;
                else
                    freqmenos(fo2,1)=Freq_respManual;
                    fo2=fo2+1;
                end
                if est>=corteInd
                    if (size(freqmais,1)>nf && size(freqmenos,1)>nf)
                        if freqmais(nf,1)+ freqmenos(nf,1)~=0
                            ID_d=freqmais(nf,1)/(freqmais(nf,1)+ freqmenos(nf,1));
                            ID(pp,1)=ID_d;
                            pp=pp+1;
                            nf=nf+1;
                        else
                            ID_d=.5;
                            ID(pp,1)=ID_d;
                            pp=pp+1;
                            nf=nf+1;
                        end
                    end
                    if size(ID,1)>(amostraCrit+supertreino)
                        i_id=find(ID(end-(crit+supertreino):end,1)<indiceD);
                        if  isempty(i_id)
                            if size(freqmais,1)==size(freqmenos,1)
                                fase=8;
                                est=0;
                            end
                        end
                    end
                end
                if est==corteFim
                    if teste==1
                        fase=8;
                        est=0;
                    else
                        break
                    end
                end
            case 8
                if grupo==1 %reversao
                    if cond(2)==1
                        freqmais(fo1,1)=Freq_respManual;
                        fo1=fo1+1;
                    else
                        freqmenos(fo2,1)=Freq_respManual;
                        fo2=fo2+1;
                    end
                    if est>=corteInd
                        if (size(freqmais,1)>nf && size(freqmenos,1)>nf)
                            if freqmais(nf,1)+ freqmenos(nf,1)~=0
                                ID_d=freqmais(nf,1)/(freqmais(nf,1)+ freqmenos(nf,1));
                                ID(pp,1)=ID_d;
                                pp=pp+1;
                                nf=nf+1;
                            else
                                ID_d=.5;
                                ID(pp,1)=ID_d;
                                pp=pp+1;
                                nf=nf+1;
                            end
                        end
                        if size(ID,1)>(amostraCrit+supertreino)
                            i_id=find(ID(end-(crit+supertreino):end,1)<indiceD);
                            if  isempty(i_id)
                                if size(freqmais,1)==size(freqmenos,1)
                                    break
                                end
                            end
                        end
                    end
                elseif grupo==2 %extincao - descorrelacao dos estimulos - abolicao da discriminacao
                    if cond(col_Disc)==1
                        freqdisc(fd,1)=Freq_respManual;
                        fd=fd+1;
                    else
                        freqNdisc(fnd,1)=Freq_respManual;
                        fnd=fnd+1;
                    end
                    if est>=corteInd
                        if (size(freqdisc,1)>nf && size(freqNdisc,1)>nf)
                            if freqdisc(nf,1)+ freqNdisc(nf,1)~=0
                                ID_d=freqdisc(nf,1)/(freqdisc(nf,1)+ freqNdisc(nf,1));
                                ID(pp,1)= ID_d;
                                pp=pp+1;
                                nf=nf+1;
                            else
                                ID_d=.5;
                                ID(pp,1)=ID_d;
                                pp=pp+1;
                                nf=nf+1;
                            end
                        end
                        if size(ID,1)>(amostraCrit+supertreino)
                            i_id=find(ID(end-(crit+supertreino):end,1)<indicenD | ID(end-(crit+supertreino):end,1)>indiceD);
                            if  isempty(i_id)
                                if size(freqdisc,1)==size(freqNdisc,1)
                                    break
                                end
                            end
                        end
                    end
                end
                if est>=corteFim;
                    break
                end
        end
        jornal_ID=ID;
        est=est+1;
        if est==1
            cal=1;
            amostraCrit=size(ID,1)+crit;
            freqmais=[];
            freqmenos=[];
            freqdisc=[];
            freqNdisc=[];
            fd=1;
            fnd=1;
            fo1=1;
            fo2=1;
            nf=1;
        end
    end
    %% fim da tentativa
    for j=128:-0.8:100
        Screen(window, 'FillRect',j,screenRect);
        Screen(window, 'Flip');
    end
    WaitSecs(2);
    for jj=100:0.8:128
        Screen(window, 'FillRect',jj,screenRect);
        Screen(window, 'Flip');
    end
    %% agradecimentos
    Screen ('TextSize',window,60);
    Screen ('TextFont',window,'Arial');
    DrawFormattedText(window,'Obrigado por sua participação!!', 'center' , 'center' , [240 240 240], 29,[],[],1.63);
    Screen('Flip', window);
    WaitSecs(tempodespedida);
catch
    WaitSecs(0.5);
    Eyelink('Command','set_idle_mode');
    WaitSecs(0.5);
    Eyelink('CloseFile');
    ShowCursor;
    atalho=cd;
    cd('C:\Peter\PosDocCompleto')
    Nome_do_jornal=sprintf('jornal_%s.mat',nome);
    Res.jornal=jornal;
    Res.var=Varie;
    Res.ID=ID;
    eval(sprintf('save %s Res',Nome_do_jornal));
    Eyelink('ReceiveFile');
    Eyelink('Shutdown')
    eval(sprintf('cd ''%s''',atalho));
    Screen(window,'close');
    rethrow(lasterror);
end
Eyelink('Command','set_idle_mode');
WaitSecs(0.5);
Eyelink('CloseFile');
ShowCursor;
atalho=cd;
cd('C:\Peter\PosDocCompleto')
Nome_do_jornal=sprintf('jornal_%s.mat',nome);
Res.jornal=jornal;
Res.var=Varie;
Res.ID=ID;
eval(sprintf('save %s Res',Nome_do_jornal));
Eyelink('ReceiveFile');
Eyelink('Shutdown')
eval(sprintf('cd ''%s''',atalho));
Screen(window,'close');