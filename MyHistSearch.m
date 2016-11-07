function [histy] = MyHistSearch(SearchResults, bins)

histy.Estar = NaN;
histy.Esample = NaN;
histy.ModLength = NaN;
histy.Fit1R2 = NaN;
histy.Fit1AAR = NaN;
histy.Fit1MAR = NaN;
histy.Fit2R2 = NaN;
histy.Fit2AAR = NaN;
histy.Fit2MAR = NaN;
histy.Hr = NaN;
histy.Fit3R2 = NaN;
histy.hchange = NaN;
histy.Pchange = NaN;
histy.Fit4AAR = NaN;
histy.Fit4MAR = NaN;
histy.P_star = NaN;
histy.h_star = NaN;
histy.dP = NaN;
histy.dH = NaN;


%% the histogram plots
Fit1 = [SearchResults.Fit1];
Fit2 = [SearchResults.Fit2];
Fit3 = [SearchResults.Fit3];
Fit4 = [SearchResults.Fit4];

subplot(4,4,1); % E_star & E_sample
[N, X] = hist([SearchResults.E_star], bins);
histy.Estar = [N; X];
plot(X,N,'b.-');
hold on
[N, X] = hist([SearchResults.E_sample], bins);
histy.Esample = [N; X];
plot(X,N,'g.-');
xlabel('Modulus [GPa]', 'FontWeight', 'Bold');
legend('effective','sample','Location','NorthWest');
hold off

subplot(4,4,2) % Fit1 & Fit2 & Fit3 R2
[N, X] = hist([Fit1.Rsquared], bins);
plot(X,N,'b.-');
histy.Fit1R2 = [N; X];
hold on
[N, X] = hist([Fit2.Rsquared], bins);
histy.Fit2R2 = [N; X];
plot(X,N,'g.-');
[N, X] = hist([Fit3.Rsquared], bins);
histy.Fit3R2 = [N; X];
plot(X,N,'r.-');
xlabel('R^2', 'FontWeight', 'Bold');
legend('Fit1','Fit2', 'Fit3','Location','NorthWest');
hold off

subplot(4,4,3); % Modulus Segment Length
[N, X] = hist([SearchResults.modulus_length], bins);
histy.ModLength = [N; X];
plot(X,N,'b.-');
xlabel('Modulus Length [#points]', 'FontWeight', 'Bold');

subplot(4,4,4); % Hr - residual height
[N, X] = hist(real([Fit2.y_intercept]), bins);
histy.Hr = [N; X];
plot(X, N, 'b.-'); 
xlabel('H_r [nm]', 'FontWeight', 'Bold');

subplot(4,4,5); % Fit1 AAR
[N, X] = hist([Fit1.AverageAbsoluteResidual], bins);
histy.Fit1AAR = [N; X];
plot(X,N,'b.-');
xlabel('Fit1 Avg.Abs.Res.', 'FontWeight', 'Bold');

subplot(4,4,6); % Fit1 MAR
[N, X] = hist([Fit1.MaxAbsoluteResidual], bins);
histy.Fit1MAR = [N; X];
plot(X,N,'b.-');
xlabel('Fit1 Max.Abs.Res.', 'FontWeight', 'Bold');

subplot(4,4,7); % Fit2 AAR
[N, X] = hist([Fit2.AverageAbsoluteResidual], bins);
histy.Fit2AAR = [N; X];
plot(X,N,'b.-');
xlabel('Fit2 Avg.Abs.Res.', 'FontWeight', 'Bold');

subplot(4,4,8); % Fit2 MAR
[N, X] = hist([Fit2.MaxAbsoluteResidual], bins);
histy.Fit2MAR = [N; X];
plot(X,N,'b.-');
xlabel('Fit2 Max.Abs.Res.', 'FontWeight', 'Bold');

subplot(4,4,9); % h_change
[N, X] = hist([SearchResults.h_change], bins);
histy.hchange = [N; X];
plot(X,N,'b.-');
xlabel('h change [nm/nm]', 'FontWeight', 'Bold');

subplot(4,4,10); % P_change
[N, X] = hist([SearchResults.p_change], bins);
histy.Pchange = [N; X];
plot(X,N,'b.-');
xlabel('P change [mN/mN]', 'FontWeight', 'Bold');

subplot(4,4,11); % Fit4 Avg. Abs. Residual
[N, X] = hist([Fit4.AverageAbsoluteResidual], bins);
histy.Fit4AAR = [N; X];
plot(X, N, 'b.-');
xlabel('Fit4 Avg.Abs.Res.', 'FontWeight', 'Bold');

subplot(4,4,12); % Fit4 MaxAbsResidual
[N, X] = hist([Fit4.MaxAbsoluteResidual], bins);
histy.Fit4MAR = [N; X];
plot(X,N,'b.-');
xlabel('Fit4 Max.Abs.Res.', 'FontWeight', 'Bold');

subplot(4,4,13); % P_star
[N, X] = hist([SearchResults.P_star], bins);
histy.P_star = [N; X];
plot(X,N,'b.-');
xlabel('P^* [mN]', 'FontWeight', 'Bold');

subplot(4,4,14); % h_star
[N, X] = hist([SearchResults.h_star], bins);
histy.h_star = [N; X];
plot(X,N,'b.-');
xlabel('h^* [nm]', 'FontWeight', 'Bold');

subplot(4,4,15); % dP
[N, X] = hist([SearchResults.dP], bins);
histy.dP = [N; X];
plot(X,N,'b.-');
xlabel('dP [mN]', 'FontWeight', 'Bold');

subplot(4,4,16); % dH
[N, X] = hist([SearchResults.dH], bins);
histy.dH = [N; X];
plot(X,N,'b.-');
xlabel('dH [nm]', 'FontWeight', 'Bold');

end
