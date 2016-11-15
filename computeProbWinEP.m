function P = computeProbWinEP(means, variance, W)
P = zeros(length(means),1);
for player1=1:length(means)
   for player2=1:length(means)
       P(player1)=P(player1)+ normcdf((means(player1) - means(player2)) / sqrt(1+variance(player1) + variance(player2)) );  
   end
end
P = P/107;
cw2(P,W)
