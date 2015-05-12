function varargout = genderrec(varargin)
% GENDERREC MATLAB code for genderrec.fig
%      GENDERREC, by itself, creates a new GENDERREC or raises the existing
%      singleton*.
%
%      H = GENDERREC returns the handle to a new GENDERREC or the handle to
%      the existing singleton*.
%
%      GENDERREC('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GENDERREC.M with the given input arguments.
%
%      GENDERREC('Property','Value',...) creates a new GENDERREC or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before genderrec_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to genderrec_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help genderrec

% Last Modified by GUIDE v2.5 13-Apr-2013 23:31:08

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @genderrec_OpeningFcn, ...
                   'gui_OutputFcn',  @genderrec_OutputFcn, ...
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


% --- Executes just before genderrec is made visible.
function genderrec_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to genderrec (see VARARGIN)

% Choose default command line output for genderrec
handles.output = hObject;

% Update handles structure
global x fs ms20 ms2 r;
x = ones(9600,1);
set(hObject, 'toolbar', 'figure');
guidata(hObject, handles);

% UIWAIT makes genderrec wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = genderrec_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton_plotSignal.
function pushbutton_plotSignal_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_plotSignal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global x fs ms20;
axes(handles.axes1);
cla;
time = get(handles.time_slider,'Value');
if time == 0
    %the first, second and third lines of the message box
    msgboxText{1} = 'You have tried to plot a signal without recording one';
    msgboxText{2} = 'Try recording a signal using record button';
    %this command actually creates the message box
   msgbox(msgboxText,'Signal recording not done', 'warn');
else
    fs = 10000;
    ms20 = fs/50;
    t = (0:length(x)-1)/fs;
    plot(t,x);
    title('Waveform');
    xlabel('Time (s)');
    ylabel('Amplitude');
end
guidata(hObject, handles);


% --- Executes on button press in pushbutton_record.
function pushbutton_record_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_record (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global x;
time = get(handles.time_slider,'Value');
x = wavrecord(time*8000,8000);
set(handles.gender,'String','See the estimated gender here');
set(handles.Fx1,'String', 'Fundamental Frequency');
guidata(hObject, handles);


% --- Executes on button press in estimateGender.
function estimateGender_Callback(hObject, eventdata, handles)
% hObject    handle to estimateGender (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global x fs ms20 ms2 r;
axes(handles.axes2);
cla;
time = get(handles.time_slider,'Value');
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


% --- Executes on button press in Play.
function Play_Callback(hObject, eventdata, handles)
% hObject    handle to Play (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global x;
time = get(handles.time_slider,'Value');
if time == 0
    %the first, second and third lines of the message box
    msgboxText{1} = 'You have tried to play without recording signal';
    msgboxText{2} = 'Try recording a signal using record button';
    %this command actually creates the message box
   msgbox(msgboxText,'Signal recording not done', 'warn');
else
    wavplay(x,8000);
    guidata(hObject, handles);
end


% --- Executes on slider movement.
function time_slider_Callback(hObject, eventdata, handles)
% hObject    handle to time_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
time = get(handles.time_slider,'Value');
set(handles.time_text, 'String', num2str(time));
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function time_slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to time_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
