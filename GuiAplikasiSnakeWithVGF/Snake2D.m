function [P,J]=Snake2D(I,P,Options)
% This function SNAKE implements the basic snake segmentation. A snake is an 
% active (moving) contour, in which the points are attracted by edges and
% other boundaries. To keep the contour smooth, an membrame and thin plate
% energy is used as regularization.
%
% [O,J]=Snake2D(I,P,Options)
%  
% inputs,
%   I : An Image of type double preferable ranged [0..1]
%   P : List with coordinates descriping the rough contour N x 2
%   Options : A struct with all snake options
%   
% outputs,
%   O : List with coordinates of the final contour M x 2
%   J : Binary image with the segmented region
%
% options (general),
%  Option.Verbose : If true show important images, default false
%  Options.nPoints : Number of contour points, default 100
%  Options.Gamma : Time step, default 1
%  Options.Iterations : Number of iterations, default 100
%
% options (Image Edge Energy / Image force))
%  Options.Sigma1 : Sigma used to calculate image derivatives, default 10
%  Options.Wline : Attraction to lines, if negative to black lines otherwise white
%                    lines , default 0.04
%  Options.Wedge : Attraction to edges, default 2.0
%  Options.Wterm : Attraction to terminations of lines (end points) and
%                    corners, default 0.01
%  Options.Sigma2 : Sigma used to calculate the gradient of the edge energy
%                    image (which gives the image force), default 20
%
% options (Gradient Vector Flow)
%  Options.Mu : Trade of between real edge vectors, and noise vectors,
%                default 0.2. (Warning setting this to high >0.5 gives
%                an instable Vector Flow)
%  Options.GIterations : Number of GVF iterations, default 0
%  Options.Sigma3 : Sigma used to calculate the laplacian in GVF, default 1.0
%
% options (Snake)
%  Options.Alpha : Membrame energy  (first order), default 0.2
%  Options.Beta : Thin plate energy (second order), default 0.2
%  Options.Delta : Baloon force, default 0.1
%  Options.Kappa : Weight of external image force, default 2
%
%
% Literature:
%   - Michael Kass, Andrew Witkin and Demetri TerzoPoulos "Snakes : Active
%       Contour Models", 1987
%   - Jim Ivins amd John Porrill, "Everything you always wanted to know
%       about snakes (but wer afraid to ask)
%   - Chenyang Xu and Jerry L. Prince, "Gradient Vector Flow: A New
%       external force for Snakes
%
% Example, Basic:
%
 % Read an image
%   I = imread('testimage.png');
%  % Convert the image to double data type
%   I = im2double(I); 
%   if(size(I,3)==3), I=rgb2gray(I); end
% 
%  % Show the image and select some points with the mouse (at least 4)
%  %figure, imshow(I); [y,x] = getpts;
%   y=[182 233 251 205 169];
%   x=[163 166 207 248 210];
%  % Make an array with the clicked coordinates
%   P=[x(:) y(:)];
%  % Start Snake Process
%   Options=struct;
%   Options.Verbose=true;
%   Options.Iterations=300;
%   [O,J]=Snake2D(I,P,Options);
%  % Show the result
%   Irgb(:,:,1)=I;
%   Irgb(:,:,2)=I;
%   Irgb(:,:,3)=J;
%   figure, imshow(Irgb,[]); 
%   hold on; plot([O(:,2);O(1,2)],[O(:,1);O(1,1)]);
%  
% GVF:
%   I=im2double(imread('testimage2.png'));
%I=im2double(imread('t1.jpg'));
%I=im2double(imread('DatasetMRI/AA/2/IM_00230.TIF'));
%J = imread('_imageTumor/case1/tumor1_30.png');
%Ji = imresize(J, 0.17);
%I = im2double(Ji);

[BW, y, x] = roipoly(I);
%figure(1), imshow(BW);
%title('Choice ROI');

namafileRoi = '_imageHasil/roi.png';
axis on
fg1=figure, imshow(BW);
%title('Choice ROI');
set(fg1,'MenuBar', 'none', 'ToolBar', 'none')
set(gca,'position',[0 0 1 1],'units','normalized')
print(fg1,'-dpng', namafileRoi);
close (fg1)

%   x=[96 51 98 202 272 280 182];
%   y=[63 147 242 262 211 97 59];
%   x=[194 220 223 223 213 183 148 132 134 159];
%   y=[96 123 150 181 208 222 210 178 139 108];
  P=[x(:) y(:)];
  Options=struct;%
  Options.Verbose=true;
  Options.Iterations=150;
  Options.Wedge=2;
  Options.Wline=0;
  Options.Wterm=0;
  Options.Kappa=4;
  Options.Sigma1=8;
  Options.Sigma2=8;
  Options.Alpha=0.1;
  Options.Beta=0.1;
  Options.Mu=0.2;
  Options.Delta=-0.1;
  Options.GIterations=200; %ori: 400
%   [O,J]=Snake2D(I,P,Options);
%   
% Function is written by D.Kroon University of Twente (July 2010)

% Process inputs
defaultoptions=struct('Verbose',false,'nPoints',100,'Wline',0.04,'Wedge',2,'Wterm',0.01,'Sigma1',10,'Sigma2',20,'Alpha',0.2,'Beta',0.2,'Delta',0.1,'Gamma',1,'Kappa',2,'Iterations',100,'GIterations',0,'Mu',0.2,'Sigma3',1);
if(~exist('Options','var')), 
    Options=defaultoptions; 
else
    hwb = waitbar(0, 'Proses sedang berlangsung...', 'Name', 'Process Inputs');
    tags = fieldnames(defaultoptions);
    for i=1:length(tags)
         if(~isfield(Options,tags{i})), Options.(tags{i})=defaultoptions.(tags{i}); end
        waitbar(i/length(tags), hwb);
    end
    close (hwb);
    if(length(tags)~=length(fieldnames(Options))), 
        warning('snake:unknownoption','unknown options found');
    end
end

% Convert input to double
I = double(I);

% If color image convert to grayscale
if(size(I,3)==3), I=rgb2gray(I); end

% The contour must always be clockwise (because of the balloon force)
P=MakeContourClockwise2D(P);

% Make an uniform sampled contour description
P=InterpolateContourPoints2D(P,Options.nPoints);

% Transform the Image into an External Energy Image
Eext = ExternalForceImage2D(I,Options.Wline, Options.Wedge, Options.Wterm,Options.Sigma1);

% Make the external force (flow) field.
Fx=ImageDerivatives2D(Eext,Options.Sigma2,'x');
Fy=ImageDerivatives2D(Eext,Options.Sigma2,'y');
Fext(:,:,1)=-Fx*2*Options.Sigma2^2;
Fext(:,:,2)=-Fy*2*Options.Sigma2^2;

% Do Gradient vector flow, optimalization
Fext=GVFOptimizeImageForces2D(Fext, Options.Mu, Options.GIterations, Options.Sigma3);

% Show the image, contour and force field
% if(Options.Verbose)
% ---- aslinya ---- %
    %h=figure; 
     %set(h,'render','opengl') % ini aslinya non aktif
     %subplot(2,2,1),
     %imshow(I,[]);
     %hold on; plot(P(:,2),P(:,1),'b.'); hold on;
     %title('The image with initial contour');
      
     %% rebuild fungsi
      filename = '_imageHasil/inisial_awal'; 
      fg2=figure, imshow(I,[]); 
      hold on; plot(P(:,2),P(:,1),'b.'); hold on
      %title('The image with initial contour');
      set(fg2,'MenuBar', 'none', 'ToolBar', 'none')
      set(gca,'position',[0 0 1 1],'units','normalized')
      print (fg2,'-dpng',filename)
      close (fg2)
      
      %% -- original external engery
      
      %subplot(2,2,2),
      %imshow(Eext,[]); 
      %title('The external energy');
      
      %% rebuild external
      filenameEnergy = '_imageHasil/external_energy';
      fg3 = figure, imshow(Eext,[]);
      set(fg3,'MenuBar', 'none', 'ToolBar', 'none')
      set(gca,'position',[0 0 1 1],'units','normalized')
      print (fg3, '-dpng', filenameEnergy)
      close (fg3)
      
      %% original external force
      %subplot(2,2,3), 
      %[x,y]=ndgrid(1:10:size(Fext,1),1:10:size(Fext,2));
      %imshow(I), hold on; quiver(y,x,Fext(1:10:end,1:10:end,2),Fext(1:10:end,1:10:end,1));
      %title('The external force field ')
      
      %% rebuild external force
      filenameExternalForce = '_imageHasil/external_force.png';
      fg4 = figure;
      [x,y]=ndgrid(1:10:size(Fext,1),1:10:size(Fext,2));
      imshow(I), hold on; quiver(y,x,Fext(1:10:end,1:10:end,2),Fext(1:10:end,1:10:end,1));
      %title('The external force field ')
      set(fg4,'MenuBar', 'none', 'ToolBar', 'none')
      set(gca,'position',[0 0 1 1],'units','normalized')
      print (fg4,'-dpng',filenameExternalForce)
      close (fg4)
      
     %% original snake movement
     %subplot(2,2,4), 
      %imshow(I), hold on; plot(P(:,2),P(:,1),'b.'); 
      %title('Snake movement ')
      
      %% -- rebuild snake movebement
      filenameSnakeMov = '_imageHasil/snake_move.png';
      fg5 = figure
      set(fg5,'MenuBar', 'none', 'ToolBar', 'none')
      imshow(I), hold on; plot(P(:,2),P(:,1),'b.'); 
      %title('Snake movement ')
      set(gca,'position',[0 0 1 1],'units','normalized')
      print (fg5, '-dpng', filenameSnakeMov);
      %close (fg5)
    drawnow
    
    %print (m4, '-dpng', filenameSnakeMov);
    %close (m4)
% end
% --- aslinya ----%

% Make the interal force matrix, which constrains the moving points to a
% smooth contour
              
S=SnakeInternalForceMatrix2D(Options.nPoints,Options.Alpha,Options.Beta,Options.Gamma);
h=[];

writeObj = VideoWriter('_imageHasil/SnakeMove.avi');
open(writeObj);

for i=1:Options.Iterations
    P=SnakeMoveIteration2D(S,P,Fext,Options.Gamma,Options.Kappa,Options.Delta);

    % Show current contour
    if(Options.Verbose)
        if(ishandle(h)), delete(h), end
        h=plot(P(:,2),P(:,1),'r.');
        c=i/Options.Iterations;
        plot([P(:,2);P(1,2)],[P(:,1);P(1,1)],'-','Color',[c 1-c 0]);  drawnow
        
        frame = getframe;
        writeVideo (writeObj, frame);
    end
end

close(writeObj);

set(fg5,'MenuBar', 'none', 'ToolBar', 'none')
set(gca,'position',[0 0 1 1],'units','normalized')
print (fg5, '-dpng', '_imageHasil/snake_move.png')
close (fg5)

r = P(:,1);
c = P(:,2);

format short
baris = round(r);
kolom = round(c);

area = roipoly(I,c,r);
save _hasilTxt/DataKoordinat.txt baris kolom -ascii;
%figure(3), imshow(area)
%title('Segmented Region');
filenameSegmen = '_imageHasil/segmentasi.png';
fg6 = figure(3), imshow(area)
%title('Segmented Region');
set(fg6,'MenuBar', 'none', 'ToolBar', 'none')
set(gca,'position',[0 0 1 1],'units','normalized')
print (fg6, '-dpng', filenameSegmen)
close (fg6)

% result = I*area';
% ROI = result';
% fig7=figure(3),imshow(ROI);
% [p q] = ginput(2);
% crop = imcrop(ROI,[p(1) q(1) p(2)-p(1) q(2)-q(1)]);
% fig8=figure(4), imshow(crop);
% title('Segmented Region');

% Get content area has value 1
content = size(area);
idx = 1;
for i = 1 : content(1)
    for j = 1:content(2)
        if(area(i,j)==1)
            crop(idx) = I(i,j);
            idx = idx + 1;
        end
    end
end

FeatureExtraction(crop);
% close (fig7);
% close (fig8);
% if(nargout>1)
%      J=DrawSegmentedArea2D(P,size(I));
% end

