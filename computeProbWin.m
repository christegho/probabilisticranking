function computeProbWin(w,W)
mean = mean(w,2); %Calculate mean of each player’s skill
P = zeros(length(mean),1);
for player1=1:length(mean)
   for player2=1:length(mean)
       P(player1)+= normcdf(mean(player1)-mean(player2));  
   end
end
P = P/length(mean);
cw2(P,W)