%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%% Install NAOMi Simulation  %%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% This script adds all the necessary subfolders etc. to run the NAOMi
% simulation. 
%
%
% 2019 - Adam Charles & Alex Song

% modified by YZ. last update: 9/28/2021.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%

currentFolder = pwd; % Get base folder

if ~isfile([currentFolder,'/NAOMi1p/MEX/array_SubMod.mexa64'])||...
           ~isfile([currentFolder,'/NAOMi1p/MEX/array_SubModTest.mexa64'])||...
               ~isfile([currentFolder,'/NAOMi1p/MEX/array_SubSub.mexa64'])||...
           ~isfile([currentFolder,'/NAOMi1p/MEX/array_SubSubTest.mexa64'])||...
      ~isfile([currentFolder,'/NAOMi1p/MEX/dendrite_dijkstra_cpp.mexa64'])||...
           ~isfile([currentFolder,'/NAOMi1p/MEX/dendrite_randomwalk_cpp.mexa64'])
    mex_compiling;                                                         % Compile all MEX functions
end

addpath(genpath([currentFolder,'/NAOMi1p/MEX']));                                  % Add folder for MEX files
addpath(genpath([currentFolder,'/NAOMi1p/MiscCode']));                             % Add folder for Misc files
addpath(genpath([currentFolder,'/NAOMi1p/OpticsCode']));                           % Add folder for Optics simulation files
addpath(genpath([currentFolder,'/NAOMi1p/TimeTraceCode']));                        % Add folder for Time-trace simulation files
addpath(genpath([currentFolder,'/NAOMi1p/VolumeCode']));                           % Add folder for Neural volume simulation files
addpath(genpath([currentFolder,'/NAOMi1p/ScanningCode']));                         % Add folder for Scanning simulation files
addpath(genpath([currentFolder,'/NAOMi1p/AnalysisAndPlotting']));                  % Add folder for various analysis scripts
addpath(genpath([currentFolder,'/NAOMi1p/ExternalPackages']));                     % Add folder for external packages
addpath(genpath([currentFolder,'/NAOMi1p/config']));       
cd(currentFolder);                                                         % Return to the main folder
clear currentFolder ans

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

