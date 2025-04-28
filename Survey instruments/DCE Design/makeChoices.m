close all;
clear all;
load bestChoiceData_updated


meTimeColor = [0 0 .5];
themTimeColor = [.5 0 0.05];
otherTimeColor = [.5 .5 .5];

a = 'abcdefghijklmnopqrstuvwxyz';
cowSizeNoise = .04;
animalList = {'../goat.png','../cow copy.png','../camel.png'};
animalNames = {'goat','cow','camel'};

actualIncome = [10 20 30 40 50 60 70 80 90 100 110 120 130 140 150 160 170 180 190 200];
%designate the variables here, and their attributes

fallow = data(:,1);
earnings = data(:,2);
badEarnings = data(:,3);
fractionMe = data(:,4);
fractionThem = data(:,5);

countSets = 1;
codeList = table('Size',[3 * length(actualIncome) * length(fallow)/2,2],'VariableTypes',{'double','char'},'VariableNames',{'Set','Code'});
codeList(:,'Set') = table([1:height(codeList)]');
mkdir fullset
cd fullset;

%[animalPic, ~, ImageAlpha] = imread(animalList{indexA});
%     if ~exist(animalNames{indexA})
%         mkdir(animalNames{indexA});
%     end
%     cd(animalNames{indexA});
for indexK = 1:length(actualIncome)
    currentSize = string(actualIncome(indexK));
    %         if ~exist(string(currentSize))
    %             mkdir(string(currentSize))
    %         end
    %         cd(string(currentSize));
    for indexI = 1:2:length(fallow)
        currentSet = figure;
        set(currentSet,'Position', [50 50 1300 750],'Color',[1 1 1]);

        subplot('Position',[0.27 0.93 0.02 0.05])
        text(0,0,'Choice 1', 'FontSize', 30)
        axis off;

        subplot('Position', [0.04, 0.55, 0.07, 0.05])
        text(1.3,0,{'Typical'; 'Earnings'},'FontSize', 20, 'HorizontalAlignment', 'right')
        axis off

        subplot('Position', [0.04, 0.4, 0.07, 0.05])
        text(1.3,0,{'Bad year (1 in 5)'; 'Earnings'},'FontSize', 20, 'HorizontalAlignment', 'right')
        axis off

        subplot('Position', [0.04, 0.25, 0.07, 0.05])
        text(1.3,0,{'Community Land'; 'in Conservation'},'FontSize', 20, 'HorizontalAlignment', 'right')
        axis off

        subplot('Position', [0.04, 0.75, 0.07, 0.05])
        text(1.3,0,{'Effort'},'FontSize', 20, 'HorizontalAlignment', 'right')
        axis off


        %%alternative 1


        %earnings attribute
        currentEarnings = round(actualIncome(indexK) * earnings(indexI));
        axes('Pos',[0.13 0.525 0.05 0.05]);
        axis off
        text(1.3, .5, strcat(num2str(currentEarnings),",000 Ksh"),'FontSize',60);

        %bad earnings attribute
        currentBadEarnings = round(actualIncome(indexK) * earnings(indexI) * badEarnings(indexI));
        axes('Pos',[0.13 0.375 0.05 .05]);
        axis off
        text(1.3, .5, strcat(num2str(currentBadEarnings), ",000 Ksh"),'FontSize',60);

        %fallow attribute
        currentFallow = fallow(indexI);
        axes('Pos',[0.13 0.225 0.05 .05]);
        axis off
        text(2, .5, (num2str(currentFallow)),'FontSize',60);

        subplot('Position', [0.2, 0.7, 0.23, 0.1])
        axis off;
        axis([0 1 0 1]);
        patchX = [0.01 0.09 0.09 0.01 0.01];
        patchY = [0.01 0.01 0.99 0.99 0.01];
        for indexE = 1:10
            if indexE <= 10 * fractionMe(indexI)
                currentColor = meTimeColor;
            elseif indexE <= 10 * (fractionMe(indexI) + fractionThem(indexI))
                currentColor = themTimeColor;
            else
                currentColor = otherTimeColor;
            end
            patch(patchX + (indexE-1)*0.1,patchY,currentColor);
        end


        %%%%%%%%alternative 2


        subplot('Position',[0.59 0.93 0.02 0.05])
        text(0,0,'Choice 2', 'FontSize', 30)
        axis off;

        subplot('Position',[0.44 0.1 0.02 0.8])
        plot([0 0],[0 1],'LineWidth',2,'Color','k')
        axis off

        %earnings attribute
        currentEarnings = round(actualIncome(indexK) * earnings(indexI+1));
        axes('Pos',[0.46 0.525 0.05 .05]);
        axis off
        text(1.3, .5, strcat(num2str(currentEarnings),",000 Ksh"),'FontSize',60);

        %bad earnings attribute
        currentBadEarnings = round(actualIncome(indexK) * earnings(indexI+1) * badEarnings(indexI+1));
        axes('Pos',[0.46 0.375 0.05 .05]);
        axis off
        text(1.3, .5, strcat(num2str(currentBadEarnings), ",000 Ksh"),'FontSize',60);

        %fallow attribute
        currentFallow = fallow(indexI+1);
        axes('Pos',[0.46 0.225 0.05 .05]);
        axis off
        text(2, .5, num2str(currentFallow),'FontSize',60);


        subplot('Position', [0.54, 0.7, 0.23, 0.1])
        axis off;
        axis([0 1 0 1]);
        patchX = [0.01 0.09 0.09 0.01 0.01];
        patchY = [0.01 0.01 0.99 0.99 0.01];
        for indexE = 1:10
            if indexE <= 10 * fractionMe(indexI+1)
                currentColor = meTimeColor;
            elseif indexE <= 10 * (fractionMe(indexI+1) + fractionThem(indexI+1))
                currentColor = themTimeColor;
            else
                currentColor = otherTimeColor;
            end
            patch(patchX + (indexE-1)*0.1,patchY,currentColor);
        end

        %%%%%%

        subplot('Position',[0.78 0.1 0.02 0.8])
        plot([0 0],[0 1],'LineWidth',2,'Color','k')
        axis off

        subplot('Position',[0.84 0.93 0.02 0.05])
        text(0,0,'Choice 3', 'FontSize', 30)
        axis off;

        subplot('Position',[0.84 0.53 0.02 0.05])
        text(2.5,0,{'Status'; 'Quo'}, 'FontSize', 30, 'HorizontalAlignment', 'center')
        axis off;

        subplot('Position',[0.95 0.03 0.02 0.05])
        text(0,0,num2str(countSets), 'FontSize', 30)
        axis off;

        subplot('Position',[0.05 0.03 0.02 0.05])
        currentCode = a(randperm(26,3));
        text(0,0,currentCode, 'FontSize', 30);
        axis off;
        codeList.Code{codeList.Set == countSets} = currentCode;

        set(currentSet,'PaperPositionMode','auto');
        print('-dpng','-painters','-r150',strcat(['choiceSet' num2str(indexK) '_' num2str((indexI-1)/2+1) '.png']));
        %print('-depsc2','-painters','-r150',strcat(['choiceSet' num2str((indexI-1)/2+1) '.eps']));

        close(currentSet);

        countSets = countSets + 1;
    end

end



save preRandomizationVars

%make randomization
numberRandomizations = 600;
numberSets = 5;
numberSetOptions = size(data,1)/2;
numberScales = size(actualIncome,2);
spacer = 1000;
numAnimals = 1;

baseIDList = (1:numberRandomizations)';
fullRandomizations = zeros(numberRandomizations, numberSets);
for indexI = 1:numberRandomizations
    fullRandomizations(indexI,:) = randperm(numberSetOptions, numberSets);
end

fullIDList = zeros(numAnimals * numberRandomizations * numberScales, 1);
fullScale_Randomizations = zeros(numAnimals * numberRandomizations * numberScales, numberSets);
for indexA = 1:numAnimals
    for indexI = 1:numberScales
        fullIDList(((indexA-1) * numberRandomizations * numberScales + (indexI-1)*numberRandomizations) + 1:((indexA-1) * numberRandomizations * numberScales + indexI * numberRandomizations)) = indexA * spacer * spacer + actualIncome(indexI) * spacer + baseIDList;
        fullScale_Randomizations(((indexA-1) * numberRandomizations * numberScales + (indexI-1)*numberRandomizations) + 1:((indexA-1) * numberRandomizations * numberScales + indexI * numberRandomizations),:) = fullRandomizations + (indexI-1) * numberSetOptions + (indexA-1) * numberSetOptions * numberScales;
    end
end

codeColumns = table;
setNames = {};
for indexI = 1:numberSets
    tempTable = codeList(fullScale_Randomizations(:,indexI),2);
    tempTable.Properties.VariableNames{1} = ['code_' num2str(indexI)];
    codeColumns = horzcat(codeColumns,tempTable);
    setNames(end+1) = {['set_' num2str(indexI)]};
end

setTable = array2table([fullIDList fullScale_Randomizations],'VariableNames',{'setID',setNames{:}});
fullTable = horzcat(setTable, codeColumns);
writetable(fullTable,'randomTable.csv');

%make randomization
numberRandomizations = 600;
numberSets = 5;
numberSetOptions = size(data,1)/2;
numberScales = size(actualIncome,2);
spacer = 1000;
numAnimals = 1;

baseIDList = (1:numberRandomizations)';
fullRandomizations = zeros(numberRandomizations, numberSets);
for indexI = 1:numberRandomizations
    fullRandomizations(indexI,:) = randperm(numberSetOptions, numberSets);
end

fullIDList = zeros(numAnimals * numberRandomizations * numberScales, 1);
fullScale_Randomizations = zeros(numAnimals * numberRandomizations * numberScales, numberSets);
for indexA = 1:numAnimals
    for indexI = 1:numberScales
        fullIDList(((indexA-1) * numberRandomizations * numberScales + (indexI-1)*numberRandomizations) + 1:((indexA-1) * numberRandomizations * numberScales + indexI * numberRandomizations)) = indexA * spacer * spacer + actualIncome(indexI) * spacer + baseIDList;
        fullScale_Randomizations(((indexA-1) * numberRandomizations * numberScales + (indexI-1)*numberRandomizations) + 1:((indexA-1) * numberRandomizations * numberScales + indexI * numberRandomizations),:) = fullRandomizations + (indexI-1) * numberSetOptions + (indexA-1) * numberSetOptions * numberScales;
    end
end

codeColumns = table;
setNames = {};
for indexI = 1:numberSets
    tempTable = codeList(fullScale_Randomizations(:,indexI),2);
    tempTable.Properties.VariableNames{1} = ['code_' num2str(indexI)];
    codeColumns = horzcat(codeColumns,tempTable);
    setNames(end+1) = {['set_' num2str(indexI)]};
end

setTable = array2table([fullIDList fullScale_Randomizations],'VariableNames',{'setID',setNames{:}});
fullTable = horzcat(setTable, codeColumns);
writetable(fullTable,'randomTable_post.csv');