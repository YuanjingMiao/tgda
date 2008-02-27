#import "Core/NPObject/NPObject.h"
#import "Core/Resource/NPResource.h"
#import "Core/Resource/NPPResource.h"

@class NPFile;

typedef enum NPPixelFormat
{
    NP_PIXELFORMAT_NONE = 0,
    NP_PIXELFORMAT_BYTE_R = 1,
    NP_PIXELFORMAT_BYTE_RG = 2,
    NP_PIXELFORMAT_BYTE_RGB = 3,
    NP_PIXELFORMAT_BYTE_RGBA = 4,
    NP_PIXELFORMAT_FLOAT16_R = 5,
    NP_PIXELFORMAT_FLOAT16_RG = 6,
    NP_PIXELFORMAT_FLOAT16_RGB = 7,
    NP_PIXELFORMAT_FLOAT16_RGBA = 8,
    NP_PIXELFORMAT_FLOAT32_R = 9,
    NP_PIXELFORMAT_FLOAT32_RG = 10,
    NP_PIXELFORMAT_FLOAT32_RGB = 11,
    NP_PIXELFORMAT_FLOAT32_RGBA = 12
}
NPPixelFormat;

@interface NPTexture : NPResource < NPPResource >
{
    NPPixelFormat pixelFormat;
    Int width;
    Int height;
    UInt textureID;
}

- (id) init;
- (id) initWithName:(NSString *)newName;
- (id) initWithName:(NSString *)newName parent:(NPObject *)newParent;
- (void) dealloc;

- (BOOL) loadFromFile:(NPFile *)file;
- (BOOL) loadFromFile:(NPFile *)file withMipMaps:(BOOL)generateMipMaps;
- (void) reset;
- (BOOL) isReady;

- (void) uploadToGL;

@end
