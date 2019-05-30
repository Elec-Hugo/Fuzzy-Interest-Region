clear;
clc;
close all;
tic
dataDir = './data';

resultsDir = 'ResultsSIGGRAPH2013/';

mkdir(resultsDir);
defaultPyrType = 'halfOctave'; % Half octave pyramid is default as discussed in paper
scaleAndClipLargeVideos = true; % With this enabled, approximately 4GB of memory is used

% Uncomment to use octave bandwidth pyramid: speeds up processing,
% but will produce slightly different results
%defaultPyrType = 'octave'; 

% Uncomment to process full video sequences (uses about 16GB of memory)
%scaleAndClipLargeVideos = false;

%% Car Engine
inFile = fullfile(dataDir, '8.avi');
global rsflag;
global timeTic;
global test;
global a1;
global a2;
global a3;
global b1;
global b2;
global b3;
test= 1;
rsflag=1;
a1=0;a2=0;a3=0;
b1=0;b2=0;b3=0;

samplingRate = 500; % Hz
loCutoff = 10; % Hz
hiCutoff = 20; % Hz
alpha = 30;
sigma = 2;         % Pixels
pyrType = 'octave';
toc
fprintf('Begin phaseAmplify\n');
if (scaleAndClipLargeVideos)
    phaseAmplify(inFile, alpha, loCutoff, hiCutoff, samplingRate, resultsDir,'sigma', sigma,'pyrType', pyrType,'scaleVideo', 0.5);
else
    phaseAmplify(inFile, alpha, loCutoff, hiCutoff, samplingRate, resultsDir,'sigma', sigma,'pyrType', pyrType,'scaleVideo', 1);
end
toc
fprintf('End phaseAmplify\n');
-timeTic(1)+timeTic(end)

fprintf("x1=%d,y1=%d,z1=%d\n",a1,a2,a3);
fprintf("x2=%d,y2=%d,z2=%d\n",b1,b2,b3);
