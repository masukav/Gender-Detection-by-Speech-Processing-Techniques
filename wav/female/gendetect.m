function varargout = gendetect(varargin)
%GENDETECT M-file for gendetect.fig
%      GENDETECT, by itself, creates a new GENDETECT or raises the existing
%      singleton*.
%
%      H = GENDETECT returns the handle to a new GENDETECT or the handle to
%      the existing singleton*.
%
%      GENDETECT('Property','Value',...) creates a new GENDETECT using the
%      given property value pairs. Unrecognized properties are passed via
%      varargin to gendetect_OpeningFcn.  This calling syntax produces a
%      warning when there is an existing singleton*.
%
%      GENDETECT('CALLBACK') and GENDETECT('CALLBACK',hObject,...) call the
%      local function named CALLBACK in GENDETECT.M with the given input
%      arguments.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES
% Edit the above text to modify the response to help gendetect
% Last Modified by GUIDE v2.5 13-Apr-2013 23:05:12
% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
'gui_Singleton',  gui_Singleton, ...
'gui_OpeningFcn', @gendetect_OpeningFcn, ...
'gui_OutputFcn',  @gendetect_OutputFcn, ...
'gui_LayoutFcn',  [], ...
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
% --- Executes just before gendetect is made visible.
function gendetect_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   unrecognized PropertyName/PropertyValue pairs from the
%            command line (see VARARGIN)
% Choose default command line output for gendetect
handles.output = hObject;
% Update handles structure
guidata(hObject, handles);
% UIWAIT makes gendetect wait for user response (see UIRESUME)
% uiwait(handles.figure1);
% --- Outputs from this function are returned to the command line.
function varargout = gendetect_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Get default command line output from handles structure
varargout{1} = handles.output;
% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global x fs ms20 ms2 r y time filename;
varargout{1} = handles.output;
[file_name file_path] = uigetfile ({'*.wav'});
if file_path ~= 0
filename = [file_path,file_name];
end
[y, fs]=wavread(filename);
wavplay(y,fs);
cla;
axes(handles.axes1);
time = length(y)/fs;
ms20 = fs/50;
t = (0:length(y)-1)/fs;
plot(t,y);
title('Waveform');
xlabel('Time (s)');
ylabel('Amplitude');
% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global x y fs ms20 ms2 r time;
axes(handles.axes2);
cla;
if time == 0
%the first, second and third lines of the message box
msgboxText{1} = 'You have tried to estimate gender without recording signal';
msgboxText{2} = 'Try recording a signal using record button';
%this command actually creates the message box
msgbox(msgboxText,'Signal recording not done', 'warn');
else
%calculate autocorrelation
r = xcorr(y, ms20, 'coeff');
%plot autocorrelation
d = (-ms20:ms20)/fs;
plot(d,r);
ms2 = fs/500; %maximum speech Fx at 500Hz
ms20 = fs/50; %maximum speech Fx at 50Hz
%just look at region corresponding to positive delays
r = r(ms20 + 1 : 2*ms20+1);
[rmax, ty] = max(r(ms2:ms20));
Fx = fs/(ms2+ty-1);
if Fx <= 175 && Fx >=80
set(handles.gender,'String', 'Male');
set(handles.Fx1,'String', num2str(round(Fx)));
guidata(hObject, handles);
elseif Fx>175 && Fx<=255
set(handles.gender,'String', 'Female');
set(handles.Fx1,'String', num2str(round(Fx)));
guidata(hObject, handles);
else
set(handles.gender,'String', 'Could not recognize. Try speaking slowly.');
set(handles.Fx1,'String', num2str(Fx));
guidata(hObject, handles);
end
end
function gender_Callback(hObject, eventdata, handles)
% hObject    handle to gender (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: get(hObject,'String') returns contents of gender as text
%        str2double(get(hObject,'String')) returns contents of gender as a double
% --- Executes during object creation, after setting all properties.
function gender_CreateFcn(hObject, eventdata, handles)
% hObject    handle to gender (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
set(hObject,'BackgroundColor','white');
end

function Fx1_Callback(hObject, eventdata, handles)
% hObject    handle to Fx1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Fx1 as text
%        str2double(get(hObject,'String')) returns contents of Fx1 as a double


% --- Executes during object creation, after setting all properties.
function Fx1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Fx1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
