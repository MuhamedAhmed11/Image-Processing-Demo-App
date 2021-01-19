function varargout = fourierTab(varargin)
% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @fourierTab_OpeningFcn, ...
                   'gui_OutputFcn',  @fourierTab_OutputFcn, ...
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


% --- Executes just before fourierTab is made visible.
function fourierTab_OpeningFcn(hObject, eventdata, handles, varargin)
% Choose default command line output for fourierTab
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes fourierTab wait for user response (see UIRESUME)
% uiwait(handles.fourierTab);

% --- Outputs from this function are returned to the command line.
function varargout = fourierTab_OutputFcn(hObject, eventdata, handles) 
% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes on button press in backBtn.
function backBtn_Callback(hObject, eventdata, handles)
% hObject    handle to backBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global browsedImg;
browsedImg = [];
menu;
histogramTabObject = findobj(0, 'tag', 'fourierTab');
delete(histogramTabObject);

% --- Executes on button press in browseBtn.
function browseBtn_Callback(hObject, eventdata, handles)
global Filename;
global Pathname;
global browsedImg;
% calling browse function to choose an image
[Filename,Pathname, browsedImg] = BrowseImagefile(handles.BrowsedImgView, handles.imgPath);



function imgPath_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function imgPath_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in resultBtn.
function resultBtn_Callback(hObject, eventdata, handles)
global Filename;
global Pathname;
global browsedImg;
% check if browsed image is empty
% if user clicks on it before choosing image to avoid application crash
if isempty(browsedImg)
    msgbox('Please Choose image first');
    return
end
browsedImg = strcat(Pathname, Filename);
browsedImg = imread(browsedImg);
% apply fourier and fourier shift to display the transformed image
browsedImgFourier = fftshift(fft2(browsedImg));
fl = log(1+abs(browsedImgFourier));
fm = max(fl(:));
% choosing axes to display
axes(handles.TransformedImgView);
% display the transformed image
imshow(im2uint8(fl/fm));

% --- Executes when fourierTab is resized.
function fourierTab_SizeChangedFcn(hObject, eventdata, handles)
