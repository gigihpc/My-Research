function varargout = GuiSnakeGVM(varargin)
% GUISNAKEGVM MATLAB code for GuiSnakeGVM.fig
%      GUISNAKEGVM, by itself, creates a new GUISNAKEGVM or raises the existing
%      singleton*.
%
%      H = GUISNAKEGVM returns the handle to a new GUISNAKEGVM or the handle to
%      the existing singleton*.
%
%      GUISNAKEGVM('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUISNAKEGVM.M with the given input arguments.
%
%      GUISNAKEGVM('Property','Value',...) creates a new GUISNAKEGVM or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GuiSnakeGVM_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GuiSnakeGVM_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GuiSnakeGVM

% Last Modified by GUIDE v2.5 05-Nov-2014 12:58:28

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GuiSnakeGVM_OpeningFcn, ...
                   'gui_OutputFcn',  @GuiSnakeGVM_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before GuiSnakeGVM is made visible.
function GuiSnakeGVM_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GuiSnakeGVM (see VARARGIN)

% Choose default command line output for GuiSnakeGVM
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes GuiSnakeGVM wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = GuiSnakeGVM_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --------------------------------------------------------------------
function mfFile_Callback(hObject, eventdata, handles)
% hObject    handle to mfFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function getLoadCase_Callback(hObject, eventdata, handles)
% hObject    handle to getLoadCase (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[namafile,folderfile]=uigetfile({'*.dat'})
file = strcat(folderfile, namafile)

fileID = fopen(file);
c = textscan(fileID, '%s %s %s %s');
fclose(fileID);

folder = c{1}{1};
prefix = c{2}{1};
tipe = c{3}{1};
hasilExt = c{4}{1};

set (handles.txtFolder, 'string', folder);
%set (handles.folder, 'string', folder);
set (handles.txtPrefix, 'string', prefix);
%set (handles.prefix, 'string', prefix);

set (handles.sliderVerViewImage, 'Enable','on');
set (handles.uipanel16, 'Visible', 'on');

% if (hasilExt == '1')
%     load _hasilTxt/hasilExtraksi_Case1.txt
%     set(handles.tblExt, 'Data', hasilExtraksi_Case1)
% elseif(hasilExt == '2')
%     load _hasilTxt/hasilExtraksi_Case2.txt
%     set(handles.tblExt, 'Data', hasilExtraksi_Case2)
% elseif(hasilExt == '3')
%     load _hasilTxt/hasilExtraksi_Case3.txt
%     set(handles.tblExt, 'Data', hasilExtraksi_Case3)
% elseif(hasilExt == '4')
%     load _hasilTxt/hasilExtraksi_Case4.txt
%     set(handles.tblExt, 'Data', hasilExtraksi_Case4)
% elseif(hasilExt == '5')
%     load _hasilTxt/hasilExtraksi_Case5.txt
%     set(handles.tblExt, 'Data', hasilExtraksi_Case5)
% elseif(hasilExt == '6')
%     load _hasilTxt/hasilExtraksi_Case6.txt
%     set(handles.tblExt, 'Data', hasilExtraksi_Case6)
% elseif(hasilExt == '7')
%     load _hasilTxt/hasilExtraksi_Case7.txt
%     set(handles.tblExt, 'Data', hasilExtraksi_Case7)
% elseif(hasilExt == '8')
%     load _hasilTxt/hasilExtraksi_Case8.txt
%     set(handles.tblExt, 'Data', hasilExtraksi_Case8)
% elseif(hasilExt == '9')
%     load _hasilTxt/hasilExtraksi_Case9.txt
%     set(handles.tblExt, 'Data', hasilExtraksi_Case9)
% elseif(hasilExt == '10')
%     load _hasilTxt/hasilExtraksi_Case10.txt
%     set(handles.tblExt, 'Data', hasilExtraksi_Case10)
% end

set (handles.sliderVerViewImage, 'Value', 0);
img = strcat(folder,prefix,'0.png');
set (handles.txtNamaFile, 'string', img);
i = imread(img);
imshow(i);

im = rgb2gray(i);

axes(handles.axes5), imhist(im);
set (handles.sliderVerViewImage, 'Enable', 'on');

% --------------------------------------------------------------------
function getClose_Callback(hObject, eventdata, handles)
% hObject    handle to getClose (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close();
% --------------------------------------------------------------------
function mfView_Callback(hObject, eventdata, handles)
% hObject    handle to mfView (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function getROI_Callback(hObject, eventdata, handles)
% hObject    handle to getROI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
axes (handles.tampilGrafik);
imshow('_imageHasil/roi.png');

% --------------------------------------------------------------------
function getInitContour_Callback(hObject, eventdata, handles)
% hObject    handle to getInitContour (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
axes (handles.tampilGrafik);
imshow('_imageHasil/inisial_awal.png');

% --------------------------------------------------------------------
function getExtEnergy_Callback(hObject, eventdata, handles)
% hObject    handle to getExtEnergy (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
axes (handles.tampilGrafik);
imshow('_imageHasil/external_energy.png');

% --------------------------------------------------------------------
function getExtForce_Callback(hObject, eventdata, handles)
% hObject    handle to getExtForce (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
axes (handles.tampilGrafik);
imshow('_imageHasil/external_force.png');

% --------------------------------------------------------------------
function getSnkMovement_Callback(hObject, eventdata, handles)
% hObject    handle to getSnkMovement (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
axes (handles.tampilGrafik);
imshow('_imageHasil/snake_move.png');
implay ('_imageHasil/SnakeMove.avi');

% --------------------------------------------------------------------
function getSegRegion_Callback(hObject, eventdata, handles)
% hObject    handle to getSegRegion (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
axes (handles.tampilGrafik);
imshow('_imageHasil/segmentasi.png');

% --------------------------------------------------------------------
function getGaborFilMag_Callback(hObject, eventdata, handles)
% hObject    handle to getGaborFilMag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
axes (handles.tampilGrafik);
imshow('_imageHasil/gabor1.png');

% --------------------------------------------------------------------
function getGaborFilEnergy_Callback(hObject, eventdata, handles)
% hObject    handle to getGaborFilEnergy (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
axes (handles.tampilGrafik);
imshow('_imageHasil/gabor2.png');

% --------------------------------------------------------------------
function mfRegion_Callback(hObject, eventdata, handles)
% hObject    handle to mfRegion (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --------------------------------------------------------------------
function getSetInitRegion_Callback(hObject, eventdata, handles)
% hObject    handle to getSetInitRegion (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
axes (handles.tampilGrafik);
set (handles.mfView, 'Enable','off');

im = get(handles.txtNamaFile, 'string');
img = imread(im);
imgrz = imresize(img,0.33);
Im = rgb2gray(imgrz);
I = im2double(Im);

Snake2D(I)

set(handles.mfView, 'Enable', 'on');

% --------------------------------------------------------------------
function getLayout_Callback(hObject, eventdata, handles)
% hObject    handle to getLayout (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function getClass_Callback(hObject, eventdata, handles)
% hObject    handle to getClass (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
GuiResultClass


% --- Executes on slider movement.
function sliderVerViewImage_Callback(hObject, eventdata, handles)
% hObject    handle to sliderVerViewImage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

axes (handles.tampilGrafik);

id = get(handles.sliderVerViewImage, 'Value')
fldr = get(handles.txtFolder, 'string')
pref = get(handles.txtPrefix, 'string')

idr = id
%idr = floor(id)

file = strcat(fldr, pref, int2str(idr),'.png')
set(handles.txtNamaFile, 'string', file);
set(handles.sliderVerViewImage, 'Enable', 'on');

Im = imread(file);
I = rgb2gray(Im);
imshow(I, 'Border', 'tight', 'InitialMagnification', 150, ...
    'DisplayRange',[]), colorbar;

axes(handles.axes5), imhist(I);
% tambahkan akfirkan menu set region
set (handles.mfRegion, 'Enable','on');


% --- Executes during object creation, after setting all properties.
function sliderVerViewImage_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sliderVerViewImage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

function txtFolder_Callback(hObject, eventdata, handles)
% hObject    handle to txtFolder (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txtFolder as text
%        str2double(get(hObject,'String')) returns contents of txtFolder as a double


% --- Executes during object creation, after setting all properties.
function txtFolder_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txtFolder (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function txtPrefix_Callback(hObject, eventdata, handles)
% hObject    handle to txtPrefix (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txtPrefix as text
%        str2double(get(hObject,'String')) returns contents of txtPrefix as a double


% --- Executes during object creation, after setting all properties.
function txtPrefix_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txtPrefix (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function txtNamaFile_Callback(hObject, eventdata, handles)
% hObject    handle to txtNamaFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txtNamaFile as text
%        str2double(get(hObject,'String')) returns contents of txtNamaFile as a double


% --- Executes during object creation, after setting all properties.
function txtNamaFile_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txtNamaFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
