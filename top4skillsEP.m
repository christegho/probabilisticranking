meansP = means(:,35);
varianceP = variance(:,35);

[kk,ii] = sort(meansP, 'descend');


for player=1:4
   players(player)=W(ii(player)); %The name of each player
end

for player1=1:4
    for player2=1:4
            pWinn(player1,player2) = 1-normcdf((meansP(ii(player2))-meansP(ii(player1)))/(sqrt(varianceP(ii(player1))+varianceP(ii(player2)))));
    end
end