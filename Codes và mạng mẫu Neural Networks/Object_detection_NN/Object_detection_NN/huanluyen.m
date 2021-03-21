function huanluyen();
 persistent loaded;
 persistent w; 
 %v=zeros(8800,60);
 v=zeros(10000,60);% 3 t?p, m?i t?p 20 ?nh
   for i=1:3
        cd(strcat('s',num2str(i)));
        for j=1:20
            a=imread(['s',num2str(i),' ','(',num2str(j),')','.jpg']);
            %a = imresize(a,[110 80]);
            a = imresize(a,[100 100]);
            a=rgb2gray(a);
            %v(:,(i-1)*20+j)=reshape(a,8800,1);
            v(:,(i-1)*20+j)=reshape(a,10000,1);
        end
        cd ..
    end
    w=uint8(v); % Convert to unsigned 8 bit numbers to save memory. 
loaded=1;  % Set 'loaded' to avoid loading the database again. 
v=w;
% PCA
N = 60;
O=uint8(ones(1,size(v,2))); 
m=uint8(mean(v,2)) ;% m is the mean of all images.
vzm=v-uint8(single(m)*single(O));
L=single(vzm)'*single(vzm);
[V,D]=eig(L);
V=single(vzm)*V; 
V=V(:,end:-1:end-(N-1)); 
cv=zeros(size(v,2),N);
for i=1:size(v,2);
    cv(i,:)=single(vzm(:,i))'*V;    % Each row in cv is the signature for one image.
end
%khai bao ngo vao va ra cho mang noron, hi?n là 3 ??u ra
P=cv';
n1 = [1; 0; 0];
n2 = [0 ;1 ;0];
n3 = [0; 0; 1];
% m?i t?p có 20 ?nh
T=[n1 n1 n1 n1 n1 n1 n1 n1 n1 n1...
    n1 n1 n1 n1 n1 n1 n1 n1 n1 n1...
    n2 n2 n2 n2 n2 n2 n2 n2 n2 n2 ...
    n2 n2 n2 n2 n2 n2 n2 n2 n2 n2 ...
    n3 n3 n3 n3 n3 n3 n3 n3 n3 n3...
    n3 n3 n3 n3 n3 n3 n3 n3 n3 n3];
   
 net = noron(P,T);
 save mangnoron net;




