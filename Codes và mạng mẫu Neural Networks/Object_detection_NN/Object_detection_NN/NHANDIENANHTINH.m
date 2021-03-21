function varargout = NHANDIENANHTINH(varargin)
% NHANDIENANHTINH M-file for NHANDIENANHTINH.fig
%      NHANDIENANHTINH, by itself, creates a new NHANDIENANHTINH or raises the existing
%      singleton*.
%
%      H = NHANDIENANHTINH returns the handle to a new NHANDIENANHTINH or the handle to
%      the existing singleton*.
%
%      NHANDIENANHTINH('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in NHANDIENANHTINH.M with the given input arguments.
%
%      NHANDIENANHTINH('Property','Value',...) creates a new NHANDIENANHTINH or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before NHANDIENANHTINH_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to NHANDIENANHTINH_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help NHANDIENANHTINH

% Last Modified by GUIDE v2.5 03-Jul-2012 05:13:39

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @NHANDIENANHTINH_OpeningFcn, ...
                   'gui_OutputFcn',  @NHANDIENANHTINH_OutputFcn, ...
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


% --- Executes just before NHANDIENANHTINH is made visible.
function NHANDIENANHTINH_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to NHANDIENANHTINH (see VARARGIN)

axes(handles.axes1)
imshow('nhandienanhtinh.jpg');


% Choose default command line output for NHANDIENANHTINH
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes NHANDIENANHTINH wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = NHANDIENANHTINH_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes on button press in nhandien.
function nhandien_Callback(hObject, eventdata, handles)
% hObject    handle to nhandien (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global S2;

[filename, pathname, filterindex] = uigetfile('*.*', 'OBJECT DETECTION');
S2= imread([pathname,filename]);
%S2 = imresize(S2,[110 80]);
S2 = imresize(S2,[100 100]);
axes(handles.axes1);
imshow(S2);
%[S1,S,output,xx] = xacdinhkhuonmat(S2);
%axes(handles.axes1);
%imshow(S1);
%plotbox1(output,[],8);
persistent loaded;
persistent w;

load('mangnoron');
    %v=zeros(8800,60);
    v=zeros(10000,60);
   for i=1:3
 
      cd(strcat('s',num2str(i)));
        for j=1:20
            a=imread(['s',num2str(i),' ','(',num2str(j),')','.jpg']);
            a=rgb2gray(a);      
            %v(:,(i-1)*20+j)=reshape(a,8800,1);
            v(:,(i-1)*20+j)=reshape(a,10000,1);
        end
        cd ..
    end
    w=uint8(v); % Convert to unsigned 8 bit numbers to save memory. 

loaded=1;  % Set 'loaded' to avoid loading the database again. 

v=w;
N = 60;
O=uint8(ones(1,size(v,2))); 
m=uint8(mean(v,2)) ;                % m is the maen of all images.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
I2=rgb2gray(S2);
%I2=reshape(I2,8800,1);
I2=reshape(I2,10000,1);
I2=uint8(I2);
 
v(:,1)=I2;
I2=v;
vzm2=I2-uint8(single(m)*single(O));

L=single(vzm2)'*single(vzm2);
[V,D]=eig(L);
V=single(vzm2)*V; % 1 khuon mat rieng

V=V(:,end:-1:end-(N-1)); % m khuon mat rieng

cv2=zeros(size(I2,2),N);
for i=1:size(I2,2);
    cv2(i,:)=single(vzm2(:,i))'*V;    % Each row in cv is the signature for one image.
end

cv21=cv2(1,:)';
out=sim(net,cv21);
% axes(handles.axes1);
% imshow(S1);

if out(1,1)>=0.89
    %text(10,100,' MINH PHUC','FontSize',14,'color',[0 1 0]);
    text(10,90,' Banana','FontSize',14,'color',[0 1 0]);
    %pause(0.2)
elseif out(2,1)>=0.89
   %text(10,100,' KHACH MOI','FontSize',14,'color',[0 1 0]);
   text(10,90,' Orange','FontSize',14,'color',[0 1 0]);
   %pause(0.2)
elseif out(3,1)>=0.89
     %text(10,100,' THANH HUNG','FontSize',14,'color',[0 1 0]); 
     text(10,90,' Strawberry','FontSize',14,'color',[0 1 0]);
     %pause(0.2)
%else text(10,100,' KHONG XD','FontSize',14,'color',[0 1 0]) ;
else text(10,90,' KHONG XD','FontSize',14,'color',[0 1 0]) ;
    %pause(0.2);
end

% --- Executes on button press in thoat.
function thoat_Callback(hObject, eventdata, handles)
% hObject    handle to thoat (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
closereq;
