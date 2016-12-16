#import "NPAlphaTestState.h"
#import "NPBlendingState.h"
#import "NPCullingState.h"
#import "NPDepthTestState.h"
#import "NPPolygonFillState.h"
#import "NPStencilTestState.h"
#import "NPStateConfiguration.h"

@implementation NPStateConfiguration

- (id) init
{
    [ self notImplemented:_cmd ];
    return nil;
}

- (id) initWithName:(NSString *)newName 
{
    self = [ super initWithName:newName ];

    locked = NO;

    alphaTestState   = [[ NPAlphaTestState   alloc ] initWithName:@"NP Alpha Test State"   configuration:self ];
    blendingState    = [[ NPBlendingState    alloc ] initWithName:@"NP Blending State"     configuration:self ];
    cullingState     = [[ NPCullingState     alloc ] initWithName:@"NP Culling State"      configuration:self ];
    depthTestState   = [[ NPDepthTestState   alloc ] initWithName:@"NP Depth Test State"   configuration:self ];
    polygonFillState = [[ NPPolygonFillState alloc ] initWithName:@"NP Polygon Fill State" configuration:self ];
    stencilTestState = [[ NPStencilTestState alloc ] initWithName:@"NP Stencil Test State" configuration:self ];

    return self;
}

- (void) dealloc
{
    RELEASE(alphaTestState);
    RELEASE(blendingState);
    RELEASE(cullingState);
    RELEASE(depthTestState);
    RELEASE(polygonFillState);
    RELEASE(stencilTestState);

    [ super dealloc ];
}

- (BOOL) locked
{
    return locked;
}

- (void) setLocked:(BOOL)newLocked
{
    locked = newLocked;
}

- (BOOL) coreProfileOnly
{
    return coreProfileOnly;
}

- (void) setCoreProfileOnly:(BOOL)newCoreProfileOnly
{
    coreProfileOnly = newCoreProfileOnly;
}

- (id) alphaTestState
{
    return alphaTestState;
}

- (id) blendingState
{
    return blendingState;
}

- (id) cullingState
{
    return cullingState;
}

- (id) depthTestState
{
    return depthTestState;
}

- (id) polygonFillState
{
    return polygonFillState;
}

- (id) stencilTestState
{
    return stencilTestState;
}

- (void) activate
{
    if ( locked == NO )
    {
        if ( coreProfileOnly == NO )
        {
            [ alphaTestState   activate ];
            [ polygonFillState activate ];
        }

        [ blendingState    activate ];
        [ cullingState     activate ];
        [ depthTestState   activate ];
        [ stencilTestState activate ];
    }
}

- (void) deactivate
{
    if ( locked == NO )
    {
        if ( coreProfileOnly == NO )
        {
            [ alphaTestState   deactivate ];
            [ polygonFillState deactivate ];
        }

        [ blendingState    deactivate ];
        [ cullingState     deactivate ];
        [ depthTestState   deactivate ];
        [ stencilTestState deactivate ];
    }
}

- (void) reset
{
    if ( locked == NO )
    {
        if ( coreProfileOnly == NO )
        {
            [ alphaTestState   reset ];
            [ polygonFillState reset ];
        }

        [ blendingState    reset ];
        [ cullingState     reset ];
        [ depthTestState   reset ];
        [ stencilTestState reset ];
    }
}

@end