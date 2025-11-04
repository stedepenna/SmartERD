load('ERD_ERS_noise.mat') 
figure,imagesc(timeVec_zoom,freqVec_zoom,ERD_ERS_noise_zoom),title('ERD/ERSgram')
set(gca,'YDir', 'normal')
caxis([-70 70]);

colormap('jet')
colorbar

smarterd = TFfindRespFreq2_scirep(ERD_ERS_noise_zoom,timeVec_zoom,freqVec_zoom,thr_max)

hold on 
plot(timeVec_zoom(find(timeVec_zoom==smarterd.lat)),freqVec_zoom(find(freqVec_zoom==smarterd.freq)),'*k')