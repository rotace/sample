% main.m

a.org=[0,0];
b.org=[20,20];

a.dif=[1,1];
b.dif=[1,1];

a.itrx=2;
a.itry=3;
b.itrx=4;
b.itry=5;

pax=zeros(a.itrx,a.itry);
pay=zeros(a.itrx,a.itry);
pbx=zeros(b.itrx,b.itry);
pby=zeros(b.itrx,b.itry);
res=zeros(a.itrx,a.itry,b.itrx,b.itry);

for iax=1:a.itrx
    for iay=1:a.itry
	for ibx=1:b.itrx
	    for iby=1:b.itry
		
		va=a.org+a.dif.*[iax,iay];
		vb=b.org+b.dif.*[ibx,iby];
		pax(iax,iay)=va(1);
		pay(iax,iay)=va(2);
		pbx(ibx,iby)=vb(1);
		pby(ibx,iby)=vb(2);


		tmp=true;

		if abs(va)<3
		  tmp=false;
		end

		if abs(vb)>22
		  tmp=false;
		end

		res(iax,iay,ibx,iby)=tmp;
		
	    end
	end
    end
end

pax=reshape(pax,[a.itrx*a.itry,1]);
pay=reshape(pay,[a.itrx*a.itry,1]);
nsola=zeros(a.itrx,a.itry);
for iax=1:a.itrx
    for iay=1:a.itry
      nsola(iax,iay)=sum(sum(res(iax,iay,:,:)));
    end
end
nsola=reshape(nsola,[a.itrx*a.itry,1]);

pbx=reshape(pbx,[b.itrx*b.itry,1]);
pby=reshape(pby,[b.itrx*b.itry,1]);
nsolb=zeros(b.itrx,b.itry);
for ibx=1:b.itrx
    for iby=1:b.itry
      nsolb(ibx,iby)=sum(sum(res(:,:,ibx,iby)));
    end
end
nsolb=reshape(nsolb,[b.itrx*b.itry,1]);

scatter([pax;pbx],[pay;pby],[],[nsola;nsolb].*[255,0,0]./max([nsola;nsolb]));

res=permute(res,[1,3,2,4]);
res=reshape(res,[a.itrx*b.itrx,a.itry*b.itry]);
figure;
spygray(res)



