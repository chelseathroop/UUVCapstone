function varargout = Capstone_GUI_Matlab_032015_R2(varargin)


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
title('Frequency Spectrum Left Channel');

axes(handles.a_modul_right);
handles.a_modul_line_right = plot(0,0,'');
grid on;
xlabel('{\itf} [Hz] ');
ylabel(' [{Db}]');
title('Frequency Spectrum Right Channel');

% Initialize axis for spectrogram
axes(handles.a_spec);
xlabel('{Frequency} [Hz]');
ylabel('Time [ms]');
title('Spectrogram Left Channel');

axes(handles.a_spec_right);
xlabel('{Frequency} [Hz]');
ylabel('Time [ms]');
title('Spectrogram Right Channel');

guidata(hObject, handles);


%%


% --- Executes just before AudioSpectrum is made visible.
function AudioSpectrum_OutputFcn(hObject, eventdata, handles, varargin)

handles.output = hObject;


guidata(hObject, handles);
%%Capstone_GUI_Matlab_032015_R1
% --- Executes on button press in Load.
function Load_Callback(hObject, eventdata, handles)

% hObject    handle to Load (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%filename=uigetfile({'*.wav'},'File selector');
clc;

    [FileName,PathName] = uigetfile({'*.wav'},'Load Wav File');
    [x,fs] = audioread([PathName '/' FileName]);
    
    handles.filename=FileName;
    handles.pathname=PathName;
    [s,channel]=size(x)
    
    handles.x=x;
    if channel==1
        handles.x_left = x(:,1);
        handles.x_right=handles.x_left;
    else
        handles.x_left=x(:,1);
        handles.x_right=x(:,2);
    end
        
    handles.fs = fs;
    % initialize the play back frequency

   set(handles.e_play_fs, 'String', num2str(handles.fs));
    % Display the frequency of sample
    set(handles.e_fs, 'String', num2str(handles.fs));
guidata(hObject,handles);


%%

% --- Executes on button press in time_series.
function time_series_Callback(hObject, eventdata, handles)
% hObject    handle to time_series (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
a=get(hObject,'Value');
if a==1
    axes(handles.a_waveform);
    time = 0:1/handles.fs:(length(handles.x_left)-1)/handles.fs;
        
    handles.a_waveform_line=plot(time,handles.x_left);
     xlabel('{Time} [ms] ');
     ylabel('{Voltage}[{V}] ');
     title('Tiem Series');
     
else
     axes(handles.a_waveform);
    handles.a_waveform_line = plot(0,0,'');
end
    
% Hint: get(hObject,'Value') returns toggle state of time_series

%%
% --- Executes on button press in freq_spectrum.
function freq_spectrum_Callback(hObject, eventdata, handles)
% hObject    handle to freq_spectrum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
b=get(hObject,'Value');
if b==1
    %%%%%% for Left channel
    axes(handles.a_modul);
    L=length(handles.x_left);          
    NFFT=2^nextpow2(L); 
    %handles.x_left=handles.x_left.*chebwin(length(handles.x_left));
    X=(fft(handles.x_left,NFFT));  % /L       
    f1=handles.fs/2*(linspace(0,1,NFFT/2+1));
    X_mag=20*log10(abs(X(1:NFFT/2+1)));
         
    set(handles.a_modul_line, 'XData', f1, 'YData',  X_mag);
     
    %%%%%%for Right channel
     axes(handles.a_modul_right);
    L_R=length(handles.x_right);          
    NFFT=2^nextpow2(L_R); 
    %handles.x_left=handles.x_left.*chebwin(length(handles.x_left));
    X_right=(fft(handles.x_right,NFFT));  % /L       
    f1=handles.fs/2*(linspace(0,1,NFFT/2+1));
    X_mag_right=20*log10(abs(X_right(1:NFFT/2+1)));
         
    set(handles.a_modul_line_right, 'XData', f1, 'YData',  X_mag_right);
    
    %%%%%%%%%%%%%%%
    % Find peak in left channel spectrum
    X_max=max(X_mag)
    pos = find(X_mag==X_max)
    set(handles.e_max, 'String', num2str(f1(pos(1))));
    
      % Find peak in right channel spectrum
    X_max_right=max(X_mag_right)
    pos_right = find(X_mag_right==X_max_right)
    set(handles.e_max_right, 'String', num2str(f1(pos_right(1))));
else
    axes(handles.a_modul);
   set(handles.a_modul_line, 'XData',0, 'YData',0); 
    axes(handles.a_modul_right);
   set(handles.a_modul_line_right, 'XData',0, 'YData',0); 
end
% Hint: get(hObject,'Value') returns toggle state of freq_spectrum
%%

% --- Executes on button press in spectrogram.
function spectrogram_Callback(hObject, eventdata, handles)
% hObject    handle to spectrogram (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
c=get(hObject,'Value');
if c==1
       %axes(handles.a_spec);
       
    
win_type = get(handles.window_type, 'Value');
%Set current data to the selected data set.
switch win_type
    case 1 % User selects blackman window.        
         win_type = @blackman;
    case 2 % User selects bohman window.        
         win_type = @bohmanwin;
    case 3 % User selects gaussin window.
         win_type = @gausswin;
    case 4 % User selects hamming window.
        win_type = @hamming;

    case 5 % User selects hann window.
        win_type = @hann;
    
end

val = get(handles.popupmenu2, 'Value');
%Set current data to the selected data set.
switch val
    case 1 % User selects hot.        
         clrmap = jet;
    case 2 % User selects hot.        
         clrmap = hot;
    case 3 % User selects cool.
         clrmap = cool;
    case 4 % User selects gray.
         clrmap = gray;
end




        win=str2double(get(handles.win_len, 'String'))/1000
        L=round((handles.fs*win));
        NFFT=2^nextpow2(L);
        axes(handles.a_spec);
        spectrogram(handles.x_left,window(win_type,(NFFT)),.5*NFFT,NFFT,handles.fs);
        title('Spectrogram Left Channel ');
        colormap(clrmap);
         caxis auto;
        axes(handles.a_spec_right);
        spectrogram(handles.x_right,window(win_type,(NFFT)),.5*NFFT,NFFT,handles.fs);
        title('Spectrogram Right Channel ');
        colormap(clrmap);
         caxis auto;
   %         
%  [spec,ff,tt]=spectrogram(handles.x_left,hamming(NFFT),.2*NFFT,NFFT,handles.fs);
%   imagesc(tt,ff,(abs(((spec)))));


else
    axes(handles.a_spec);
    cla;
    axes(handles.a_spec_right);
    cla;
end

% Hint: get(hObject,'Value') returns toggle state of spectrogram

%%
% --- Executes on button press in b_display.
function b_display_Callback(hObject, eventdata, handles)
% hObject    handle to b_display (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


%%

% --- Executes on button press in b_stop.
function b_stop_Callback(hObject, eventdata, handles)
% hObject    handle to b_stop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)




function win_len_Callback(hObject, eventdata, handles)
% hObject    handle to win_len (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
get(hObject,'String');
handles.win_len=str2double(get(hObject,'String'));
% Hints: get(hObject,'String') returns contents of win_len as text
%        str2double(get(hObject,'String')) returns contents of win_len as a double


% --- Executes during object creation, after setting all properties.
function win_len_CreateFcn(hObject, eventdata, handles)
% hObject    handle to win_len (see GCBO)
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
function b_display_CreateFcn(hObject, eventdata, handles)
% hObject    handle to b_display (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called



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
% 
% fs_2=str2double(get(handles.e_play_fs, 'String'))% handles.e_play_fs;
% sound(handles.x_left,fs_2);


if(strcmp(get(handles.Play, 'String'), 'Play'))
    set(handles.Play, 'String', 'Stop');
    
fs_2=str2double(get(handles.e_play_fs, 'String'))% handles.e_play_fs;
sound(handles.x,fs_2);

else
    set(handles.Play, 'String', 'Play');
    
    if(~isempty(handles.x_left))
%         stop(handles.x_left);
%         delete(handles.x_left);
clear sound;
 
    end
    
end

%guidata(hObject,handles);


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
 fs_3 = round(handles.fs*(1+handles.FSQ));  
 set(handles.e_play_fs, 'String', [sprintf('%.1f',fs_3) ''] );
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



function e_play_fs_Callback(hObject, eventdata, handles)
% hObject    handle to e_play_fs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of e_play_fs as text
%        str2double(get(hObject,'String')) returns contents of e_play_fs as a double


% --- Executes during object creation, after setting all properties.
function e_play_fs_CreateFcn(hObject, eventdata, handles)
% hObject    handle to e_play_fs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in window_type.
function window_type_Callback(hObject, eventdata, handles)
% hObject    handle to window_type (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns window_type contents as cell array
%        contents{get(hObject,'Value')} returns selected item from window_type


% --- Executes during object creation, after setting all properties.
function window_type_CreateFcn(hObject, eventdata, handles)
% hObject    handle to window_type (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function e_max_right_Callback(hObject, eventdata, handles)
% hObject    handle to e_max_right (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of e_max_right as text
%        str2double(get(hObject,'String')) returns contents of e_max_right as a double


% --- Executes during object creation, after setting all properties.
function e_max_right_CreateFcn(hObject, eventdata, handles)
% hObject    handle to e_max_right (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
