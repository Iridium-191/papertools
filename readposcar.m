function output=readposcar(POSCAR)
    S=readlines(POSCAR);
    output.celldim=[str2num(S(3));str2num(S(4));str2num(S(5))];
    cel=output.celldim;
    coord=zeros(length(S)-8-1,3);
    if S(8)=='Cartesian'
        for i=9:length(S)-1
            coord(i-8,:)=str2num(S(i));
        end
    else
        coordtemp=zeros(length(S)-8-1,3);
        for i=9:length(S)-1
            coordtemp(i-8,:)=str2num(S(i));
        end
        coord=cel(1,:).*coordtemp+cel(2,:).*coordtemp+cel(3,:).*coordtemp;
    end
    output.coord=coord;
    num=str2num(S(7));
    type=string(sum(num));
    typ=strsplit(S(6));
    flag=1;
    for i=1:length(num)
        for j=1:num(i)
            type(flag)=typ(i+1);
            flag=flag+1;
        end
    end
    output.type=type;
end