#import "Core/Basics/NpCrc32.h"
#import "NPObject.h"
#import "NPObjectManager.h"
#import "Core/NPEngineCore.h"

@implementation NPObject

//private
- (UInt32) generateIDFromPointer
{
    return crc32_of_pointer(self);
}

- (id) init
{
    self = [ self initWithName:@"" parent:nil ];

    return self;
}

- (id) initWithName:(NSString *)newName
{
    self = [ self initWithName:newName parent:nil ];

    return self;
}

- (id) initWithName:(NSString *)newName parent:(NPObject *)newParent
{
    self = [ super init ];

    name = [ newName retain ];

    //Weak reference
    parent = newParent;

    objectID = [ self generateIDFromPointer ];
    pointer = [[ NSValue alloc ] initWithBytes:&self objCType:@encode(void *) ];

    [[[ NPEngineCore instance ] objectManager ] addObject:pointer ];

    return self;
} 

- (void) dealloc
{
    [ name release ];
    parent = nil;

    [[[ NPEngineCore instance ] objectManager ] removeObject:pointer ];
    [ pointer release ];

    [ super dealloc ];
}

- (NSString *) name
{
    return name;
}

- (void) setName:(NSString *)newName
{
    if ( name != newName )
    {
        [ name release ];

        name = [ newName retain ];
    }
}

- (NPObject *) parent
{
    return parent;
}

- (void) setParent:(NPObject *)newParent
{
    if ( parent != newParent )
    {
        parent = newParent;
    }
}

- (UInt32) objectID
{
    return objectID;
}

- (NSString *) description
{
    return [ NSString stringWithFormat: @"ID:%ud Name:%@", objectID, name ];
}

@end

@implementation NPObject ( NPCoding )

- (void) encodeWithCoder:(NSCoder *)coder
{
    if ( [coder allowsKeyedCoding] )
    {
        [ coder encodeObject:name forKey:@"Name" ];
        [ coder encodeConditionalObject:parent forKey:@"Parent" ];
    }
    else
    {
        [ coder encodeObject:name ];
        [ coder encodeConditionalObject:parent ];
    }
}

- (id) initWithCoder:(NSCoder *)coder
{
    self = [ super init ];

    if ( [coder allowsKeyedCoding] )
    {
        name = [ [ coder decodeObjectForKey:@"Name" ] retain ];
        parent = [ coder decodeObjectForKey:@"Parent" ];
    }
    else
    {
        name = [ [ coder decodeObject ] retain ];
        parent = [ coder decodeObject ];
    }

    objectID = [ self generateIDFromPointer ];

    return self;
}

@end
