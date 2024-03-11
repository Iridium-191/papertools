function [output,I]=sortatoms(input,type)
        output.celldim=input.celldim;
    if type=='x'
        sortby=input.coord(:,1);
        sortarget=input.coord;
        [~,I]=sort(sortby);
        xtmp=sortarget(:,1);
        ytmp=sortarget(:,2);
        ztmp=sortarget(:,3);
        sortarget(:,1)=xtmp(I);
        sortarget(:,2)=ytmp(I);
        sortarget(:,3)=ztmp(I);
        typetmp=input.type(I);
        output.coord=sortarget;
        output.type=typetmp;
    elseif type=='y'
        sortby=input.coord(:,2);
        sortarget=input.coord;
        [~,I]=sort(sortby);
        xtmp=sortarget(:,1);
        ytmp=sortarget(:,2);
        ztmp=sortarget(:,3);
        sortarget(:,1)=xtmp(I);
        sortarget(:,2)=ytmp(I);
        sortarget(:,3)=ztmp(I);
        typetmp=input.type(I);
        output.coord=sortarget;
        output.type=typetmp;
    elseif type=='z'
        sortby=input.coord(:,3);
        sortarget=input.coord;
        [~,I]=sort(sortby);
        xtmp=sortarget(:,1);
        ytmp=sortarget(:,2);
        ztmp=sortarget(:,3);
        sortarget(:,1)=xtmp(I);
        sortarget(:,2)=ytmp(I);
        sortarget(:,3)=ztmp(I);
        typetmp=input.type(I);
        output.coord=sortarget;
        output.type=typetmp;
    elseif type=='atomtype'
        df=unique(input.type);
        coordtemp=[];
        typetemp=[];
        for i=1:length(df)
            ccw=find(input.type==df(i));
            typetemp=[typetemp,input.type(ccw)];
            coordtemp=[coordtemp;input.coord(ccw,:)];
        end
        output.type=typetemp;
        output.coord=coordtemp;
    end
end