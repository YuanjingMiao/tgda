#import "ODMenuItem.h"

@class NPEffectTechnique;
@class NPEffectVariableFloat4;

@interface ODStepItem : ODMenuItem
{
    NSString * label;

    NSInteger minimumIntegerValue;
    NSInteger maximumIntegerValue;
    NSInteger integerStep;
    NSInteger integerValue;
    double minimumDoubleValue;
    double maximumDoubleValue;
    double doubleStep;
    double doubleValue;

    NPEffectTechnique * technique;
    NPEffectVariableFloat4 * color;
}

- (id) init;
- (id) initWithName:(NSString *)newName;
- (id) initWithName:(NSString *)newName
               menu:(ODMenu *)newMenu
                   ;
- (void) dealloc;

- (BOOL) loadFromDictionary:(NSDictionary *)source
                      error:(NSError **)error
                           ;

@end