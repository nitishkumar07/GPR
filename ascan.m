format long; %the values are to of the format long
filename='DET02.CSV'; %access the CSV file
Ascan=csvread(filename,3,0) %Ascan matrix for saving each Ascan values
Mag = sqrt(Ascan(:,2).^2 + Ascan(:,3).^2); %if imag part is non-zero
if (Ascan(:,2)~=0)
phase = tanh(Ascan(:,3)./Ascan(:,2)); %calculate phase
else
 phase =1;
end
rx_sig = Mag.*exp(j.*phase); %Calaculation of rx signal
time=Ascan(:,1); %%column matrix for storing time values
figure;
plot(time,Mag,'r') %plotting of Ascan
xlabel('time')
ylabel('Magnitude')
title('Ascan')
