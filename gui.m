function varargout = gui(varargin)
% GUI MATLAB code for gui.fig
%      GUI, by itself, creates a new GUI or raises the existing
%      singleton*.
%
%      H = GUI returns the handle to a new GUI or the handle to
%      the existing singleton*.
%
%      GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI.M with the given input arguments.
%
%      GUI('Property','Value',...) creates a new GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help gui

% Last Modified by GUIDE v2.5 18-Mar-2017 14:47:15

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @gui_OpeningFcn, ...
                   'gui_OutputFcn',  @gui_OutputFcn, ...
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


% --- Executes just before gui is made visible.
function gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to gui (see VARARGIN)

% Choose default command line output for gui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = gui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbuttonLoadCSV.
function pushbuttonLoadCSV_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonLoadCSV (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.filename = uigetfile('*.csv');
guidata(hObject, handles);
setPopupMenuString(handles.popupmenuX, eventdata, handles); % custom function
setPopupMenuString(handles.popupmenuY, eventdata, handles); % custom function
set(handles.popupmenuX, 'callback', 'gui(''updateAxes'',gcbo, [], guidata(gcbo))');
set(handles.popupmenuY, 'callback', 'gui(''updateAxes'',gcbo, [], guidata(gcbo))');

function setPopupMenuString(hObject, eventdata, handles)    % define custom function
filename = handles.filename;
fid = fopen(filename);
Headerline = 5;   % remember to check
for n = 1:Headerline
  fgetl(fid);
end
colNames = strsplit(fgetl(fid), ',');
fclose(fid);
set(hObject, 'string', colNames);

function [x, y] = parsedata(filename, xColNum, yColNum)  
%filename = handles.filename;
fid = fopen(filename);
Headerline = 7;   % remember to check
for n = 1:Headerline
  fgetl(fid);
end
data = textscan(fid,'%f%f%f%f%f%f%f', 'Delimiter', ','); % headerline doesn't work here due to empty cells
fclose(fid);
x = data{1, xColNum};
y = data{1, yColNum};


function updateAxes(hObject, eventdata, handles)
xColNum  = get(handles.popupmenuX, 'value');
yColNum  = get(handles.popupmenuY, 'value');
filename = handles.filename;
fid = fopen(filename);
Headerline = 6;   % remember to check
for n = 1:Headerline
  fgetl(fid);
end
unit = strsplit(fgetl(fid), ',');
[x, y] = parsedata(filename, xColNum, yColNum);
plot(handles.axes1, x, y, 'o', 'linewidth', 0.5);
set(gca, 'box', 'off', 'XMinorTick', 'on', 'YMinorTick', 'on');
set(handles.ylabel, 'string', unit(yColNum));
set(handles.xlabel, 'string', unit(xColNum));



% --- Executes on selection change in popupmenuX.
function popupmenuX_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenuX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenuX contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenuX


% --- Executes during object creation, after setting all properties.


% --- Executes on selection change in popupmenuY.
function popupmenuY_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenuY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenuY contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenuY


% --- Executes during object creation, after setting all properties.
function popupmenuX_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenuX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function popupmenuY_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenuY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
