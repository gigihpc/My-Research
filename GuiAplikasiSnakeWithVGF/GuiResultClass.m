function varargout = GuiResultClass(varargin)
% GUIRESULTCLASS MATLAB code for GuiResultClass.fig
%      GUIRESULTCLASS, by itself, creates a new GUIRESULTCLASS or raises the existing
%      singleton*.
%
%      H = GUIRESULTCLASS returns the handle to a new GUIRESULTCLASS or the handle to
%      the existing singleton*.
%
%      GUIRESULTCLASS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUIRESULTCLASS.M with the given input arguments.
%
%      GUIRESULTCLASS('Property','Value',...) creates a new GUIRESULTCLASS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GuiResultClass_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GuiResultClass_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GuiResultClass

% Last Modified by GUIDE v2.5 08-Nov-2014 13:35:26

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GuiResultClass_OpeningFcn, ...
                   'gui_OutputFcn',  @GuiResultClass_OutputFcn, ...
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


% --- Executes just before GuiResultClass is made visible.
function GuiResultClass_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GuiResultClass (see VARARGIN)

% Choose default command line output for GuiResultClass
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);
im = imread ('_imageTumor/case1/tumor1_28.png');
imgr = rgb2gray(im);
imshow(imgr, 'DisplayRange',[]), colorbar;



%load '_hasilTxt/hasilExtraksiClass1.txt'
%set (handles.tblFitur, 'Data', hasilExtraksiClass1);

% UIWAIT makes GuiResultClass wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = GuiResultClass_OutputFcn(hObject, eventdata, handles) 
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
function getLoadingCase_Callback(hObject, eventdata, handles)
% hObject    handle to getLoadingCase (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function getKeluar_Callback(hObject, eventdata, handles)
% hObject    handle to getKeluar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close ();

% --------------------------------------------------------------------
function getLoadingFiturExtraction_Callback(hObject, eventdata, handles)
% hObject    handle to getLoadingFiturExtraction (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[namafile,folderfile]=uigetfile({'*.txt'})
file = strcat(folderfile, namafile);
getEkstraksi = load (file, '-ascii');

baris = size(getEkstraksi,1);
kolom = size(getEkstraksi,2);

set (handles.idNamaFile, 'string', namafile);

set (handles.tblFitur, 'Data', getEkstraksi);


% --------------------------------------------------------------------
function mfAnalysis_Callback(hObject, eventdata, handles)
% hObject    handle to mfAnalysis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function getRunAnalysis_Callback(hObject, eventdata, handles)
% hObject    handle to getRunAnalysis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% perikasa menu training atau testing yang aktif
val = get(handles.getTrainingData, 'Checked');
if strcmp (val, 'on')
    %% TRAINING DATA
    set (handles.infoTabel, 'string', 'Fitur Ekstraksi: --> Training Data');
    
    %load DataTrain.txt

    %getNama = get(handles.editNamaFile, 'String')
    getNama = get(handles.idNamaFile, 'String')
    
    %nama = 'DataTrain.txt';
    getData = load (getNama,'-ascii');
    %dtTrain = size(DataTrain);
    
    dtTrain = size(getData);
    for i=1:dtTrain(2)%kolom
        maxvalue = max(getData(:,i));
        minvalue = min(getData(:,i));
        for j=1:dtTrain(1)%baris
            norm_DataTrain(j,i) = (getData(j,i)- minvalue)/(maxvalue-minvalue);
        end
    end
    fiturPerKelas = 35;
    [net, kelas]= ProcessIdentifikasi(norm_DataTrain, fiturPerKelas);
    save classification/result.mat
else
    %% TESTING DATA
    load classification/result.mat
    set (handles.infoTabel, 'string', 'Fitur Ekstraksi: --> Testing Data');
    %load dataTest.txt
    getNama = get(handles.idNamaFile, 'String')
    
    %nama = 'DataTest.txt';
    getData = load (getNama,'-ascii');
    
    dtTest = size(getData);
    for i=1:dtTest(2)%kolom
        maxvalue = max(getData(:,i));
        minvalue = min(getData(:,i));
        for j=1:dtTest(1)%baris
            norm_datatest(j,i) = (getData(j,i)- minvalue)/(maxvalue-minvalue);
        end
    end
    [identifikasi, akurasi] = ProcessTest(net, norm_datatest,kelas,fiturPerKelas);
    identifikasi
    akurasi
end
 
% --------------------------------------------------------------------
function getTrainingData_Callback(hObject, eventdata, handles)
% hObject    handle to getTrainingData (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
addpath classification

val = get(handles.getTrainingData, 'Checked');
set (handles.getRunAnalysis, 'Enable','on');

if strcmp (val, 'on')
    set (handles.getTrainingData, 'Checked', 'off');
    set (handles.getTestingData, 'Checked', 'on');
    set (handles.setStatus, 'string', '>> Testing Data');
    set (handles.setStatus, 'ForegroundColor', 'Red');
    getEkstraksi = load ('DataTest.txt', '-ascii');
    set (handles.tblFitur, 'Data', getEkstraksi);
    baris = size(getEkstraksi,1);
    kolom = size(getEkstraksi,2);
    set (handles.idNamaFile, 'string', 'DataTest.txt');
    set (handles.infoTabel, 'string', 'Fitur Ekstraksi: --> Testing Data');
else
    set (handles.getTestingData, 'Checked', 'off');
    set (handles.getTrainingData, 'Checked', 'on');
    set (handles.setStatus, 'string', '>> Training Data');
    set (handles.setStatus, 'ForegroundColor', 'Blue');
    getEkstraksi = load ('DataTrain.txt', '-ascii');
    set (handles.tblFitur, 'Data', getEkstraksi);
    baris = size(getEkstraksi,1);
    kolom = size(getEkstraksi,2);
    set (handles.idNamaFile, 'string', 'DataTrain.txt');
    set (handles.infoTabel, 'string', 'Fitur Ekstraksi: --> Training Data');
end

% --------------------------------------------------------------------
function getTestingData_Callback(hObject, eventdata, handles)
% hObject    handle to getTestingData (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
addpath classification

val = get(handles.getTestingData, 'Checked');
set (handles.getRunAnalysis, 'Enable','on');
if strcmp (val, 'on')
    set (handles.getTrainingData, 'Checked', 'on');
    set (handles.getTestingData, 'Checked', 'off');
    set (handles.setStatus, 'string', '>> Training Data');
    set (handles.setStatus, 'ForegroundColor' , 'Red');
    getEkstraksi = load ('DataTrain.txt', '-ascii');
    set (handles.tblFitur, 'Data', getEkstraksi);
    baris = size(getEkstraksi,1);
    kolom = size(getEkstraksi,2);
    set (handles.idNamaFile, 'string', 'DataTrain.txt');
    set (handles.infoTabel, 'string', 'Fitur Ekstraksi: --> Testing Data');
else
    set (handles.getTestingData, 'Checked', 'on');
    set (handles.getTrainingData, 'Checked', 'off');
    set (handles.setStatus, 'string', '>> Testing Data');
    set (handles.setStatus, 'ForegroundColor', 'Blue');
    getEkstraksi = load ('DataTest.txt', '-ascii');
    set (handles.tblFitur, 'Data', getEkstraksi);
    baris = size(getEkstraksi,1);
    kolom = size(getEkstraksi,2);
    set (handles.idNamaFile, 'string', 'DataTest.txt');
    set (handles.infoTabel, 'string', 'Fitur Ekstraksi: --> Training Data');
end


% --- Executes on selection change in tampilImage.
function tampilImage_Callback(hObject, eventdata, handles)
% hObject    handle to tampilImage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns tampilImage contents as cell array
%        contents{get(hObject,'Value')} returns selected item from tampilImage


% --- Executes during object creation, after setting all properties.
function tampilImage_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tampilImage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in tampilInfo.
function tampilInfo_Callback(hObject, eventdata, handles)
% hObject    handle to tampilInfo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns tampilInfo contents as cell array
%        contents{get(hObject,'Value')} returns selected item from tampilInfo


% --- Executes during object creation, after setting all properties.
function tampilInfo_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tampilInfo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editNamaFile_Callback(hObject, eventdata, handles)
% hObject    handle to editNamaFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editNamaFile as text
%        str2double(get(hObject,'String')) returns contents of editNamaFile as a double


% --- Executes during object creation, after setting all properties.
function editNamaFile_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editNamaFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
