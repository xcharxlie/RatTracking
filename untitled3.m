clear all
arena = [50 250 80 520];
rate = 120;
dsp = 0;
new_arena = 0;
obj = VideoReader('/Users/liusy/Documents/MATLAB/rat1.avi');
for BB = 1:size('rat1.avi',1)
height = obj.Height;
width = obj.Width;
frames = obj.NumberOfFrames;
obj.CurrentTime = 0.1;
yb1 = double(readFrame(obj));
B = yb1(:,with/2+1:end,1);
if new_arena ==1;
    figure;
    imagesc(B);
    h = imfreehand;
    BW = createMask(h);
    IM =BW;
    imwrite(BW,'picture.tiff');
    AM = BW;
    AM1 = bas(1-BW);
else 
    AM = double(imread('picture.riff'));
    AM1 = 1- AM;
end
dsk = fspecial('disk',10)
obj.currentTime = 0;
ab1 = 0;
    cr = zeros(frames,2);
    MVn1 = cr;
    s = cr(:,1);
    s1 = s;
    
    %MT = zeros(vidHeight,vidWidth/2,600);
    
    if dsp==1;
        figure
    end
    
    bx = ones(height,width/2);
    t1 = 0;
    
    MVN1_Z = zeros(frames-100,800);
    MVN1_B = MVN1_Z;
    
    dt1n = 0;
    
    for y = 1:frames-100;
        if y==20;
            tic
        end
        
        if y>10 & (round(y./360) == y./360);
            tic
        end
        
        ab1 = ab1+1;
        yb1 = double(readFrame(obj));
        %yn1 = yb1(:,vidWidth/2+1:end,1);
        yn1 = yb1(:,1:width/2,1);
        
        M1 = abs(yn1-B);
        %cd('G:\My Drive\Rat Arena\Code')
        
        M1 = IdealLowPass(M1,0.25);
        
        M1(M1<20) = 0;
        M1(M1~=0) = 1;
        M1a = M1.*AM1;
        M1 = M1.*AM;
        
        s(y) = sum(sum(M1a));
        s1(y) = sum(sum(M1));
        rt = s1(y)./(s(y)+0.001+s1(y));
        
        if (s(y)>10 & rt<0.5) | s1(y)==0;
            % bc = y;
            B = yn1;
            M1 = abs(yn1-B).*0;
            % M1 = IdealLowPass(M1,0.25);
            % M1(M1<20) = 0;
            % M1(M1~=0) = 1;
        end
        
        M1 = M1.*bx;
        zt = find(M1==1);
        MVN1_Z(y,1:length(zt)) = zt;
        MVN1_B(y,1:length(zt)) = yn1(zt);
        
        [cr(y,1) cr(y,2)] = centre(M1);
        
        if isnan(cr(y,1))
            cr(y,:) = [0 0];
            MVN1_Z(y,:) = 0;
        end
if s1(y)>10 & cr(y,1)~=0;
            if dt1n==0;
                if cr(y,1)>460 & cr(y,2)<160;
                    dt1n = dt1n+1;
                else
                    %cr(y,:) = [490,120];
                    %cr(y,:) = [145,114];
                end
            end
            
            bx = M1.*0;
            cr1 = round(cr(y,:));
            bx(cr1(2)-40:cr1(2)+40,cr1(1)-40:cr1(1)+40) = 1;
            B(bx==0) = yn1(bx==0);
            
            MV1 = M1(cr1(2)-40:cr1(2)+40,cr1(1)-40:cr1(1)+40);
            
            if t1>2;
                MVn1(y,1) = sum(sum(abs(MV2-MV1)));
                MVn1(y,2) = sum(sum(abs(M2-M1)));
            end
            
            if y>10 & (round(y./120) == y./120) & dsp==1;
                hold off
                yp = yn1./max(max(yn1));
                n1(:,:,1) = (yn1./max(max(yn1))+bx./max(max(bx)))./2;
                n1(:,:,2) = yp;
                n1(:,:,3) = yp;
                
                imshow(n1)
                hold on
                plot(cr(y,1),cr(y,2),'bo')
                axis equal
                drawnow
            end
            
            M2 = M1;
            MV2 = M1(cr1(2)-40:cr1(2)+40,cr1(1)-40:cr1(1)+40);
            t1 = t1+1;
            
            
        end
        
        
        
        if y==20;
            toc1 = toc
            calc_time_minutes = (frames.*toc1)./60
            h = waitbar(0,WB);
        end
        
        if y>10 & (round(y./360) == y./360);
            toc;
            toc2 = toc;
            remaining_time = ((frames-y).*toc2)./60
            
            waitbar(y./frames,h)
        end
        
    end
    
    close(h)
    
    %% write the output
    
    E1 = exist('DATA', 'dir');
    
    pname1 = fname(1:find(fname=='.')-1);
    pname1(end+1:end+5) = '_DATA';
    
    if E1==7;
        cd('DATA')
    else
        mkdir('DATA')
        cd('DATA')
    end
    
    ind_f = 0;
    if ind_f==1;
        E1 = exist(pname1, 'dir');
        if E1==7;
            cd(pname1)
        else
            mkdir(pname1)
            cd(pname1)
        end
    end
    
    MVn1_total.move = MVn1;
    MVn1_total.sil = MVN1_Z;
    MVn1_total.body = MVN1_B;
    
    fname1 = fname(1:find(fname=='.')-1);
    fname1(end+1:end+10) = '-xy_coords';
    fname1(end+1:end+4) = '.mat';
    
    fname2 = fname(1:find(fname=='.')-1);
    fname2(end+1:end+9) = '-movement';
    fname2(end+1:end+4) = '.mat';
    
    save(char(fname1), 'cr')
    save(char(fname2),'MVn1_total','-v7.3')
    
end


