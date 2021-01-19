function varargout = periodicNoiseTab(varargin)
% PERIODICNOISETAB MATLAB code for periodicNoiseTab.fig
%      PERIODICNOISETAB, by itself, creates a new PERIODICNOISETAB or raises the existing
%      singleton*.
%
%      H = PERIODICNOISETAB returns the handle to a new PERIODICNOISETAB or the handle to
%      the existing singleton*.
%
%      PERIODICNOISETAB('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PERIODICNOISETAB.M with the given input arguments.
%
%      PERIODICNOISETAB('Property','Value',...) creates a new PERIODICNOISETAB or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before periodicNoiseTab_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to periodicNoiseTab_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help periodicNoiseTab

% Last Modified by GUIDE v2.5 16-Jan-2021 18:21:46

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @periodicNoiseTab_OpeningFcn, ...
                   'gui_OutputFcn',  @periodicNoiseTab_OutputFcn, ...
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


% --- Executes just before periodicNoiseTab is made visible.
function periodicNoiseTab_OpeningFcn(hObject, eventdata, handles, varargin)
% Choose default command line output for periodicNoiseTab
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);




% --- Outputs from this function are returned to the command line.
function varargout = periodicNoiseTab_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --------------------------------------------------------------------
function Untitled_1_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in removeNoiseBtn.
function removeNoiseBtn_Callback(hObject, eventdata, handles)

checkNotch = findobj(0, 'tag', 'notchCheckBox');
checkBand = findobj(0, 'tag', 'bandCheckBox');
checkMask = findobj(0, 'tag', 'maskCheckBox');
methodResultObject = findobj(0, 'tag', 'methodResult');

global periodicNoisyImg;
global nxyValue;
global nxValue;
global nyValue;

% check if noise added to an image or not 
if isempty(periodicNoisyImg)
    msgbox('Please Choose image first');
    return
end

if checkNotch.Value == 1
    set(methodResultObject, 'string', 'Notch Filter');
    removePeriodicNoise(periodicNoisyImg, 'notch', handles);
    
elseif checkBand.Value == 1
    set(methodResultObject, 'string', 'Band Reject');
    removePeriodicNoise(periodicNoisyImg, 'band', handles);
    
elseif checkMask.Value == 1
    set(methodResultObject, 'string', 'Masking');
    removePeriodicNoise(periodicNoisyImg, 'mask', handles);
else
    msgbox('Please Choose Method first to remove noise');
end

function removePeriodicNoise(noisyImg, method, handles)
global nxyValue;
global nxValue;
global nyValue;

cleanImageAxesObject = findobj(0, 'tag', 'cleanImageView');
[noOfRows, noOfColumns] = size(noisyImg);
noisyImgFrequency = fftshift(fft2(noisyImg));
noisyImgMagnitude = log(abs(noisyImgFrequency));
[x, y] = meshgrid((-noOfColumns/2):((noOfColumns/2)-1),(-noOfRows/2):((noOfRows/2)-1)); %% A matrix of distances
z = sqrt(x.^2+y.^2);
centerX = round((noOfRows/2) + 1);
centerY = round((noOfColumns/2) + 1);


if method == "band"
    if nxValue > 0 && nyValue > 0
        val1 = z((centerX + nxValue), (centerY + nyValue));
        val2 = z((centerX - nxValue), (centerY - nyValue));
        br = (z < (val1 - 2) | z > (val1 + 2)); % reject band of frequencies around spikes
        imgFourierBinary = noisyImgFrequency.*br;
        axes(handles.cleanImageView);
        fl = log(1+abs(ifft2(imgFourierBinary)));
        fm = max(fl(:));
        imshow(im2uint8(fl/fm))
        return
    elseif nxValue > 0 && nyValue == 0
        val1 = z((centerX), (centerY + nxValue));
        val2 = z((centerX), (centerY - nxValue));
        br = (z < (val1 - 2) | z > (val1 + 2)); % reject band of frequencies around spikes
        imgFourierBinary = noisyImgFrequency.*br;
        axes(handles.cleanImageView);
        fl = log(1 + abs(ifft2(imgFourierBinary)));
        fm = max(fl(:));
        imshow(im2uint8(fl/fm))
        return
    elseif nyValue > 0 && nxValue == 0
        val1 = z((centerX + nyValue), (centerY));
        val2 = z((centerX - nyValue), (centerY));
        br = (z < (val1 - 2) | z > (val1 + 2)); % reject band of frequencies around spikes
        imgFourierBinary = noisyImgFrequency.*br;
        axes(handles.cleanImageView);
        fl = log(1 + abs(ifft2(imgFourierBinary)));
        fm = max(fl(:));
        imshow(im2uint8(fl/fm))
        return
    end
       
elseif method == "notch"
    % if noise in x, y directions
    if nxValue > 0 && nyValue > 0
        val1 = z((centerX + nxValue), (centerY + nyValue));
        val2 = z((centerX - nxValue), (centerY - nyValue));
        [xVal1, yVal1] = find(z == val1);
        [xVal2, yVal2] = find(z == val2);
        noisyImgFrequency(xVal1, :) = 0;
        noisyImgFrequency(xVal2, :) = 0;
        noisyImgFrequency(:, yVal1) = 0;
        noisyImgFrequency(:, yVal2) = 0;
        axes(handles.cleanImageView);
        fl = log(1+abs(ifft2(noisyImgFrequency)));
        fm = max(fl(:));
        imshow(im2uint8(fl/fm))
        return
        % if noise in x direction
    elseif nxValue > 0 && nyValue == 0
        val1 = z((centerX), (centerY + nxValue));
%         val2 = z((centerX), (centerY - nxValue));
        [xVal1, yVal1] = find(z == val1);
%         [xVal2, yVal2] = find(z == val2);
        for i = 1:length(xVal1)
            if xVal1(i) ~= centerX
                noisyImgFrequency(xVal1(i), :) = 0;
            end
            if yVal1(i) ~= centerY
                noisyImgFrequency(:, yVal1(i)) = 0;
            end
        end
%         noisyImgFrequency(xVal2, :) = 0;
%         noisyImgFrequency(:, yVal2) = 0;
        axes(handles.cleanImageView);
        fl = log(1+abs(ifft2(noisyImgFrequency)));
        fm = max(fl(:));
        imshow(im2uint8(fl/fm))
        return
        % if noise in y direction
    elseif nyValue > 0 && nxValue == 0
        val1 = z((centerX + nyValue), (centerY));
%         val2 = z((centerX - nyValue), (centerY));
        [xVal1, yVal1] = find(z == val1);
%         [xVal2, yVal2] = find(z == val2);
        
        for i = 1:length(xVal1)
            if xVal1(i) ~= centerX
                noisyImgFrequency(xVal1(i), :) = 0;
            end
            if yVal1(i) ~= centerY
                noisyImgFrequency(:, yVal1(i)) = 0;
            end
        end        
%         noisyImgFrequency(:, yVal1) = 0;
%         noisyImgFrequency(:, yVal2) = 0;
        axes(handles.cleanImageView);
        fl = log(1+abs(ifft2(noisyImgFrequency)));
        fm = max(fl(:));
        imshow(im2uint8(fl/fm))
        return
    end


elseif method == "mask"
    % Filtering in Fourier Domain
    % Mask 1 inputs     
    xAxisMask1InputObject = findobj(0, 'tag', 'xAxisMask1Input');
    yAxisMask1InputObject = findobj(0, 'tag', 'yAxisMask1Input');
    % Mask 2 inputs 
    xAxisMask2InputObject = findobj(0, 'tag', 'xAxisMask2Input');
    yAxisMask2InputObject = findobj(0, 'tag', 'yAxisMask2Input');
    %
    mask1ResultObject = findobj(0, 'tag', 'mask1Result');
    mask2ResultObject = findobj(0, 'tag', 'mask2Result');
    %%% Mask 
    mask = ones(size(noisyImgMagnitude));
    
    % getting inputs from user by mouse click
    axes(handles.fourierNoisyImgView);
    [x, y] = ginput(2);
    xVal1 = round(y(1));
    yVal1 = round(x(1));
    xVal2 = round(y(2));
    yVal2 = round(x(2));
    if nxValue > 0 && nyValue > 0
        set(xAxisMask1InputObject, 'string', xVal1);
        set(yAxisMask1InputObject, 'string', yVal1);
        set(xAxisMask2InputObject, 'string', xVal2);
        set(yAxisMask2InputObject, 'string', yVal2);
        
        mask(xVal1, yVal1) = 0;
        mask(xVal2, yVal2) = 0;
        %
        msk = num2str([xVal1 yVal1]);
        msk = ['(', msk, ')'];
        set(mask1ResultObject, 'string', msk);
        %
        msk2 = num2str([xVal2 yVal2]);
        msk2 = ['(', msk2, ')'];
        set(mask2ResultObject, 'string', msk2);
        %
        filtered = mask.*noisyImgFrequency;
        filteredImage = ifft2(ifftshift(filtered));
        ampFilteredImage = abs(filteredImage);
        minValue = min(min(ampFilteredImage));
        maxValue = max(max(ampFilteredImage));
        axes(handles.cleanImageView);
        imshow(ampFilteredImage, [minValue maxValue]);
        return
    end
    if nxValue > 0 && nyValue == 0
        set(xAxisMask1InputObject, 'string', xVal1);
        set(yAxisMask1InputObject, 'string', yVal1);
        set(xAxisMask2InputObject, 'string', xVal2);
        set(yAxisMask2InputObject, 'string', yVal2);
        mask(xVal1, yVal1) = 0;
        mask(xVal2, yVal2) = 0;
        %
        msk = num2str([xVal1 yVal1]);
        msk = ['(', msk, ')'];
        set(mask1ResultObject, 'string', msk);
        %
        msk2 = num2str([xVal2 yVal2]);
        msk2 = ['(', msk2, ')'];
        set(mask2ResultObject, 'string', msk2);
        %
        filtered = mask.*noisyImgFrequency;
        filteredImage = ifft2(ifftshift(filtered));
        ampFilteredImage = abs(filteredImage);
        minValue = min(min(ampFilteredImage));
        maxValue = max(max(ampFilteredImage));
        axes(handles.cleanImageView);
        imshow(ampFilteredImage, [minValue maxValue]);
        return
    end
    if nxValue == 0 && nyValue > 0
        set(xAxisMask1InputObject, 'string', xVal1);
        set(yAxisMask1InputObject, 'string', yVal1);
        set(xAxisMask2InputObject, 'string', xVal2);
        set(yAxisMask2InputObject, 'string', yVal2);
        mask(xVal1, yVal1) = 0;
        mask(xVal2, yVal2) = 0;
        %
        msk = num2str([xVal1 yVal1]);
        msk = ['(', msk, ')'];
        set(mask1ResultObject, 'string', msk);
        %
        msk2 = num2str([xVal2 yVal2]);
        msk2 = ['(', msk2, ')'];
        set(mask2ResultObject, 'string', msk2);
        %
        filtered = mask.*noisyImgFrequency;
        filteredImage = ifft2(ifftshift(filtered));
        ampFilteredImage = abs(filteredImage);
        minValue = min(min(ampFilteredImage));
        maxValue = max(max(ampFilteredImage));
        axes(handles.cleanImageView);
        imshow(ampFilteredImage, [minValue maxValue]);
        return
    end
end

% --- Executes on button press in sineCheckBox.
function sineCheckBox_Callback(hObject, eventdata, handles)
if get(hObject, 'Value') == get(hObject, 'Max')
    set(handles.cosineCheckBox, 'Value', 0);
else
    set(hObject, 'Value', 0);
end

% --- Executes on button press in cosineCheckBox.
function cosineCheckBox_Callback(hObject, eventdata, handles)
if get(hObject, 'Value') == get(hObject, 'Max')
    set(handles.sineCheckBox, 'Value', 0);
else
    set(hObject, 'Value', 0);
end

function nxInput_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function nxInput_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function nyInput_Callback(hObject, eventdata, handles)
% hObject    handle to nxInput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of nxInput as text
%        str2double(get(hObject,'String')) returns contents of nxInput as a double


% --- Executes during object creation, after setting all properties.
function nyInput_CreateFcn(hObject, eventdata, handles)
% hObject    handle to nxInput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in addNoiseBtn.
function addNoiseBtn_Callback(hObject, eventdata, handles)
global Filename;
global Pathname;
global yourImg;
yourImg = strcat(Pathname, Filename);
yourImg = imread(yourImg);
if size(yourImg, 3) == 3
    yourImg = rgb2gray(yourImg);
end
nxResultObject = findobj(0, 'tag', 'nxResult');
nyResultObject = findobj(0, 'tag', 'nyResult');
waveShapeResultObject = findobj(0, 'tag', 'waveShapeResult');
checkSine = findobj(0, 'tag', 'sineCheckBox');
checkCosine = findobj(0, 'tag', 'cosineCheckBox');
nxValueInputObject = findobj(0, 'tag', 'nxInput');
nyValueInputObject = findobj(0, 'tag', 'nyInput');
global nxValue;
global nyValue;
nxValue = get(nxValueInputObject, 'string');
nyValue = get(nyValueInputObject, 'string');
temp1 = nxValue;
temp2 = nyValue;
nxValue = str2double(char(nxValue));
nyValue = str2double(char(nyValue));

if checkSine.Value == 1
    set(waveShapeResultObject, 'string', 'Sine');
    if nxValue > 0 && nyValue > 0
        addingPeriodicNosie(1,'b', yourImg, nxValue, nyValue, handles);
        set(nxResultObject, 'string', nxValue);
        set(nyResultObject, 'string', nyValue);
    %    
    elseif nxValue > 0 && nyValue < 0
        set(nxResultObject, 'string', nxValue);
        msgbox('ny must be a positive number');
    %
    elseif nxValue == 0 && nyValue == 0
        addingPeriodicNosie(1, 'b', yourImg, nxValue, nyValue, handles);
        set(nxResultObject, 'string', nxValue);
        set(nyResultObject, 'string', nyValue);
        msgbox('WARNING! You enterd a both values with zeros so image will not be noisy.');
    %  
    elseif nxValue == 0 && nyValue < 0
        set(nxResultObject, 'string', nxValue);
        msgbox('WARNING! Ny Must be a Positive Value.');
    %
    elseif nxValue < 0 && nyValue == 0
        set(nyResultObject, 'string', nyValue);
        msgbox('WARNING! Nx Must be a Positive Value.');
    %
    elseif nxValue == 0 && nyValue > 0
        addingPeriodicNosie(1, 'y', yourImg, nxValue, nyValue, handles);
        set(nxResultObject, 'string', nxValue);
        set(nyResultObject, 'string', nyValue);
    % 
    elseif nxValue > 0 && nyValue == 0
        addingPeriodicNosie(1, 'x', yourImg, nxValue, nyValue, handles);
        set(nxResultObject, 'string', nxValue);
        set(nyResultObject, 'string', nyValue);
    %  
    elseif nxValue < 0 && nyValue > 0
        set(nyResultObject, 'string', nyValue);
        msgbox('nx must be a positive number');    
    %    
    elseif nxValue < 0 && nyValue < 0
        msgbox('nx, ny must be positive numbers');
    %
    elseif temp1 == "" && nyValue > 0
        set(nyResultObject, 'string', nyValue);
        msgbox('Please enter a value for nx');
    %    
    elseif temp1 == "" && nyValue < 0
        msgbox('Please enter a value for nx');
        msgbox('ny must be positive number');
    %
    elseif nxValue > 0 && temp2 == ""
        set(nxResultObject, 'string', nxValue);
        msgbox('Please enter a value for ny');
    %    
    elseif nxValue < 0 && temp2 == ""
        msgbox('nx must be positive number');        
        msgbox('Please enter a value for ny');
    %    
    elseif temp1 == "" && temp2 == ""
        msgbox('Please enter a value for nx, ny'); 
    %    
    else 
        msgbox('Both nx, ny values are invalid'); 
    end
    
elseif checkCosine.Value == 1
    set(waveShapeResultObject, 'string', 'Cosine');
    if nxValue > 0 && nyValue > 0
        addingPeriodicNosie(2, 'b', yourImg, nxValue, nyValue, handles);
        set(nxResultObject, 'string', nxValue);
        set(nyResultObject, 'string', nyValue);
    %
    elseif nxValue > 0 && nyValue < 0
        set(nxResultObject, 'string', nxValue);
        msgbox('Ny must be a positive number');
    %    
    elseif nxValue == 0 && nyValue == 0
        addingPeriodicNosie(2, 'b', yourImg, nxValue, nyValue, handles);
        set(nxResultObject, 'string', nxValue);
        set(nyResultObject, 'string', nyValue);
        msgbox('WARNING! You enterd a both values with zeros so image will not be noisy.');
    %  
    elseif nxValue == 0 && nyValue < 0
        set(nxResultObject, 'string', nxValue);
        msgbox('WARNING! Ny Must be a Positive Value.');
    %
    elseif nxValue < 0 && nyValue == 0
        set(nyResultObject, 'string', nyValue);
        msgbox('WARNING! Nx Must be a Positive Value.');
    %
    elseif nxValue == 0 && nyValue > 0
        addingPeriodicNosie(2, 'y', yourImg, nxValue, nyValue, handles);
        set(nxResultObject, 'string', nxValue);
        set(nyResultObject, 'string', nyValue);
    % 
    elseif nxValue > 0 && nyValue == 0
        addingPeriodicNosie(2, 'x', yourImg, nxValue, nyValue, handles);
        set(nxResultObject, 'string', nxValue);
        set(nyResultObject, 'string', nyValue);
    %
    elseif nxValue < 0 && nyValue > 0
        set(nyResultObject, 'string', nyValue);
        msgbox('nx must be a positive number');    
    %    
    elseif nxValue < 0 && nyValue < 0
        msgbox('nx, ny must be positive numbers');
    %
    elseif temp1 == "" && nyValue > 0
        set(nyResultObject, 'string', nyValue);
        msgbox('Please enter a value for nx');
    %    
    elseif temp1 == "" && nyValue < 0
        msgbox('Please enter a value for nx');
        msgbox('ny must be positive number');
    %
    elseif nxValue > 0 && temp2 == ""
        set(nxResultObject, 'string', nxValue);
        msgbox('Please enter a value for ny');
    %    
    elseif nxValue < 0 && temp2 == ""
        msgbox('nx must be positive number');        
        msgbox('Please enter a value for ny');
    %    
    elseif temp1 == "" && temp2 == ""
        msgbox('Please enter a value for nx, ny'); 
    %    
    else 
        msgbox('Both nx, ny values are invalid'); 
    end
    
else
    msgbox('Please Choose a Wave Shape first!');
end

function addingPeriodicNosie(value, direction, img, nxValue, nyValue, handles)
global periodicNoisyImg;
imgSize = size(img);
[x, y]= meshgrid(1:imgSize(2),1:imgSize(1));
Wx = max(max(x));
Wy = max(max(y));
% user chose x-direction
if direction == 'x'
    fx = nxValue/Wx;
    % if user chose sine
    if value == 1
        px = sin(2*pi*fx*x)+1;
    % if user chose cosine    
    elseif value == 2
        px = cos(2*pi*fx*x)+1;
    end    
    periodicNoisyImg = mat2gray((im2double(img)+px));
% user chose y-direction   
elseif direction == 'y'
    fy = nyValue/Wy;
    % if user chose sine
    if value == 1
        py = sin(2*pi*fy*y)+1;
    % if user chose cosine 
    elseif value == 2
        py = cos(2*pi*fy*y)+1;
    end    
    periodicNoisyImg = mat2gray((im2double(img)+py));
% user chose both direction    
elseif direction == 'b'
    fx = nxValue/Wx;
    fy = nyValue/Wy;
    if value == 1
        % if user chose sine
        pxy = sin(2*pi*(fx*x + fy*y))+1;
    elseif value == 2
        % if user chose cosine
        pxy = cos(2*pi*(fx*x + fy*y))+1;
    end
    periodicNoisyImg = mat2gray((im2double(img)+pxy));
end
% Display Nosiy Image
axes(handles.noisyImgView);
imshow(periodicNoisyImg);
noisyImgFrequency = fftshift(fft2(periodicNoisyImg));
% Display Fourier of Nosiy Image
axes(handles.fourierNoisyImgView);
fl = log(1+abs((noisyImgFrequency)));
fm = max(fl(:));
imshow(im2uint8(fl/fm))


% --- Executes on button press in bandCheckBox.
function bandCheckBox_Callback(hObject, eventdata, handles)
mask1InputtObject = findobj(0, 'tag', 'mask1Panel');
mask2InputtObject = findobj(0, 'tag', 'mask2Panel');

if get(hObject, 'Value') == get(hObject, 'Max')
    set(handles.notchCheckBox, 'Value', 0);
    set(handles.maskCheckBox, 'Value', 0);
    set(mask1InputtObject, 'visible', 'off');
    set(mask2InputtObject, 'visible', 'off');
else
    set(hObject, 'Value', 0);
end


% --- Executes on button press in notchCheckBox.
function notchCheckBox_Callback(hObject, eventdata, handles)
mask1InputtObject = findobj(0, 'tag', 'mask1Panel');
mask2InputtObject = findobj(0, 'tag', 'mask2Panel');
if get(hObject, 'Value') == get(hObject, 'Max')
    set(handles.bandCheckBox, 'Value', 0);
    set(handles.maskCheckBox, 'Value', 0);
    set(mask1InputtObject, 'visible', 'off');
    set(mask2InputtObject, 'visible', 'off');
else
    set(hObject, 'Value', 0);
end


% --- Executes on button press in maskCheckBox.
function maskCheckBox_Callback(hObject, eventdata, handles)
mask1InputtObject = findobj(0, 'tag', 'mask1Panel');  
mask2InputtObject = findobj(0, 'tag', 'mask2Panel');
%
mask1TextResultObject = findobj(0, 'tag', 'mask1TextResult');  
mask1ResultObject = findobj(0, 'tag', 'mask1Result');
mask2TextResultObject = findobj(0, 'tag', 'mask2TextResult');  
mask2ResultObject = findobj(0, 'tag', 'mask2Result');

if get(hObject, 'Value') == get(hObject, 'Max')
    set(handles.bandCheckBox, 'Value', 0);
    set(handles.notchCheckBox, 'Value', 0);
    set(mask1InputtObject, 'visible', 'on');
    set(mask2InputtObject, 'visible', 'on');
    %
    set(mask1TextResultObject, 'visible', 'on');
    set(mask1ResultObject, 'visible', 'on');
    set(mask2TextResultObject, 'visible', 'on');
    set(mask2ResultObject, 'visible', 'on');
else
    set(hObject, 'Value', 0);
    mask1InputtObject = findobj(0, 'tag', 'mask1Panel');
    set(mask1InputtObject, 'visible', 'off');
    set(mask2InputtObject, 'visible', 'off');
    %
    set(mask1TextResultObject, 'visible', 'off');
    set(mask1ResultObject, 'visible', 'off');
    set(mask2TextResultObject, 'visible', 'off');
    set(mask2ResultObject, 'visible', 'off');
end


% --- Executes on button press in backBtn.
function backBtn_Callback(hObject, eventdata, handles)
%free browsed image before closing
global yourImg;
%global noisyImg;
yourImg = [];
%noisyImg = [];
%opening menu
menu;
%delete curreunt page to be unseen to user
periodicNoiseTabObject = findobj(0, 'tag', 'periodicNoiseTab');
delete(periodicNoiseTabObject);


% --- Executes on button press in browseBtn.
function browseBtn_Callback(hObject, eventdata, handles)
% hObject    handle to browseBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Filename;
global Pathname;
global yourImg;
imgPathAxesObject = findobj(0, 'tag', 'imgPath');
[Filename, Pathname, yourImg] = BrowseImagefile(handles.originalImgView, imgPathAxesObject);

% --- Executes during object creation, after setting all properties.
function imgPath_CreateFcn(hObject, eventdata, handles)
% hObject    handle to imgPath (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called



function edit6_Callback(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit6 as text
%        str2double(get(hObject,'String')) returns contents of edit6 as a double


% --- Executes during object creation, after setting all properties.
function edit6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit7_Callback(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit7 as text
%        str2double(get(hObject,'String')) returns contents of edit7 as a double


% --- Executes during object creation, after setting all properties.
function edit7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit11_Callback(hObject, eventdata, handles)
% hObject    handle to edit11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit11 as text
%        str2double(get(hObject,'String')) returns contents of edit11 as a double


% --- Executes during object creation, after setting all properties.
function edit11_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit12_Callback(hObject, eventdata, handles)
% hObject    handle to edit12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit12 as text
%        str2double(get(hObject,'String')) returns contents of edit12 as a double


% --- Executes during object creation, after setting all properties.
function edit12_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function xAxisMask1Input_Callback(hObject, eventdata, handles)
% hObject    handle to xAxisMask1Input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of xAxisMask1Input as text
%        str2double(get(hObject,'String')) returns contents of xAxisMask1Input as a double


% --- Executes during object creation, after setting all properties.
function xAxisMask1Input_CreateFcn(hObject, eventdata, handles)
% hObject    handle to xAxisMask1Input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function yAxisMask1Input_Callback(hObject, eventdata, handles)
% hObject    handle to yAxisMask1Input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of yAxisMask1Input as text
%        str2double(get(hObject,'String')) returns contents of yAxisMask1Input as a double


% --- Executes during object creation, after setting all properties.
function yAxisMask1Input_CreateFcn(hObject, eventdata, handles)
% hObject    handle to yAxisMask1Input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function cleanImageView_CreateFcn(hObject, eventdata, handles)
% hObject    handle to cleanImageView (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate cleanImageView



function xAxisMask2Input_Callback(hObject, eventdata, handles)
% hObject    handle to xAxisMask2Input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of xAxisMask2Input as text
%        str2double(get(hObject,'String')) returns contents of xAxisMask2Input as a double


% --- Executes during object creation, after setting all properties.
function xAxisMask2Input_CreateFcn(hObject, eventdata, handles)
% hObject    handle to xAxisMask2Input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function yAxisMask2Input_Callback(hObject, eventdata, handles)
% hObject    handle to yAxisMask2Input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of yAxisMask2Input as text
%        str2double(get(hObject,'String')) returns contents of yAxisMask2Input as a double


% --- Executes during object creation, after setting all properties.
function yAxisMask2Input_CreateFcn(hObject, eventdata, handles)
% hObject    handle to yAxisMask2Input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function sineCheckBox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sineCheckBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on mouse press over axes background.
function fourierNoisyImgView_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to fourierNoisyImgView (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% coordinates = get(handles.fourierNoisyImgView,'CurrentPoint'); 
% coordinates = coordinates(1,1:2);
% disp(coordinates)


% --- Executes on mouse press over axes background.
function noisyImgView_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to noisyImgView (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
