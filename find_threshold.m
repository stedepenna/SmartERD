function [thr_max] = find_threshold(Time_freqx,Time_freqy,Time_freqz,timeVec,freqVec,t_pre,t_basel_on,t_basel_off);

%%% Time_freqx      structure, with size 1 x number of trials; Time_freqx.B
%%% contains the TFR time x frequency along the x direction of the vector source activity
%%% Time_freqy      structure, with size 1 x number of trials; Time_freqx.B
%%% contains the TFR time x frequency along the y direction of the vector source activity
%%% Time_freqz      structure, with size 1 x number of trials; Time_freqx.B
%%% contains the TFR time x frequency along the z direction of the vector source activity
%%% timeVec         time vector in secs
%%% freqVec         frequency vector in the alpha or beta band, in Hz
%%% t_pre           trigger onset from the trial first point, in s 
%%% t_basel_on      first point of the baseline, in s
%%% t_basel_off     last point of the baseline, in s

%%% Reference  "SmartERD: a pipeline for referencing subjects to a common
%%% peak in the analysis of ERD dynamics", Sara Spadone, 
%%% Carlo Sestieri, Paolo Capotosto, Antonello Baldassarre, Stefano Sensi,
%%% Stefania Della Penna, Scientific Reports 2025


alpha_index=8:15; %alpha  freq 7-16 Hz


bas_tot=[];
%%% estimate BAS(f) for each trial
for ind_trial=1:size(Time_freqx,2)

    Time_freq=Time_freqx(1,ind_trial).B+Time_freqy(1,ind_trial).B+Time_freqz(1,ind_trial).B;
    bas_tot(:,ind_trial)=mean(Time_freq(:,1+round(t_basel_on*Fsnew)+abs(round(t_pre*Fsnew)):round(t_basel_off*Fsnew)+abs(round(t_pre*Fsnew))),2);

end                         
%               
%%% estimate THRE
tot_trial=length(find(bas_tot(1,:,:)));
prova=[];
for ind=alpha_index
    bas_distrib=bas_tot(ind,:);
    prova(ind)=std(bas_distrib(find(bas_distrib)))/sqrt(tot_trial)/mean(bas_distrib(find(bas_distrib)))*sqrt(2);
end
thr_max=max(prova(alpha_index));