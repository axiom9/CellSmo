% BME 200 Fall 2019 
%
% ANAS PUTHAWALA FINAL PROJECT

%There are three parts in this final project, case 1, 2, and 3. 

%For case 1
%select a cancer cell image and the code I've written will analyze it and
%go through and put a red boundary over all the potential cancer cells.

%For my second part in case 2, there are images of whtie blood cells mixed
%in amongst red blood cells in a blood smear and basically what I've coded
%is so that when you select a file, the file you selected gets displayed
%and you can click and hold and circle a white blood cell and in return
%you will get the same original image but that circle that you made will be
%shaded in lightly with a green tint. 

%For my 3rd part, I'll be taking images from a blood smear with sickle cell
%disease and basically allow the user to create a rectangle over the region
%of interest. Upon double clicking INSIDE the rectangle created (to confirm
%your selection) it will crop the rectangle and display it in another
%figure.

clear all; close all; clc;

loop = true; % sets loops equal to true so it runs through the code smoothly
error = false; 
while (loop == true)% creates the initial loop
    choice = menu('Select an analysis option',... % title
                  'Select one out of the three cancer cell blood smears    ',... % case 1
                  'Select one out of the three white cell blood smears     ',... % case 2
                  'Select a blood smear for sickle cells     ',...               % case 3
                  'Display all final plots alongside original images      ',...  % case 4
                  '            EXIT               ');% exit
switch(choice)
    case 1
        cells = uigetfile('*.*'); %prompts the user to pick a file.
        file1 = imread(cells); %this imread's the file selected to let it be analyzed via matlab properly.
        msgbox('Cancer Cell Image Loaded') %Displays a message box notifying the user that the desired file was successfully loaded
        rgb = imread(cells); %reads the cells files
        figure('Name','Blood Cell Analysis','NumberTitle','off');
        subplot(1,4,1); hold all;%subplot for the original image
        title('Original image') 
        imshow(rgb);
        I = rgb2gray(rgb); %utilized matlab's built in function rgb2gray().
        subplot(1,4,2); hold all; %subplot for the grayscale image
        title('Grayscale image') 
        imshow(I);
        bw = imbinarize(I); %Uses matlab built in function imbinarize().
        subplot(1,4,4); hold all; %subplot for the image with the cells outlined in red
        title('Cells outlined')
        imshow(bw);
        [B,L,N] = bwboundaries(bw);  %calls on the matlab function bwboundaries to draw the red circle around the desired figure.
        imshow(bw); hold on;
        for k=1:length(B) %this is a for loop I used from matlab bwboundaries documentation, it helps with drawing the actual boundaries by incorporating a for loop with a nested if else inside the loop.
            boundary = B{k};
                if(k > N)
            plot(boundary(:,2), boundary(:,1), 'r','LineWidth',2);
%               else
%           plot(boundary(:,2), boundary(:,1), 'bl','LineWidth',0.1);
   end
        end
        subplot(1,4,3); hold all;
        title('Binarized image') %subplot for the binarized image.
        imshow(bw) 
        
    case 2
        whitebcells = uigetfile('*.*'); %prompts the user to pick a file.
        file2 = imread(whitebcells); %this imread's the file selected to let it be analyzed via matlab properly.
        originalImg = uint8(file2); %This is basically the original color image that was selected, the unit8 is for making sure the values are within 0 - 255.
        msgbox('White Blood Cell Image Loaded')
        figure('Name','White Blood Cell Smear Original Image','NumberTitle','off'); fId = imagesc(file2); axis image; %View the original image in a figure.
        title ('Click and hold to draw on the original image') %Title explaining on what to do.
        Layer = imfreehand(); %uses matlab's built in function imfreehand to allow the user to circle a portion and have it highlighted.
        maskImg = Layer.createMask; %Creates another layer from the
%       figure; imagesc(maskImg); colormap gray; axis image;
        amountIncrease = 255/2; 
        %The lines below are used to create the greenish tint 
        alphaImg(:, :, 1) = zeros(size(maskImg)); %all zeros
        alphaImg(:, :, 2) = round(maskImg*(amountIncrease)); %we round these since we're dealing with 
        alphaImg(:, :, 3) = zeros(size(maskImg)); %all zeros
        alphaImg = uint8(alphaImg); %Making sure that the values are from 0 - 255 
%         figure; imagesc(alphaImg); axis image;
        blendImg = originalImg + alphaImg; %The blended image is a mixture from the originalImg and the alphaImg
        figure('Name','Blood Cell with highlighted region of interest','NumberTitle','off'); imagesc(blendImg); axis image; %displaying the blended image (the one with the highlight visible).
    case 3
        cells3 = uigetfile('*.*'); %prompts the user to pick a file.
        file3 = imread(cells3); %this imread's the file selected to let it be analyzed via matlab properly.
        msgbox('Sickle Cell Image Loaded')
        figure('Name','Original Sickle Cell Blood Smear','NumberTitle','off');
        imshow(file3); hold on; %displays the selected file initially
        title('Hold down left click and draw a rectangle over your region of interest. Double click INSIDE the rectangle to confirm your selection.') %title including brief instructions
        Layer = imrect; %creates a new layer using imrect so that the user can manually create a rectanglular region to crop.
        position = wait(Layer); %this grabs the position coordinates from the rectangle manually created
        
        Image2 = imcrop(file3,position); %crops that rectangle region and creates a new image (Image2)
        figure('Name','Cropped Out Region of Interest','NumberTitle','off'); axis image; imshow(Image2); %displays Image2 alongside the original image.
        
    case 4
        figure('Name','Final Data Plots','NumberTitle','off');
        subplot(3,2,1); hold on; %Subplot for the cancer cells that are binarized.
        title('Binarized Image of Cancer Cells')
        imshow(bw);
        subplot(3,2,2); hold on; %Subplot for the original cancer cells image
        title('Original cancer cell blood smear')
        imshow(file1);
        subplot(3,2,3); hold on; %Subplot for the white blood cells with the manually selected region highlighted.
        title('Image of White Blood Cell with manually selected region') 
        imshow(blendImg);
        subplot(3,2,4); hold on; %Subplot for the original white blood cell image
        title('Original White Blood Cell blood smear')
        imshow(file2);
        subplot(3,2,5); hold on; %Subplot of the cropped out rectangular region from the sickle cells.
        imshow(Image2)
        title('Cropped out region of interest');
        subplot(3,2,6); hold on; %Subplot of original sickle cell blood smear
        imshow(file3)
        title('Original sickle cell blood smear')
        
         otherwise 
            loop = false; %kills loop
end
end