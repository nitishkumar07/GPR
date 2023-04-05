% NOTE1 : Make sure the VNA out file (S parameters with frquency) in the
% following order.[f(Hz) s11r s11i s21r s21i s21r s21i s22r s22i]
% NOTE2 : load the VNA file as a veriable and keep the same name as line 9
% in the code
% NOTE3: Change the frq unit, this code is made for GHz 
%% Converstion
clc;
clearvars -except mu_pdd10mm12 mu_pdd06mm12 epcilon_pdd06mm12 epcilon_pdd10mm12 mu_pdd08mm12 epcilon_pdd08mm12 pdd05 pdd06 pdd08 pdd10
% clear all;
%% Parameters
clc
VNA_data=readmatrix('Book1.xlsx');
t=35; 
persum=0;

for var=1:150
                                                            % File name of the VNA data S-parameter file [f s11r s11i s21r s21i s21r s21i s22r s22i]
%filevar= xlsread("C:\Users\prade\OneDrive\Desktop\OMN\Book.xlsx");
                  % Thickness of the Shielding material in cm
% S11=VNA_data(:,2)+1i*VNA_data(:,3);                                         % Reform S11 in the complex form
 %S21=VNA_data(:,4)+1i*VNA_data(:,5);                                         % Reform S21 in the complex form 
 S22=VNA_data(var,8)+1i*VNA_data(var,9);                                         % Reform S22 in the complex form
S12=VNA_data(var,6)+1i*VNA_data(var,7);                                         % Reform S12 in the complex form 
frq=VNA_data(var,1);  % Extract the frquency data
fck(var)=frq;
%frq=10^9
f=frq./10^9; % X-band frquency in GHz
fc=1.2;%input('Cutoff frequency in GHz:--> ');                                    % The cutoff_frq in GHz use to calculate wavelength lamda_0
lamda_0=29.9792458./f;                                                      % Wave lengths in cm                                                      
lamda_c=29.9792458./fc;                                                    % Cutoff Wave lengths in cm                                                    
n=fix(t.*sqrt((1./lamda_0.^2)-(1./lamda_c.^2)));                            % 'n' used to choose correct root of complex log term
%% NRW Conversations
clc
K=(((S22).^2)-((S12).^2)+1)./(2.*S22);                                      % Step1 : Calculate the roots of the reflection coefficient
GAMA1=K+sqrt(((K.^2)-1));                                                   % Step2 : Calculate the reflection coefficients with possible roots
GAMA2=K-sqrt(((K.^2)-1));
%% Checking 1 : |GAMA| < 1
mode_GAMA1=abs(GAMA1);                                                      % check |GAMA| <1, to select the correct root
mode_GAMA2=abs(GAMA2);
gama_final=ones(length(GAMA1),1);

for i = 1:length(mode_GAMA1)
    if mode_GAMA1(i,1)<1
       gama_final(i,1) = GAMA1(i,1);
    else
       gama_final(i,1) = GAMA2(i,1);
    end
end
clc
disp(round(abs(gama_final),2))

%% NRW Converstions
clc
T=(S22+S12-gama_final)./(1-((S22+S12).*gama_final));                       %Step3 : Calcualte the transmission coefficient
log_inv=log(abs(1./T))+1i.*(((angle(1./T)+(2.*pi.*n))));
first_term_permeability1_sqr=(((1./(2.*pi.*t)).*log_inv).^2);
first_term_permeability=sqrt(-1.*first_term_permeability1_sqr);
%% NRW Converstions 
clc
Second_term_permeability=(1+gama_final)./(1-gama_final);
permeabillity=(first_term_permeability.*Second_term_permeability)./(sqrt((1./lamda_0.^2)-(1./lamda_c.^2)));
permittivity(var)=(((first_term_permeability1_sqr+(1./(lamda_c).^2)).*lamda_0.^2))./(permeabillity);
persum= persum+permittivity(var);
%% UPdate the file name
mu_cfrp8l08mm12=permeabillity(1:end,1);                                              % change the veriable name and replace for all
epcilon_cfrp8l08mm12=permittivity(1:end,1);                  %changed                        % change the veriable name and replace for all
f=f(1:end);
%% Del points if needed
% f(31)=[];
% mu_GFRP8LPDD05(31)=[];
% epcilon_GFRP8LPDD05(31)=[];
end
%% Update the Legend name
clc;    % Clear the command window.
workspace;  % Make sure the workspace panel is showing.
format longg;
format compact;
fontSize = 20;
% Create axes
axes1 = axes('Parent',figure('DefaultAxesFontSize',20));
set(axes1,'FontSize',20);
subplot(2,2,1)
plot(f(1:end-1),real(mu_cfrp8l08mm12(1:end-1)),'LineWidth',2)
hold on
% ylim([0 60])
% plot(f,real(mu_PDD08mm),'LineWidth',2)
% % hold on
% plot(f,real(mu_PDD06mm),'LineWidth',2)
% plot(f,real(mu_PDD05mm),'LineWidth',2)

xlabel('Frequency (GHz)', 'FontSize', fontSize)
ylabel('\mu''', 'FontSize', fontSize)
legend('PDD layer 1mm (0.97S/cm)','PDD layer 0.8mm (0.73S/cm)','PDD layer 0.6mm (0.71S/cm)','PDD layer 0.5mm (0.75S/cm)','Location','southeast')
% legend('PDD layer 0.6mm (0.71S/cm)','PDD layer 0.5mm (0.75S/cm)','Location','southeast')
legend('GFRP8LPDD layer 1mm (0.82S/cm)','PDD layer 0.8mm (0.73S/cm)','PDD layer 0.6mm (0.71S/cm)','PDD layer 0.5mm (0.75S/cm)','Location','southeast')
% legend('PDD layer 1mm (0.97S/cm)','PDD layer 0.8mm (0.73S/cm)','PDD layer 0.6mm (0.71S/cm)','PDD layer 0.5mm (0.75S/cm)','Location','southeast')

subplot(2,2,2)
plot(f,imag(mu_cfrp8l08mm12(1:end-1)),'LineWidth',2)
hold on
% ylim([0 60])
% plot(f,imag(mu_PDD08mm),'LineWidth',2)
% plot(f,imag(mu_PDD06mm),'LineWidth',2)
% plot(f,imag(mu_PDD05mm),'LineWidth',2)
xlabel('Frequency (GHz)', 'FontSize', fontSize)
ylabel('\mu" ', 'FontSize', fontSize)
% legend('PDD layer 1mm (0.97S/cm)','PDD layer 0.8mm (0.73S/cm)','PDD layer 0.6mm (0.71S/cm)','PDD layer 0.5mm (0.75S/cm)','Location','southeast')
legend('GFRP8LPDD layer 1mm (0.82S/cm)','PDD layer 0.8mm (0.73S/cm)','PDD layer 0.6mm (0.71S/cm)','PDD layer 0.5mm (0.75S/cm)','Location','southeast')
% legend('PDD layer 1mm (0.97S/cm)','PDD layer 0.8mm (0.73S/cm)','PDD layer 0.6mm (0.71S/cm)','PDD layer 0.5mm (0.75S/cm)','Location','southeast')

subplot(2,2,3)
plot(f,real(epcilon_cfrp8l08mm12(1:end-1)),'LineWidth',2)
hold on
% ylim([0 30])
% plot(f,real(epcilon_PDD08mm),'LineWidth',2)
% plot(f,real(epcilon_PDD06mm),'LineWidth',2)
% plot(f,real(epcilon_PDD05mm),'LineWidth',2)

xlabel('Frequency (GHz)', 'FontSize', fontSize)
ylabel('\epsilon''', 'FontSize', fontSize)
legend('GFRP10L','GFRP8L','GFRP4L','GFRP8LPDD05','Location','southeast')
% legend('PDD layer 1mm (0.97S/cm)','PDD layer 0.8mm (0.73S/cm)','PDD layer 0.6mm (0.71S/cm)','PDD layer 0.5mm (0.75S/cm)','Location','southeast')
% legend('PDD layer 0.6mm (0.71S/cm)','PDD layer 0.5mm (0.75S/cm)','Location','southeast')
% legend('GFRP8LPDD layer 1mm (0.82S/cm)','PDD layer 0.8mm (0.73S/cm)','PDD layer 0.6mm (0.71S/cm)','PDD layer 0.5mm (0.75S/cm)','Location','southeast')
% legend('PDD layer 1mm (0.97S/cm)','PDD layer 0.8mm (0.73S/cm)','PDD layer 0.6mm (0.71S/cm)','PDD layer 0.5mm (0.75S/cm)','Location','southeast')

subplot(2,2,4)
plot(f,imag(epcilon_cfrp8l08mm12(1:end-1)),'LineWidth',2)
hold on
% ylim([0 30])
% plot(f,imag(epcilon_PDD08mm),'LineWidth',2)
% plot(f,imag(epcilon_PDD06mm),'LineWidth',2)
% plot(f,imag(epcilon_PDD05mm),'LineWidth',2)
xlabel('Frequency (GHz)', 'FontSize', fontSize)
ylabel('\epsilon" ', 'FontSize', fontSize)
% legend('PDD layer 1mm (0.97S/cm)','PDD layer 0.8mm (0.73S/cm)','PDD layer 0.6mm (0.71S/cm)','PDD layer 0.5mm (0.75S/cm)','Location','southeast')
legend('CFRP8LPDD layer 1mm (0.82S/cm)','PDD layer 0.8mm (0.73S/cm)','PDD layer 0.6mm (0.71S/cm)','PDD layer 0.5mm (0.75S/cm)','Location','southeast')

hold on
% % Enlarge figure to full screen.
font_size=12; % Technical paper writting font size 
f_width=8.5; %the figure width (in inches)
f_hight=6.5; %the figure hight (in inches)
font_rate=10/font_size;
set(gcf, 'Position',[100 100 round(f_width*font_rate*144) round(f_hight*font_rate*144)])
set(gca, 'fontsize', 20)
clc
%% Update the file name
saveas(gcf,'/Users/sukantadas/Google Drive /MATLAB/MATLAB-UoT/Paper-III/PDD Thickness/CFRPPDD1mmDielectricPDD1mmp2-Finalpaper.tif');
savefig(gcf,'/Users/sukantadas/Google Drive /MATLAB/MATLAB-UoT/Paper-III/PDD Thickness/CFRPPDD1mmDielectricPDD1mmp2-Finalpaper.fig');