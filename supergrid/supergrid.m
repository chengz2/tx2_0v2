% Create the supergrid for the tx2_0v2 configuration by subsampling the tx2_3 supergrid

clearvars

fin  = 'ocean_hgrid_tx2_3.nc';
fout = 'ocean_hgrid_tx2_0v2.nc';

%% Coordinate variables
% Unfortunately, it is not possible to have a grid line locate along the equator.
x = ncread(fin,'x',[1,1],[Inf,Inf],[3,3]);
y = ncread(fin,'y',[1,1],[Inf,Inf],[3,3]);

[nxp,nyp] = size(x); nx = nxp - 1; ny = nyp - 1;

%% Grid length
% Zonal direction
dx23 = ncread(fin,'dx',[1,1],[Inf,Inf],[1,3]);
dx20 = dx23(1:3:end,:) + dx23(2:3:end,:) + dx23(3:3:end,:);

% Meridional direction
dy23 = ncread(fin,'dy',[1,1],[Inf,Inf],[3,1]);
dy20 = dy23(:,1:3:end) + dy23(:,2:3:end) + dy23(:,3:3:end);

%% Grid area
a23 = ncread(fin,'area'); a20 = 0;

for ii = 1 : 3
    for jj = 1 : 3
        a20 = a20 + a23(ii:3:end,jj:3:end);
    end
end

%% Angle
% For simplicity, I'm subsampling the original angles here, but this may not be accurate.
angle = ncread(fin,'angle_dx',[1,1],[Inf,Inf],[3,3]);

%% Save data
nccreate(fout,'x','Dimensions',{'nxp',nxp,'nyp',nyp}), ncwrite(fout,'x',x)
nccreate(fout,'y','Dimensions',{'nxp',nxp,'nyp',nyp}), ncwrite(fout,'y',y)
nccreate(fout,'dx','Dimensions',{'nx',nx,'nyp',nyp}),  ncwrite(fout,'dx',dx20)
nccreate(fout,'dy','Dimensions',{'nxp',nxp,'ny',ny}),  ncwrite(fout,'dy',dy20)
nccreate(fout,'area','Dimensions',{'nx',nx,'ny',ny}),  ncwrite(fout,'area',a20)
nccreate(fout,'angle_dx','Dimensions',{'nxp',nxp,'nyp',nyp}), ncwrite(fout,'angle_dx',angle)

ncwriteatt(fout,'x','units','degrees'), ncwriteatt(fout,'y','units','degrees')
ncwriteatt(fout,'dx','units','meters'), ncwriteatt(fout,'dy','units','meters')
ncwriteatt(fout,'area','units','m2'),   ncwriteatt(fout,'angle_dx','units','degrees')
ncwriteatt(fout,'angle_dx','description','angle between X-axis and true EAST')

ncwriteatt(fout,'/','Description',['MOM6 2-degree tripolar grid (ORCA type), ' ...
    'created by subsampling the 2/3-degree supergrid'])
ncwriteatt(fout,'/','Author','William Xu (chengz@ucar.edu)')
ncwriteatt(fout,'/','Date',string(datetime("today","Format","yyyy-MM-dd")))
ncwriteatt(fout,'/','Type','MOM6 supergrid')
