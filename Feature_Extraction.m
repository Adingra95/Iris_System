% Load the processed iris images
load('irisImages.mat', 'irisImages');

% Preallocate arrays for storing LBP features
numImages = length(irisImages);
lbpFeatures = [];

% Extract LBP features from each image
for k = 1:numImages
    if ~isempty(irisImages{k})
        % Extract LBP features
        lbp = extractLBPFeatures(irisImages{k});
        lbpFeatures = [lbpFeatures; lbp];
    end
end

% Normalize LBP features
lbpFeatures = lbpFeatures ./ max(lbpFeatures(:));

% Define SOM parameters
gridSize = [10 10]; % Size of the SOM grid
dimension = size(lbpFeatures, 2); % Dimension of the input vectors

% Create and train the SOM
som = selforgmap(gridSize);
som = train(som, lbpFeatures');

% Get the weight positions of the neurons in the input space
weights = som.IW{1};

% Save the LBP features and SOM weights
save('extractedFeatures.mat', 'lbpFeatures', 'weights');

% Plot LBP features
figure;
plot(lbpFeatures);
title('LBP Features');
xlabel('Feature Index');
ylabel('Feature Value');

% Plot SOM weight positions
figure;
plotsompos(som, lbpFeatures');
title('SOM Weight Positions');

% Plot SOM hits
figure;
plotsomhits(som, lbpFeatures');
title('SOM Hits');
