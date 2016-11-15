close all;
load tennis_data

randn('seed',27); % set the pseudo-random number generator seed

M = size(W,1);            % number of players
N = size(G,1);            % number of games in 2011 season 

pv = 0.5*ones(M,1);           % prior skill variance 


iterations = 1020;
w = zeros(M,1);               % set skills to prior mean %Chris changed
w_u1 = zeros(M,iterations);
pl1 = zeros(iterations,1);
w_u10 = zeros(M,iterations/10); 

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

  for g=1:N
    iS(G(g,1),G(g,1)) = iS(G(g,1),G(g,1))+1;
    iS(G(g,2),G(g,2)) = iS(G(g,2),G(g,2))+1;
    iS(G(g,1),G(g,2)) = iS(G(g,1),G(g,2))-1;
    iS(G(g,2),G(g,1)) = iS(G(g,2),G(g,1))-1;
  end

  iSS = diag(1./pv) + iS; % posterior precision matrix
  % prepare to sample from a multivariate Gaussian
  % Note: inv(M)*z = R\(R'\z) where R = chol(M);
  iR = chol(iSS);  % Cholesky decomposition of the posterior precision matrix
  mu = iR\(iR'\m); % equivalent to inv(iSS)*m but more efficient

  % sample from N(mu, inv(iSS))
  w = mu + iR\randn(M,1); 
  pl1(i) = w(1);
  w_u1(:,i) = mu + iR\randn(M,1); 
  if(rem(i-1,10) == 0)
    w_u10(:,((i-1)/10)+1) =  mu + iR\randn(M,1); 
  end
  
end
[covVal, lags] = xcov(w_u1(1,:),100,'coeff');
plot(lags,covVal);
xlabel('Lags');
ylabel('Autocorrelation');
legend('Player 1');
title('Autocorrelation for amples for 10000 iterations without thinning')

figure 
plot(w_u1(1:3,:)');
xlabel('Iterations');
ylabel('Skill');
title('100 samples generated without thinning - seed nb 33')
legend('Player 1', 'Player 2', 'Player 3');

figure
[covVal, lags] = xcov(w_u10(1,3:end),100,'coeff');
plot(lags,covVal);
xlabel('Lags');
ylabel('Autocorrelation');
legend('Player 1');
title('Autocorrelation for samples for 1000 iterations with thinning and burn in')


figure 
plot(w_u10(1:3,3:end)');
xlabel('Iterations');
ylabel('Skill');
title('100 samples generated after thinning and burn-in')
legend('Player 1', 'Player 2', 'Player 3');
