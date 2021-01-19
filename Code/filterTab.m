function varargout = filterTab(varargin)
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @filterTab_OpeningFcn, ...
                   'gui_OutputFcn',  @filterTab_OutputFcn, ...
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


% --- Executes just before filterTab is made visible.
function filterTab_OpeningFcn(hObject, eventdata, handles, varargin)
% Choose default command line output for filterTab
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% --- Outputs from this function are returned to the command line.
function varargout = filterTab_OutputFcn(hObject, eventdata, handles) 
% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in backBtn.
function backBtn_Callback(hObject, eventdata, handles)
global originalImg;
originalImg = [];
menu;
currentPage = findobj(0, 'tag', 'filterTab');
delete(currentPage);

% --- Executes on button press in browseBtn.
function browseBtn_Callback(hObject, eventdata, handles)
imgPathAxesObject = findobj(0, 'tag', 'imgPath');
set(imgPathAxesObject, 'string', '');
imgAxesObject = findobj(0, 'tag', 'browsedImgview');
%filterdImgAxesObject = findobj(0, 'tag', 'filterdImgView');
 
global Filename;
global Pathname;
global originalImg;

[Filename, Pathname, originalImg] = BrowseImagefile(handles.browsedImgView, handles.imgPath);


function imgPath_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function imgPath_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in showResultBtn1.
function showResultBtn1_Callback(hObject, eventdata, handles)
filterdImgAxesObject = findobj(0, 'tag', 'filterdImgView'); 
alphaResult = findobj(0, 'tag', 'alphaResult');
shapeResult = findobj(0, 'tag', 'shapeResult');

input1Object = findobj(0, 'tag', 'input1');
input2Object = findobj(0, 'tag', 'input2');
inputValue1 = get(input1Object, 'string');
temp = inputValue1;
inputValue2 = get(input2Object, 'string');
inputValue1 = str2double(char(inputValue1));

global Filename;
global Pathname;
global originalImg;
global popChoice;

% check if browsed image is empty
% if user clicks on it before choosing image to avoid application crash
if isempty(originalImg)
    msgbox('Please Choose image first');
    return
end
originalImg = strcat(Pathname, Filename);
originalImg = imread(originalImg);
% Convert rgb image to gray image 
if size(originalImg, 3) == 3
    originalImg = rgb2gray(originalImg);
end
% If user chose laplacian method
if popChoice == "laplacian"
    % ------ Handling Errors to avoid app craching ----- %
    % check if input value1(alpha) is within range
    % check if input value2(shape) is a right method (same, valid, or full)
    if (inputValue1 >= 0 && inputValue1 <= 1) && (inputValue2 == "same" || inputValue2 == "valid" || inputValue2 == "full")
        % set output text object by value1(alpha)
        set(alphaResult, 'string', inputValue1);
        % set output text object by value2(shape)
        set(shapeResult, 'string', inputValue2);
        % apply laplacian filter
        fltr = fspecial('laplacian', inputValue1);
        laplaceFltr = filter2(fltr, originalImg, inputValue2);
        % choose axes to display filterd image
        axes(handles.filterdImgView);
        % display image
        imshow(laplaceFltr);
        
    % if input value1(alpha) is within range
    % if input value2(shape) is empty
    elseif (inputValue1 > 0 && inputValue1 < 1) && inputValue2 == ""
        % set shape with default value = same
        inputValue2 = "same";
        % set output text object by value1(alpha)
        set(alphaResult, 'string', inputValue1);
        % set output text object by value2(shape)
        set(shapeResult, 'string', inputValue2);
        % apply laplacian filter
        Fltr = fspecial('laplacian', inputValue1);
        laplaceFltr = filter2(Fltr, originalImg, inputValue2);
        % choose axes to display filterd image
        axes(handles.filterdImgView);
        % display image
        imshow(laplaceFltr);

    % if input value1(alpha) is empty
    % if input value2(shape) is a right method (same, valid, or full)    
    elseif temp == "" && (inputValue2 == "same" || inputValue2 == "valid" || inputValue2 == "full")
        % set alpha with default value = 0.2
        inputValue1 = 0.2;
        % set output text object by value1(alpha)
        set(alphaResult, 'string', inputValue1);
        % set output text object by value2(shape)
        set(shapeResult, 'string', inputValue2);
        % apply laplacian filter
        Fltr = fspecial('laplacian', inputValue1);
        laplaceFltr = filter2(Fltr, originalImg, inputValue2);
        % choose axes to display filterd image
        axes(handles.filterdImgView);
        % display image
        imshow(laplaceFltr);
     
    % if input value1(alpha) is empty
    % if input value2(shape) is empty  
    elseif temp == "" && inputValue2 == ""
        % set alpha with default value = 0.2
        inputValue1 = 0.2;
        % set shape with default value = same
        inputValue2 = "same";
        % set output text object by value1(alpha)
        set(alphaResult, 'string', inputValue1);
        % set output text object by value2(shape)
        set(shapeResult, 'string', inputValue2);
        % apply laplacian filter
        Fltr = fspecial('laplacian', inputValue1);
        laplaceFltr = filter2(Fltr, originalImg, inputValue2);
        % choose axes to display filterd image
        axes(handles.filterdImgView);
        % display image
        imshow(laplaceFltr);
        
     % if input value1(alpha) is valid & input value2(shape) is empty   
    elseif (inputValue1 >= 0 && inputValue1 <= 1) && ~(inputValue2 == "same" || inputValue2 == "valid" || inputValue2 == "full") && inputValue2 ~= ""
        % print msg to user to enter a valid method
        msgbox('Please Choose a Correct Shape Method(same - valid - full)');
        
     % if input value1(alpha) is not in valid range & 
     % input value2(shape) is valid
    elseif ~(inputValue1 >= 0 && inputValue1 <= 1) && (inputValue2 == "same" || inputValue2 == "valid" || inputValue2 == "full")
        % print msg to user to enter alpha in a valid range [0, 1]
        msgbox('alpha must be in range [0, 1]');
        
    % if input value1(alpha) is empty & 
    % input value2(shape) is invalid    
    elseif temp == "" && ~(inputValue2 == "same" || inputValue2 == "valid" || inputValue2 == "full")
        % set alpha with default value = 0.2
        inputValue1 = 0.2;
        set(alphaResult, 'string', inputValue1);
        % print msg to user to enter shape in valid method 
        msgbox('Please Enter a correct direction method (same - valid - full)');
    elseif ~(inputValue1 >= 0 && inputValue1 <= 1) && inputValue2 == ""
        % set alpha with default value = 0.2
        inputValue2 = "same";
        set(shapeResult, 'string', inputValue2);
        msgbox('alpha must be in range [0, 1]');
    elseif (inputValue1 >= 0 && inputValue1 <= 1) && inputValue2 == ""
        % set alpha with default value = 0.2
        inputValue2 = "same";
        set(alphaResult, 'string', inputValue1);
        set(shapeResult, 'string', inputValue2);
        % apply laplacian filter
        Fltr = fspecial('laplacian', inputValue1);
        laplaceFltr = filter2(Fltr, originalImg, inputValue2);
        % choose axes to display filterd image
        axes(handles.filterdImgView);
        % display image
        imshow(laplaceFltr);
    else
        msgbox('Both inputs are invalid');
    end

% If user chose sobel method
elseif popChoice == "sobel"
    % ------ Handling Errors to avoid app craching ----- %
    % check if input value1(threshold) is within range [0, 1]
    % check if input value2(direction) is a right method (vetical, horizontal, or both)
    if (inputValue1 >= 1 && inputValue1 <= 255)&& (inputValue2 == "vertical" || inputValue2 == "horizontal" || inputValue2 == "both")
        % set output text object by value1(threshold)
        set(alphaResult, 'string', inputValue1);
        % set output text object by value2(direction)
        set(shapeResult, 'string', inputValue2);
        % apply sobel filter
        fltr = edge(originalImg, 'sobel', inputValue1/255, inputValue2); 
        % choose axes to display filterd image
        axes(handles.filterdImgView);
        % display image
        imshow(fltr);
    
    % if input value1(threshold) is within range
    % if input value2(direction) is empty    
    elseif (inputValue1 >= 1 && inputValue1 <= 255) && inputValue2 == ""
        % set (direction) value with default value = both
        inputValue2 = "both";
        set(alphaResult, 'string', inputValue1/255);
        set(shapeResult, 'string', inputValue2);
        % apply sobel filter
        fltr = edge(originalImg, 'sobel', inputValue1/255, inputValue2);
        % choose axes to display filterd image
        axes(handles.filterdImgView);
        % display image
        imshow(fltr);
        
    % if input value1(threshold) is within range
    % if input value2(direction) is valid
    elseif (inputValue1 >= 0 && inputValue1 < 1) && (inputValue2 == "vertical" || inputValue2 == "horizontal" || inputValue2 == "both")
        set(alphaResult, 'string', inputValue1);
        set(shapeResult, 'string', inputValue2);
        % apply sobel filter
        fltr = edge(originalImg, 'sobel', inputValue1, inputValue2);
        % choose axes to display filterd image
        axes(handles.filterdImgView);
        % display image
        imshow(fltr);
    
    % if input value1(threshold) is not within range
    % if input value2(direction) is empty    
    elseif (inputValue1 >= 0 && inputValue1 < 1) && inputValue2 == ""
        % set direction with default value
        inputValue2 = "both";
        set(alphaResult, 'string', inputValue1);
        set(shapeResult, 'string', inputValue2);
        fltr = edge(originalImg, 'sobel', inputValue1/255, inputValue2); 
        axes(handles.filterdImgView);
        imshow(fltr);
        
    elseif temp == "" && (inputValue2 == "vertical" || inputValue2 == "horizontal" || inputValue2 == "both")
        [e, thresh] = edge(originalImg, 'sobel');
        inputValue1 = thresh;
        set(alphaResult, 'string', inputValue1);
        set(shapeResult, 'string', inputValue2);
        fltr = edge(originalImg, 'sobel', inputValue1, inputValue2); 
        axes(handles.filterdImgView);
        imshow(fltr); 
    elseif temp == "" &&  inputValue2 == ""
        [e, thresh] = edge(originalImg, 'sobel');
        inputValue1 = thresh;
        inputValue2 = "both";
        set(alphaResult, 'string', inputValue1);
        set(shapeResult, 'string', inputValue2);
        fltr = edge(originalImg, 'sobel', inputValue1, inputValue2); 
        axes(handles.filterdImgView);
        imshow(fltr);       
    elseif (inputValue1 < 0 || inputValue1 <= 255) && (inputValue2 == "vertical" || inputValue2 == "horizontal" || inputValue2 == "both")
        msgbox('Threshold must be a positive number and within range');
    elseif (inputValue1 >= 0 && inputValue1 <= 255) && ~(inputValue2 == "vertical" || inputValue2 == "horizontal" || inputValue2 == "both")
        msgbox('Please Enter a correct direction method (vertical, horizontal or both)');
    elseif temp == "" && ~(inputValue2 == "vertical" || inputValue2 == "horizontal" || inputValue2 == "both")
        [e, thresh] = edge(originalImg, 'sobel');
        inputValue1 = thresh;
        set(alphaResult, 'string', inputValue1);
        msgbox('Please Enter a correct direction method (vertical, horizontal or both)');
    elseif (inputValue1 < 0 || inputValue1 >= 255) && inputValue2 == ""
        inputValue2 = "both";
        set(shapeResult, 'string', inputValue2);
        msgbox('Threshold must be a positive number and within range');
    elseif ~(inputValue1 > 0 || inputValue1 <= 255) &&  inputValue2 == ""
        inputValue2 = "both";
        set(shapeResult, 'string', inputValue2);
        msgbox('Threshold must be a positive number and within range');
    elseif ~(inputValue1 > 0 || inputValue1 <= 255) &&  ~(inputValue2 == "vertical" || inputValue2 == "horizontal" || inputValue2 == "both")
        msgbox('Both inputs are invalid');
    else
        msgbox('Invalid Threshold Value');
    end   
else
    msgbox('Please choose filter method');
end

function input1_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function input1_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function input2_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function input2_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu.
function popupmenu_Callback(hObject, eventdata, handles)
global content;
global popChoice;
popupMenuObject = findobj(0, 'tag', 'popupmenu');
content = cellstr(get(popupMenuObject, 'String'));
popChoice = content(get(popupMenuObject, 'Value'));

if popChoice == "sobel"
    input1Object = findobj(0, 'tag', 'input1');
    set(input1Object, 'string', '');
    input2Object = findobj(0, 'tag', 'input2');
    set(input2Object, 'string', '');
    %
    valuesPanelObject = findobj(0, 'tag', 'valuesPanel');
    set(valuesPanelObject, 'visible', 'on');
    %
    shapeInputText = findobj(0, 'tag', 'shapeText');
    set(shapeInputText, 'string', 'Direction:');
    alphaTextObject = findobj(0, 'tag', 'alphaText');
    set(alphaTextObject, 'string', 'Threshold:');
    %
    alphaResultTextObject = findobj(0, 'tag', 'alphaResultText');
    set(alphaResultTextObject, 'string', 'Threshold:');
    alphaResultObject = findobj(0, 'tag', 'alphaResult');
    set(alphaResultObject, 'string', '---');
    %
    shapeResultTextObject = findobj(0, 'tag', 'shapeResultText');
    set(shapeResultTextObject, 'string', 'Direction:');
    shapeResultObject = findobj(0, 'tag', 'shapeResult');
    set(shapeResultObject, 'string', '---');
    %
    set(alphaResultObject, 'visible', 'on');
    set(shapeResultTextObject, 'visible', 'on');
    set(shapeResultObject, 'visible', 'on');
    set(alphaResultTextObject, 'visible', 'on');
elseif popChoice == "laplacian"
    %
    input1Object = findobj(0, 'tag', 'input1');
    set(input1Object, 'string', '');
    input2Object = findobj(0, 'tag', 'input2');
    set(input2Object, 'string', '');
    %
    valuesPanelObject = findobj(0, 'tag', 'valuesPanel');
    set(valuesPanelObject, 'visible', 'on');
    alphaTextObject = findobj(0, 'tag', 'alphaText');
    set(alphaTextObject, 'visible', 'on');
    alphaInputtObject = findobj(0, 'tag', 'input1');
    set(alphaInputtObject, 'visible', 'on');
    %
    alphaText = findobj(0, 'tag', 'alphaText');
    set(alphaText, 'string', 'alpha:');
    alphaResultTextObject = findobj(0, 'tag', 'alphaResultText');
    set(alphaResultTextObject, 'string', 'alpha:');
    %
    shapeInputText = findobj(0, 'tag', 'shapeText');
    set(shapeInputText, 'string', 'shape:');
    %
    alphaResultObject = findobj(0, 'tag', 'alphaResult');
    set(alphaResultObject, 'string', '---');
    %
    shapeResultObject = findobj(0, 'tag', 'shapeResult');
    set(shapeResultObject, 'string', '---');
    shapeResultTextObject = findobj(0, 'tag', 'shapeResultText');
    set(shapeResultTextObject, 'string', 'shape:');
    %
    set(alphaResultObject, 'visible', 'on');
    set(shapeResultTextObject, 'visible', 'on');
    set(shapeResultObject, 'visible', 'on');
    set(alphaResultTextObject, 'visible', 'on');
else
    valuesPanelObject = findobj(0, 'tag', 'valuesPanel');
    alphaResultObject = findobj(0, 'tag', 'alphaResult');
    shapeResultTextObject = findobj(0, 'tag', 'shapeResultText');
    shapeResultObject = findobj(0, 'tag', 'shapeResult');
    alphaResultTextObject = findobj(0, 'tag', 'alphaResultText');
    
    set(alphaResultObject, 'visible', 'off');
    set(shapeResultTextObject, 'visible', 'off');
    set(shapeResultObject, 'visible', 'off');
    set(alphaResultTextObject, 'visible', 'off');
    set(valuesPanelObject, 'visible', 'off');
end


% --- Executes during object creation, after setting all properties.
function popupmenu_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

global popChoice;
popChoice = "choose method";
if popChoice == "choose method"
    valuesPanelObject = findobj(0, 'tag', 'valuesPanel');
    alphaResultObject = findobj(0, 'tag', 'alphaResult');
    shapeResultTextObject = findobj(0, 'tag', 'shapeResultText');
    shapeResultObject = findobj(0, 'tag', 'shapeResult');
    alphaResultTextObject = findobj(0, 'tag', 'alphaResultText');
    
    set(alphaResultObject, 'visible', 'off');
    set(shapeResultTextObject, 'visible', 'off');
    set(shapeResultObject, 'visible', 'off');
    set(alphaResultTextObject, 'visible', 'off');
    set(valuesPanelObject, 'visible', 'off');
end


% --- Executes during object creation, after setting all properties.
function browsedImgView_CreateFcn(hObject, eventdata, handles)

% --- Executes during object deletion, before destroying properties.
function browsedImgView_DeleteFcn(hObject, eventdata, handles)
