#import "ODEntity.h"
#import "NP.h"

@implementation ODEntity

- (id) init
{
    return [ self initWithName:@"ODEntity" ];
}

- (id) initWithName:(NSString *)newName
{
    return [ self initWithName:newName parent:nil ];
}

- (id) initWithName:(NSString *)newName parent:(id <NPPObject>)newParent
{
    self =  [ super initWithName:newName parent:newParent ];

    modelMatrix = fm4_alloc_init();
    position = fv3_alloc();

    return self;
}

- (void) dealloc
{
    [ stateset release ];
    [ model    release ];

    [ super dealloc ];
}

- (BOOL) loadFromPath:(NSString *)path
{
    config = [[ NSMutableDictionary alloc ] initWithContentsOfFile:path ];

    NSString * entityName      = [ config objectForKey:@"Name"     ];
    NSString * modelPath       = [ config objectForKey:@"Model"    ];
    NSString * statesetPath    = [ config objectForKey:@"States"   ];
    NSArray  * positionStrings = [ config objectForKey:@"Position" ];

    V_X(*position) = [[ positionStrings objectAtIndex:0 ] floatValue ];
    V_Y(*position) = [[ positionStrings objectAtIndex:1 ] floatValue ];
    V_Z(*position) = [[ positionStrings objectAtIndex:2 ] floatValue ];

    if ( modelPath == nil || statesetPath == nil || entityName == nil )
    {
        return NO;
    }

    [ self setName:entityName ];

    model    = [[[[ NP Graphics ] modelManager    ] loadModelFromPath:modelPath       ] retain ];
    stateset = [[[[ NP Graphics ] stateSetManager ] loadStateSetFromPath:statesetPath ] retain ];

    if ( model == nil || stateset == nil )
    {
        return NO;
    }

    return YES;
}

- (FVector3 *) position
{
    return position;
}

- (void) setPosition:(FVector3 *)newPosition
{
    *position = *newPosition;
}

- (void) update
{

}

- (void) render
{
    fm4_mv_translation_matrix(modelMatrix,position);
    [[[[ NP Core ] transformationStateManager ] currentTransformationState ] setModelMatrix:modelMatrix ];

    [ stateset activate ];
    [ model render ];
}

@end
