clear all
survey_data = readtable('full_survey_pre.xlsx');
survey_post_data = readtable('full_survey_post.xlsx');
game_list = readtable('game_participant_list.xlsx');


survey_post_data.rightKey = survey_post_data.x_ENTERTHECHOICESETIDENTIFIERNUMBERYOUWROTEDOWNFORTHISPARTICIPA;
survey_data.leftKey = str2double(survey_data.earnings_ID_pair);

joinedData = innerjoin(survey_data,survey_post_data,"LeftKeys","leftKey","RightKeys","rightKey");

joinedData.earnings_ID_pair = str2double(joinedData.earnings_ID_pair);
joinedData.earnings = str2double(joinedData.earnings);
joinedData.bad_earnings = str2double(joinedData.bad_earnings);
[b,i,j] = unique(joinedData.WhatBestDescribesTheLevelOfSchoolingYouHaveCompleted_);
j(j == 4) = 10;
j(j == 5) = 11;
j(j == 1) = 12;
j(j == 6) = 13;
j(j == 2) = 14;
j(j == 7) = 15;
j(j == 3) = 16;
j = j - 10;
joinedData.edu = j;
[b,i,j] = unique(joinedData.cons_label);
j(j==4) = 10;
j(j==2) = 11;
j(j==1) = 12;
j(j==5) = 13;
j(j==3) = 14;
j = j - 10;
joinedData.cons_frac = j;

group_summary = table();
for indexI = 1:max(game_list.group)

    current_group = game_list(game_list.group == indexI,:);
    current_group = innerjoin(current_group,joinedData,"LeftKeys","dce_code","RightKeys","earnings_ID_pair");
    group_summary.age(indexI) = mean(current_group.HowOldAreYou_);
    group_summary.num_matched_members(indexI) = size(current_group,1);
    group_summary.edu(indexI) = mean(current_group.edu);
    group_summary.land(indexI) = mean(current_group.AboutHowMuchLandDoYouCultivate_);
    group_summary.group(indexI) = indexI;
    group_summary.earnings(indexI) = mean(current_group.earnings);
    group_summary.bad_earnings(indexI) = mean(current_group.bad_earnings);
    group_summary.time_self(indexI) = mean(current_group.TimeSpentDoingFarmingForSelf);
    group_summary.time_share(indexI) = mean(current_group.TimeSpentDoingFarmingForSharedGroup);
    group_summary.cons_frac(indexI) = mean(current_group.cons_frac);
    group_summary.cattle(indexI) = mean(current_group.Cattle);
    group_summary.shoat(indexI) = mean(current_group.SheepAndGoats);

end

writetable(group_summary,'group_summary.csv');