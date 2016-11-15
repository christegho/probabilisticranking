function P = computeProbWin(w,W)

P = zeros(length(w),1);
for player1=1:length(w)
   for player2=1:length(w)
       P(player1)=P(player1)+ sum(normcdf(w(player1,:)-w(player2,:)))/size(w,2);  
   end
end
P = P/107;
cw2(P,W)

