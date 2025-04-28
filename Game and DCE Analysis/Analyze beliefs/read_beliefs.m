close all;

a = readtable("belief_vars_only.xlsx");

[p_animals,h_animals,stat_animals] = signrank(a.belief_animals, a.belief_animals_post);
[p_landuse,h_landuse,stat_landuse] = signrank(a.belief_landuse, a.belief_landuse_post);
[p_invest,h_invest,stat_invest] = signrank(a.belief_invest, a.belief_invest_post);
[p_manage,h_manage,stat_manage] = signrank(a.belief_manage, a.belief_manage_post);
[p_markets,h_markets,stat_markets] = signrank(a.belief_markets, a.belief_markets_post);

[p_animals,h_animals,stat_animals] = ranksum(a.belief_animals, a.belief_animals_post);
[p_landuse,h_landuse,stat_landuse] = ranksum(a.belief_landuse, a.belief_landuse_post);
[p_invest,h_invest,stat_invest] = ranksum(a.belief_invest, a.belief_invest_post);
[p_manage,h_manage,stat_manage] = ranksum(a.belief_manage, a.belief_manage_post);
[p_markets,h_markets,stat_markets] = ranksum(a.belief_markets, a.belief_markets_post);

[p_d_animals,h_d_animals,s_d_animals] = ranksum(a.belief_animals - a.belief_animals_post, 0);
[p_d_landuse,h_d_landuse,s_d_landuse] = ranksum(a.belief_landuse - a.belief_landuse_post, 0);
[p_d_invest,h_d_invest,s_d_invest] = ranksum(a.belief_invest - a.belief_invest_post, 0);
[p_d_manage,h_d_manage,s_d_manage] = ranksum(a.belief_manage - a.belief_manage_post, 0);
[p_d_markets,h_d_markets,s_d_markets] = ranksum(a.belief_markets - a.belief_markets_post, 0);

hist_animals = hist(a.belief_animals,1:4);
hist_landuse = hist(a.belief_landuse,1:4);
hist_invest = hist(a.belief_invest,1:4);
hist_manage = hist(a.belief_manage,1:4);
hist_markets = hist(a.belief_markets,1:4);

hist_animals_post = hist(a.belief_animals_post,1:4);
hist_landuse_post = hist(a.belief_landuse_post,1:4);
hist_invest_post = hist(a.belief_invest_post,1:4);
hist_manage_post = hist(a.belief_manage_post,1:4);
hist_markets_post = hist(a.belief_markets_post,1:4);

bar_graph = bar([hist_animals; hist_animals_post; hist_landuse; hist_landuse_post; hist_invest; hist_invest_post; hist_manage; hist_manage_post; hist_markets; hist_markets_post],'stacked');

set(bar_graph,'FaceColor','flat');
bar_graph(1).CData = [0 0 1];
bar_graph(2).CData = [0 0.5 1];
bar_graph(3).CData = [0.75 0.5 0.5];
bar_graph(4).CData = [0.75 0 0];


ylim([0 161])
grid on
yticks([0:20:160])
xticks([]);
set(gca,'FontSize',14)
set(gcf,'Position',[200 300 1200 600])

extremes_animals = a.belief_animals;
extremes_landuse = a.belief_landuse;
extremes_invest = a.belief_invest;
extremes_manage = a.belief_manage;
extremes_markets = a.belief_markets;

extremes_animals_post = a.belief_animals_post;
extremes_landuse_post = a.belief_landuse_post;
extremes_invest_post = a.belief_invest_post;
extremes_manage_post = a.belief_manage_post;
extremes_markets_post = a.belief_markets_post;

extremes_animals(a.belief_animals == 1) = 1;
extremes_animals(a.belief_animals == 2) = 0;
extremes_animals(a.belief_animals == 3) = 0;
extremes_animals(a.belief_animals == 4) = 1;

extremes_landuse(a.belief_landuse == 1) = 1;
extremes_landuse(a.belief_landuse == 2) = 0;
extremes_landuse(a.belief_landuse == 3) = 0;
extremes_landuse(a.belief_landuse == 4) = 1;

extremes_invest(a.belief_invest == 1) = 1;
extremes_invest(a.belief_invest == 2) = 0;
extremes_invest(a.belief_invest == 3) = 0;
extremes_invest(a.belief_invest == 4) = 1;

extremes_manage(a.belief_manage == 1) = 1;
extremes_manage(a.belief_manage == 2) = 0;
extremes_manage(a.belief_manage == 3) = 0;
extremes_manage(a.belief_manage == 4) = 1;

extremes_markets(a.belief_markets == 1) = 1;
extremes_markets(a.belief_markets == 2) = 0;
extremes_markets(a.belief_markets == 3) = 0;
extremes_markets(a.belief_markets == 4) = 1;


extremes_animals_post(a.belief_animals_post == 1) = 1;
extremes_animals_post(a.belief_animals_post == 2) = 0;
extremes_animals_post(a.belief_animals_post == 3) = 0;
extremes_animals_post(a.belief_animals_post == 4) = 1;

extremes_landuse_post(a.belief_landuse_post == 1) = 1;
extremes_landuse_post(a.belief_landuse_post == 2) = 0;
extremes_landuse_post(a.belief_landuse_post == 3) = 0;
extremes_landuse_post(a.belief_landuse_post == 4) = 1;

extremes_invest_post(a.belief_invest_post == 1) = 1;
extremes_invest_post(a.belief_invest_post == 2) = 0;
extremes_invest_post(a.belief_invest_post == 3) = 0;
extremes_invest_post(a.belief_invest_post == 4) = 1;

extremes_manage_post(a.belief_manage_post == 1) = 1;
extremes_manage_post(a.belief_manage_post == 2) = 0;
extremes_manage_post(a.belief_manage_post == 3) = 0;
extremes_manage_post(a.belief_manage_post == 4) = 1;

extremes_markets_post(a.belief_markets_post == 1) = 1;
extremes_markets_post(a.belief_markets_post == 2) = 0;
extremes_markets_post(a.belief_markets_post == 3) = 0;
extremes_markets_post(a.belief_markets_post == 4) = 1;

[p_e_animals,h_e_animals,stat_e_animals] = ranksum(extremes_animals, extremes_animals_post);
[p_e_landuse,h_e_landuse,stat_e_landuse] = ranksum(extremes_landuse, extremes_landuse_post);
[p_e_invest,h_e_invest,stat_e_invest] = ranksum(extremes_invest, extremes_invest_post);
[p_e_manage,h_e_manage,stat_e_manage] = ranksum(extremes_manage, extremes_manage_post);
[p_e_markets,h_e_markets,stat_e_markets] = ranksum(extremes_markets, extremes_markets_post);
