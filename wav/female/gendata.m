function [i j]= gendata(n)
global fs  y  myFolder i;

myDir = uigetdir; %gets directory
myFiles = dir(fullfile(myDir,'*.wav')); %gets all wav files in struct
count1=0;
count2=0;
for k = 1:length(myFiles)
  baseFileName = myFiles(k).name;
  fullFileName = fullfile(myFolder, baseFileName);
  fprintf(1, 'Now reading %s\n', fullFileName);
  [y,fs]=wavread(fullFileName);
   time = length(y)/fs;
ms20 = fs/50;
t = (0:length(y)-1)/fs;
r = xcorr(y, ms20, 'coeff');
d = (-ms20:ms20)/fs;
ms2 = fs/500; %maximum speech Fx at 500Hz
ms20 = fs/50; %maximum speech Fx at 50Hz
r = r(ms20 + 1 : 2*ms20+1);
[rmax, ty] = max(r(ms2:ms20));
Fx = fs/(ms2+ty-1);

if Fx <= 175 && Fx >=80   
    fprintf('Male\n');
    count1= count1+1;
   
    count1
 
elseif Fx>175 && Fx<=255
    fprintf('Female\n');
    count2=count2+1;
    count2
 
else
    fprintf('Could not recognize');
end 
end
i=(count2/k);
j=i*100;
fprintf('Accuracy rate = %f',j);


