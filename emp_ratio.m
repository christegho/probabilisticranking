function P = emp_ratio()
% Ranking of each player based on the empirical ratio of number of wins to
% total number of games played

load("tennis_data.mat");
P = zeros(length(W),1);
for k = 1:length(W)
  games = sum(G == k);
  gamesplayed = games(:,1)+games(:,2);
  if (gamesplayed~=0)
    P(k) = games(:,1)/gamesplayed;
  end
end

cw2(P,W);