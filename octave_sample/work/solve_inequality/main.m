% main.m

a.org=[0,0,0];
b.org=[20,20,0];

a.dif=[1,1,0];
b.dif=[1,1,0];

a.itrx=4;
a.itry=4;
b.itrx=4;
b.itry=4;

pax=zeros(a.itrx,a.itry,b.itrx,b.itry);
pay=zeros(a.itrx,a.itry,b.itrx,b.itry);
pbx=zeros(a.itrx,a.itry,b.itrx,b.itry);
pby=zeros(a.itrx,a.itry,b.itrx,b.itry);
res=zeros(a.itrx,a.itry,b.itrx,b.itry)==1;

for iax=1:a.itrx
    for iay=1:a.itry
	for ibx=1:b.itrx
	    for iby=1:b.itry
		
		va=a.org+a.dif.*[iax-1,iay-1,0];
		vb=b.org+b.dif.*[ibx-1,iby-1,0];

		tmp=true;

		if norm(va)<1.1
		  tmp=false;
		end

		if norm(vb)>30
		  tmp=false;
		end
		
		pax(iax,iay,ibx,iby)=va(1);
		pay(iax,iay,ibx,iby)=va(2);
		pbx(iax,iay,ibx,iby)=vb(1);
		pby(iax,iay,ibx,iby)=vb(2);
		res(iax,iay,ibx,iby)=tmp;
		
	    end
	end
    end
end

nsola=sum(sum(res,3),4);
nsolb=sum(sum(res,1),2);
x=[pax(:,:,1,1)(:);pbx(1,1,:,:)(:)];
y=[pay(:,:,1,1)(:);pby(1,1,:,:)(:)];
scale=[nsola(:);nsolb(:)].*[255]./max([nsola(:);nsolb(:)]);
scatter(x,y,scale/10+5,scale,'filled');


res=permute(res,[1,3,2,4]);
res=reshape(res,[a.itrx*b.itrx,a.itry*b.itry]);
res=res';

figure;
pcolor([res,zeros(a.itry*b.itry,1);zeros(1,a.itrx*b.itrx+1)]);
colorbar;
axis square;

figure;
res=flipud(res);
imagesc(res);
colorbar;
axis square;

data=[pax(res),pay(res),pbx(res),pby(res)];
plotmatrix(data);
