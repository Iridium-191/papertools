function colorlist= generatecolor(orig,style,num)
[m1,i1]=max(orig);
[m2,i2]=min(orig);
colorlist=zeros(num,3);
if m1==m2
    h=0;
elseif i1==1 && orig(2)>=orig(3)
    h=60*(orig(2)-orig(3))/(m1-m2);
elseif i1==1 && orig(2)<orig(3)
    h=60*(orig(2)-orig(3))/(m1-m2)+360;
elseif i1==2
    h=60*(orig(3)-orig(1))/(m1-m2)+120;
elseif i1==3
    h=60*(orig(1)-orig(2))/(m1-m2)+240;
end
l=0.5*(m1+m2);
if l==0 || m1==m2
    s=0;
elseif l>0 && l<=0.5
    s=(m1-m2)/(m1+m2);
elseif l>0.5 
    s=(m1-m2)/(2-(m1+m2));
end
if strcmp(style,'rand')
    for i=1:num
        %htemp=h+50*(i-1)+randi(10);
        htemp=h+(randi(90)-90)+10*i;
        htemp=mod(htemp,360);
        stemp=s+(rand-1)/10;
        if stemp<0
            stemp=stemp+1;
        end
        ltemp=l+(rand-1)/10;
        if ltemp<0
            ltemp=ltemp+1;
        end
        colorlist(i,1)=htemp;
        colorlist(i,2)=stemp;
        colorlist(i,3)=ltemp;
    end
elseif strcmp(style,'near')
    if l<=0.2
        lsq=linspace(0,0.5,num);
    elseif l>0.2 && l<=0.5
        lsq=linspace(-0.1,0.4,num);
    elseif l>0.5 && l<=0.8
        lsq=linspace(-0.4,0.1,num);
    else
        lsq=linspace(-0.5,0,num);
    end
    for i=1:num
        htemp=h+randi(10)-10;
        htemp=mod(htemp+360,360);
        stemp=s+(rand-1)/10;
        if stemp<0
            stemp=stemp+1;
        end
        ltemp=l+lsq(i);
        colorlist(i,1)=htemp;
        colorlist(i,2)=stemp;
        colorlist(i,3)=ltemp;
    end
elseif strcmp(style,'map_jet')
    hhf=linspace(0,240,num);
    for i=1:num
        htemp=h+hhf(i);
        stemp=s;
        if stemp<0
            stemp=stemp+1;
        end
        ltemp=l;
        if ltemp<0
            ltemp=ltemp+1;
        end
        colorlist(i,1)=htemp;
        colorlist(i,2)=stemp;
        colorlist(i,3)=ltemp;
    end
    if num<50
       colortemp=zeros(256,3);
       for i=1:num
           colortemp(:,1)=interp1(linspace(0,1,num),colorlist(:,1),linspace(0,1,256));
           colortemp(:,2)=interp1(linspace(0,1,num),colorlist(:,2),linspace(0,1,256));
           colortemp(:,3)=interp1(linspace(0,1,num),colorlist(:,3),linspace(0,1,256));
       end
       colorlist=colortemp;
    end
    colorlist(:,1)=mod(colorlist(:,1),360);
elseif strcmp(style,'map_sl')
    if l<=0.2
        lsq=linspace(0,0.5,num);
    elseif l>0.2 && l<=0.5
        lsq=linspace(-0.1,0.4,num);
    elseif l>0.5 && l<=0.8
        lsq=linspace(-0.4,0.1,num);
    else
        lsq=linspace(-0.5,0,num);
    end
    if s<=0.3
        ssq=zeros(num,1);
    elseif l>0.3 && l<=0.5
        ssq=linspace(0,0.2,num);
    elseif l>0.5 && l<=0.8
        ssq=linspace(-0.2,0.1,num);
    else
        ssq=linspace(-0.3,0,num);
    end
    for i=1:num
        htemp=h;
        htemp=mod(htemp+360,360);
        stemp=s+ssq(i);
        ltemp=l+lsq(i);
        colorlist(i,1)=htemp;
        colorlist(i,2)=stemp;
        colorlist(i,3)=ltemp;
    end
    if num<50
       colortemp=zeros(256,3);
       for i=1:num
           colortemp(:,1)=interp1(linspace(0,1,num),colorlist(:,1),linspace(0,1,256));
           colortemp(:,2)=interp1(linspace(0,1,num),colorlist(:,2),linspace(0,1,256));
           colortemp(:,3)=interp1(linspace(0,1,num),colorlist(:,3),linspace(0,1,256));
       end
       colorlist=colortemp;
    end
elseif strcmp(style,'map_pair')
    if num<10
        error('It seems that your color number is too few for generating colormap!')
    end
    if l<=0.5
        lsq=linspace(0,1-l,num/2);
    elseif l>0.5
        error('It seems that your color is too bright for generating this style!')
    end
    if mod(num,2)==0
        lsq=[lsq,flip(lsq)];
    else
        lsq=[lsq,1,flip(lsq)];
    end
    for i=1:num
        if i<num/2
           htemp=h;
        end
        if i>num/2
           htemp=mod(h+120,360);
        end
        stemp=s;
        ltemp=l+lsq(i);
        colorlist(i,1)=htemp;
        colorlist(i,2)=stemp;
        colorlist(i,3)=ltemp;
    end
    if num<50
       colortemp=zeros(256,3);
       for i=1:num
           colortemp(:,1)=interp1(linspace(0,1,num),colorlist(:,1),linspace(0,1,256));
           colortemp(:,2)=interp1(linspace(0,1,num),colorlist(:,2),linspace(0,1,256));
           colortemp(:,3)=interp1(linspace(0,1,num),colorlist(:,3),linspace(0,1,256));
       end
       colorlist=colortemp;
    end
end
[a,b]=size(colorlist);
colorr=zeros(a,b);
for i=1:a
    if colorlist(i,3)<0.5
        q=colorlist(i,3)*(colorlist(i,2)+1);
    else
        q=colorlist(i,3)+colorlist(i,2)-colorlist(i,3)*colorlist(i,2);
    end
    p=2*colorlist(i,3)-q;
    tr=colorlist(i,1)/360+1/3;
    tg=colorlist(i,1)/360;
    tb=colorlist(i,1)/360-1/3;
    if tr<0
        tr=tr+1;
    elseif tr>1
        tr=tr-1;
    end
    if tg<0
        tg=tg+1;
    elseif tg>1
        tg=tg-1;
    end
    if tb<0
        tb=tb+1;
    elseif tb>1
        tb=tb-1;
    end
    ic=[tr,tg,tb];
    for j=1:3
        if ic(j)<1/6
            colorr(i,j)=p+((q-p)*6*ic(j));
        elseif ic(j)>=1/6 && ic(j)<0.5
            colorr(i,j)=q;
        elseif ic(j)>=0.5 && ic(j)<2/3
            colorr(i,j)=p+((q-p)*6*(2/3-ic(j)));
        else
            colorr(i,j)=p;
        end
    end
end
figure;
colorr(colorr>1)=1;
colorlist=abs(colorr);
mapp=[];
if strcmp(style,'rand')
    [j1,j2]=find(colorlist==max(max(colorlist)));
    if j2==1
    [t,ii]=sort(colorlist(:,1));
    colorlist=colorlist(ii,:);
    elseif j2==2
    [t,ii]=sort(colorlist(:,2));
    colorlist=colorlist(ii,:);
    else
    [t,ii]=sort(colorlist(:,3));
    colorlist=colorlist(ii,:);
    end
end
if a<10
    for i=1:a
        mapp=[mapp,i*ones(20,20)];
    end
    imagesc(mapp)
    colormap(colorlist);
else
    for i=1:a
        mapp=[mapp,i*ones(a,5)];
    end
    imagesc(mapp)
    colormap(colorlist);
end
axis xy equal tight;
end