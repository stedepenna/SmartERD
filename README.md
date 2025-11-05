Scripts and data for the pipeline SmartERD;
launch_SmartERD.m            script to load the ERDgrams and apply SmartERD;
TFfindRespFreq2_scirep.m     core script of SmartERD: searches for peaks, selects the earlier peak within the boundary and estimates the AEP, the SmartERD peak and the related features; 
find_threshold.m             basic script of SmartERD: estimates THRE from the BAS distribution within a selected band;
ERD_ERS_TRUE.mat             ERDgram of the subject used in the simulation and THRE found by find_threshold.m, to be used as imput in launch_SmartERD.m;
ERD_ERS_noise.mat            ERDgram of the subject used in the simulation, + 21% noise level, and THRE found by find_threshold.m, to be used as imput in launch_SmartERD.m;
