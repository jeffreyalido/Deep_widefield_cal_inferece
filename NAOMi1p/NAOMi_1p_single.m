clc, clear
close all

%% this file is used to generate NAOMi1p data
%  last update: 5/29/2022. YZ

%% add paths
run('installNAOMi1p.m')

%% load pre-defined data
% pre-defined configuration file for RUSH
% cm2v2_config
RUSH_ai148d_config

%% RUSH 148d config
FOV_sz = 1000;% FOV, um // in image space
nt = 200;  % frames
fn = 10; % frame rate
pavg = 5; %mW per mm^2. for noisy measurements


%% parser
vol_params.vol_sz(1) = FOV_sz;
vol_params.vol_sz(2) = FOV_sz;
spike_opts.nt = nt + 200;
spike_opts.dt = 1 / fn;
wdm_params.pavg = pavg;

%% vessel modulation
vessel_mod.flag = true; % true for enable vessel modulation.
vessel_mod.frate = fn; % frame rate
vessel_mod.vessel_dynamics = 2; % vessel dilation rate
vessel_mod.FOV_N = 2; % crop the whole FOV into patches for individual modulation
vessel_mod.max_dilate_amp = 10; % dilate amplitude
vessel_mod.seed = 10; 
%% output path
output_dir = sprintf('H:/ccaragon/naomi/data/%s', ...
                                             spike_opts.rate)
% % make sub folders
buf = true;
id = 1;
while buf
    if exist(sprintf('%s\\%d', output_dir, id), 'dir') == 7
        id = id +1;
    else
        buf = false;
    end
    
end
output_dir = sprintf('%s\\%d', output_dir, id);
mkdir(output_dir)
%% generate volume

[vol_out,vol_params,neur_params,vasc_params,dend_params,bg_params, ...
    axon_params] = simulate_neural_volume(vol_params, neur_params, ...
            vasc_params, dend_params, bg_params, axon_params, psf_params); % Draw a random volume - this takes the longest amound of time
        
% assign all targets with fluroescences
spike_opts.K = size(vol_out.gp_vals,1); % Read off the number of neurons              
        
fprintf('Simulated neural volume in %f seconds.\n', toc);
save(sprintf('%s\\vol_out.mat', output_dir), 'vol_out', '-v7.3')
save(sprintf('%s\\prams.mat', output_dir), 'vol_params', 'neur_params', 'vasc_params', 'dend_params', 'bg_params', 'axon_params');
%% save necessary volumes
neur_vol = vol_out.neur_vol;
saveastiff(im2uint16(neur_vol / max(neur_vol(:))), sprintf('%s\\neur_vol.tiff', output_dir));

neur_ves = vol_out.neur_ves_all;
saveastiff(im2uint16(neur_ves / max(neur_ves(:))), sprintf('%s\\neur_ves_all.tiff', output_dir));
%% generate PSFs
tic
PSF_struct.psf = psf_params.psf; % Create the point-spread function and mask for scanning
fprintf('Simulated optical propagation in %f seconds.\n', toc); 
save(sprintf('%s\\PSF_struct.mat', output_dir), 'PSF_struct')
%% save necessary PSF files
% saveastiff(im2uint16(PSF_struct.psf / max(PSF_struct.psf, [], 'all')), sprintf('%s\\psf.tiff', output_dir))
% saveastiff(im2uint16(PSF_struct.mask / max(PSF_struct.mask, [], 'all')), sprintf('%s\\psf_mask.tiff', output_dir))
% saveastiff(im2uint16(PSF_struct.colmask / max(PSF_struct.colmask, [], 'all')), sprintf('%s\\psf_colmask.tiff', output_dir))
% saveastiff(im2uint16(PSF_struct.psfB.mask / max(PSF_struct.psfB.mask, [], 'all')), sprintf('%s\\psfB_mask.tiff', output_dir))
% saveastiff(im2uint16(PSF_struct.psfT.mask/ max(PSF_struct.psfT.mask, [], 'all')), sprintf('%s\\psfT_colmask.tiff', output_dir))

%% generate neurons
tic
% [neur_act,spikes] = generateTimeTraces(spike_opts,[],vol_out.locs);        % Generate time traces using AR-2 process
fun_time_trace_generation(vol_out, nt, fn, output_dir)
spike_opts = importdata(sprintf('%s\\firing_rate_%g_smod_flag_other\\spikes_opts.mat', output_dir, spike_opts.rate));
neur_act = importdata(sprintf('%s\\firing_rate_%g_smod_flag_other\\S.mat', output_dir, spike_opts.rate));

fprintf('Simulated temporal activity in %f seconds.\n', toc); 
%% plot traces
figure('position', [100, 100, 400, 800]), imagesc(neur_act.soma(:, : )),  title('soma'), colormap(othercolor('BuGn7'))
saveas(gcf, sprintf('%s\\soma_heat.jpg', output_dir)), close
figure('position', [100, 100, 400, 800]), imagesc(neur_act.bg(:, : )),  title('bg'), colormap(othercolor('BuGn7'))
saveas(gcf, sprintf('%s\\bg_heat.jpg', output_dir)), close
figure('position', [100, 100, 400, 800]), imagesc(neur_act.dend(:, : )), title('dendrites'), colormap(othercolor('BuGn7'))
saveas(gcf, sprintf('%s\\dend_heat.jpg', output_dir)), close

%% peform imaging    
% vol_out = importdata(sprintf('%s\\vol_out.mat', output_dir));
% PSF_struct = importdata(sprintf('%s\\PSF_struct.mat',output_dir));  
tic
parfor ii = 1 : 9
	scan_volume_1p(vol_out, PSF_struct, neur_act, ...
                       vol_params, scan_params, noise_params, spike_opts, wdm_params, vessel_mod, pixel_size, exp_level, output_dir,ii); % Perform the scanning simulation
end
fprintf('Simulated recordings in %f seconds.\n', toc); 


