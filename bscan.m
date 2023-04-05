format long; %the values are to of the format long
XT=ones(201,28); %initialise a matrix of size 201x8
dx=(1/28); %step size 
x=-0:dx:1; %column matrix or lateral distance
for i = 1:28 %number of Ascans
filename= sprintf('DET01.CSV',i); %access the CSV file
Ascan = csvread(filename,3,0) %Ascan matrix for saving each Ascan values
Mag = sqrt(Ascan(:,2).^2 + Ascan(:,3).^2); %calculation of magnitude
if (Ascan(:,2)~=0) %if imag part is non zero
phase = tanh(Ascan(:,3)./Ascan(:,2)); %calculate phase
else
 phase =1;
end
rx_sig = Mag.*exp(j.*phase); %Calaculation of rx signal
time=Ascan(:,1); %column matrix for storing time values
disp(i);
 eval(sprintf('XT(:,i)=Mag'));%formation of 2D matrix for plotting Bscan
end
n=length(XT); %number of Ascan
figure;
imagesc(x,time,XT), %plotting of Bscan
xlabel('Distance')
ylabel('Time')
title('Bscan')
