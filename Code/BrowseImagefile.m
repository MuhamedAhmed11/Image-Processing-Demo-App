function [filename, Pathname, choosenImg] = BrowseImagefile(orginalImgeAxesObject, imagePathPreviewObject)
% get static text object to use it later
imgPathAxesObject = findobj(0, 'tag', 'imgPath');
% clear any text on it 
set(imgPathAxesObject, 'string', '');
% To make user choose images only
[filename, Pathname] = uigetfile({'*.jpg;*.png;*.jpeg;*.JPG;*.PNG;*.JPEG;*.tif;*.TIF'}, 'File Selector');
% check if user click browse image and didn't choose any file
if Pathname ~= 0
    % Choosen file
    choosenImg = strcat(Pathname, filename);
    [fpth,name,ext] = fileparts(filename);
    % Check if user choose one of these extensions (image)
    if ext == ".jpg" || ext == ".JPG" || ext == ".jpeg" || ext == ".JPEG" || ext == ".png" || ext == ".PNG" || ext == ".tif" || ext == ".TIF"
        % set background of browse filename text object by green color
        % "which means browsed file is image"
        set(imagePathPreviewObject, 'BackgroundColor', [0 1 0]);
        set(imagePathPreviewObject, 'string', choosenImg);
        % display original image on it's axes
        axes(orginalImgeAxesObject);
        imshow(choosenImg);
    else 
        set(imagePathPreviewObject, 'string', choosenImg);
        % set background of browse filename text object by red color
        % "which means browsed file is not image"
        set(imagePathPreviewObject, 'BackgroundColor', [1 0 0]);
        % msg for user that there is an error
        promptMessage = sprintf('You did not choose image. try again?');
        titleBarCaption = 'ERROR!';
        % ask user if user wants to choose image again or not
        buttonText = questdlg(promptMessage, titleBarCaption, 'Ok', 'Quit', 'Ok');
        % if user clicks quit
        if contains(buttonText, 'Quit')
            % return all values, object to their intial states
            choosenImg = [];
            set(imagePathPreviewObject, 'string', '---');
            set(imagePathPreviewObject, 'BackgroundColor', [1 1 1]);
            return
            % if user clicks ok
        elseif contains(buttonText, 'Ok')
            choosenImg = [];
            % recalling browse function
            [filename,Pathname, choosenImg] = BrowseImagefile(orginalImgeAxesObject, imagePathPreviewObject);
            return
        end
        return
    end
else
    % msg for user that there is an error
    promptMessage = sprintf('You did not choose any image. try again?');
    titleBarCaption = 'ERROR!';
    % ask user if user wants to choose image again or not
    buttonText = questdlg(promptMessage, titleBarCaption, 'Ok', 'Quit', 'Ok');
    if contains(buttonText, 'Quit')
        choosenImg = [];
        set(imagePathPreviewObject, 'string', '---');
        set(imagePathPreviewObject, 'BackgroundColor', [1 1 1]);
        return
    elseif contains(buttonText, 'Ok')
        choosenImg = [];
        [filename,Pathname, choosenImg] = BrowseImagefile(orginalImgeAxesObject, imagePathPreviewObject);
        return
    end
end
end
