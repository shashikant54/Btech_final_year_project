clc
clear all
close all
[file, path]=uigetfile('.xlsx');
n3=xlsread([path,file]);
n3=n3(1:500);
figure,plot(n3,'k'),title('Input signal'),xlabel('time'),ylabel('Amplitude')
 
%Pre-processing using NLM
ix=1:length(n3); 
PatchHW=10;  
P = 1000; 
lambda = 0.6*.02;
[dnEcg,debugEcg]= NLM_1dDarbon(n3,lambda,P,PatchHW);
[noisySig,targetNoiseSigma] = createSignalPlusNoise(n3,10);
lambda=0.6*targetNoiseSigma;  
dnEcg2= NLM_1dDarbon(noisySig,lambda,P,PatchHW);
xlim_vals = [1000 2000];
dnEcg2(isnan(dnEcg2))=0;
figure,plot(ix,dnEcg2,'r'),title('deenoised signal')
 
%Feature extraction
dnEcg2=n3;
%Find alpha,beta,theta,delta,gamma
N=length(dnEcg2); 
waveletFunction = 'db8';
[C,L] = wavedec(dnEcg2,8,waveletFunction);
cD1 = detcoef(C,L,1); 
cD2 = detcoef(C,L,2); 
cD3 = detcoef(C,L,3); 
cD4 = detcoef(C,L,4); 
cD5 = detcoef(C,L,5); %GAMA
cD6 = detcoef(C,L,6); %BETA
cD7 = detcoef(C,L,7); %ALPHA
cD8 = detcoef(C,L,8); %THETA
cA8 = appcoef(C,L,waveletFunction,8); %DELTA 
D1 = wrcoef('d',C,L,waveletFunction,1); 
D2 = wrcoef('d',C,L,waveletFunction,2); 
D3 = wrcoef('d',C,L,waveletFunction,3); 
D4 = wrcoef('d',C,L,waveletFunction,4); 
D5 = wrcoef('d',C,L,waveletFunction,5); 
D6 = wrcoef('d',C,L,waveletFunction,6); 
D7 = wrcoef('d',C,L,waveletFunction,7); 
D8 = wrcoef('d',C,L,waveletFunction,8); 
A8 = wrcoef('a',C,L,waveletFunction,8); 
Gamma = D5; 
figure; subplot(5,1,1); plot(1:1:length(Gamma),Gamma);title('GAMMA');
Beta = D6; 
subplot(5,1,2); plot(1:1:length(Beta), Beta); title('BETA');
Alpha = D7; 
subplot(5,1,3); plot(1:1:length(Alpha),Alpha); title('ALPHA'); 
Theta = D8; 
subplot(5,1,4); plot(1:1:length(Theta),Theta);title('THETA');
Delta = A8; 
subplot(5,1,5);plot(1:1:length(Delta),Delta);title('DELTA');
 
%Find maximum frequency using FFT
D5 = detrend(D5,0);
xdft = fft(D5);
xdft = xdft(1:length(D5)/2+1);
I1 = max(abs(xdft));
 
D6 = detrend(D6,0);
xdft2 = fft(D6);
xdft2 = xdft2(1:length(D6)/2+1);
I2 = max(abs(xdft2));
 
D7 = detrend(D7,0);
xdft3 = fft(D7);
xdft3 = xdft3(1:length(D7)/2+1);
I3 = max(abs(xdft3));
 
xdft4 = fft(D8);
xdft4 = xdft4(1:length(D8)/2+1);
I4 = max(abs(xdft4));
 
 
xdft5 = fft(A8);
xdft5 = xdft5(1:length(A8)/2+1);
I5 = max(abs(xdft5));
 
feat=[I1 I2 I3 I4 I5];
im=mean(feat);
 
%Classification using NN
load net1
y = round(sim(net1,im));
if y==1
    msgbox('Open')
    s = serial('com5');
             fopen(s)
             pause(0.05)
fprintf(s,'%s','O')
             
fclose(s)
delete(s)
clear s
 
elseif y==2
    msgbox('close')
    s = serial('com5');
             fopen(s)
             pause(0.05)
fprintf(s,'%s','C')
             
fclose(s)
delete(s)
clear s
elseif y==3
    msgbox('Up')
    s = serial('com5');
             fopen(s)
             pause(0.05)
fprintf(s,'%s','U')
             
fclose(s)
delete(s)
clear s
elseif y==4
msgbox('Down')
    s = serial('com5');
             fopen(s)
             pause(0.05)
fprintf(s,'%s','D')
             
fclose(s)
delete(s)
clear s
   elseif y==5
msgbox('Stop')
    s = serial('com5');
             fopen(s)
             pause(0.05)
fprintf(s,'%s','S')
             
fclose(s)
delete(s)
clear s
end
