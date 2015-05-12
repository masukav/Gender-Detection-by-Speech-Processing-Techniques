function varargout = genderreco(varargin)
% GENDERRECO M-file for genderreco.fig
%      GENDERRECO, by itself, creates a new GENDERRECO or raises the existing
%      singleton*.
%
%      H = GENDERRECO returns the handle to a new GENDERRECO or the handle to
%      the existing singleton*.
%
%      GENDERRECO('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GENDERRECO.M with the given input arguments.
%
%      GENDERRECO('Property','Value',...) creates a new GENDERRECO or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before genderreco_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to genderreco_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help genderreco

% Last Modified by GUIDE v2.5 13-Apr-2013 14:03:23

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @genderreco_OpeningFcn, ...
                   'gui_OutputFcn',  @genderreco_OutputFcn, ...
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
% --- Executes just before genderreco is made visible.
function genderreco_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to genderreco (see VARARGIN)

% Choose default command line output for genderreco
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes genderreco wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = genderreco_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure


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
wavplay(y,16000);
cla;
axes(handles.axes1);
time = length(y)/fs;
if time == 0
    %the first, second and third lines of the message box
    msgboxText{1} = 'You have tried to estimate gender without recording signal';
    msgboxText{2} = 'Try recording a signal using record button';
    %this command actually creates the message box
   msgbox(msgboxText,'Signal recording not done', 'warn');
else
    ms20 = fs/50;
    t = (0:length(y)-1)/fs;
    plot(t,y);
    title('Waveform');
    xlabel('Time (s)');
    ylabel('Amplitude');
end
% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% --- Executes on button press in pushbutton3.

global x fs ms20 ms2 r time;
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
    r = xcorr(x, ms20, 'coeff');
    %plot autocorrelation
    d = (-ms20:ms20)/fs;
    plot(d, r);
    title('Autocorrelation');
    xlabel('Delay (s)');
    ylabel('Correlation coeff.');
    ms2 = fs/500; %maximum speech Fx at 500Hz
    ms20 = fs/50; %maximum speech Fx at 50Hz
    %just look at region corresponding to positive delays
    r = r(ms20 + 1 : 2*ms20+1);
    [rmax, tx] = max(r(ms2:ms20));
    Fx = fs/(ms2+tx-1);
    
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

