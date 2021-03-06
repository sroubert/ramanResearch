
function [outputs] = ramanAnalysis6withindexeditET2017_updated_11_16_17(input,pmma)
%rawColumn2 = rawData(1, 2);
%firstIndex = 1;
%column = 1;

%rearranges the format of the raw data output by the Raman scope into a
%more workable form. Input is 'rawData' - a giant list of x pos, y pos,
%cm-1, value. output is 'goodData' - a giant set of columns of the values.
%If the raman output format ever changes, this also will have to change.

% ramanFiles = dir('*.txt');
%
% for counter=1:length(ramanFiles)
%     goodData(:,:,counter) = dlmread(ramanFiles(counter).name, '\t', 2, 0);
% end
%
% %*creates loop for number of .txt files in folder*
% %loops through each spectrum in goodData, performing all necessary
% %analyses. temporary variable is 'spectrum'.
%
% ramandata1=dlmread(ramanFiles(1).name, '\t', 2, 0);

ramandata1=input;

wnindex=ramandata1(:,1);



%determine index for baselining entire spectra
%changed on 7/7/17 by Sebastian Roubert to match Erik Taylor's
%"newcodeQCw_XLR.m"
wn1749index=find(wnindex<1749,1);
wn1725index=find(wnindex<1725,1);
wn1190index=find(wnindex<1190,1);
wn1100index=find(wnindex<1100,1);
wn811index=find(wnindex<811,1);
wn802index=find(wnindex<802,1);

%wn 813 used to normalize to pmma
wn813index=find(wnindex<813,1);



%index for baselining ch2 wag (1446)
wn1420index=find(wnindex<1420,1);
wn1430index=find(wnindex<1430,1);
wn1480index=find(wnindex<1480,1);
wn1520index=find(wnindex<1520,1);

%index for baselining the phenylalanine peak (1003)
wn990index=find(wnindex<990,1);
wn1000index=find(wnindex<1000,1);
wn1010index=find(wnindex<1010,1);
wn1020index=find(wnindex<1020,1);

%index for baselining the proline 855 peak (#1) and hydroxproline 873
wn820index=find(wnindex<820,1);
wn840index=find(wnindex<840,1);
wn890index=find(wnindex<890,1);
wn910index=find(wnindex<910,1);


%index for baselining proline 920 peak (#2)
% wn890index=find(wnindex<890,1);
% wn910index=find(wnindex<910,1);
wn920index=find(wnindex<920,1);
wn925index=find(wnindex<925,1);


%index for baselining amide1
wn1562index=find(wnindex<1562,1);
wn1608index=find(wnindex<1608,1);
wn1687index=find(wnindex<1687,1);
wn1737index=find(wnindex<1737,1);

%index for calculating amide1 area
%changed 7/7/17 by Sebastian Roubert. 1620 -> 1620. 1700 ->1700.
wn1620index=find(wnindex<1620,1);
wn1700index=find(wnindex<1700,1);

%index for peak heights amide1
wn1660index=find(wnindex<1660,1);
wn1690index=find(wnindex<1690,1);

%index for baselining amide3
%changed 7/7/17 by Sebastian Roubert. 1223 -> 1200.
%1253 -> 1240. 1290 -> 1290. 1284 -> 1320.

wn1200index=find(wnindex<1200,1);
wn1240index=find(wnindex<1240,1);
wn1290index=find(wnindex<1290,1);
wn1320index=find(wnindex<1320,1);

%index for peak area amide3
%changed 7/7/17 by Sebastian Roubert. 1243 -> 1215. 1268 -> 1300.
wn1215index=find(wnindex<1215,1);
wn1300index=find(wnindex<1300,1);

%index for baselining PO4 v1-v3
%changed 7/7/17 by Sebastian Roubert. 9 35 -> 920. 9 75->940. 10 33->980.
%10 75-> 1000.
wn920index=find(wnindex<920,1);
wn940index=find(wnindex<940,1);
wn980index=find(wnindex<980,1);
wn1000index=find(wnindex<1000,1);

%index for peak area PO4
%changed 7/7/17 by Sebastian Roubert. 9 56 -> 930. 9 62 -> 980.
wn930index=find(wnindex<930,1);
wn980index=find(wnindex<980,1);

%index for gaus fit PO4
%changed 7/7/17 by Sebastian Roubert. 9 22 -> 930. 10 05 -> 980.
wn930index=find(wnindex<930,1);
wn980index=find(wnindex<980,1);

%index for baselining CO3 v1
%changed 7/7/17 by Sebastian Roubert. 10 63 -> 1040. 10 69 -> 1050.
%10 70 -> 1100. 10 74 -> 1110.
wn1040index=find(wnindex<1040,1);
wn1050index=find(wnindex<1050,1);
wn1100index=find(wnindex<1100,1);
wn1110index=find(wnindex<1110,1);

%index for peak small area CO3
%changed 7/7/17 by Sebastian Roubert. 10 67 -> 1050. 10 71 -> 1100.
wn1050index=find(wnindex<1050,1);
wn1100index=find(wnindex<1100,1);

%index for baselining XLR
%wn1181index=find(wnindex<1181,1);
%wn1222index=find(wnindex<1222,1);
%wn1281index=find(wnindex<1281,1);
%wn1321index=find(wnindex<1321,1);

%for j=1:length(goodData(1, 1, :)) %*loops for number of .txt files*
spectrum = input;%goodData(:, :, j); %creates temporary variable spectrum which

%smoothing with a moving average
spectrum(:,2) = smooth(spectrum(:,2));

%baselining from the values at ~800, ~1140, and ~1800
% between 1749-1725.23 *WRONG, these are not the correct numbers but
% seem to fit in the minimums of the several different sample spectra
% provided, no need to change code, just comments.

[lowNum, lowBase] = min(spectrum(wn1749index:wn1725index, 2));
% between 1190.72-1100
[midNum, midBase] = min(spectrum(wn1190index:wn1100index, 2));
% between 811-733
[highNum, highBase] = min(spectrum(wn811index:wn802index, 2));

lowBase = lowBase + (wn1749index-1);
midBase = midBase + (wn1190index-1);
highBase = highBase + (wn811index-1);
bases = [spectrum(lowBase, 1) spectrum(midBase, 1) spectrum(highBase, 1)];
nums = [lowNum midNum highNum];

fitBits = polyfit(bases, nums, 2);
baseline = polyval(fitBits, spectrum(:, 1));

spectrum(:, 2) = spectrum(:, 2) - baseline;

%normalizing to 813.2 wavenumber and subtracting pmma
normalizer = spectrum(wn813index, 2);
    for i=1:length(spectrum(:,1))
       spectrum(i, 2) = spectrum(i, 2)/normalizer;
       %spectrum(i, 2) = spectrum(i, 2) - pmma(i, 2);
    end

figure
plot(spectrum(:, 1), spectrum(:,2))
title('Spectrum divided by raw spectrum peak at 813')

    for i=1:length(spectrum(:,1))
       %spectrum(i, 2) = spectrum(i, 2)/normalizer;
       spectrum(i, 2) = spectrum(i, 2) - pmma(i, 2);
    end

figure
plot(spectrum(:, 1), spectrum(:,2))
title('New spectrum following PMMA subtraction')   
 
%5 point rubber band baselint, different functions

%a=spectrum



%normalizing to 813.2 wavenumber and subtracting pmma

%WRONG!!!!!!, @spectrum (951,2) wn=803.93. wn=813.46 is @943
%normalizer = spectrum(wn813index, 2);

%for i=1:length(spectrum(:,1))
%    spectrum(i, 2) = spectrum(i, 2)/normalizer;
%    spectrum(i, 2) = spectrum(i, 2) - pmma(i, 2);
%end

%plots the normalized and baselined spectrum. This is so that we can
%manually check whether each spectrum is good or not.

%figure(j)
%plot(spectrum(:, 1), spectrum(:, 2))

%baselining all peaks of interest. In this section, the numbers (e.g.
%"spectrum(71:122)" are just index numbers, not wavenumbers. Convert
%wavenumbers into index numbers by looking at an excel file of spectra.

%baselining CH2 1446

[~, ch2LowBase] = min(spectrum(wn1430index:wn1420index, 2));
[~, ch2HighBase] = min(spectrum(wn1520index:wn1480index, 2));

ch2LowBase = ch2LowBase + (wn1430index-1);
ch2HighBase = ch2HighBase + (wn1520index-1);

ch2x2=spectrum(ch2LowBase, 1);
ch2x1=spectrum(ch2HighBase, 1);
ch2y2=spectrum(ch2LowBase, 2);
ch2y1=spectrum(ch2HighBase, 2);

ch2Baseline = [];
for i=1:length(spectrum(:,1));
    ch2Baseline(i) = ((ch2y2-ch2y1)/(ch2x2-ch2x1))*(spectrum(i, 1)-ch2x1)+ch2y1;
end

ch2Baseline = transpose(ch2Baseline);
ch2Spectrum = spectrum(:, 2) - ch2Baseline;


%baselining phynlyalanine 1003

[~, phynLowBase] = min(spectrum(wn1000index:wn990index, 2));
[~, phynHighBase] = min(spectrum(wn1020index:wn1010index, 2));

phynLowBase = phynLowBase + (wn1000index-1);
phynHighBase = phynHighBase + (wn1020index-1);

phynx2=spectrum(phynLowBase, 1);
phynx1=spectrum(phynHighBase, 1);
phyny2=spectrum(phynLowBase, 2);
phyny1=spectrum(phynHighBase, 2);

phynBaseline = [];
for i=1:length(spectrum(:,1));
    phynBaseline(i) = ((phyny2-phyny1)/(phynx2-phynx1))*(spectrum(i, 1)-phynx1)+phyny1;
end

phynBaseline = transpose(phynBaseline);
phynSpectrum = spectrum(:, 2) - phynBaseline;

%baselining proline 1 855 and hydroxyproline 873

[~, pro1hypLowBase] = min(spectrum(wn840index:wn820index, 2));
[~, pro1hypHighBase] = min(spectrum(wn910index:wn890index, 2));

pro1hypLowBase = pro1hypLowBase + (wn840index-1);
pro1hypHighBase = pro1hypHighBase + (wn910index-1);

pro1hypx2=spectrum(pro1hypLowBase, 1);
pro1hypx1=spectrum(pro1hypHighBase, 1);
pro1hypy2=spectrum(pro1hypLowBase, 2);
pro1hypy1=spectrum(pro1hypHighBase, 2);

pro1hypBaseline = [];
for i=1:length(spectrum(:,1));
    pro1hypBaseline(i) = ((pro1hypy2-pro1hypy1)/(pro1hypx2-pro1hypx1))*(spectrum(i, 1)-pro1hypx1)+pro1hypy1;
end

pro1hypBaseline = transpose(pro1hypBaseline);
pro1hypSpectrum = spectrum(:, 2) - pro1hypBaseline;

%figure(j)
%plot(spectrum(:, 1), amide1Spectrum)

%baselining proline 2 920

[~, pro2LowBase] = min(spectrum(wn910index:wn890index, 2));
[~, pro2HighBase] = min(spectrum(wn925index:wn920index, 2));

pro2LowBase = pro2LowBase + (wn910index-1);
pro2HighBase = pro2HighBase + (wn925index-1);

pro2x2=spectrum(pro2LowBase, 1);
pro2x1=spectrum(pro2HighBase, 1);
pro2y2=spectrum(pro2LowBase, 2);
pro2y1=spectrum(pro2HighBase, 2);

pro2Baseline = [];
for i=1:length(spectrum(:,1));
    pro2Baseline(i) = ((pro2y2-pro2y1)/(pro2x2-pro2x1))*(spectrum(i, 1)-pro2x1)+pro2y1;
end

pro2Baseline = transpose(pro2Baseline);
pro2Spectrum = spectrum(:, 2) - pro2Baseline;

%figure(j)
%plot(spectrum(:, 1), pro2Spectrum)

%baselining amide1
%band between 1620-1700
[~, amide1LowBase] = min(spectrum(wn1608index:wn1562index, 2));
[~, amide1HighBase] = min(spectrum(wn1737index:wn1687index, 2));

amide1LowBase = amide1LowBase + (wn1608index-1);
amide1HighBase = amide1HighBase + (wn1737index-1);

amide1x2=spectrum(amide1LowBase, 1);
amide1x1=spectrum(amide1HighBase, 1);
amide1y2=spectrum(amide1LowBase, 2);
amide1y1=spectrum(amide1HighBase, 2);

amide1Baseline = [];
for i=1:length(spectrum(:,1));
    amide1Baseline(i) = ((amide1y2-amide1y1)/(amide1x2-amide1x1))*(spectrum(i, 1)-amide1x1)+amide1y1;
end

amide1Baseline = transpose(amide1Baseline);
amide1Spectrum = spectrum(:, 2) - amide1Baseline;

[amide1Max, amide1MaxIndex] = max(amide1Spectrum(wn1700index:wn1620index));

amide1WaveNum = wnindex(amide1MaxIndex+wn1700index);

%wn1562index

%length(amide1Spectrum) - length(amide1Baseline)

assignin('base','amide1Baseline',amide1Baseline)

assignin('base','amide1Spectrum',amide1Spectrum)

assignin('base','wnindex',wnindex)

%  figure(j)
%plot(spectrum(:, 1), amide1Spectrum)

%Baselining proteoglycan (1363-1390)
%     [~, proteoLowBase] = min(spectrum(450:481, 2)); % from wn=1366-1333
%     [~, proteoHighBase] = min(spectrum(408:427, 2)); % from wn=1410-1390
%     proteoHighBase =proteoHighBase+407;
%     proteoLowBase =proteoHighBase+449;
%
%     proteox2=spectrum(proteoLowBase, 1);
%     proteox1=spectrum( proteoHighBase, 1);
%     proteoy2=spectrum( proteoLowBase, 2);
%     proteoy1=spectrum( proteoHighBase, 2);
%
%     proteoBaseline = [];
%     for i=1:length(spectrum(:,1))
%          proteoBaseline(i) = (( proteoy2- proteoy1)/( proteox2- proteox1))*(spectrum(i, 1)- proteox1)+ proteoy1;
%     end
%
%     proteoBaseline = transpose( proteoBaseline);
%     proteoSpectrum = spectrum(:, 2) -  proteoBaseline;

%baselining Lipid Content (integrating band at ~1298
%1316.04-1304

%     [~, lipidHighBase] = min(spectrum(505:516, 2)); %from 1307-1295
%     %1276-1261
%     [~, lipidLowBase] = min(spectrum(574:604, 2)); %from 1233-1201
%     lipidHighBase = lipidHighBase + 504;
%     lipidLowBase = lipidLowBase + 573;
%
%    lipidx2=spectrum(lipidLowBase, 1);
%     lipidx1=spectrum(lipidHighBase, 1);
%     lipidy2=spectrum(lipidLowBase, 2);
%    lipidy1=spectrum(lipidHighBase, 2);
%
%     lipidBaseline = [];
%     for i=1:length(spectrum(:,1))
%         lipidBaseline(i) = ((lipidy2-lipidy1)/(lipidx2-lipidx1))*(spectrum(i, 1)-lipidx1)+lipidy1;
%     end
%
%     lipidBaseline = transpose(lipidBaseline);
%     lipidSpectrum = spectrum(:, 2) - lipidBaseline;

%baselining Pentonsidine Content
%1362.86-1356.5
%     [~, AGE1LowBase] = min(spectrum(486:498, 2)); %from wn=1327-1315
%     %1364-1371
%     [~, AGE1HighBase] = min(spectrum(443:459, 2)); %from wn=1373-1356
%     AGE1HighBase = AGE1HighBase + 442;
%     AGE1LowBase = AGE1LowBase + 485;
%
%     AGE1x2=spectrum(AGE1LowBase, 1);
%     AGE1x1=spectrum(AGE1HighBase, 1);
%     AGE1y2=spectrum(AGE1LowBase, 2);
%     AGE1y1=spectrum(AGE1HighBase, 2);
%
%     AGE1Baseline = [];
%     for i=1:length(spectrum(:,1))
%         AGE1Baseline(i) = ((AGE1y2-AGE1y1)/(AGE1x2-AGE1x1))*(spectrum(i, 1)-AGE1x1)+AGE1y1;
%     end
%
%     AGE1Baseline = transpose(AGE1Baseline);
%     AGE1Spectrum = spectrum(:, 2) - AGE1Baseline;
%     plot(spectrum(:,1),AGE1Spectrum)

%baselining amide3 (1243-1269)
[~, amide3LowBase] = min(spectrum(wn1240index:wn1200index, 2));
[~, amide3HighBase] = min(spectrum(wn1320index:wn1290index, 2));

amide3LowBase = amide3LowBase + (wn1240index-1);
amide3HighBase = amide3HighBase + (wn1320index-1);

amide3x2=spectrum(amide3LowBase, 1);
amide3x1=spectrum(amide3HighBase, 1);
amide3y2=spectrum(amide3LowBase, 2);
amide3y1=spectrum(amide3HighBase, 2);

amide3Baseline = [];
for i=1:length(spectrum(:,1))
    amide3Baseline(i) = ((amide3y2-amide3y1)/(amide3x2-amide3x1))*(spectrum(i, 1)-amide3x1)+amide3y1;
end

amide3Baseline = transpose(amide3Baseline);
amide3Spectrum = spectrum(:, 2) - amide3Baseline;

[amide3Max, amide3MaxIndex] = max(amide3Spectrum(wn1300index:wn1215index));

amide3WaveNum = wnindex(amide3MaxIndex+wn1300index);



%figure(j)
%plot(spectrum(:, 1), amide3Spectrum)

%baselining PO4
[~, PO4LowBase] = min(spectrum(wn940index:wn920index, 2));
[~, PO4HighBase] = min(spectrum(wn1000index:wn980index, 2));

PO4LowBase = PO4LowBase + (wn940index-1);
PO4HighBase = PO4HighBase + (wn1000index-1);

PO4x2=spectrum(PO4LowBase, 1);
PO4x1=spectrum(PO4HighBase, 1);
PO4y2=spectrum(PO4LowBase, 2);
PO4y1=spectrum(PO4HighBase, 2);

PO4Baseline = [];
for i=1:length(spectrum(:,1))
    PO4Baseline(i) = ((PO4y2-PO4y1)/(PO4x2-PO4x1))*(spectrum(i, 1)-PO4x1)+PO4y1;
end

PO4Baseline = transpose(PO4Baseline);
PO4Spectrum = spectrum(:, 2) - PO4Baseline;

[PO4Max, PO4MaxIndex] = max(PO4Spectrum(wn980index:wn930index));

PO4WaveNum = wnindex(PO4MaxIndex+wn980index);
figure
plot(spectrum(:,1),PO4Spectrum)

%xlim([PO4x2,PO4x1]);

ylim([-2.5,20])
%figure(j)
%plot(spectrum(:, 1), PO4Spectrum)

%baselining CO3
%CO3 (1050-1100)
%NOT PERFECT
[~, CO3LowBase] = min(spectrum(wn1050index:wn1040index, 2));
[~, CO3HighBase] = min(spectrum(wn1110index:wn1100index, 2));

CO3LowBase = CO3LowBase + (wn1050index-1);
CO3HighBase = CO3HighBase + (wn1110index-1);

CO3x2=spectrum(CO3LowBase, 1);
CO3x1=spectrum(CO3HighBase, 1);
CO3y2=spectrum(CO3LowBase, 2);
CO3y1=spectrum(CO3HighBase, 2);

CO3Baseline = [];
for i=1:length(spectrum(:,1))
    CO3Baseline(i) = ((CO3y2-CO3y1)/(CO3x2-CO3x1))*(spectrum(i, 1)-CO3x1)+CO3y1;
end

CO3Baseline = transpose(CO3Baseline);
CO3Spectrum = spectrum(:, 2) - CO3Baseline;

[CO3Max, CO3MaxIndex] = max(CO3Spectrum(wn1100index:wn1050index));

CO3WaveNum = wnindex(CO3MaxIndex+wn1100index);


%figure(j)
%plot(spectrum(:, 1), CO3Spectrum)


%     %baselining CH2
%     [~, CH2LowBase] = min(spectrum(378:397, 2));
%     [~, CH2HighBase] = min(spectrum(320:359, 2));
%     CH2HighBase = CH2HighBase + 319;
%     CH2LowBase = CH2LowBase + 377;
%
%     CH2x2=spectrum(CH2LowBase, 1);
%     CH2x1=spectrum(CH2HighBase, 1);
%     CH2y2=spectrum(CH2LowBase, 2);
%     CH2y1=spectrum(CH2HighBase, 2);
%
%     CH2Baseline = [];
%     for i=1:length(spectrum(:,1))
%         CH2Baseline(i) = ((CH2y2-CH2y1)/(CH2x2-CH2x1))*(spectrum(i, 1)-CH2x1)+CH2y1;
%     end
%
%     CH2Baseline = transpose(CH2Baseline);
%     CH2Spectrum = spectrum(:, 2) - CH2Baseline;

%baselining phenylalanine
% 1001.07-991.930
%     [~, PhenylLowBase] = min(spectrum(790:798, 2));
%     % 1017.04-1009.06
%     [~, PhenylHighBase] = min(spectrum(776:783, 2));
%     PhenylHighBase = PhenylHighBase + 775;
%     PhenylLowBase = PhenylLowBase + 789;
%
%     Phenylx2=spectrum(PhenylLowBase, 1);
%     Phenylx1=spectrum(PhenylHighBase, 1);
%     Phenyly2=spectrum(PhenylLowBase, 2);
%     Phenyly1=spectrum(PhenylHighBase, 2);
%
%     PhenylBaseline = [];
%     for i=1:length(spectrum(:,1))
%         PhenylBaseline(i) = ((Phenyly2-Phenyly1)/(Phenylx2-Phenylx1))*(spectrum(i, 1)-Phenylx1)+Phenyly1;
%     end
%
%     PhenylBaseline = transpose(PhenylBaseline);
%     PhenylSpectrum = spectrum(:, 2) - PhenylBaseline;


%baselining 'xlr'? not sure what peak this is...
%NOT PERFECT
% 1181.56-1222.09
%[~, xlrLowBase] = min(spectrum(wn1222index:wn1181index, 2));
% 1281.7-1321.39
%[~, xlrHighBase] = min(spectrum(wn1321index:wn1281index, 2));

%xlrLowBase = xlrLowBase + (wn1222index-1);
%xlrHighBase = xlrHighBase + (wn1321index-1);

%xlrx2=spectrum(xlrLowBase, 1);
%xlrx1=spectrum(xlrHighBase, 1);
%xlry2=spectrum(xlrLowBase, 2);
%xlry1=spectrum(xlrHighBase, 2);

%xlrBaseline = [];
%for i=1:length(spectrum(:,1))
%    xlrBaseline(i) = ((xlry2-xlry1)/(xlrx2-xlrx1))*(spectrum(i, 1)-xlrx1)+xlry1;
%end

%xlrBaseline = transpose(xlrBaseline);
%xlrSpectrum = spectrum(:, 2) - xlrBaseline;

%here is where the actual output analyses are

%finding integrated peak areas

%ch2 peak area at 1446
wnch2lowindex=ch2LowBase+1;
wnch2highindex=ch2HighBase-1;
ch2Area = abs(-1*trapz(spectrum(wnch2highindex:wnch2lowindex, 1), ch2Spectrum(wnch2highindex:wnch2lowindex)));

wnch2lowwn=spectrum(wnch2lowindex,1);
wnch2highwn=spectrum(wnch2highindex,1);

%phyn peak area at 1003
wnphynlowindex=phynLowBase+1;
wnphynhighindex=phynHighBase-1;
phynArea = -1*trapz(spectrum(wnphynhighindex:wnphynlowindex, 1), phynSpectrum(wnphynhighindex:wnphynlowindex));

wnphynlowwn=spectrum(wnphynlowindex,1);
wnphynhighwn=spectrum(wnphynhighindex,1);

%pro1 peak area
%first need to index integration range
wnpro1hyplowindex=pro1hypLowBase+1;
wnpro1hyphighindex=pro1hypHighBase-1;
%now calculate area
pro1hypArea = abs(-1*trapz(spectrum(wnpro1hyphighindex:wnpro1hyplowindex, 1), pro1hypSpectrum(wnpro1hyphighindex:wnpro1hyplowindex)));

wnpro1hyplowwn=spectrum(wnpro1hyplowindex,1);
wnpro1hyphighwn=spectrum(wnpro1hyphighindex,1);


[pro1hypMax, pro1hypMaxIndex] = max(pro1hypSpectrum(wnpro1hyphighindex:wnpro1hyplowindex));

pro1hypWaveNum = wnindex(pro1hypMaxIndex+wnpro1hyphighindex);

%pro2 peak area
%first need to index integration range
wnpro2lowindex=pro2LowBase+1;
wnpro2highindex=pro2HighBase-1;
%now calculate area
pro2Area = abs(-1*trapz(spectrum(wnpro2highindex:wnpro2lowindex, 1), pro2Spectrum(wnpro2highindex:wnpro2lowindex)));

wnpro2lowwn=spectrum(wnpro2lowindex,1);
wnpro2highwn=spectrum(wnpro2highindex,1);


[pro2Max, pro2MaxIndex] = max(pro2Spectrum(wnpro2highindex:wnpro2lowindex));

pro2WaveNum = wnindex(pro2MaxIndex+wnpro2highindex);

%combined proline  (855 and 920) and hydroxyproline (920) peak area

prohypproArea=pro1hypArea+pro2Area;

%area 1620.41 to 1719.984
amide1Area = abs(-1*trapz(spectrum(wn1700index:wn1620index, 1), amide1Spectrum(wn1700index:wn1620index)));
%area 1215 to 1300.75
amide3Area = abs(-1*trapz(spectrum(wn1300index:wn1215index, 1), amide3Spectrum(wn1300index:wn1215index)));
%area 930.29 to 980.05
PO4Area = abs(-1*trapz(spectrum(wn980index:wn930index, 1), PO4Spectrum(wn980index:wn930index)));
%area 1050.62 to 1100.38
CO3Area = abs(-1*trapz(spectrum(wn1100index:wn1050index, 1), CO3Spectrum(wn1100index:wn1050index)));
%area 1445.798 to 1452.038
%     CH2Area = -1*trapz(spectrum(376:382, 1), CH2Spectrum(376:382));
%area 998.78 to 1004.49
%     PhenylArea = -1*trapz(spectrum(787:792, 1), PhenylSpectrum(787:792));
%area 1365-1390
%     ProteoArea=-1*trapz(spectrum(427:451,1), proteoSpectrum(427:451));
%area 1275-1300
%     LipidArea=-1*trapz(spectrum(520:543,1), lipidSpectrum(520:543));
%area 1158-1268
%     PenArea=-1*trapz(spectrum(641:650,1), AGE1Spectrum(641:650));
%area 1480-1505
%DAGEArea=-1*trapz(spectrum(345:388,1), DAGE(345:388));


%     %finding peak heights
%     %height at 1665.55
%     amide1Height = amide1Spectrum(157);
%     %height at 1246.01
%     amide3Height = amide3Spectrum(561);
%     %height at 959.75
%     PO4Height = PO4Spectrum(817);
%     %height at 1100.38
%     CO3Height = CO3Spectrum(719);
%     %height at 1449.95
%     CH2Height = CH2Spectrum(369);
%     %height at 1002.2
%     PhenylHeight = PhenylSpectrum(780);
%     %height at 850.13
%     ProlineHeight = ProlineSpectrum(911);
%     %height at 1045.42
%     Height1045 = PO4Spectrum(742);
%height at 1660.58
Height1660 = amide1Spectrum(wn1660index);
%height at 1684.43
%     Height1684 = amide1Spectrum(147);
%height at 1690.36
Height1690 = (wn1690index);
%     %height at 1248.18
%     Height1248 = xlrSpectrum(559);
%     %height at 1268.75
%     Height1268 = xlrSpectrum(540);

%doing a gaussian fit on po4 NOTE DIFFERENT RANGE THEN WHEN BASELINING
%PO4 PEAK

PO4gaussSpectrum = PO4Spectrum(wn980index:wn930index);
totalSumPO4 = abs(-1*trapz(spectrum(wn980index:wn930index, 1), PO4gaussSpectrum));
PO4gaussSpectrum = PO4gaussSpectrum ./ totalSumPO4;

[sigma,mu] = gaussfit(spectrum(wn980index:wn930index), PO4gaussSpectrum);
gaussCurve = 1/(sqrt(2*pi)* sigma ) * exp( - ((spectrum(wn980index:wn930index))-mu).^2 / (2*sigma^2));

fwhmPO4 = 2*sigma*sqrt(2*log(2));

%calculating the reported outputs

%mineral matrix outputs

MinMatAm3Area = PO4Area/amide3Area;

MinMatAm1Area=PO4Area/amide1Area;

MinMatprohypArea=PO4Area/prohypproArea;

MinMatphynArea=PO4Area/phynArea;

MinMatch2Area=PO4Area/ch2Area;

%carbonate to phosphate outputs
CarbPhosArea = CO3Area/PO4Area;

%Crystallinity outputs
XSTPhosFWHM = 1/fwhmPO4;

%Collagen maturity outputs
XLR1660Height = Height1660/Height1690;
XLRarea = Height1690/amide1Area;
%     XLR1248Height = Height1248/Height1268;

% Calculate the Relative PYD Content
%    PYD=Height1690/amide3Area;

%Proteoglycan
%    ProteoAmide3=ProteoArea/amide3Area;

%Lipid
%    Lip2Am3=LipidArea/amide3Area;

% Pentosidine content
%    Pen2Am3=PenArea/amide3Area;

outputs(1, :) = [ MinMatprohypArea,MinMatAm3Area, MinMatAm1Area, XSTPhosFWHM, CarbPhosArea, XLR1660Height,...
    PO4WaveNum, CO3WaveNum, amide1WaveNum, amide3WaveNum, pro1hypWaveNum,...
    pro2WaveNum];


end


%end



function [sigma, mu] = gaussfit( x, y, sigma0, mu0 )
% [sigma, mu] = gaussfit( x, y, sigma0, mu0 )
% Fits a guassian probability density function into (x,y) points using iterative
% LMS method. Gaussian p.d.f is given by:
% y = 1/(sqrt(2*pi)*sigma)*exp( -(x - mu)^2 / (2*sigma^2))
% The results are much better than minimazing logarithmic residuals
%
% INPUT:
% sigma0 - initial value of sigma (optional)
% mu0 - initial value of mean (optional)
%
% OUTPUT:
% sigma - optimal value of standard deviation
% mu - optimal value of mean
%
% REMARKS:
% The function does not always converge in which case try to use initial
% values sigma0, mu0. Check also if the data is properly scaled, i.e. p.d.f
% should approx. sum up to 1
%
% VERSION: 23.02.2012
%
% EXAMPLE USAGE:
% x = -10:1:10;
% s = 2;
% m = 3;
% y = 1/(sqrt(2*pi)* s ) * exp( - (x-m).^2 / (2*s^2)) + 0.02*randn( 1, 21 );
% [sigma,mu] = gaussfit( x, y )
% xp = -10:0.1:10;
% yp = 1/(sqrt(2*pi)* sigma ) * exp( - (xp-mu).^2 / (2*sigma^2));
% plot( x, y, 'o', xp, yp, '-' );


% Maximum number of iterations
Nmax = 50;

if( length( x ) ~= length( y ))
    fprintf( 'x and y should be of equal length\n\r' );
    exit;
end

n = length( x );
x = reshape( x, n, 1 );
y = reshape( y, n, 1 );

%sort according to x
X = [x,y];
X = sortrows( X );
x = X(:,1);
y = X(:,2);

%Checking if the data is normalized
dx = diff( x );
dy = 0.5*(y(1:length(y)-1) + y(2:length(y)));
s = sum( dx .* dy );
if( s > 1.5 | s < 0.5 )
    fprintf( 'Data is not normalized! The pdf sums to: %f. Normalizing...\n\r', s );
    y = y ./ s;
end

X = zeros( n, 3 );
X(:,1) = 1;
X(:,2) = x;
X(:,3) = (x.*x);


% try to estimate mean mu from the location of the maximum
[ymax,index]=max(y);
mu = x(index);

% estimate sigma
sigma = 1/(sqrt(2*pi)*ymax);

if( nargin == 3 )
    sigma = sigma0;
end

if( nargin == 4 )
    mu = mu0;
end

%xp = linspace( min(x), max(x) );

% iterations
for i=1:Nmax
    %    yp = 1/(sqrt(2*pi)*sigma) * exp( -(xp - mu).^2 / (2*sigma^2));
    %    plot( x, y, 'o', xp, yp, '-' );
    
    dfdsigma = -1/(sqrt(2*pi)*sigma^2)*exp(-((x-mu).^2) / (2*sigma^2));
    dfdsigma = dfdsigma + 1/(sqrt(2*pi)*sigma).*exp(-((x-mu).^2) / (2*sigma^2)).*((x-mu).^2/sigma^3);
    
    dfdmu = 1/(sqrt(2*pi)*sigma)*exp(-((x-mu).^2)/(2*sigma^2)).*(x-mu)/(sigma^2);
    
    F = [ dfdsigma dfdmu ];
    a0 = [sigma;mu];
    f0 = 1/(sqrt(2*pi)*sigma).*exp( -(x-mu).^2 /(2*sigma^2));
    a = (F'*F)^(-1)*F'*(y-f0) + a0;
    sigma = a(1);
    mu = a(2);
    
    if( sigma < 0 )
        sigma = abs( sigma );
        fprintf( 'Instability detected! Rerun with initial values sigma0 and mu0! \n\r' );
        error( 'Check if your data is properly scaled! p.d.f should approx. sum up to \n\r' );
    end
end

end