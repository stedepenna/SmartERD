function smarterd = TFfindRespFreq2(TF_subj,timeVec,freqVec,thr_max);

%TF_subj            ERDgram freq x time in alpha or beta (e.g. 7:16 Hz - for alpha 1 bin is
%added for each side, it is needed in the peak search procedure)
%timeVec            time vector in secs
%freqVec            frequency vector in the alpha or beta band, in Hz
%thr_max            SmartERD threshold

%%% Reference  "SmartERD: a pipeline for referencing subjects to a common
%%% peak in the analysis of ERD dynamics", Sara Spadone, 
%%% Carlo Sestieri, Paolo Capotosto, Antonello Baldassarre, Stefano Sensi,
%%% Stefania Della Penna, Scientific Reports 2025


%%peak search procedure to identify all 2D peaks in the ERDgram, for each frequency bin

TF_subj=-TF_subj;

deltat=timeVec(2)-timeVec(1);

pks_end=[]; locs_end=[]; freqs_end=[];
smarterd=[];

for ind=1:size(TF_subj,1)-1

    if ind~=1

        [pks,locs]=findpeaks(TF_subj(ind,:));
        locs(find(pks<0))=[];
        pks(find(pks<0))=[];

        freqs=ones(size(locs)).*ind;
        ind_locs=0;

        while ind_locs<length(locs)
            ind_locs=ind_locs+1;

            junk=ind-1:ind+1;
            junk(find((junk==0) | (junk>size(TF_subj,1))))=[];
            [pks_tmp,pos_peak]=findpeaks(TF_subj(junk,locs(ind_locs)));
            if pos_peak~=2
               
                pks(ind_locs)=[]; locs(ind_locs)=[]; freqs(ind_locs)=[];
                ind_locs=ind_locs-1;
            end

        end

        pks_end=[pks_end,pks];
        locs_end=[locs_end,locs];
        freqs_end=[freqs_end,freqs];

    end
end

if ~isempty(pks_end)

         
    [global_amp b]=max(pks_end); %AEP
    global_lat=locs_end(b); %AEP latency
    junk=global_amp-thr_max*(-global_amp+100)*2;  %BOUNDARY
    junk2=find(pks_end>=junk);
    [smarterd_ind_lat b]=min(locs_end(junk2)); %select the first peak within BOUNDARY
    smarterd_amp=pks_end(junk2(b));
    smarterd_ind_freq=freqs_end(junk2(b));
    smarterd_amp=-smarterd_amp;    
else
    
    [smarterd_amp]=NaN;
    
end

          

if ~isnan(smarterd_amp)

    smarterd.lat=timeVec(smarterd_ind_lat)+1;
    smarterd.freq=freqVec(smarterd_ind_freq);
    smarterd.amp=smarterd_amp;
    smarterd.global_amp=global_amp;
    smarterd.global_lat=global_lat;


    wav=-TF_subj(smarterd_ind_freq,:);

    temp_onset=wav(1:smarterd_ind_lat);
    temp_offset=wav(smarterd_ind_lat:end);


    cross_onset=find(temp_onset>0);
    cross_offset=find(temp_offset>0);


    if ~isempty(cross_onset)
        smarterd.onset=cross_onset(end);
    else
        smarterd.onset=1;
    end
    if ~isempty(cross_offset)
        smarterd.offset=cross_offset(1)+smarterd_ind_lat-1;
    else
        smarterd.offset=length(wav);
    end
    smarterd.area_wav=abs(trapz(wav(smarterd.onset:smarterd.offset)))*deltat;


    smarterd.duration=smarterd.offset-smarterd.onset;
    smarterd.wav=wav;

else

    smarterd.amp=smarted_amp;

    smarterd.lat=NaN; smarterd.freq=NaN;

    smarterd.wav=NaN;
    smarterd.onset=NaN; smarterd.offset=NaN; smarterd.area_wav=NaN;
    smarterd.duration=NaN;
end
        
end

       




   