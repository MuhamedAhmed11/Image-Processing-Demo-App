function varargout = histTab(varargin)
% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @histTab_OpeningFcn, ...
                   'gui_OutputFcn',  @histTab_OutputFcn, ...
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


% --- Executes just before histTab is made visible.
function histTab_OpeningFcn(hObject, eventdata, handles, varargin)
% Choose default command line output for histTab
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);



% --- Outputs from this function are returned to the command line.
function varargout = histTab_OutputFcn(hObject, eventdata, handles) 
% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in backBtn.
function backBtn_Callback(hObject, eventdata, handles)
global choosenImg;
choosenImg = [];
menu;
currentTab = findobj(0, 'tag', 'histTab');
delete(currentTab);

% --- Executes on button press in browseBtn.
function browseBtn_Callback(hObject, eventdata, handles)
% get static text object to use it later
imgPathAxesObject = findobj(0, 'tag', 'imgPath');
% clear any text on it 
set(imgPathAxesObject, 'string', '');
global Filename; 
global Pathname;
global choosenImg;
% calling browse function to choose an image
[Filename,Pathname, choosenImg] = BrowseImagefile(handles.originalImgView, imgPathAxesObject);


function imgPath_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function imgPath_CreateFcn(hObject, eventdata, handles)
% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in histogramBtn.
function histogramBtn_Callback(hObject, eventdata, handles)
global Pathname;
global Filename;
global choosenImg;
% check if browsed image is empty
% if user clicks on it before choosing image to avoid application crash
if isempty(choosenImg)
    msgbox('Please Choose image first');
    return
end
% read image
choosenImg = imread(choosenImg);
% choose axes to display image
axes(handles.histogramView);
% apply histogram to image
imhist(choosenImg);
% color x, y axes to white colors 
set(handles.histogramView,'XColor','white');
set(handles.histogramView,'YColor','white');


% --- Executes on button press in histogramEqBtn.
function histogramEqBtn_Callback(hObject, eventdata, handles)
global Filename;
global Pathname;
global choosenImg;
if isempty(choosenImg)
    msgbox('Please Choose image first');
    return
end
name = strcat(Pathname, Filename);
% read image
choosenImg = imread(name);
% apply histogram equlization
hq = histeq(choosenImg);
% choose axes to plot equlaized image
axes(handles.histogramEqImgView);
% display equlaized image
imshow(hq);
% choose axes to plot histogram equalization of an equlaized image
axes(handles.histogramEqView);
% display histogram equalization
imhist(hq);
% color x, y axes to white colors 
set(handles.histogramEqView,'XColor','white');
set(handles.histogramEqView,'YColor','white');


% --- Executes during object creation, after setting all properties.
function histogramView_CreateFcn(hObject, eventdata, handles)
