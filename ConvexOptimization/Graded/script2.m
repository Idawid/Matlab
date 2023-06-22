x1=imread('parrot.png');
x1=imresize(x1,[200,200]);
x0=im2double(rgb2gray(x1));
a=4;
n=size(x0,1);
Lambda=ones(n);
Lambda([(floor(n/2)-a):(floor(n/2)+a)],:)=0;
y=Lambda.*x0;
figure
imshow(y);

Phi=@(x) Lambda.*x; % function to apply mask to proceeded image
PhiS=@(x) Lambda.*x; % conjugate to apply mask to proceeded image

ProjD=@(x) x+PhiS(y-Phi(x));

gradF=@(x)cat(3, x-x(:,[end,1:(end-1)]),x-x([end,1:(end-1)],:));
div=@(w) (w(:,[2:end,1],1)-w(:,:,1)+w([2:end,1],:,2)-w(:,:,2));
epsilon=0.001; % smoothing norm
NormEps=@(u,eps) sqrt(eps^2+sum(u.^2,3));
J=@(u,eps) sum(sum(NormEps(gradF(u),eps)));
%J=@(u,eps) sum(sum(NormEps(grad(u),eps))); with toolbox signal
Normalization=@(u,eps) u./repmat(NormEps(u,eps),[1,1,2]);
gradJ=@(x,eps)-div(Normalization(gradF(x),eps)); % gradient of gradient smoothing term
%gradJ=@(x,eps)-div(Normalization(grad(x),eps)); % gradient of gradient
%smoothing term with toolbox signal

tau=1.8/(8/epsilon); % step size for grad iteration
niter=40000;

x=y; % initialize by noisy
E=zeros(1,niter); % storage of energy

for i=1:niter
    E(i)=J(x,epsilon); % update for energy
    s=x-tau*gradJ(x,epsilon);
    x=ProjD(s);    
end

figure
imshow(x)