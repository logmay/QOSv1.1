% tomography and randomized bnenchmarking
%%
q = 'q9';
setQSettings('r_avg',10000,q);
state = '|1>';
data = Tomo_1QState('qubit',q,'state',state,'gui',true,'save',true);
% rho = sqc.qfcns.stateTomoData2Rho(data);
% h = figure();bar3(real(rho));h = figure();bar3(imag(rho));
%%
q = 'q7';
setQSettings('r_avg',5000,q);
process = 'X/2';
data = Tomo_1QProcess_animation('qubit',q,'process',process,'numPts',50,'notes','','save',true);
%%
gate = 'Z';
data = Tomo_1QProcess('qubit','q8','process',gate,'gui',true);
%% 
setQSettings('r_avg',5000,'q7');
setQSettings('r_avg',5000,'q8');
CZTomoData = Tomo_2QProcess('qubit1','q7','qubit2','q8',...
       'process','CZ',...
       'notes','','gui',true,'save',true);
%%
setQSettings('r_avg',10000,'q8');
setQSettings('r_avg',10000,'q9');
twoQStateTomoData = Tomo_2QState('qubit1','q8','qubit2','q9',...
  'state','|11>',...
 'notes','','gui',true,'save',true);
%%
qubits = {'q7','q8','q9'};
setQSettings('r_avg',10000,qubits);
twoQStateTomoData = Tomo_mQState('qubits',qubits,...
  'state','1',...
 'notes','','gui',true,'save',true);
%%
q = 'q8';
setQSettings('r_avg',500,q);
numGates = int16(unique(round(logspace(0,log10(100),5))));
[Pref,Pi] = randBenchMarking('qubit1',q,'qubit2',[],...
       'process','X','numGates',numGates,'numReps',60,...
       'gui',true,'save',true);
%% two qubit gate benchmarking
setQSettings('r_avg',3000,'q7');
setQSettings('r_avg',3000,'q8');
numGates = 1:1:10;
[Pref,Pi] = randBenchMarking('qubit1','q7','qubit2','q8',...
       'process','CZ','numGates',numGates,'numReps',70,...
       'gui',true,'save',true);
%%