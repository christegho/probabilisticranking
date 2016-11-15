meanP = mean(w_u10,2)/102;
[kk,ii] = sort(meanP, 'descend');


for player=1:4
   players(player)=W(ii(player)); 
end

for player1=1:4
    for player2=1:4
            pWinn(player1,player2) = sum(normcdf(w_u10(ii(player1),:)-w_u10(ii(player2),:)))/size(w_u10,2);
    end
end