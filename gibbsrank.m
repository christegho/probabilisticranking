close all;
load tennis_data

randn('seed',27); % set the pseudo-random number generator seed

M = size(W,1);            % number of players
N = size(G,1);            % number of games in 2011 season 

pv = 0.5*ones(M,1);           % prior skill variance 


iterations = 1000;
w = zeros(M,iterations);               % set skills to prior mean %Chris changed
w_uncorrelated = zeros(M,iterations/10); 
for i = 1:iterations

  % First, sample performance differences given the skills and outcomes
  
  t = nan(N,1); % contains a t_g variable for each game
  for g = 1:N   % loop over games
    s = w(G(g,1))-w(G(g,2));  % difference in skills
    t(g) = randn()+s;         % performace difference sample
    while t(g) < 0  % rejection sampling: only positive perf diffs accepted
      t(g) = randn()+s; % if rejected, sample again
    end
  end 
 
  
  % Second, jointly sample skills given the performance differences
  
  m = nan(M,1);  % container for the mean of the conditional 
                 % skill distribution given the t_g samples
  for p = 1:M
    m(p) = t'*(((p-G(:,1))==0)-((p-G(:,2))==0));
  end
  
  iS = zeros(M,M); % container for the sum of precision matrices contributed
                   % by all the games (likelihood terms)
  
%    for p = 1:M
%      for k = 1:M
%        if (p==k)
%          iS(p,k) = sum(((p-G(:,1))==0)+((p-G(:,2))==0));
%        else
%          iS(p,k) = -sum(((p-G(:,1))==0).*((k-G(:,2))==0)+((p-G(:,2))==0).*((k-G(:,1))==0));
%        end
%      end
%    end
    
%    p = meshgrid(1:107);
%    k = p';
%    for g=1:N
%      iS+=((p-G(g,1))==0).*(((k-G(g,2))==0).^(p-k!=0))+((p-G(g,2))==0).*(((k-G(g,1))==0).^(p-k!=0));
%    end

  for g=1:N
    iS(G(g,1),G(g,1)) = iS(G(g,1),G(g,1))+1;
    iS(G(g,2),G(g,2)) = iS(G(g,2),G(g,2))+1;
    iS(G(g,1),G(g,2)) = iS(G(g,1),G(g,2))+1;
    iS(G(g,2),G(g,1)) = iS(G(g,2),G(g,1))+1;
  end

  iSS = diag(1./pv) + iS; % posterior precision matrix
  % prepare to sample from a multivariate Gaussian
  % Note: inv(M)*z = R\(R'\z) where R = chol(M);
  iR = chol(iSS);  % Cholesky decomposition of the posterior precision matrix
  mu = iR\(iR'\m); % equivalent to inv(iSS)*m but more efficient

  % sample from N(mu, inv(iSS))
  w(:,i) = mu + iR\randn(M,1); %Chris changed
  if(rem(i-1,10) == 0)
    w_uncorrelated(:,((i-1)/10)+1) =  mu + iR\randn(M,1); 
  end
end

figure
plot(w(1:3,:)')
xlabel('iterations')
ylabel('skill')
legend('Player1', 'Player2', 'Player3')
title('plot of skills for 1000 iterations, without removing any sample')

figure 
xcovW = xcov(w(1,:)');
plot(xcovW)
legend('Player1')
title('xcov 1000 samples, without removing any sample')

figure 
plot(xcovW(991:1009))
legend('Player1')
title('ZOOM xcov 1000 samples, without removing any sample')

figure
plot(w_uncorrelated(1:3,:)')
ylabel('iterations')
xlabel('skill')
legend('Player1', 'Player2', 'Player3')
title('plot of skills for 1000 iterations retaining every 10th sample')

figure 
plot(xcov(w_uncorrelated(1,:)'))
legend('Player1')
title('xcov 1000 samples retaing every 10th sample only')

