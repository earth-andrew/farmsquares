clear all;

gameList = dir('*.xlsx');

gameSummary = table();

currentRecord = 1;
for indexI = 1:size(gameList,1)

    currentGame = readtable(gameList(indexI).name,"ReadVariableNames",false);

    gameID = currentGame.Var1(contains(currentGame.Var1, "gameID: "));

    gameName = gameList(indexI).name;

    gender = -99;
    if(contains(gameList(indexI).name,"_Men_")) gender = 1; end
    if(contains(gameList(indexI).name,"_Women_")) gender = 2; end
    if(contains(gameList(indexI).name,"_Mixed_")) gender = 3; end

    group = str2double(gameName(strfind(gameName,"Group")+6:strfind(gameName,"Treatment")-2));
    
    if(isnan(group))
        f=1;
    end
    site = -99;
    if(contains(gameList(indexI).name,"Agoro East")) site = 1; end
    if(contains(gameList(indexI).name,"Lyanaginga")) site = 2; end
    if(contains(gameList(indexI).name,"Jimo East")) site = 3; end
    
    player1Score = currentGame.Var1(contains(currentGame.Var1, "Player 1 earns " | "Player 1 score "));
    player2Score = currentGame.Var1(contains(currentGame.Var1, "Player 2 earns " | "Player 2 score "));
    player3Score = currentGame.Var1(contains(currentGame.Var1, "Player 3 earns " | "Player 3 score "));
    player4Score = currentGame.Var1(contains(currentGame.Var1, "Player 4 earns " | "Player 4 score "));
    player5Score = currentGame.Var1(contains(currentGame.Var1, "Player 5 earns " | "Player 5 score "));
    player6Score = currentGame.Var1(contains(currentGame.Var1, "Player 6 earns " | "Player 6 score "));

    endRound = find(contains(currentGame.Var1, "clicked confirm"));
    endRound = endRound(1:6:end);
    endRound = [0; endRound];

    soilHealth = find(contains(currentGame.Var1, "Environmental Variable - soil_fert"));
    yield = find(contains(currentGame.Var1, "Yield"));

    gifts = find(contains(currentGame.Var1, "gave"));

    if ~isempty(gifts)
        f =1;
    end

    if ~isempty(player6Score) %player6Score is only defined for completed games with 6 players
        gameSummary.gameID(currentRecord) = {gameID{1}(9:end)};

        p1Score = str2double(player1Score{1}(15:end));
        p2Score = str2double(player2Score{1}(15:end));
        p3Score = str2double(player3Score{1}(15:end));
        p4Score = str2double(player4Score{1}(15:end));
        p5Score = str2double(player5Score{1}(15:end));
        p6Score = str2double(player6Score{1}(15:end));
        totalScore = p1Score + p2Score + p3Score + p4Score + p5Score + p6Score;
        varScore = var([p1Score,p2Score,p3Score,p4Score,p5Score,p6Score]);
        gameSummary.p1Score(currentRecord) = p1Score;
        gameSummary.p2Score(currentRecord) = p2Score;
        gameSummary.p3Score(currentRecord) = p3Score;
        gameSummary.p4Score(currentRecord) = p4Score;
        gameSummary.p5Score(currentRecord) = p5Score;
        gameSummary.p6Score(currentRecord) = p6Score;
        gameSummary.totalScore(currentRecord) = totalScore;
        gameSummary.varScore(currentRecord) = varScore;
        gameSummary.gender(currentRecord) = gender;
        gameSummary.site(currentRecord) = site;
        gameSummary.numGifts(currentRecord) = size(gifts,1);
        gameSummary.group(currentRecord) = group;

        sumGifts = 0;
        for indexK = 1:size(gifts,1)
            a = currentGame.Var1 {gifts(indexK)};
            sumGifts = sumGifts + str2double(a(strfind(a,'gave')+4:strfind(a,'to')-1));
        end

        gameSummary.sumGifts(currentRecord) = sumGifts;
        
        for indexK = 2:length(endRound)
            currentValue = 0;
            currentList = soilHealth(and(soilHealth > endRound(indexK-1), soilHealth < endRound(indexK)));
            currentSoilHealth = currentGame.Var1(currentList);
            for indexJ = 1:length(currentList)
                currentValue = currentValue + str2double(currentSoilHealth{indexJ}(46));
            end
            currentValue = currentValue / indexJ;

            eval(['gameSummary.soilHealth_round' num2str(indexK-1) '(currentRecord) = currentValue;']);
        end

        for indexK = 2:length(endRound)
            currentValue = 0;
            currentList = yield(and(yield > endRound(indexK-1), yield < endRound(indexK)));
            currentYield = currentGame.Var1(currentList);
            yieldList = zeros(size(currentYield,1),1);
            for indexJ = 1:length(currentList)
                yieldList(indexJ) = str2double(currentYield{indexJ}(31:32));
                currentValue = currentValue + str2double(currentYield{indexJ}(31:32));
            end
            yield_3 = sum(yieldList == 3);
            yield_15 = sum(yieldList == 15);
            yield_32 = sum(yieldList == 32);

            eval(['gameSummary.yield_round' num2str(indexK-1) '(currentRecord) = currentValue;']);
            eval(['gameSummary.yield_3_round' num2str(indexK-1) '(currentRecord) = yield_3;']);
            eval(['gameSummary.yield_15_round' num2str(indexK-1) '(currentRecord) = yield_15;']);
            eval(['gameSummary.yield_32_round' num2str(indexK-1) '(currentRecord) = yield_32;']);
            
        end

        currentRecord = currentRecord + 1;
    end

end

[b,i,j] = unique(gameSummary.gameID);
gameSummary.treatment = j;

writetable(gameSummary,'gameSummary.csv');

gameMeans = [ ...
mean(gameSummary.totalScore(contains(gameSummary.gameID, b(1))));
mean(gameSummary.totalScore(contains(gameSummary.gameID, b(2))));
mean(gameSummary.totalScore(contains(gameSummary.gameID, b(3))));
mean(gameSummary.totalScore(contains(gameSummary.gameID, b(4))));
mean(gameSummary.totalScore(gameSummary.gender == 1));
mean(gameSummary.totalScore(gameSummary.gender == 2));
mean(gameSummary.totalScore(gameSummary.gender == 3));
];

gameVars = [ ...
mean(gameSummary.varScore(contains(gameSummary.gameID, b(1))));
mean(gameSummary.varScore(contains(gameSummary.gameID, b(2))));
mean(gameSummary.varScore(contains(gameSummary.gameID, b(3))));
mean(gameSummary.varScore(contains(gameSummary.gameID, b(4))));
mean(gameSummary.varScore(gameSummary.gender == 1));
mean(gameSummary.varScore(gameSummary.gender == 2));
mean(gameSummary.varScore(gameSummary.gender == 3));
];

diff_meanscore_men_women = kstest2(gameSummary.totalScore(gameSummary.gender == 1), gameSummary.totalScore(gameSummary.gender == 2));
diff_meanscore_men_mixed = kstest2(gameSummary.totalScore(gameSummary.gender == 1), gameSummary.totalScore(gameSummary.gender == 3));
diff_meanscore_women_mixed = kstest2(gameSummary.totalScore(gameSummary.gender == 2), gameSummary.totalScore(gameSummary.gender == 3));

diff_varscore_men_women = kstest2(gameSummary.varScore(gameSummary.gender == 1 & (gameSummary.treatment == 1 | gameSummary.treatment == 4)), gameSummary.varScore(gameSummary.gender == 2 & (gameSummary.treatment == 1 | gameSummary.treatment == 4)));
diff_varscore_men_mixed = kstest2(gameSummary.varScore(gameSummary.gender == 1 & (gameSummary.treatment == 1 | gameSummary.treatment == 4)), gameSummary.varScore(gameSummary.gender == 3 & (gameSummary.treatment == 1 | gameSummary.treatment == 4)));
diff_varscore_women_mixed = kstest2(gameSummary.varScore(gameSummary.gender == 2 & (gameSummary.treatment == 1 | gameSummary.treatment == 4)), gameSummary.varScore(gameSummary.gender == 3 & (gameSummary.treatment == 1 | gameSummary.treatment == 4)));

diff_meanscore_1_2or3 = kstest2(gameSummary.totalScore(gameSummary.treatment == 1), gameSummary.totalScore(gameSummary.treatment == 2 | gameSummary.treatment == 3));
diff_meanscore_1_4 = kstest2(gameSummary.totalScore(gameSummary.treatment == 1), gameSummary.totalScore(gameSummary.treatment == 4));
diff_meanscore_2or3_4 = kstest2(gameSummary.totalScore(gameSummary.treatment == 2 | gameSummary.treatment == 3), gameSummary.totalScore(gameSummary.treatment == 4));

diff_meanhealth_men_women = kstest2(gameSummary.soilHealth_round15(gameSummary.gender == 1), gameSummary.soilHealth_round15(gameSummary.gender == 2));
diff_meanhealth_men_mixed = kstest2(gameSummary.soilHealth_round15(gameSummary.gender == 1), gameSummary.soilHealth_round15(gameSummary.gender == 3));
diff_meanhealth_women_mixed = kstest2(gameSummary.soilHealth_round15(gameSummary.gender == 2), gameSummary.soilHealth_round15(gameSummary.gender == 3));

diff_meanhealth_1_2or3 = kstest2(gameSummary.soilHealth_round15(gameSummary.treatment == 1), gameSummary.soilHealth_round15(gameSummary.treatment == 2 | gameSummary.treatment == 3));
diff_meanhealth_1_4 = kstest2(gameSummary.soilHealth_round15(gameSummary.treatment == 1), gameSummary.soilHealth_round15(gameSummary.treatment == 4));
diff_meanhealth_2or3_4 = kstest2(gameSummary.soilHealth_round15(gameSummary.treatment == 2 | gameSummary.treatment == 3), gameSummary.soilHealth_round15(gameSummary.treatment == 4));
