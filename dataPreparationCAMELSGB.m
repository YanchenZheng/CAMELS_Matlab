%% Data preparation for CAMELS-GB data:
%   - eate struct file with CAMELS-GB time series and attributes
%   - Uses local paths (large CAMELS-GB files)
%   - Uses PET without interception correction
%
%   ---
%
%   Sebastian Gnann, sebastian.gnann@bristol.ac.uk (2020)

% clc
% clear all
% close all

%% add directories for functions to path

%% load CAMELS data

% Before you can run the code you need to extract CAMELS data and store
% them in the correct folder. The following folders/files are required:
%   \CAMELS_GB
%   	\timeseries
%       \CAMELS_GB_climatic_attributes
%       \CAMELS_GB_humaninfluence_attributes
%       \CAMELS_GB_hydrogeology_attributes
%       \CAMELS_GB_hydrologic_attributes
%       \CAMELS_GB_hydrometry_attributes
%       \CAMELS_GB_landcover_attributes
%       \CAMELS_GB_soil_attributes
%       \CAMELS_GB_topographic_attributes

disp('This function uses local paths. Change to local path where CAMELS-GB data are stored.')

path_time_series = "C:\Users\sg16200\Local Documents\CAMELS_GB\timeseries\"; % change to your local path
path_catchment_attributes = "C:\Users\sg16200\Local Documents\CAMELS_GB\"; % change to your local path

if ~exist(path_time_series) == 7
    error('Cannot find local path. You can download CAMELS-GB from https://catalogue.ceh.ac.uk/documents/8344e4f3-d2ea-44f5-8afa-86d2987543a9.')
end

%% load catchment attributes
% load data from files

% topography
% gauge_id	gauge_name	gauge_lat	gauge_lon	gauge_easting	gauge_northing	gauge_elev	area	dpsbar	elev_mean	elev_min	elev_10	elev_50	elev_90	elev_max
[camels_GB_topo_data,camels_GB_topo_data_str] = ...
    xlsread(strcat(path_catchment_attributes,'CAMELS_GB_topographic_attributes.csv'));

% climatic indices
% gauge_id	p_mean	pet_mean	aridity	p_seasonality	frac_snow	high_prec_freq	high_prec_dur	high_prec_timing	low_prec_freq	low_prec_dur	low_prec_timing
[camels_GB_climate_data,camels_GB_climate_data_str] = ...
    xlsread(strcat(path_catchment_attributes,'CAMELS_GB_climatic_attributes.csv'));

% hydrology
% gauge_id	q_mean	runoff_ratio	stream_elas	slope_fdc	baseflow_index	baseflow_index_ceh	hfd_mean	Q5	Q95	high_q_freq	high_q_dur	low_q_freq	low_q_dur	zero_q_freq
[camels_GB_hydro_data,camels_GB_hydro_data_str] = ...
    xlsread(strcat(path_catchment_attributes,'CAMELS_GB_hydrologic_attributes.csv'));

% land cover
% gauge_id	dwood_perc	ewood_perc	grass_perc	shrub_perc	crop_perc	urban_perc	inwater_perc	bares_perc	dom_land_cover
[camels_GB_land_data,camels_GB_land_data_str] = ...
    xlsread(strcat(path_catchment_attributes,'CAMELS_GB_landcover_attributes.csv'));

% soils
% gauge_id	sand_perc	sand_perc_missing	silt_perc	silt_perc_missing	clay_perc	clay_perc_missing	organic_perc	organic_perc_missing	bulkdens	bulkdens_missing	bulkdens_5	bulkdens_50	bulkdens_95	tawc	tawc_missing	tawc_5	tawc_50	tawc_95	porosity_cosby	porosity_cosby_missing	porosity_cosby_5	porosity_cosby_50	porosity_cosby_95	porosity_hypres	porosity_hypres_missing	porosity_hypres_5	porosity_hypres_50	porosity_hypres_95	conductivity_cosby	conductivity_cosby_missing	conductivity_cosby_5	conductivity_cosby_50	conductivity_cosby_95	conductivity_hypres	conductivity_hypres_missing	conductivity_hypres_5	conductivity_hypres_50	conductivity_hypres_95	root_depth	root_depth_missing	root_depth_5	root_depth_50	root_depth_95	soil_depth_pelletier	soil_depth_pelletier_missing	soil_depth_pelletier_5	soil_depth_pelletier_50	soil_depth_pelletier_95
[camels_GB_soil_data,camels_GB_soil_data_str] = ...
    xlsread(strcat(path_catchment_attributes,'CAMELS_GB_soil_attributes.csv'));

% hydrogeology
% gauge_id	inter_high_perc	inter_mod_perc	inter_low_perc	frac_high_perc	frac_mod_perc	frac_low_perc	no_gw_perc	low_nsig_perc	nsig_low_perc
[camels_GB_geology_data,camels_GB_geology_data_str] = ...
    xlsread(strcat(path_catchment_attributes,'CAMELS_GB_hydrogeology_attributes.csv'));

% hydrometry data
% gauge_id	station_type	flow_period_start	flow_period_end	flow_perc_complete	bankfull_flow	structurefull_flow	q5_uncert_upper	q5_uncert_lower	q25_uncert_upper	q25_uncert_lower	q50_uncert_upper	q50_uncert_lower	q75_uncert_upper	q75_uncert_lower	q95_uncert_upper	q95_uncert_lower	q99_uncert_upper	q99_uncert_lower	quncert_meta
[camels_GB_hydrometry_data,camels_GB_hydrometry_data_str] = ...
    xlsread(strcat(path_catchment_attributes,'CAMELS_GB_hydrometry_attributes.csv'));

% human influences
% gauge_id	benchmark_catch	surfacewater_abs	groundwater_abs	discharges	abs_agriculture_perc	abs_amenities_perc	abs_energy_perc	abs_environmental_perc	abs_industry_perc	abs_watersupply_perc	num_reservoir	reservoir_cap	reservoir_he	reservoir_nav	reservoir_drain	reservoir_wr	reservoir_fs	reservoir_env	reservoir_nousedata	reservoir_year_first	reservoir_year_last
[camels_GB_human_data,camels_GB_human_data_str] = ...
    xlsread(strcat(path_catchment_attributes,'CAMELS_GB_humaninfluence_attributes.csv'));

%% extract data from matrices

% topography
gauge_id = camels_GB_topo_data(:,1);
gauge_name = camels_GB_topo_data_str(2:end,2); %
gauge_lat = camels_GB_topo_data(:,3);
gauge_lon = camels_GB_topo_data(:,4);
gauge_easting = camels_GB_topo_data(:,5);
gauge_northing = camels_GB_topo_data(:,6);
gauge_elev = camels_GB_topo_data(:,7);
area = camels_GB_topo_data(:,8);
dpsbar = camels_GB_topo_data(:,9);
elev_mean = camels_GB_topo_data(:,10);
elev_min = camels_GB_topo_data(:,11);
elev_10 = camels_GB_topo_data(:,12);
elev_50 = camels_GB_topo_data(:,13);
elev_90 = camels_GB_topo_data(:,14);
elev_max = camels_GB_topo_data(:,15);

% climatic indices
p_mean = camels_GB_climate_data(:,2);
pet_mean = camels_GB_climate_data(:,3);
aridity = camels_GB_climate_data(:,4);
p_seasonality = camels_GB_climate_data(:,5);
frac_snow = camels_GB_climate_data(:,6);
high_prec_freq = camels_GB_climate_data(:,7);
high_prec_dur = camels_GB_climate_data(:,8);
high_prec_timing = camels_GB_climate_data_str(2:end,9);
low_prec_freq = camels_GB_climate_data(:,10);
low_prec_dur = camels_GB_climate_data(:,11);
low_prec_timing = camels_GB_climate_data_str(2:end,12);

% hydrological signatures
q_mean = camels_GB_hydro_data(:,2);
runoff_ratio = camels_GB_hydro_data(:,3);
stream_elas = camels_GB_hydro_data(:,4);
slope_fdc = camels_GB_hydro_data(:,5);
baseflow_index = camels_GB_hydro_data(:,6);
baseflow_index_ceh = camels_GB_hydro_data(:,7);
hfd_mean = camels_GB_hydro_data(:,8);
q5 = camels_GB_hydro_data(:,9);
q95 = camels_GB_hydro_data(:,10);
high_q_freq = camels_GB_hydro_data(:,11);
high_q_dur = camels_GB_hydro_data(:,12);
low_q_freq = camels_GB_hydro_data(:,13);
low_q_dur = camels_GB_hydro_data(:,14);
zero_q_freq = camels_GB_hydro_data(:,15);

% land cover
dwood_perc = camels_GB_land_data(:,2);
ewood_perc = camels_GB_land_data(:,3);
grass_perc = camels_GB_land_data(:,4);
shrub_perc = camels_GB_land_data(:,5);
crop_perc = camels_GB_land_data(:,6);
urban_perc = camels_GB_land_data(:,7);
inwater_perc = camels_GB_land_data(:,8);
bares_perc = camels_GB_land_data(:,9);
dom_land_cover = camels_GB_land_data_str(2:end,10);

% soils
sand_perc = camels_GB_soil_data(:,2);
sand_perc_missing = camels_GB_soil_data(:,3);
silt_perc = camels_GB_soil_data(:,4);
silt_perc_missing = camels_GB_soil_data(:,5);
clay_perc = camels_GB_soil_data(:,6);
clay_perc_missing = camels_GB_soil_data(:,7);
organic_perc = camels_GB_soil_data(:,8);
organic_perc_missing = camels_GB_soil_data(:,9);
bulkdens = camels_GB_soil_data(:,10);
bulkdens_missing = camels_GB_soil_data(:,11);
bulkdens_5 = camels_GB_soil_data(:,12);
bulkdens_50 = camels_GB_soil_data(:,13);
bulkdens_95 = camels_GB_soil_data(:,14);
tawc = camels_GB_soil_data(:,15);
tawc_missing = camels_GB_soil_data(:,16);
tawc_5 = camels_GB_soil_data(:,17);
tawc_50 = camels_GB_soil_data(:,18);
tawc_95 = camels_GB_soil_data(:,19);
porosity_cosby = camels_GB_soil_data(:,20);
porosity_cosby_missing = camels_GB_soil_data(:,21);
porosity_cosby_5 = camels_GB_soil_data(:,22);
porosity_cosby_50 = camels_GB_soil_data(:,23);
porosity_cosby_95 = camels_GB_soil_data(:,24);
porosity_hypres = camels_GB_soil_data(:,25);
porosity_hypres_missing = camels_GB_soil_data(:,26);
porosity_hypres_5 = camels_GB_soil_data(:,27);
porosity_hypres_50 = camels_GB_soil_data(:,28);
porosity_hypres_95 = camels_GB_soil_data(:,29);
conductivity_cosby = camels_GB_soil_data(:,30);
conductivity_cosby_missing = camels_GB_soil_data(:,31);
conductivity_cosby_5 = camels_GB_soil_data(:,32);
conductivity_cosby_50 = camels_GB_soil_data(:,33);
conductivity_cosby_95 = camels_GB_soil_data(:,34);
conductivity_hypres = camels_GB_soil_data(:,35);
conductivity_hypres_missing = camels_GB_soil_data(:,36);
conductivity_hypres_5 = camels_GB_soil_data(:,37);
conductivity_hypres_50 = camels_GB_soil_data(:,38);
conductivity_hypres_95 = camels_GB_soil_data(:,39);
root_depth = camels_GB_soil_data(:,40);
root_depth_missing = camels_GB_soil_data(:,41);
root_depth_5 = camels_GB_soil_data(:,42);
root_depth_50 = camels_GB_soil_data(:,43);
root_depth_95 = camels_GB_soil_data(:,44);
soil_depth_pelletier = camels_GB_soil_data(:,45);
soil_depth_pelletier_missing = camels_GB_soil_data(:,46);
soil_depth_pelletier_5 = camels_GB_soil_data(:,47);
soil_depth_pelletier_50 = camels_GB_soil_data(:,48);
soil_depth_pelletier_95 = camels_GB_soil_data(:,49);

% hydrogeology
inter_high_perc = camels_GB_geology_data(:,2);
inter_mod_perc = camels_GB_geology_data(:,3);
inter_low_perc = camels_GB_geology_data(:,4);
frac_high_perc = camels_GB_geology_data(:,5);
frac_mod_perc = camels_GB_geology_data(:,6);
frac_low_perc = camels_GB_geology_data(:,7);
no_gw_perc = camels_GB_geology_data(:,8);
low_nsig_perc = camels_GB_geology_data(:,9);
nsig_low_perc = camels_GB_geology_data(:,10);

% hydrometry
station_type = camels_GB_hydrometry_data_str(2:end,2);
flow_period_start = camels_GB_hydrometry_data_str(2:end,3);
flow_period_end = camels_GB_hydrometry_data_str(2:end,4);
flow_perc_complete = camels_GB_hydrometry_data(:,5);
bankfull_flow = camels_GB_hydrometry_data(:,6);
structurefull_flow = camels_GB_hydrometry_data(:,7);
q5_uncert_upper = camels_GB_hydrometry_data(:,8);
q5_uncert_lower = camels_GB_hydrometry_data(:,9);
q25_uncert_upper = camels_GB_hydrometry_data(:,10);
q25_uncert_lower = camels_GB_hydrometry_data(:,11);
q50_uncert_upper = camels_GB_hydrometry_data(:,12);
q50_uncert_lower = camels_GB_hydrometry_data(:,13);
q75_uncert_upper = camels_GB_hydrometry_data(:,14);
q75_uncert_lower = camels_GB_hydrometry_data(:,15);
q95_uncert_upper = camels_GB_hydrometry_data(:,16);
q95_uncert_lower = camels_GB_hydrometry_data(:,17);
q99_uncert_upper = camels_GB_hydrometry_data(:,18);
q99_uncert_lower = camels_GB_hydrometry_data(:,19);
quncert_meta = camels_GB_hydrometry_data_str(2:end,20);

% human influences
benchmark_catch = camels_GB_human_data_str(2:end,2);
isBenchmark = zeros(size(benchmark_catch));
isBenchmark(strcmp('Y',benchmark_catch)) = 1;
isBenchmark = logical(isBenchmark);
surfacewater_abs = camels_GB_human_data(:,3);
groundwater_abs = camels_GB_human_data(:,4);
discharges = camels_GB_human_data(:,5);
abs_agriculture_perc = camels_GB_human_data(:,6);
abs_amenities_perc = camels_GB_human_data(:,7);
abs_energy_perc = camels_GB_human_data(:,8);
abs_environmental_perc = camels_GB_human_data(:,9);
abs_industry_perc = camels_GB_human_data(:,10);
abs_watersupply_perc = camels_GB_human_data(:,11);
num_reservoir = camels_GB_human_data(:,12);
reservoir_cap = camels_GB_human_data(:,13);
reservoir_he = camels_GB_human_data(:,14);
reservoir_nav = camels_GB_human_data(:,15);
reservoir_drain = camels_GB_human_data(:,16);
reservoir_wr = camels_GB_human_data(:,17);
reservoir_fs = camels_GB_human_data(:,18);
reservoir_env = camels_GB_human_data(:,19);
reservoir_nousedata = camels_GB_human_data(:,20);
reservoir_year_first = camels_GB_human_data(:,21);
reservoir_year_last = camels_GB_human_data(:,22);

%% load time series
P = cell(length(gauge_id),1); % precipitation
PET = cell(length(gauge_id),1); % potential evapotranspiration
Q = cell(length(gauge_id),1); % streamflow
T = cell(length(gauge_id),1); % temperature

% loop over all catchments
for i = 1:length(gauge_id)
    
    if mod(i,10) == 0 % check progress
        fprintf('%.0f/%.0f\n',i,length(gauge_id))
    end
    
    ID = gauge_id(i);
    [P{i}, PET{i}, Q{i}, T{i}] = loadCatchmentCAMELSGB(ID,path_time_series);
    
end

%% create structure

% topography
CAMELS_GB_data.gauge_id = gauge_id;
CAMELS_GB_data.gauge_name = gauge_name;
CAMELS_GB_data.gauge_lat = gauge_lat;
CAMELS_GB_data.gauge_lon = gauge_lon;
CAMELS_GB_data.gauge_easting = gauge_easting;
CAMELS_GB_data.gauge_northing = gauge_northing;
CAMELS_GB_data.gauge_elev = gauge_elev;
CAMELS_GB_data.area = area;
CAMELS_GB_data.dpsbar = dpsbar;
CAMELS_GB_data.elev_mean = elev_mean;
CAMELS_GB_data.elev_min = elev_min;
CAMELS_GB_data.elev_10 = elev_10;
CAMELS_GB_data.elev_50 = elev_50;
CAMELS_GB_data.elev_90 = elev_90;
CAMELS_GB_data.elev_max = elev_max;

% climatic indices
CAMELS_GB_data.p_mean = p_mean;
CAMELS_GB_data.pet_mean = pet_mean;
CAMELS_GB_data.aridity = aridity;
CAMELS_GB_data.p_seasonality = p_seasonality;
CAMELS_GB_data.frac_snow = frac_snow;
CAMELS_GB_data.high_prec_freq = high_prec_freq;
CAMELS_GB_data.high_prec_dur = high_prec_dur;
CAMELS_GB_data.high_prec_timing = high_prec_timing;
CAMELS_GB_data.low_prec_freq = low_prec_freq;
CAMELS_GB_data.low_prec_dur = low_prec_dur;
CAMELS_GB_data.low_prec_timing = low_prec_timing;

% hydrological signatures
CAMELS_GB_data.q_mean = q_mean;
CAMELS_GB_data.runoff_ratio = runoff_ratio;
CAMELS_GB_data.stream_elas = stream_elas;
CAMELS_GB_data.slope_fdc = slope_fdc;
CAMELS_GB_data.baseflow_index = baseflow_index;
CAMELS_GB_data.baseflow_index_ceh = baseflow_index_ceh;
CAMELS_GB_data.hfd_mean = hfd_mean;
CAMELS_GB_data.q5 = q5;
CAMELS_GB_data.q95 = q95;
CAMELS_GB_data.high_q_freq = high_q_freq;
CAMELS_GB_data.high_q_dur = high_q_dur;
CAMELS_GB_data.low_q_freq = low_q_freq;
CAMELS_GB_data.low_q_dur = low_q_dur;
CAMELS_GB_data.zero_q_freq = zero_q_freq;

% land cover
CAMELS_GB_data.dwood_perc = dwood_perc;
CAMELS_GB_data.ewood_perc = ewood_perc;
CAMELS_GB_data.grass_perc = grass_perc;
CAMELS_GB_data.shrub_perc = shrub_perc;
CAMELS_GB_data.crop_perc = crop_perc;
CAMELS_GB_data.urban_perc = urban_perc;
CAMELS_GB_data.inwater_perc = inwater_perc;
CAMELS_GB_data.bares_perc = bares_perc;
CAMELS_GB_data.dom_land_cover = dom_land_cover;

% soils
CAMELS_GB_data.sand_perc = sand_perc;
CAMELS_GB_data.sand_perc_missing = sand_perc_missing;
CAMELS_GB_data.silt_perc = silt_perc;
CAMELS_GB_data.silt_perc_missing = silt_perc_missing;
CAMELS_GB_data.clay_perc = clay_perc;
CAMELS_GB_data.clay_perc_missing = clay_perc_missing;
CAMELS_GB_data.organic_perc = organic_perc;
CAMELS_GB_data.organic_perc_missing = organic_perc_missing;
CAMELS_GB_data.bulkdens = bulkdens;
CAMELS_GB_data.bulkdens_missing = bulkdens_missing;
CAMELS_GB_data.bulkdens_5 = bulkdens_5;
CAMELS_GB_data.bulkdens_50 = bulkdens_50;
CAMELS_GB_data.bulkdens_95 = bulkdens_95;
CAMELS_GB_data.tawc = tawc;
CAMELS_GB_data.tawc_missing = tawc_missing;
CAMELS_GB_data.tawc_5 = tawc_5;
CAMELS_GB_data.tawc_50 = tawc_50;
CAMELS_GB_data.tawc_95 = tawc_95;
CAMELS_GB_data.porosity_cosby = porosity_cosby;
CAMELS_GB_data.porosity_cosby_missing = porosity_cosby_missing;
CAMELS_GB_data.porosity_cosby_5 = porosity_cosby_5;
CAMELS_GB_data.porosity_cosby_50 = porosity_cosby_50;
CAMELS_GB_data.porosity_cosby_95 = porosity_cosby_95;
CAMELS_GB_data.porosity_hypres = porosity_hypres;
CAMELS_GB_data.porosity_hypres_missing = porosity_hypres_missing;
CAMELS_GB_data.porosity_hypres_5 = porosity_hypres_5;
CAMELS_GB_data.porosity_hypres_50 = porosity_hypres_50;
CAMELS_GB_data.porosity_hypres_95 = porosity_hypres_95;
CAMELS_GB_data.conductivity_cosby = conductivity_cosby;
CAMELS_GB_data.conductivity_cosby_missing = conductivity_cosby_missing;
CAMELS_GB_data.conductivity_cosby_5 = conductivity_cosby_5;
CAMELS_GB_data.conductivity_cosby_50 = conductivity_cosby_50;
CAMELS_GB_data.conductivity_cosby_95 = conductivity_cosby_95;
CAMELS_GB_data.conductivity_hypres = conductivity_hypres;
CAMELS_GB_data.conductivity_hypres_missing = conductivity_hypres_missing;
CAMELS_GB_data.conductivity_hypres_5 = conductivity_hypres_5;
CAMELS_GB_data.conductivity_hypres_50 = conductivity_hypres_50;
CAMELS_GB_data.conductivity_hypres_95 = conductivity_hypres_95;
CAMELS_GB_data.root_depth = root_depth;
CAMELS_GB_data.root_depth_missing = root_depth_missing;
CAMELS_GB_data.root_depth_5 = root_depth_5;
CAMELS_GB_data.root_depth_50 = root_depth_50;
CAMELS_GB_data.root_depth_95 = root_depth_95;
CAMELS_GB_data.soil_depth_pelletier = soil_depth_pelletier;
CAMELS_GB_data.soil_depth_pelletier_missing = soil_depth_pelletier_missing;
CAMELS_GB_data.soil_depth_pelletier_5 = soil_depth_pelletier_5;
CAMELS_GB_data.soil_depth_pelletier_50 = soil_depth_pelletier_50;
CAMELS_GB_data.soil_depth_pelletier_95 = soil_depth_pelletier_95;

% hydrogeology
CAMELS_GB_data.inter_high_perc = inter_high_perc;
CAMELS_GB_data.inter_mod_perc = inter_mod_perc;
CAMELS_GB_data.inter_low_perc = inter_low_perc;
CAMELS_GB_data.frac_high_perc = frac_high_perc;
CAMELS_GB_data.frac_mod_perc = frac_mod_perc;
CAMELS_GB_data.frac_low_perc = frac_low_perc;
CAMELS_GB_data.no_gw_perc = no_gw_perc;
CAMELS_GB_data.low_nsig_perc = low_nsig_perc;
CAMELS_GB_data.low_nsig_perc = low_nsig_perc;

% hydrometry
CAMELS_GB_data.station_type = station_type;
CAMELS_GB_data.flow_period_start = flow_period_start;
CAMELS_GB_data.flow_period_end = flow_period_end;
CAMELS_GB_data.flow_perc_complete = flow_perc_complete;
CAMELS_GB_data.bankfull_flow = bankfull_flow;
CAMELS_GB_data.structurefull_flow = structurefull_flow;
CAMELS_GB_data.q5_uncert_upper = q5_uncert_upper;
CAMELS_GB_data.q5_uncert_lower = q5_uncert_lower;
CAMELS_GB_data.q25_uncert_upper = q25_uncert_upper;
CAMELS_GB_data.q25_uncert_lower = q25_uncert_lower;
CAMELS_GB_data.q50_uncert_upper = q50_uncert_upper;
CAMELS_GB_data.q50_uncert_lower = q50_uncert_lower;
CAMELS_GB_data.q75_uncert_upper = q75_uncert_upper;
CAMELS_GB_data.q75_uncert_lower = q75_uncert_lower;
CAMELS_GB_data.q95_uncert_upper = q95_uncert_upper;
CAMELS_GB_data.q95_uncert_lower = q95_uncert_lower;
CAMELS_GB_data.q99_uncert_upper = q99_uncert_upper;
CAMELS_GB_data.q99_uncert_lower = q99_uncert_lower;
CAMELS_GB_data.quncert_meta = quncert_meta;

% human influences
CAMELS_GB_data.benchmark_catch = benchmark_catch;
CAMELS_GB_data.isBenchmark = isBenchmark;
CAMELS_GB_data.surfacewater_abs = surfacewater_abs;
CAMELS_GB_data.groundwater_abs = groundwater_abs;
CAMELS_GB_data.discharges = discharges;
CAMELS_GB_data.abs_agriculture_perc = abs_agriculture_perc;
CAMELS_GB_data.abs_amenities_perc = abs_amenities_perc;
CAMELS_GB_data.abs_energy_perc = abs_energy_perc;
CAMELS_GB_data.abs_environmental_perc = abs_environmental_perc;
CAMELS_GB_data.abs_industry_perc = abs_industry_perc;
CAMELS_GB_data.abs_watersupply_perc = abs_watersupply_perc;
CAMELS_GB_data.num_reservoir = num_reservoir;
CAMELS_GB_data.reservoir_cap = reservoir_cap;
CAMELS_GB_data.reservoir_he = reservoir_he;
CAMELS_GB_data.reservoir_nav = reservoir_nav;
CAMELS_GB_data.reservoir_drain = reservoir_drain;
CAMELS_GB_data.reservoir_wr = reservoir_wr;
CAMELS_GB_data.reservoir_fs = reservoir_fs;
CAMELS_GB_data.reservoir_env = reservoir_env;
CAMELS_GB_data.reservoir_nousedata = reservoir_nousedata;
CAMELS_GB_data.reservoir_year_first = reservoir_year_first;
CAMELS_GB_data.reservoir_year_last = reservoir_year_last;

% hydro-meteorological time series
CAMELS_GB_data.P = P;
CAMELS_GB_data.PET = PET;
CAMELS_GB_data.Q = Q;
CAMELS_GB_data.T = T;

% save file to table
save('./CAMELS_Matlab/Data/CAMELS_GB_data.mat','CAMELS_GB_data')

