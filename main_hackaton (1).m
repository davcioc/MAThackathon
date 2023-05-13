% Author: 
% Team: 

% Questo codice permette di monitorare le prestazioni e i parametri durante
% l'attività fisica.
%questo è il main

clear
clc
close all

%m=mobiledev; %per utilizzarlo direttamente tramite acquisizione diretta da Matlab mobile
m=importdata("datiesempio.mat"); %dati esempio per corsa breve (con optional grafico accelerazioni)


Temperatura = input('Inserire temperatura[°C]=');
Peso= input('Inserire peso [Kg]=');
Altezza= input('Inserire altezza [m]=');


[totaldist, kcalmedh, AccX, AccY,AccZ, passieffettuati,Liquid_loss,VO2med]=fittracker(Temperatura,Peso,Altezza,m);



