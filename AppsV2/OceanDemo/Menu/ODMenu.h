#import "Core/Math/FVector.h"
#import "Core/Math/FRectangle.h"
#import "Core/NPObject/NPObject.h"
#import "Core/Protocols/NPPPersistentObject.h"
#import "Graphics/NPEngineGraphicsEnums.h"

@class NSMutableArray;
@class NSMutableDictionary;
@class NPInputAction;
@class NPFont;
@class NPEffect;

@interface ODMenu : NPObject < NPPPersistentObject >
{
    NSString * file;
    BOOL ready;

    NSMutableDictionary * textures;
    NSMutableArray * menuItems;

    NPInputAction * menuActivationAction;
    NPInputAction * menuClickAction;
    BOOL menuActive;

    NPFont * font;
    NPEffect * effect;
}

+ (FRectangle) alignRectangle:(const FRectangle)rectangle
                withAlignment:(const NpOrthographicAlignment)alignment
                             ;

- (id) init;
- (id) initWithName:(NSString *)newName;
- (void) dealloc;

- (void) clear;

- (NPFont *) font;
- (NPEffect *) effect;

- (BOOL) isHit:(const FVector2)mousePosition;
- (void) onClick:(const FVector2)mousePosition;
- (void) update:(const float)frameTime;
- (void) render;

@end
