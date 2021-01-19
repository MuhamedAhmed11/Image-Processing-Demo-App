function varargout = loginTab(varargin)
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @loginTab_OpeningFcn, ...
                   'gui_OutputFcn',  @loginTab_OutputFcn, ...
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


% --- Executes just before loginTab is made visible.
function loginTab_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);
% UIWAIT makes loginTab wait for user response (see UIRESUME)
% uiwait(handles.loginTab);
axes(handles.logoPreview)
imshow('mlogo.png');


% --- Outputs from this function are returned to the command line.
function varargout = loginTab_OutputFcn(hObject, eventdata, handles) 
% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in loginButton.
function loginButton_Callback(hObject, eventdata, handles)
% get username input object to use it later
userObject = findobj(0, 'tag', 'usernameInput');
% get password input object to use it later
passwordObject = findobj(0, 'tag', 'passwordInput');
% ger login page object to use it later
loginPageObject = findobj(0, 'tag', 'loginTab');
% get text in the input that users enters
username = get(userObject, 'string');
% get text in the input that users enters
password = get(passwordObject, 'string');
user = 'Admin'; % valid username 
passwd = '1234'; % valid password
% Compare user input with valid username
checkUser = strcmp(username, user);
% Compare user input with valid password
checkPasswd = strcmp(password, passwd);
% check that user enters correct username and password
if checkUser == 1 && checkPasswd == 1
    % open menu tab
    menu;
    % msg for success logged in
    msgbox('You Logged in Successfully');
    % clearing username, password values
    set(userObject, 'string', '');
    set(passwordObject, 'string', '');
    % closing login tab
    delete(loginPageObject);
    % Check if username is incorrect and password is correct
elseif checkUser ~=1 && checkPasswd == 1
    % msg to user
    msgbox('Wrong Username, Please Enter a valid Username!');
    % Check if username is correct and password is incorrect
elseif checkUser ==1 && checkPasswd ~= 1
    % msg to user
    msgbox('Wrong Password, Please Enter a valid Password!');
    % Check if both username and password are incorrect
else
    % msg to user
    msgbox('Wrong Username and Password, Please try again!');
end


function usernameInput_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function usernameInput_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function passwordInput_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function passwordInput_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function logoPreview_CreateFcn(hObject, eventdata, handles)
axes(hObject)
imshow('mlogo.png');
