function varargout = spTab(varargin)
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @spTab_OpeningFcn, ...
                   'gui_OutputFcn',  @spTab_OutputFcn, ...
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


% --- Executes just before spTab is made visible.
function spTab_OpeningFcn(hObject, eventdata, handles, varargin)
% Choose default command line output for spTab
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);


% --- Outputs from this function are returned to the command line.
function varargout = spTab_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;


% --- Button that retrun user back to menu page.
function backBtn_Callback(hObject, eventdata, handles)
%free browsed image before closing
global origImg;
global noisyImg;
origImg = [];
noisyImg = [];
%opening menu
menu;
%delete curreunt page to be unseen to user
spTabObject = findobj(0, 'tag', 'spTab');
delete(spTabObject);

% ---Button that user uses to browse images from PC.
function BrowseBtn_Callback(hObject, eventdata, handles)
global Filename;
global Pathname;
global origImg;
imgPathAxesObject = findobj(0, 'tag', 'imgPath');
% ask user to choose only images
[Filename, Pathname] = uigetfile({'*.jpg;*.png;*.jpeg;*.JPG;*.PNG;*.JPEG;*.tif;*.TIF'}, 'File Selector');
% check that user check image or not
if Pathname ~= 0
    origImg = strcat(Pathname, Filename);
    [fpth,name,ext] = fileparts(Filename);
    if ext == ".jpg" || ext == ".JPG" || ext == ".jpeg" || ext == ".JPEG" || ext == ".png" || ext == ".PNG" || ext == ".tif" || ext == ".TIF"
        %axes(imgAxesObject);
        set(imgPathAxesObject, 'BackgroundColor', [0 1 0]);
        set(imgPathAxesObject, 'string', origImg);
        axes(handles.originalImgView);
        imshow(origImg);
    else 
        set(imgPathAxesObject, 'string', origImg);
        set(imgPathAxesObject, 'BackgroundColor', [1 0 0]);
        promptMessage = sprintf('You did not choose image. try again?');
        titleBarCaption = 'ERROR!';
        buttonText = questdlg(promptMessage, titleBarCaption, 'Ok', 'Quit', 'Ok');
        if contains(buttonText, 'Quit')
            origImg = [];
            set(imgPathAxesObject, 'string', '---');
            set(imgPathAxesObject, 'BackgroundColor', [1 1 1]);
            return
        elseif contains(buttonText, 'Ok')
            origImg = [];
            BrowseBtn_Callback(hObject, eventdata, handles)
            return
        end
    end
else
        promptMessage = sprintf('You did not choose any image. try again?');
        titleBarCaption = 'ERROR!';
        buttonText = questdlg(promptMessage, titleBarCaption, 'Ok', 'Quit', 'Ok');
        if contains(buttonText, 'Quit')
            origImg = [];
            set(imgPathAxesObject, 'string', '---');
            set(imgPathAxesObject, 'BackgroundColor', [1 1 1]);
            return
        elseif contains(buttonText, 'Ok')
            origImg = [];
            BrowseBtn_Callback(hObject, eventdata, handles)
            return
        end
end

function imgPath_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function imgPath_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- addNoiseBtn that add noise to image when user click.
function addNoiseBtn_Callback(hObject, eventdata, handles)
densityResultObject = findobj(0, 'tag', 'densityResult');
global Filename;
global Pathname;
global origImg;
global noisyImg;
% check if user click button without choosing image
if isempty(origImg)
    msgbox('Please Choose image first');
    return
end
origImg = strcat(Pathname, Filename);
origImg = imread(origImg);
if size(origImg, 3) == 3
    origImg = rgb2gray(origImg);
end
% density input
densityInputObject = findobj(0, 'tag', 'densityInput');
densityValue = get(densityInputObject, 'string');
temp = densityValue;
densityValue = str2double(char(densityValue));

% check if user enter value not within range
if (densityValue >= 0 && densityValue <= 1)
    set(densityResultObject, 'string', densityValue);
    noisyImg = imnoise(origImg, 'salt & pepper', densityValue);
    %axes(noisyImgAxesObject);
    axes(handles.noisyImgView);
    imshow(noisyImg);
    %origImg = [];
% if user didnot enter value, set density with default value = 0.2
elseif temp == ""
    densityValue = 0.2;
    set(densityResultObject, 'string', densityValue);
    noisyImg = imnoise(origImg, 'salt & pepper', densityValue);
    axes(handles.noisyImgView);
    %axes(noisyImgAxesObject);
    imshow(noisyImg);
    %origImg = [];
else
    msgbox('desnity must be in range [0, 1]');

end
% --- removeNoiseBtn to remove added noise to the image.
function removeNoiseBtn_Callback(hObject, eventdata, handles)
maskResultObject = findobj(0, 'tag', 'maskResult');
global noisyImg;
% check if noise added to an image or not 
if isempty(noisyImg)
    msgbox('Please Choose image first');
    return
end
% Mask input
maskInputObject = findobj(0, 'tag', 'maskInput1');
maskInput2Object = findobj(0, 'tag', 'maskInput2');
maskValue1 = get(maskInputObject, 'string');
maskValue2 = get(maskInput2Object, 'string');
mskVal1 = maskValue1;
mskVal2 = maskValue2;
maskValue1 = str2double(char(maskValue1));
maskValue2 = str2double(char(maskValue2));
mskVal1 = isempty(mskVal1);
mskVal2 = isempty(mskVal2);

% check that mask value not negative number
if (maskValue1 > 0 && maskValue2 > 0)
    x = num2str([maskValue1 maskValue2]);
    x = ['[', x, ']'];
    set(maskResultObject, 'string', x);
    % apply median filter
    filtredImg = medfilt2(noisyImg, [maskValue1 maskValue2]);
    axes(handles.clearImgView);
    imshow(filtredImg);

    
elseif (maskValue1 < 0 || maskValue2 < 0)
    msgbox('Mask value must be Positive Number')
% if user didn't enter value, set with default value = [3 3]

% if user didn't enter value, set with default value = [3 3]
elseif mskVal1 && mskVal2
    maskValue1 = 3;
    maskValue2 = 3;
    x = num2str([maskValue1 maskValue2]);
    x = ['[', x, ']'];
    set(maskResultObject, 'string', x);
    filtredImg = medfilt2(noisyImg, [maskValue1 maskValue2]);
    axes(handles.clearImgView);
    imshow(filtredImg);
% if mask value1 is empty    
elseif mskVal1 && ~mskVal2 
    msgbox('You Missed first value of the Mask')
% if mask value2 is empty
elseif ~mskVal1 && mskVal2 
    msgbox('You Missed second value of the Mask')
% mask must be positive
else
    msgbox('Mask value must be Positive Number')
end

function densityInput_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function densityInput_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function maskInput1_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function maskInput1_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function maskInput2_Callback(hObject, eventdata, handles)

function maskInput2_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
