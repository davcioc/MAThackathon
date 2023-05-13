function [totaldist, kcalmedh, AccX, AccY,AccZ, passieffettuati,Liquid_loss,vmed]= fittracker (Temperatura,Peso,Altezza,m)

 

% prompt=" Inserisci la tua età"
% Età= input(prompt);
% 
% prompt=" Inserisci la tua altezza"
% Altezza= input(prompt);
% 
% prompt=" Inserisci il tuo peso corporeo"
% Peso= input(prompt);
% 
% prompt=" Inserisci la temperatura esterna"
% Temperatura= input(prompt)


%acquisizione dati

%lat=latitudine, long=longitudine, v= velocità, alt= altitudine
lat=m.Position.latitude;
long=m.Position.longitude;
v=m.Position.speed;
alt=m.Position.altitude;


% Tempo
timestamp=m.Position.Timestamp;

% newArray = second(datetime_array);
%     arraySize = numel(newArray); % Number of elements in the array
%     first = newArray(1);
%     i = 1;
%     
%     % The following loop will run until it reaches the end of the array.
%     % Whenever the next number is smaller than the current number the loop will
%     % add 60 seconds and then start at the begining of the array again.
%     while i < arraySize
%         if newArray(i) > newArray(i+1)
%             newArray(i+1) = newArray(i+1) +60;
%             i = 1;
%         end
%         i = i+1;
%     end
%     
%     % Subtract the first number to all elements of the array in order to start
%     % the array at 0.
%         newArray = newArray - first;  
% end
% 


% Posizione GPS 

geoplot(lat,long)
earthCirc = 24901;
totaldist = 0;
for i = 1:(length(m.Position.latitude)-1)

    lat1 = m.Position.latitude(i);     % The first latitude
    lat2 = m.Position.latitude(i+1);   % The second latitude
    lon1 = m.Position.longitude(i);     % The first longitude
    lon2 = m.Position.longitude(i+1);   % The second longitude

    degDist = distance(lat1, lon1, lat2, lon2);
    dist = (degDist/360)*earthCirc;

    totaldist = totaldist + dist;
end


%Calcolo calorie e volume d'ossigeno

vmed=  mean(v); %%%
alt0=alt(1);
altmed= mean(alt)-alt0; %%%
incldegmed=asind(altmed/dist); %%%
inclpercmed=(altmed / (dist*cosd(incldegmed)))*100; %%%
VO2med=0.2*(vmed/60)+9.0*(vmed/60)*inclpercmed+3.5; %%%

if vmed*3.6<=3.2
    met=2;
    kcalmedh=met*Peso; %%%

elseif vmed*3.6 <=4.8
    met=2.6; 
    kcalmedh=met*Peso; %%%

elseif vmed*3.6<=6.4
    met=3.8;
    kcalmedh=met*Peso; %%%

else 
    kcalmedh=(VO2med/3.5)*Peso; %%%

end


% Accelerazioni


AccX=m.Acceleration.X;
AccY=m.Acceleration.Y;
AccZ=m.Acceleration.Z;


% Liquidi da reintegrare

%liquid loss over distance

if Temperatura<=10

  fitliq10T= 0.0012*Peso+0.0005; %litri/km
  Liquid_loss = fitliq10T*dist; %litri

elseif Temperatura>10 && Temperatura<=15
  
  fitliq15T= 0.0012*Peso+0.0001; %litri/km
  Liquid_loss = fitliq15T*dist; %litri

elseif Temperatura>15 && Temperatura<=20
  fitliq20T= 0.0013*Peso-0.0001; %litri/km
  Liquid_loss = fitliq20T*dist; %litri

elseif Temperatura>20 && Temperatura<=25
  fitliq25T= 0.0014*Peso+0.0008; %litri/km
  Liquid_loss = fitliq25T*dist; %litri

elseif Temperatura>25 && Temperatura<=30
  fitliq30T= 0.0017*Peso-0.0078; %litri/km
  Liquid_loss = fitliq30T*dist; %litri

else
  fitliq35T= 0.0018*Peso+0.0015; %litri/km
  Liquid_loss = fitliq35T*dist; %litri
end


% Calcolo dei passi

passo= (Altezza/1000)*0.414;
passieffettuati= totaldist/passo;


% Plottaggio dati 

figure 
plot(timestamp,alt)
figure 
plot(timestamp,v)
figure
plot(AccX,'g')
hold on
plot(AccY,'b')
hold on
plot(AccZ,'r')
legend(["AccX","AccY","AccZ"])







