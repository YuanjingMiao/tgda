#import "NP.h"
#import "RTVCore.h"
#import "RTVPressure.h"

@implementation RTVPressure

- (id) init
{
    return [ self initWithName:@"Pressure" ];
}

- (id) initWithName:(NSString *)newName
{
    return [ self initWithName:newName parent:nil ];
}

- (id) initWithName:(NSString *)newName parent:(id <NPPObject>)newParent
{
    self = [ super initWithName:newName parent:newParent ];

    currentResolution = iv2_alloc_init();
    resolutionLastFrame = iv2_alloc_init();

    innerQuadUpperLeft  = fv2_alloc_init();
    innerQuadLowerRight = fv2_alloc_init();
    pixelSize = fv2_alloc_init();

    pressureEffect = [[[ NP Graphics ] effectManager ] loadEffectFromPath:@"Pressure.cgfx" ];
    alpha = [ pressureEffect parameterWithName:@"alpha" ];
    rBeta = [ pressureEffect parameterWithName:@"rBeta" ];
    gradientSubtractionEffect = [[[ NP Graphics ] effectManager ] loadEffectFromPath:@"GradientSubtraction.cgfx" ];
    rHalfDX = [ gradientSubtractionEffect parameterWithName:@"rHalfDX" ];

    pressureRenderTargetConfiguration = [[ NPRenderTargetConfiguration alloc ] initWithName:@"PressureRT" parent:self ];

    numberOfIterations = 1;

    return self;
}

- (void) dealloc
{
    iv2_free(currentResolution);
    iv2_free(resolutionLastFrame);

    fv2_free(innerQuadUpperLeft);
    fv2_free(innerQuadUpperLeft);
    fv2_free(pixelSize);

    [ pressureRenderTargetConfiguration clear ];
    [ pressureRenderTargetConfiguration release ];

    [ super dealloc ];
}

- (Int32) numberOfIterations
{
    return numberOfIterations;
}

- (IVector2) resolution
{
    return *currentResolution;
}

- (void) setNumberOfIterations:(Int32)newNumberOfIterations
{
    numberOfIterations = newNumberOfIterations;
}

- (void) setResolution:(IVector2)newResolution
{
    currentResolution->x = newResolution.x;
    currentResolution->y = newResolution.y;
}

- (void) computePressureFrom:(id)pressureSource 
                          to:(id)pressureTarget
             usingDivergence:(id)divergence
                      deltaX:(Float)deltaX
                      deltaY:(Float)deltaY
{
    #warning FIXME clear pressure every frame

    id source = pressureSource;
    id target = pressureTarget;
    id tmp;

    Float alphaValue = -(deltaX * deltaY);
    Float rBetaValue = 1.0f / 4.0f;

    [ pressureRenderTargetConfiguration bindFBO ];
    [ pressureRenderTargetConfiguration activateViewport ];

    [ pressureEffect uploadFloatParameter:alpha andValue:alphaValue  ];
    [ pressureEffect uploadFloatParameter:rBeta andValue:rBetaValue ];

    for ( Int i = 0; i < numberOfIterations; i++ )
    {
        [[ pressureRenderTargetConfiguration colorTargets ] replaceObjectAtIndex:0 withObject:target ];
        [ target attachToColorBufferIndex:0 ];
        [ pressureRenderTargetConfiguration activateDrawBuffers ];

        [[ NP Graphics ] clearFrameBuffer:YES depthBuffer:NO stencilBuffer:NO ];

        [[ source texture ]     activateAtColorMapIndex:0 ];
        [[ divergence texture ] activateAtColorMapIndex:1 ];
        [ pressureEffect activateTechniqueWithName:@"compute_pressure" ];

        glBegin(GL_QUADS);
            glVertex4f(innerQuadUpperLeft->x,  innerQuadUpperLeft->y,  0.0f, 1.0f);
            glVertex4f(innerQuadUpperLeft->x,  innerQuadLowerRight->y, 0.0f, 1.0f);
            glVertex4f(innerQuadLowerRight->x, innerQuadLowerRight->y, 0.0f, 1.0f);
            glVertex4f(innerQuadLowerRight->x, innerQuadUpperLeft->y,  0.0f, 1.0f);
        glEnd();

        [ pressureEffect deactivate ];

        tmp = source;
        source = target;
        target = tmp;
    }

    [ pressureRenderTargetConfiguration unbindFBO ];
    [ pressureRenderTargetConfiguration deactivateDrawBuffers ];
    [ pressureRenderTargetConfiguration deactivateViewport ];
}

- (void) subtractGradientFromVelocity:(NPTexture *)velocitySource
                                   to:(NPRenderTexture *)velocityTarget
                        usingPressure:(NPTexture *)pressure
                               deltaX:(Float)deltaX
{
    Float rHalfDXValue = (1.0f / deltaX) * 0.5f;

    [[ pressureRenderTargetConfiguration colorTargets ] replaceObjectAtIndex:0 withObject:velocityTarget ];
    [ pressureRenderTargetConfiguration bindFBO ];
    [ velocityTarget attachToColorBufferIndex:0 ];
    [ pressureRenderTargetConfiguration activateDrawBuffers ];
    [ pressureRenderTargetConfiguration activateViewport ];
    [ pressureRenderTargetConfiguration checkFrameBufferCompleteness ];

    [[ NP Graphics ] clearFrameBuffer:YES depthBuffer:NO stencilBuffer:NO ];

    [ pressure       activateAtColorMapIndex:0 ];
    [ velocitySource activateAtColorMapIndex:1 ];

    [ gradientSubtractionEffect uploadFloatParameter:rHalfDX andValue:rHalfDXValue  ];
    [ gradientSubtractionEffect activateTechniqueWithName:@"gradient_subtraction" ];

    glBegin(GL_QUADS);
        glVertex4f(innerQuadUpperLeft->x,  innerQuadUpperLeft->y,  0.0f, 1.0f);
        glVertex4f(innerQuadUpperLeft->x,  innerQuadLowerRight->y, 0.0f, 1.0f);
        glVertex4f(innerQuadLowerRight->x, innerQuadLowerRight->y, 0.0f, 1.0f);
        glVertex4f(innerQuadLowerRight->x, innerQuadUpperLeft->y,  0.0f, 1.0f);
    glEnd();

    [ gradientSubtractionEffect deactivate ];

    [ velocityTarget detach ]; 
    [ pressureRenderTargetConfiguration unbindFBO ];
    [ pressureRenderTargetConfiguration deactivateDrawBuffers ];
    [ pressureRenderTargetConfiguration deactivateViewport ];
}

- (void) updateInnerQuadCoordinates
{
    pixelSize->x = 1.0f/(Float)(currentResolution->x);
    pixelSize->y = 1.0f/(Float)(currentResolution->y);

    innerQuadUpperLeft->x  = pixelSize->x;
    innerQuadUpperLeft->y  = 1.0f - pixelSize->y;
    innerQuadLowerRight->x = 1.0f - pixelSize->x;
    innerQuadLowerRight->y = pixelSize->y;
}

- (void) update:(Float)frameTime
{
    if ( (currentResolution->x != resolutionLastFrame->x) || (currentResolution->y != resolutionLastFrame->y) )
    {
        [ self updateInnerQuadCoordinates ];

        [ pressureRenderTargetConfiguration setWidth :currentResolution->x ];
        [ pressureRenderTargetConfiguration setHeight:currentResolution->y ];

        resolutionLastFrame->x = currentResolution->x;
        resolutionLastFrame->y = currentResolution->y;
    }
}

- (void) render
{

}

@end
