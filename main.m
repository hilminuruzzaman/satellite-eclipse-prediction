clear all

StateVec=readtable("State Vector.txt");
warning('off','all')
warning

Epoch_2022=2459580.5000000;

for i=1:size(StateVec,1)/6
    tanggalan(i)=juliandate(StateVec.Date(6*i));
end
x=0;
for i=1:size(StateVec,1)/6-1
    EpochInitial=tanggalan(i);
    sma=StateVec.Value((i-1)*6+1);
    ecc=StateVec.Value((i-1)*6+2);
    inc=deg2rad(StateVec.Value((i-1)*6+3));
    node=deg2rad(StateVec.Value((i-1)*6+4));
    aop=deg2rad(StateVec.Value((i-1)*6+5));
    Long=deg2rad(StateVec.Value(6*i));
    Epoch=EpochInitial;

    TA=Long2TA(sma,ecc,inc,node,aop,Long,EpochInitial,Epoch);
    [r,v]=Keplerian2State(sma,ecc,inc,node,aop,TA);
    dur=tanggalan(i+1)-tanggalan(i);
    
    [EclipseTable,Fraction,EclipseTableMoon,FractionMoon]=OneDayEclipseCheck2022(r,v,Epoch,dur);
    
    EclipseTable(size(EclipseTable,1),:)=[];
    if size(EclipseTable,1)>0
    for j=1:size(EclipseTable,1)
        x=x+1;
        t1=datetime(2022,1,1);
        delT=EclipseTable(j,1)-Epoch_2022;
        Time(x,:)=t1+delT;

        if EclipseTable(j,3)==0.5
            Status(x,:)='Penumbra';
        elseif EclipseTable(j,3)==1
            Status(x,:)='Umbra   ';
        else
            Status(x,:)='Full    ';
        end
    FractionTot(x,:)=Fraction(j,:);
    smolpp(x,:)=EclipseTable(j,1);
    bigpp(x,:)=EclipseTable(j,3);
    end
    
    Output=table(Time,FractionTot,Status);
    end
end

z=0;
RealOutput(1,:)=Output(1,:);
k=floor(smolpp).*bigpp;
for y=2:x-1
    if and(k(y)-k(y-1)==0,k(y)-k(y+1)==0)
    else
        z=z+1;
        RealOutput(z+1,:)=Output(y,:);
    end      
end
RealOutput(z+2,:)=Output(x,:);

for m=1:size(RealOutput,1)/2
    Num(m,:)=m;
    Event(m,:)=RealOutput.Status(2*m,:);
    Start(m,:)=RealOutput.Time(2*(m-1)+1,:);
    Finish(m,:)=RealOutput.Time(2*m,:);
    Object(m,:)='Earth';
    Duration(m,:)=Finish(m,:)-Start(m,:);
end
FinalForm=table(Num,Event,Start,Finish,Object,Duration);
writetable(FinalForm,'dataMatlab.txt');
%% dari sebelumnya


%{

if size(Fraction,1)>1
    Output=table(Time,Fraction,Status); 
    disp(['Ada gerhana akibat bumi waktu',string(Time(1,:)),'UTC'])
else
    disp('Seharian nggak gerhana akibat bumi')
end
%%
for k=1:size(EclipseTableMoon,1)
    t1=datetime(2023,1,1);
    delT=EclipseTableMoon(k,1)-Epoch_2022;
    TimeMoon(k,:)=t1+delT;
    if EclipseTableMoon(k,3)==0.5
        StatusMoon(k,:)='Penumbra';
    elseif EclipseTableMoon(k,3)==1
        StatusMoon(k,:)='Umbra   ';
    else
        StatusMoon(k,:)='Full    ';
    end
end
TimeMoon(k,:)=datetime(-4713,1,1);
if size(FractionMoon,1)>1
    OutputMoon=table(TimeMoon,FractionMoon,StatusMoon); 
    disp(['Ada gerhana akibat bulan waktu',string(TimeMoon(1,:)),'UTC'])
else
    disp('Seharian nggak gerhana akibat bulan')
end
%}