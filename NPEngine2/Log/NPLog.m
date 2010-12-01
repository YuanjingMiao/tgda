#import <Foundation/NSException.h>
#import <Foundation/NSFileManager.h>
#import "NPLog.h"

static NPLog * NP_ENGINE_LOG = nil;

@implementation NPLog

+ (void) initialize
{
	if ( [ NPLog class ] == self )
	{
		[[ self alloc ] init ];
	}
}

+ (NPLog *) instance
{
    return NP_ENGINE_LOG;
}

+ (id) allocWithZone:(NSZone*)zone
{
    if ( self != [ NPLog class ] )
    {
        [ NSException raise:NSInvalidArgumentException
	                 format:@"Illegal attempt to subclass NPLog as %@", self ];
    }

    if ( NP_ENGINE_LOG == nil )
    {
        NP_ENGINE_LOG = [ super allocWithZone:zone ];
    }

    return NP_ENGINE_LOG;
}

/*
- (void) setupFileHandle
{
    NSString * logFileName = [[ NSHomeDirectory() stringByStandardizingPath ]
                                    stringByAppendingPathComponent:@"np.log" ];

    if ( [[ NSFileManager defaultManager ] 
                createFileAtPath:logFileName
                        contents:nil
                      attributes:nil ] == YES )
    {
        logFile = RETAIN([ NSFileHandle fileHandleForWritingAtPath:logFileName ]);
    }
    else
    {
        logFile = RETAIN([ NSFileHandle fileHandleWithStandardOutput ]);
    }
}
*/

- (id) init
{
    self = [ super init ];

    //[ self setupFileHandle ];

    loggers = [[ NSMutableArray alloc ] init ];

    return self;
}

- (void) dealloc
{
    [ loggers removeAllObjects ];
    DESTROY(loggers);

    [ super dealloc ];
}

- (void) addLogger:(id <NPPLogger>)logger
{
    [ loggers addObject:logger ];
}

- (void) removeLogger:(id <NPPLogger>)logger
{
    [ loggers removeObjectIdenticalTo:logger ];
}

- (void) logMessage:(NSString *)message
{
    NSUInteger numberOfLoggers = [ loggers count ];
    for ( NSUInteger i = 0; i < numberOfLoggers; i++ )
    {
        [[ loggers objectAtIndex:i ] logMessage:message ];
    }
}

- (void) logWarning:(NSString *)warning
{
    NSUInteger numberOfLoggers = [ loggers count ];
    for ( NSUInteger i = 0; i < numberOfLoggers; i++ )
    {
        [[ loggers objectAtIndex:i ] logWarning:warning ];
    }
}

- (void) logError:(NSError *)error
{
    NSUInteger numberOfLoggers = [ loggers count ];
    for ( NSUInteger i = 0; i < numberOfLoggers; i++ )
    {
        [[ loggers objectAtIndex:i ] logError:error ];
    }   
}

- (id) copyWithZone:(NSZone *)zone
{
    return self;
}

- (id) retain
{
    return self;
}

- (NSUInteger) retainCount
{
    return ULONG_MAX;
} 

- (void) release
{
    //do nothing
} 

- (id) autorelease
{
    return self;
}

@end
