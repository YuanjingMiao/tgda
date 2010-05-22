#import "NPTextureBindingState.h"
#import "NPTexture.h"
#import "NPTexture3D.h"
#import "Graphics/npgl.h"
#import "Graphics/NPEngineGraphicsConstants.h"

@implementation NPTextureBindingState

- (id) init
{
    return [ self initWithName:@"NPEngine Core Texture Binding State" ];
}

- (id) initWithName:(NSString *)newName
{
    return [ self initWithName:newName parent:nil ];
}

- (id) initWithName:(NSString *)newName parent:(id <NPPObject> )newParent
{
    self = [ super initWithName:newName parent:newParent ];

    textureBindings = [[ NSMutableDictionary alloc ] init ];

    return self;
}

- (void) dealloc
{
    [ textureBindings removeAllObjects ];
    [ textureBindings release ];

    [ super dealloc ];
}

- (id) textureForKey:(NSString *)colormapSemantic
{
    return [ textureBindings objectForKey:colormapSemantic ];
}

- (void) setTexture:(id)texture forKey:(NSString *)colormapSemantic
{
    [ textureBindings setObject:texture forKey:colormapSemantic ]; 
}

@end
