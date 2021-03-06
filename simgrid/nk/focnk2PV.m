function f = focnk2PV(x0,rnpast,gnow,znow,rnow,ystar,coefc,coefpi,polyd,xmat,wmat,...
    pibar,gamma,beta,invnu,gbar,tau,phi,psi1,psi2,rhor,rhog,rhoz,rnss)

nghe = size(xmat,1);

c0  = x0(1,:);
pi0 = x0(2,:);

y0 = c0/(1/gbar/exp(gnow) - phi/2*(pi0-pibar)^2);
rn0 = rnpast^rhor*( rnss*(pi0/pibar)^psi1*(y0/ystar)^psi2 )^(1-rhor)*exp(rnow);

fc0 = 0.0;
fp0 = 0.0;
for ighe=1:nghe

    gp = rhog*gnow + xmat(ighe,1);
    zp = rhoz*znow + xmat(ighe,2);
    rp = xmat(ighe,3);    

    cp = makebas4([rn0 gp zp rp],polyd)*coefc;
    pip = makebas4([rn0 gp zp rp],polyd)*coefpi;

    yp = cp/(1/gbar/exp(gp) - phi/2*(pip-pibar)^2);
    fcx = beta*cp^(-tau)*rn0/(gamma*exp(zp))/pip;
    fpx = beta*phi*cp^(-tau)*yp*(pip-pibar)*pip;
    weight = wmat(ighe,1)*wmat(ighe,2)*wmat(ighe,3);
    fc0 = fc0 + weight*fcx;
    fp0 = fp0 + weight*fpx;

end

f(1,:) = -c0^(-tau) + rn0*fc0;
f(2,:) = ( (1-invnu)+invnu*c0^tau - phi*(pi0-pibar)*(pi0-.5*invnu*(pi0-pibar)) )*c0^(-tau)*y0 ...
    + fp0;