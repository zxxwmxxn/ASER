clc;
clear;
warning('off');

%%%%%%%%%%%% You can choose one of the synthetic datasets for testing %%%%%%%%%%
DataName = "Two Moon";
load 'data'\'Two Moon.mat'

% DataName = "Spheres";
% load 'data'\'Spheres.mat'

%%%%%%%%%%%% Experimental Setup %%%%%%%%%%
X = double(X);
X = zscore(X);
[data_n,d] = size(X);
c = length(unique(gnd)); % c is the number of classes.
if ismember(DataName, {'Two Moon'})
    m = 32; % m is the number of anchors.
    k = 3; % k is the number of nearest neighbors.
elseif ismember(DataName, { 'Spheres'})
    m = 16;
    k=8;
end

%%%%%%%%%%%%%% 1.Generate anchors by BKBK %%%%%%%%%%%%%%%%%%
tic;
[~,locAnchor] = hKM(X',[1:data_n],log2(m),1);
V_Anchor = locAnchor';
Sel_Anchor_Time = toc;
Anchor_method_name = "BKHK";
clear locAnchor;
[anchor_n,anchor_d] = size(V_Anchor);

%%%%%%%%%%%  2.Construct the anchor graph by AGC %%%%%%%%%%%%%%%%%%%%
tic;
AnchorGraph = ConstructA_NP(X',(V_Anchor'),k);
Con_AnchorGraph_Time = toc;
AnchorGraph_name = "PCAN";

%%%%%%%%%%%%%% 3.Compute the spectral embedding representation of the anchors %%%%%%%%%%%%%%%%%%%%%%
tic;
[W, ~] = selftuning(V_Anchor,k);
W_name = "selftuning";
D=diag(sum(W,2));
L=D-W;
L_norm=D^(-1/2)*L*D^(-1/2);
[F, ~]=eigs(L_norm,c,'SM');
Cal_F_Time = toc;
clear W D L L_norm;

%%%%%%%%%%%%%  4.Learning Spectrum of the original data and Clustering  %%%%%%%%%%%%%%%%%%%%%%%%%%
tic;
X_F = AnchorGraph * F;
our_label=kmeans(X_F,c,'MaxIter',100,'Replicates',10);
result_time = toc;
clear X_F;

%%%%%%%%%%%%%  5.Results presentation  %%%%%%%%%%%%%%%%%%%%%%%%%%
OurResult=  Clustering8Measure(our_label,gnd);
OurTime = Sel_Anchor_Time+Con_AnchorGraph_Time+Cal_F_Time+result_time;
fprintf("%s: ACC=%.4f,NMI=%.4f,Fscore=%.4f,time=%.4f,\n",DataName,OurResult(1),OurResult(2),OurResult(4),OurTime);
