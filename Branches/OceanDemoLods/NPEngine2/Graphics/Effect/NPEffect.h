#import "Core/NPObject/NPObject.h"
#import "Core/Protocols/NPPPersistentObject.h"

@class NSMutableArray;
@class NPStringList;
@class NSError;
@class NPEffectVariable;
@class NPEffectTechnique;

@interface NPEffect : NPObject < NPPPersistentObject >
{
    NSString * file;
    BOOL ready;
    NSMutableArray * techniques;
    NSMutableArray * variables;
}

- (id) init;
- (id) initWithName:(NSString *)newName;
- (void) dealloc;

- (void) clear;

- (id) variableWithName:(NSString *)variableName;
- (id) variableAtIndex:(NSUInteger)index;
- (NPEffectTechnique *) techniqueWithName:(NSString *)techniqueName;
- (NPEffectTechnique *) techniqueAtIndex:(NSUInteger)index;

- (BOOL) loadFromStringList:(NPStringList *)stringList
                      error:(NSError **)error
                           ;

@end
