% Define the main folder containing subfolders with images
mainFolder = 'C:\Users\ading\OneDrive\Bureau\A_REDACTION MEMOIRE UQTR\Syst_MATLAB\DATABASE'; % Change this to the path of your main folder

% Get a list of all subfolders
subFolders = dir(fullfile(mainFolder, '**', '*.jpg')); % Adjust the extension if images are not .jpg

numImages = length(subFolders);

% Preallocate cell array to store iris images
irisImages = cell(1, numImages);

% Process Each Image
for k = 1:numImages
    try
        % Read Image
        filename = fullfile(subFolders(k).folder, subFolders(k).name);
        eyeImage = imread(filename);
        
        % Convert to Grayscale if necessary
        if size(eyeImage, 3) == 3
            eyeImage = rgb2gray(eyeImage);
        end
        
        % Preprocessing: Apply edge detection
        edges = edge(eyeImage, 'canny');
        
        % Detect circles using Hough Transform
        [centers, radii] = imfindcircles(edges, [20 60], 'Sensitivity', 0.92); % Adjust the radius range based on your dataset
        
        if ~isempty(centers)
            % Assuming the first detected circle is the iris
            center = centers(1, :);
            radius = radii(1);
            
            % Create a mask for the iris
            [rows, cols] = size(eyeImage);
            [X, Y] = meshgrid(1:cols, 1:rows);
            mask = (X - center(1)).^2 + (Y - center(2)).^2 <= radius^2;
            
            % Extract the iris region
            irisImage = eyeImage .* uint8(mask);
            
            % Store the extracted iris image
            irisImages{k} = irisImage;
        else
            % If no circles detected, store an empty array
            irisImages{k} = [];
        end
    catch ME
        % If an error occurs, display a warning and continue
        warning('Error reading image %s: %s', filename, ME.message);
        irisImages{k} = [];
    end
end

% Save the processed iris images to a .mat file
save('irisImages.mat', 'irisImages');

% Plot some of the processed iris images
figure;
numPlots = min(9, numImages); % Plot up to 9 images
for k = 1:numPlots
    subplot(3, 3, k);
    if ~isempty(irisImages{k})
        imshow(irisImages{k});
        title(['Image ', num2str(k)]);
    else
        title(['Image ', num2str(k), ' (No Iris Detected)']);
    end
end