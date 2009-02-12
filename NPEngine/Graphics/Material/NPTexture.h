#import "Core/NPObject/NPObject.h"
#import "Core/Resource/NPResource.h"
#import "NpTexture.h"
#import "Graphics/npgl.h"

@class NPFile;
@class NPImage;

@interface NPTexture : NPResource
{
    UInt textureID;

    Int width;
    Int height;

    NpState dataFormat;
    NpState pixelFormat;

    NpTextureFilterState textureFilterState;
    NpTextureWrapState textureWrapState;
}

- (id) init;
- (id) initWithName:(NSString *)newName;
- (id) initWithName:(NSString *)newName parent:(id <NPPObject> )newParent;
- (void) dealloc;

- (void) clear;
- (void) reset;

- (UInt) textureID;
- (NpState) dataFormat;
- (NpState) pixelFormat;
- (Int) width;
- (Int) height;

- (void) setDataFormat:(NpState)newDataFormat;
- (void) setPixelFormat:(NpState)newPixelFormat;
- (void) setWidth:(Int)newWidth;
- (void) setHeight:(Int)newHeight;
- (void) setMipMapping:(NpState)newMipMapping;
- (void) setTextureMinFilter:(NpState)newTextureMinFilter;
- (void) setTextureMagFilter:(NpState)newTextureMagFilter;
- (void) setTextureAnisotropyFilter:(NpState)newTextureAnisotropyFilter;
- (void) setTextureWrapS:(NpState)newWrapS;
- (void) setTextureWrapT:(NpState)newWrapT;

- (BOOL) loadFromFile:(NPFile *)file;

- (void) uploadToGLWithoutData;
- (void) uploadToGLUsingImage:(NPImage *)image;
- (void) uploadToGLWithData:(NSData *)data;

- (void) updateGLTextureState;

@end


