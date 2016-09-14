function [k,coh,ph,ss,ss2,sig,sig2]=kcoherence(x,y,sb,Nv,dz,demn,detrnd,taper,deg,fg,kmin,kmax,off);
%function [k,coh,ph,ss1,ss2,sig,sig2]=kcoherence(x,y,sb,Nv,dz,demn,detrnd,taper,deg,fg,kmin,kmax,off);
%The convention for phase is that a positive phase indicates that x leads y.
%Phase = atan(x/y).  A phase of +90 degs indicates that x=iy.
%
% Modified from an MHA script
[m,n]=size(x);
[m2,n2]=size(y);
if ~(m == m2 & n == n2)
	disp 'error: arrays must have same dimensions.'
	return;
end

if ~exist('sb')
	sb=1; % start indice
end
if ~exist('Nv')
	Nv=m; % window size
end
if ~exist('deg')
	deg=n; % # of columns from input matrix to use
end
if ~exist('dz')
	dz=1;  % sampling intervl
end
if ~exist('fig')
	fig=1; % make a figure
end
if ~exist('off')
	off=0; % offset from the start
end
if ~exist('demn')
	demn=1; % demean
end
if ~exist('detrnd')
	detrnd=1; % detrend
end
if ~exist('taper')
	taper=1;
end

%pass 0 for Nv and deg to use the entire array
if deg==0
	deg=n;
end
if Nv==0
	Nv=m;
end


dk=1/Nv/dz;
%This is not quite right if Nv is odd...  fix.  mha 6/25/99
if rem(Nv,2)==0
    k=-Nv/2*dk:dk:Nv/2*dk-dk;
else
    kp=dk:dk:dk*floor(Nv/2);
    k=[fliplr(-kp) 0 kp];
end

%sig and sig2 are chunks of the original series from sb+1 to sb+Nv
sig=x(sb+off+1:sb+off+Nv,1:deg) ;
sig2=y(sb+1:sb+Nv,1:deg) ;


for c=1:deg
	ind=find(isnan(sig(:,c)));
	if length(ind)>0
		sig(ind,c)=nanmean(sig(:,c));
	end
	ind=find(isnan(sig2(:,c)));
	if length(ind)>0
		sig2(ind,c)=nanmean(sig2(:,c));
	end
end


%demean.  Isn't this cute with detrend.
if demn==1
sig=detrend(sig,0);
sig2=detrend(sig2,0);
end
%detrend
if detrnd ==1 
sig=detrend(sig);
sig2=detrend(sig2);
end
%window, normalized st mean(wind^2) = 1
if taper==1
wind=hanning(Nv)/.3752*ones(1,deg);
sig=sig.*wind;
sig2=sig2.*wind;
end

%compute spectra and cross sprectrum
% ss=(abs(fft(  sig )).^2)/Nv^2/dk;
SS = fft(sig);
ss = SS.*conj(SS)/Nv^2/dk;
ss=fftshift(ss);

% ss2=(abs(fft( sig2  )).^2)/Nv^2/dk;
SS2 = fft(sig2);
ss2 = SS2.*conj(SS2)./Nv^2/dk;
ss2=fftshift(ss2);

% cross spectra
cs=( fft( sig ).*conj(fft(sig2)) )/Nv^2/dk;
cs=fftshift(cs);
% coherence, phase
% coh=abs(cs)./sqrt(ss)./sqrt(ss2);
coh = abs(sum(cs, 2)).^2./sum(ss,2)./sum(ss2,2);
ph=atan2(imag(cs),real(cs));

%use zero, nyquist as defaults
if ~exist('kmin', 'var')
kmin=0;
end
if ~exist('kmax', 'var')
kmax=max(abs(k));
end

if ~exist('fg')
	fg=1;
end
if fg ~= 0
   figure(fg)
   subplot(2,1,1)
   plot(k(Nv/2+1:Nv),coh(Nv/2+1:Nv).^2, 'r-')
   xlabel('k (cpm)')
   ylabel('coherence squared')
   title('Coherence squared')
   grid
   axis([kmin kmax 0 1])
   subplot(2,1,2)
   plot(k(Nv/2+1:Nv),ph(Nv/2+1:Nv)/pi*180)
   xlabel('k (cpm)')
   ylabel('degrees')
   title('Phase')
   grid
   axis([kmin kmax -180 180])
end


