function [g,atom_num,frame_num,dt,cells,typp] = readtraj(filename,type)
%UNTITLED6 此处提供此函数的摘要
if type=="CP2K"
    str1=fileread(filename);
    lines=regexp(str1,'\r\n|\r|\n', 'split');
    theader=find(contains(lines,'time ='));
    atmp1=regexp(lines{theader(1)},'time =');
    atmp2=regexp(lines{theader(1)},',');
    strtmp=lines{theader(1)};
    t1=str2num(strtmp((atmp1+6):(atmp2(2)-1)));
    btmp1=regexp(lines{theader(2)},'time =');
    btmp2=regexp(lines{theader(2)},',');
    strtmp=lines{theader(2)};
    t2=str2num(strtmp((btmp1+6):(btmp2(2)-1)));
    dt=t2-t1;
    frame_num=length(theader);
    atom_num=theader(2)-theader(1)-2;
    g=zeros(atom_num,frame_num,3);
    cells=zeros(3,3);
    l=0;
    typp=cell(atom_num,1);
    for i=1:frame_num
        for n=1:atom_num+2
            l=l+1;
            if n<3
                continue
            else
                temp=lines{l};
                s=regexp(temp,'\s+','split');
                g(n-2,i,1)=str2double(s{3});
                g(n-2,i,2)=str2double(s{4});
                g(n-2,i,3)=str2double(s{5});
                if i==1
                    typp{n-2}=s{2};
                end
            end
        end
    end
elseif type=="LAMMPS"
    str1=fileread(filename);
    lines=regexp(str1,'\r\n|\r|\n', 'split');
    theader=find(contains(lines,'ITEM: TIMESTEP'));
    atom_num=str2num(lines{4});
    cells=zeros(3,2);
    cells(1,:)=str2num(lines{6});
    cells(2,:)=str2num(lines{7});
    cells(3,:)=str2num(lines{8});
    dt=str2num(lines{2})-str2num(lines{theader(2)+1});
    frame_num=length(theader);
    g=zeros(atom_num,frame_num,3);
    l=0;
    typp=zeros(atom_num,1);
    tmpp=zeros(atom_num,1);
    for n=1:atom_num+9
            l=l+1;
            if n<10
                continue
            else
                temp=lines{l};
                s=regexp(temp,'\s+','split');
                typp(n-9)=str2double(s{2});
                tmpp(n-9)=str2double(s{1});
            end
    end
    [~,ind]=sort(tmpp);
    typp=typp(ind);
    l=0;
    for i=1:frame_num
        tm=zeros(atom_num,1);
        gtm=zeros(atom_num,3);
        for n=1:atom_num+9
            l=l+1;
            if n<10
                continue
            else
                temp=lines{l};
                s=regexp(temp,'\s+','split');
                tm(n-9)=str2double(s{1});
                gtm(n-9,1)=str2double(s{3});
                gtm(n-9,2)=str2double(s{4});
                gtm(n-9,3)=str2double(s{5});
            end
        end
        [~,ind]=sort(tm);
        gtm=gtm(ind,:);
        g(:,i,:)=gtm;
    end
%% 将轨迹的离群值矫正
    for i=1:atom_num
        for j=1:3
            lll=squeeze(g(i,:,j));
            gmm=max(lll)-min(lll);
            if gmm<2
                continue;
            else
                if j==1
                    kk=length(lll(lll>(cells(1,1)+(cells(1,2)-cells(1,1))/2)));
                    if kk<(frame_num-kk)
                       lll(lll>(cells(1,1)+(cells(1,2)-cells(1,1))/2))=lll(lll>(cells(1,1)+(cells(1,2)-cells(1,1))/2))-(cells(1,2)-cells(1,1));
                    else
                        lll(lll<(cells(1,1)+(cells(1,2)-cells(1,1))/2))=lll(lll<(cells(1,1)+(cells(1,2)-cells(1,1))/2))+(cells(1,2)-cells(1,1));
                    end
                elseif j==2
                    kk=length(lll(lll>(cells(2,1)+(cells(2,2)-cells(2,1))/2)));
                    if kk<(frame_num-kk)
                       lll(lll>(cells(2,1)+(cells(2,2)-cells(2,1))/2))=lll(lll>(cells(2,1)+(cells(2,2)-cells(2,1))/2))-(cells(2,2)-cells(2,1));
                    else
                       lll(lll<(cells(2,1)+(cells(2,2)-cells(2,1))/2))=lll(lll<(cells(2,1)+(cells(2,2)-cells(2,1))/2))+(cells(2,2)-cells(2,1));
                    end
                elseif j==3
                    kk=length(lll(lll>(cells(3,1)+(cells(3,2)-cells(3,1))/2)));
                    if kk<(frame_num-kk)
                       lll(lll>(cells(3,1)+(cells(3,2)-cells(3,1))/2))=lll(lll>(cells(3,1)+(cells(3,2)-cells(3,1))/2))-(cells(3,2)-cells(3,1));
                    else
                       lll(lll<(cells(3,1)+(cells(3,2)-cells(3,1))/2))=lll(lll<(cells(3,1)+(cells(3,2)-cells(3,1))/2))+(cells(3,2)-cells(3,1));
                    end    
                end
            g(i,:,j)=lll;
            end
        end
    end
else
    error("Unknown file format!")
end
end