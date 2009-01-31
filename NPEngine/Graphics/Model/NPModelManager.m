#import "NPModelManager.h"
#import "NP.h"

@implementation NPModelManager

- (id) init
{
    return [ self initWithName:@"NPEngine Model Manager" ];
}

- (id) initWithName:(NSString *)newName
{
    return [ self initWithName:newName parent:nil ];
}

- (id) initWithName:(NSString *)newName parent:(id <NPPObject> )newParent
{
    self = [ super initWithName:newName parent:newParent ];

    models = [[ NSMutableDictionary alloc ] init ];

    return self;
}

- (void) dealloc
{
    [ models removeAllObjects ];
    [ models release ];

    [ super dealloc ];
}

- (id) loadModelFromPath:(NSString *)path
{
    NSString * absolutePath = [[[ NP Core ] pathManager ] getAbsoluteFilePath:path ];

    return [ self loadModelFromAbsolutePath:absolutePath ];
}

- (id) loadModelFromAbsolutePath:(NSString *)path
{
    NPLOG(@"%@: loading %@", name, path);

    if ( [ path isEqual:@"" ] == NO )
    {
        NPSUXModel * model = [ models objectForKey:path ];

        if ( model == nil )
        {
            NPFile * file = [[ NPFile alloc ] initWithName:path parent:self fileName:path ];
            model = [ self loadModelUsingFileHandle:file ];
            [ file release ];
        }

        return model;
    }

    return nil;
}

- (id) loadModelUsingFileHandle:(NPFile *)file
{
    NPSUXModel * model = [[ NPSUXModel alloc ] initWithName:@"" parent:self ];

    if ( [ model loadFromFile:file ] == YES )
    {
        [ models setObject:model forKey:[file fileName] ];
        [ model release ];

        return model;
    }
    else
    {
        [ model release ];

        return nil;
    } 
}

- (BOOL) saveModel:(NPSUXModel *)model atAbsolutePath:(NSString *)path
{
    NpState mode = NP_FILE_WRITING;

    if ( [[ NSFileManager defaultManager ] isDirectory:path ] == YES )
    {
        NPLOG_WARNING(@"%@ is a directory", path);
        return NO;
    }

    if ( [[ NSFileManager defaultManager ] isFile:path ] == YES )
    {
        NPLOG(@"%@ already exist, overwriting...", path);
        mode = NP_FILE_UPDATING;        
    }
    else
    {
        if ( [[ NSFileManager defaultManager ] createEmptyFileAtPath:path ] == NO )
        {
            NPLOG_WARNING(@"Could not create file %@", path);
            return NO;
        }
    }

    NPFile * file = [[ NPFile alloc ] initWithName:@"" parent:self fileName:path mode:mode ];

    if ( [ model saveToFile:file ] == NO )
    {
        [ file release ];
        return NO;
    }

    [ file release ];

    return YES;
}

@end
