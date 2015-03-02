function varargout = AudioSpectrum(varargin)


gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @AudioSpectrum_OpeningFcn, ...
                   'gui_OutputFcn',  @AudioSpectrum_OutputFcn, ...
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



% --- Executes just before AudioSpectrum is made visible.
function AudioSpectrum_OpeningFcn(hObject, eventdata, handles, varargin)

handles.output = hObject;

% Set analog input to empty values
handles.AI = [];
 handles.x=[];
% Basic variables

handles.NFFT = 4096;
 handles.spec_len = 20;

% Initialize axis for waveform
axes(handles.a_waveform);
handles.a_waveform_line = plot(0,0,'');
grid on;
 xlabel('{Time} [ms] ');
 ylabel('{Voltage}[{V}] ');

title('Time series');

% Initialize axis for spectrum
axes(handles.a_modul);
handles.a_modul_line = plot(0,0,'');
grid on;
xlabel('{\itf} [Hz] ');
ylabel(' [{Db}]');
title('Frequency Spectrum');

% Initialize axis for spectrogram
axes(handles.a_spec);
xlabel('{Frequency} [Hz]');
ylabel('Time [ms]');
title('Spectrogram');
% 
% set(hObject,'RendererMode','Manual')  %  If you don't do this, the surface plot
% set(hObject,'Renderer','OpenGL')      %    will draw VERY slowly.

% Update handles structure
guidata(hObject, handles);




% --- Executes on button press in Load.
function Load_Callback(hObject, eventdata, handles)

% hObject    handle to Load (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%filename=uigetfile({'*.wav'},'File selector');
clc;

    [FileName,PathName] = uigetfile({'*.wav'},'Load Wav File');
    [x,fs] = wavread([PathName '/' FileName]);
    
    handles.x = x;
    handles.fs = fs;
    
    axes(handles.a_waveform);
    time = 0:1/fs:(length(handles.x)-1)/fs;
    
    plot(time,handles.x);
     xlabel('{Time} [ms] ');
     ylabel('{Voltage}[{V}] ');
     title('Tiem Series');
    
     axes(handles.a_spec);
       xlabel('{\itf} [Hz] ');
        ylabel(' [{Db}]');
     specgram(handles.x, 4096, handles.fs);
     title('Spectrogram ');
     
    clc;
    %X = 20*log10(abs(fft(handles.x,handles.NFFT)));
    X = 10*log10(abs(fft(handles.x,handles.NFFT)));
    X = X(1:end/2);
    f = linspace(0,str2double(get(handles.e_fs, 'String'))/2,length(X));

    set(handles.a_modul_line, 'XData', f, 'YData', X);
     xlabel('{\itf} [Hz] ');
        ylabel(' [{Db}]');
    % Find peak in spectrum
    pos = find(X == max(X));
    set(handles.e_max, 'String', num2str(f(pos(1))));
    
guidata(hObject,handles);



% --- Executes on button press in ch_waveform.
function ch_waveform_Callback(hObject, eventdata, handles)
% hObject    handle to ch_waveform (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of ch_waveform


% --- Executes on button press in ch_modul.
function ch_modul_Callback(hObject, eventdata, handles)
% hObject    handle to ch_modul (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of ch_modul


% --- Executes on button press in ch_spec.
function ch_spec_Callback(hObject, eventdata, handles)
% hObject    handle to ch_spec (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of ch_spec



function e_len_Callback(hObject, eventdata, handles)
% hObject    handle to e_len (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of e_len as text
%        str2double(get(hObject,'String')) returns contents of e_len as a double


% --- Executes during object creation, after setting all properties.
function e_len_CreateFcn(hObject, eventdata, handles)
% hObject    handle to e_len (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function e_fs_Callback(hObject, eventdata, handles)
% hObject    handle to e_fs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of e_fs as text
%        str2double(get(hObject,'String')) returns contents of e_fs as a double


% --- Executes during object creation, after setting all properties.
function e_fs_CreateFcn(hObject, eventdata, handles)
% hObject    handle to e_fs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function e_max_Callback(hObject, eventdata, handles)
% hObject    handle to e_max (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of e_max as text
%        str2double(get(hObject,'String')) returns contents of e_max as a double


% --- Executes during object creation, after setting all properties.
function e_max_CreateFcn(hObject, eventdata, handles)
% hObject    handle to e_max (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in b_start.
function b_start_Callback(hObject, eventdata, handles)
% hObject    handle to b_start (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)




% --- Executes on button press in b_stop.
function b_stop_Callback(hObject, eventdata, handles)
% hObject    handle to b_stop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

function dis_en_start(handles)

set(handles.e_len, 'Enable', 'off');
set(handles.e_fs, 'Enable', 'off');

function dis_en_stop(handles)

set(handles.e_len, 'Enable', 'on');
set(handles.e_fs, 'Enable', 'on');

% function handles = init_ai(hObject, handles)
% 
% Create a device object
% AI = analoginput('winsound');
% 
% % Add channels
% chan = addchannel(AI,1);

% Configure property values
duration = str2double(get(handles.e_len, 'String'))/1000;
fs = str2double(get(handles.e_fs, 'String'));

data.handles = handles;
data.spec = zeros(handles.NFFT/2, handles.spec_len);

% set(AI,'SampleRate',fs);
% set(AI,'SamplesPerTrigger',duration*fs);
% set(AI,'TriggerRepeat',inf);
% set(AI,'TriggerFcn',@process_signal);
% set(AI,'UserData',data);
% 
% set(AI, 'TimerFcn', @process_signal);
% set(AI, 'SampleRate', fs);
% set(AI, 'SamplesPerTrigger', duration*fs);
% set(AI, 'TriggerRepeat', 1);
% set(AI, 'TriggerType', 'manual');
% set(AI,'UserData',data);
% set(AI, 'TimerPeriod', 0.01);  
% set(AI, 'BufferingConfig',[duration*fs*2,20]);
% 
% handles.AI = AI;
guidata(hObject, handles);

function process_signal(obj, event)
% global x;
% % Get handles
% user_data = get(obj,'UserData');
% handles = user_data.handles;
% spec = user_data.spec;
% 
% % Read data
% warning off;
% data = peekdata(obj,obj.SamplesPerTrigger);
% warning on;
% x = flipud(data);

% Display new characteristics
% if(get(handles.ch_waveform, 'Value'))
%     disp_waveform(x, handles);
% end
% if(get(handles.ch_modul, 'Value'))
%     disp_modul(x, handles);
% end
% if(get(handles.ch_spec, 'Value'))
%     user_data.spec = disp_spec(x, handles, spec);
%     set(obj,'UserData',user_data);
% end

% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1


% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function slider2_Callback(hObject, eventdata, handles)
% hObject    handle to slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes during object creation, after setting all properties.
function ch_waveform_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ch_waveform (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function ch_modul_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ch_modul (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function ch_spec_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ch_spec (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function b_start_CreateFcn(hObject, eventdata, handles)
% hObject    handle to b_start (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on button press in checkbox4.
function checkbox4_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox4


% --- Executes on button press in checkbox5.
function checkbox5_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox5


% --- Executes on selection change in popupmenu2.
function popupmenu2_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu2


% --- Executes during object creation, after setting all properties.
function popupmenu2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes on button press in Play.
function Play_Callback(hObject, eventdata, handles)
% hObject    handle to Play (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%fs = handles.fs*(1 + handles.FSQ);
fs_2 = handles.fs*(1+handles.FSQ) ;
sound(handles.x,fs_2);
%guidata(hObject,handles);


% --- Executes on button press in From_File.
function From_File_Callback(hObject, eventdata, handles)
% hObject    handle to From_File (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of From_File


% --- Executes on button press in From_Mic.
function From_Mic_Callback(hObject, eventdata, handles)
% hObject    handle to From_Mic (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of From_Mic


% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on selection change in popupmenu3.
function popupmenu3_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu3 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu3


% --- Executes during object creation, after setting all properties.
function popupmenu3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over Load.
function Load_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to Load (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)




function File_name_Callback(hObject, eventdata, handles)
% hObject    handle to File_name (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of File_name as text
%        str2double(get(hObject,'String')) returns contents of File_name as a double


% --- Executes during object creation, after setting all properties.
function File_name_CreateFcn(hObject, eventdata, handles)
% hObject    handle to File_name (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in File_List.
function File_List_Callback(hObject, eventdata, handles)
% hObject    handle to File_List (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns File_List contents as cell array
%        contents{get(hObject,'Value')} returns selected item from File_List


% --- Executes during object creation, after setting all properties.
function File_List_CreateFcn(hObject, eventdata, handles)
% hObject    handle to File_List (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function Sample_Frequency_Callback(hObject, eventdata, handles)
% hObject    handle to Sample_Frequency (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 handles.FSQ = (get(hObject,'Value'));
    set(handles.edit5, 'String', [sprintf('%.1f',handles.FSQ) ''] );
guidata(hObject, handles);

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function Sample_Frequency_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Sample_Frequency (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over Sample_Frequency.
function Sample_Frequency_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to Sample_Frequency (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function edit5_Callback(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit5 as text
%        str2double(get(hObject,'String')) returns contents of edit5 as a double


% --- Executes during object creation, after setting all properties.
function edit5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
