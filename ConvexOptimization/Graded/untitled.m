for c=1:3
    image = imageRGB(:,:,c);
    primalVar = initialPrimalVar(:,:,c);
    relaxedPrimalVar = initialRelaxedPrimalVar(:,:,c);
    dualVar = initialDualVar;

    % Main loop for the primal-dual splitting method
    for i=1:numIterations
        dualVar = proximalOperatorFs(dualVar + dualStepSize * gradientFunc(relaxedPrimalVar), dualStepSize);
        oldPrimalVar = primalVar;
        primalVar = proximalOperatorG(primalVar + primalStepSize * divergenceFunc(dualVar), primalStepSize);
        relaxedPrimalVar = primalVar + relaxationParam * (primalVar - oldPrimalVar);
        % totalVariation(i) = totalVariationFunc(relaxedPrimalVar);
        % SNR(i) = snr(originalImageGray, relaxedPrimalVar);    
    end

    primalVarRGB(:,:,c) = primalVar;
    relaxedPrimalVarRGB(:,:,c) = relaxedPrimalVar;
end