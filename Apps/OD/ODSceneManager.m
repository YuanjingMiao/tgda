#import "ODSceneManager.h"
#import "ODScene.h"
#import "NP.h"

@implementation ODSceneManager

- (id) init
{
    return [ self initWithName:@"ODSceneManager" ];
}

- (id) initWithName:(NSString *)newName
{
    return [ self initWithName:newName parent:nil ];
}

- (id) initWithName:(NSString *)newName parent:(NPObject *)newParent
{
    self =  [ super initWithName:newName parent:newParent ];

    scenes = [[ NSMutableDictionary alloc ] init ];
    currentScene = nil;

    return self;
}

- (void) dealloc
{
    [ scenes removeAllObjects ];
    [ scenes release ];

    [ super dealloc ];
}

- (id) loadSceneFromPath:(NSString *)path
{
    NSString * absolutePath = [[[ NP Core ] pathManager ] getAbsoluteFilePath:path ];

    return [ self loadSceneFromAbsolutePath:absolutePath ];   
}

- (id) loadSceneFromAbsolutePath:(NSString *)path
{
    NPLOG(([NSString stringWithFormat:@"%@: loading %@", name, path]));

    if ( [ path isEqual:@"" ] == NO )
    {
        id scene = [ scenes objectForKey:path ];

        if ( scene == nil )
        {
            scene = [[ ODScene alloc ] initWithName:@"" parent:self ];

            if ( [ scene loadFromPath:path ] == YES )
            {
                [ scenes setObject:scene forKey:path ];
                [ scene release ];

                return scene;
            }
            else
            {
                [ scene release ];

                return nil;
            }
        }

        return scene;
    }

    return nil;
}

@end
