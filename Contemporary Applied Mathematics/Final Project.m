##PCA analysis

#read the data
X = dlmread('beijing_short.csv');
[n,m] = size(X);

# Centering the data
for j=1:m
  c(j) = mean(X(:,j));
  P(:,j) = X(:,j).-c(j);
endfor

# Scaling the data
for j=1:m
  S(j)   = norm(P(:,j))/sqrt(n);
  P(:,j) = P(:,j)/S(j);
endfor

[U,S,V] = svd(P);

#vectors
dim = 2;
V_inv = V';
ai = zeros(dim,1);

#p1 approximation
for i = 1:2
  for j = 5:6
    ai(i) = ai(i) + V(1,j)*V_inv(j,i);
  endfor
endfor

#data approximation
ps = zeros(n,1);
for i = 1:n
  for j = 5:6
    ps(i) = ps(i) + ai(j-4)*P(i,j);
  endfor
endfor

#xes=1:673;

plot(ps,'ro');hold
plot(P(:,4),'b+'); hold
legend('approximation','true values')


##global polynomial interpolation using built-in octave function

x = X(2:6:end,:);
y =x(:,4);  
x = x(:,5);

polyfit(x,y,2)

plot(X(:,5),0.0069451*X(:,5).^2+7.9313501*X(:,5)+193.4286227,'ro'); hold
plot(X(:,5),X(:,4),'b+')
