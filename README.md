# Fuzzy-Interest-Region
This repository contains codes I used for Fuzzy Interest Region for Motion Magnification.

"MyFunction.m" is the main part of Fuzzy Interest Region implementation. To use this code please download phase based motion magnification code from http://people.csail.mit.edu/nwadhwa/phase-video/ and extract the code. Then replace "reproduceResultsSiggraph13.m" and "setPath.m" which are loacated in "\PhaseBasedRelease_20131023\Release" also "phaseAmplify.m" loacated in "\PhaseBasedRelease_20131023\Release\PhaseBased" with "reproduceResultsSiggraph13.m", "setPath.m" and "phaseAmplify.m" uploaded in this repository. 

The other files including:
1- extractAndSaveORB.m
2- MyFunction.m
3- SelectFile.m
4- myFile*.AVI
....
must be copyed in "\PhaseBasedRelease_20131023\Release\data". 

In this papre OpenCV is used to ORB feature extraction so it must be installed on your matlab.

The  video used for motion magnification must be placed in "\PhaseBasedRelease_20131023\Release\data" and its  name  must be set at  21th line of "reproduceResultsSiggraph13.m".


