function [ Cost ] = criterion( w )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
    global Classifier
    global TemplateData
    global TrainingData
    
    % l1-regularized LR
    lambda = 0.05; % control the l1 regularization
    cost(1) = lambda * sum(abs(w));  % l1 norm of w
    
    tmp_w = repmat(w, 1, TrainingData.num);
     cost(2) = sum(-log((1+exp(-sum(TrainingData.feature .* tmp_w) .* TrainingData.y')).^(-1)));
%     cost(2) = sum(-sum(30.*TrainingData.feature .* tmp_w) .* TrainingData.y');
    
    tmp2_w = repmat(w, 1, Classifier.FeatureNum);
    % terrain template
    cost(3) = sum(-log((1+exp(-sum(TemplateData.feature .* tmp2_w) .* TemplateData.y')).^(-1)));
    
    Cost = sum(cost);
    
end

