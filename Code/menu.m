function varargout = menu(varargin)
% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @menu_OpeningFcn, ...
                   'gui_OutputFcn',  @menu_OutputFcn, ...
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


% --- Executes just before menu is made visible.
function menu_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output = hObject;
% Update handles structure
guidata(hObject, handles);
% UIWAIT makes menu wait for user response (see UIRESUME)
% uiwait(handles.homePage);


% --- Outputs from this function are returned to the command line.
function varargout = menu_OutputFcn(hObject, eventdata, handles) 
% Get default command line output from handles structure
varargout{1} = handles.output;


% --- goToHistogramBtn to open histogram page.
function goToHistogramBtn_Callback(hObject, eventdata, handles)
% opening histogram page
histTab;
% closing current page to be unseen for user
currentPage = findobj(0, 'tag', 'homePage');
delete(currentPage);

% --- goToFiltersBtn to open histogram page.
function goToFiltersBtn_Callback(hObject, eventdata, handles)
% opening filters page
filterTab;
% closing current page to be unseen for user
currentPage = findobj(0, 'tag', 'homePage');
delete(currentPage);

% --- goToSPNoiseBtn to open Salt & Pepper Noise page.
function goToSPNoiseBtn_Callback(hObject, eventdata, handles)
% opening Salt & Pepper Noise page
spTab;
% closing current page to be unseen for user
currentPage = findobj(0, 'tag', 'homePage');
delete(currentPage)

% --- goToPeriodicBtn to open Periodic Noise page.
function goToPeriodicBtn_Callback(hObject, eventdata, handles)
% opening Periodic Noise page
periodicNoiseTab;
% closing current page to be unseen for user
currentPage = findobj(0, 'tag', 'homePage');
delete(currentPage);

% --- goToFourierBtn to open Fourier page.
function goToFourierBtn_Callback(hObject, eventdata, handles)
% opening Fourier page
fourierTab;
% closing current page to be unseen for user
currentPage = findobj(0, 'tag', 'homePage');
delete(currentPage);

% --- goToHistEqualizationBtn to open histogram page.
function goToHistEqualizationBtn_Callback(hObject, eventdata, handles)
% opening histogram page
histTab;
% closing current page to be unseen for user
currentPage = findobj(0, 'tag', 'homePage');
delete(currentPage);


% --- Executes on button press in logOutButton.
function logOutButton_Callback(hObject, eventdata, handles)
% opening login page
loginTab;
% closing current page to be unseen for user
currentPage = findobj(0, 'tag', 'homePage');
delete(currentPage);
