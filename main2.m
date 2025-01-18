MatlabData=readtable("dataMatlab.txt");
RealData=readtable("Eclipse 2022 Feb-Apr.txt");
GMAT=readtable("GMAT result.txt");
a=char(RealData.Var3);
a2=char(RealData.Var4);
pp(1:size(a,1),:)=[' '];
RealStart=[a(:,9:10) a(:,5:7) a(:,5) a(:,1:4) pp a(:,12:19)];
RealFin=[a2(:,9:10) a2(:,5:7) a2(:,5) a2(:,1:4) pp a2(:,12:19)];
RealStart=datetime(RealStart,"InputFormat","dd/MM/uuuu HH:mm:ss");
RealFin=datetime(RealFin,"InputFormat","dd/MM/uuuu HH:mm:ss");
MatlabStart=MatlabData.Start; MatlabFin=MatlabData.Finish;
[y,m,d]=ymd(RealFin);
Date=datetime(y,m,d);
Date(134,:)=datetime(2022,04,13);
Date(4:5,:)=[];
%% nyari beda waktu
StartDiff(1,:)=duration('24:00:00');
FinDiff(1,:)=duration('24:00:00');
Stat(1,:)='NoEcl   ';
StartDiff(2,:)=RealStart(2,:)-MatlabStart(1,:);
FinDiff(2,:)=RealFin(2,:)-MatlabFin(1,:);
Stat(2,:)='Penumbra';
StartDiff(3,:)=RealStart(3,:)-MatlabStart(2,:);
FinDiff(3,:)=RealFin(5,:)-MatlabFin(2,:);
Stat(3,:)='Penumbra';
for i=3:128
    StartDiff(i+1,:)=RealStart(i+3,:)-MatlabStart(i);
    FinDiff(i+1,:)=RealFin(i+3,:)-MatlabFin(i);
    if size(char(MatlabData.Event(i,:)),2)~=8
        sts=[char(MatlabData.Event(i,:)),'   '];
    else
        sts=char(MatlabData.Event(i,:));
    end
    Stat(i+1,:)=sts;
end
StartDiff(130,:)=RealStart(132,:)-MatlabStart(129,:);
FinDiff(130,:)=RealFin(132,:)-MatlabFin(131,:);
Stat(130,:)='Penumbra';
StartDiff(131,:)=RealStart(133,:)-MatlabStart(132,:);
FinDiff(131,:)=RealFin(133,:)-MatlabFin(132,:);
Stat(131,:)='Penumbra';
StartDiff(132,:)=duration('24:00:00');
FinDiff(132,:)=duration('24:00:00');
Stat(132,:)='NoEcl   ';

for i=1:134
kk=[num2str(GMAT.Var1(i)),'-',char(GMAT.Var2(i)),'-',num2str(GMAT.Var3(i)),' ',char(GMAT.Var4(i))];
kl=[num2str(GMAT.Var5(i)),'-',char(GMAT.Var6(i)),'-',num2str(GMAT.Var7(i)),' ',char(GMAT.Var8(i))];
GMATStart(i,:)=datetime(kk);
GMATFin(i,:)=datetime(kl);
end

%% start dan end eclipse tiap hari
%matlab
EclStart_matlab(1:2,:)=MatlabStart(1:2,:);
EclFin_matlab(1:2,:)=MatlabFin(1:2,:);
for i=1:132/3
EclStart_matlab(i+2,:)=MatlabStart(3*i,:);
if i<43
EclFin_matlab(i+2,:)=MatlabFin(3*i+2,:);
end
end
EclStart_matlab(47,:)=MatlabStart(133,:);
EclFin_matlab(46:47,:)=MatlabFin(132:133,:);

%GMAT
EclStart_gmat(1,:)=GMATStart(1,:);
EclFin_gmat(1,:)=GMATFin(1,:);
for i=1:44
EclStart_gmat(i+1,:)=GMATStart(3*i-1,:);
EclFin_gmat(i+1,:)=GMATFin(3*i+1,:);
end
EclStart_gmat(46,:)=GMATStart(134,:);
EclFin_gmat(46,:)=GMATFin(134,:);

%real
EclStart_real(1:2,:)=RealStart(1:2,:);
EclFin_real(1:2,:)=RealFin(1:2,:);
for i=1:43
EclStart_real(i+2,:)=RealStart(i*3,:);
EclFin_real(i+2,:)=RealFin(i*3+2,:);
end
EclStart_real(46:47,:)=RealStart(132:133,:);
EclFin_real(46:47,:)=RealFin(132:133,:);

%% plot waktu mulai eclipse(?)
%matlab
mtlb=[EclStart_matlab EclFin_matlab];
[ym,mm,dm]=ymd(mtlb);
[hm,mim,sm]=hms(mtlb);
matlabdate=datetime(ym,mm,dm);
matlabecls=duration(hm,mim,sm);

%gmat
gmt=[EclStart_gmat EclFin_gmat];
[yg,mg,dg]=ymd(gmt);
[hg,mig,sg]=hms(gmt);
gmatdate=datetime(yg,mg,dg);
gmatecls=duration(hg,mig,sg);

%real
riil=[EclStart_real EclFin_real];
[yr,mr,dr]=ymd(riil);
[hr,mir,sr]=hms(riil);
realdate=datetime(yr,mr,dr);
realecls=duration(hr,mir,sr);

%plot start eclipse
figure(1)
hold on
plot(matlabdate(:,1),matlabecls(:,1))
plot(gmatdate(:,1),gmatecls(:,1))
plot(realdate(:,1),realecls(:,1))
hold off
grid on
xlabel('Date');ylabel('Eclipse Start')
legend('Matlab','GMAT','Real')
title('Eclipse Start Over Time')

figure(2)
hold on
plot(matlabdate(:,1),matlabecls(:,2))
plot(gmatdate(:,1),gmatecls(:,2))
plot(realdate(:,1),realecls(:,2))
hold off
grid on
xlabel('Date');ylabel('Eclipse Finish')
legend('Matlab','GMAT','Real')
title('Eclipse Finish Over Time')

%% UMBRA test
%matlab
for i=1:43
umbra_matlab(i,:)=[MatlabStart(3*i+1,:) MatlabFin(3*i+1,:)];
end
%gmat
for i=1:44
umbra_gmat(i,:)=[GMATStart(3*i,:) GMATFin(3*i,:)];
end
%real
for i=1:43
umbra_real(i,:)=[RealStart(3*i+1,:) RealFin(3*i+1,:)];
end

%% plot umbra
%matlab
[yum,mum,dum]=ymd(umbra_matlab);
[hum,mium,sum]=hms(umbra_matlab);
umbrdate_mtlb=datetime(yum,mum,dum);
umbrtime_mtlb=duration(hum,mium,sum);
%gmat
[yum,mum,dum]=ymd(umbra_gmat);
[hum,mium,sum]=hms(umbra_gmat);
umbrdate_gmat=datetime(yum,mum,dum);
umbrtime_gmat=duration(hum,mium,sum);
%real
[yum,mum,dum]=ymd(umbra_real);
[hum,mium,sum]=hms(umbra_real);
umbrdate_real=datetime(yum,mum,dum);
umbrtime_real=duration(hum,mium,sum);

%% plot ultimate
figure
hold on
plot(matlabdate(:,1),matlabecls(:,1),'r')
plot(gmatdate(:,1),gmatecls(:,1),'g')
plot(realdate(:,1),realecls(:,1),'b')
plot(matlabdate(:,1),matlabecls(:,2),'r')
plot(gmatdate(:,1),gmatecls(:,2),'g')
plot(realdate(:,1),realecls(:,2),'b')
plot(umbrdate_mtlb(:,1),umbrtime_mtlb(:,1),'r')
plot(umbrdate_gmat(:,1),umbrtime_gmat(:,1),'g')
plot(umbrdate_real(:,1),umbrtime_real(:,1),'b')
plot(umbrdate_mtlb(:,1),umbrtime_mtlb(:,2),'r')
plot(umbrdate_gmat(:,1),umbrtime_gmat(:,2),'g')
plot(umbrdate_real(:,1),umbrtime_real(:,2),'b')
hold off
grid on
xlabel('Date');ylabel('Eclipse Time')
legend('Matlab','GMAT','Real')
title('Eclipse Start and Finish Over Time')
%%
degdiff=[minutes(StartDiff(2:131)) minutes(FinDiff(2:131))]./4;
TimeDiff=table(Date,Stat,StartDiff,FinDiff);