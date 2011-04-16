#ifndef NPENGINEGRAPHICSENUMS_H_
#define NPENGINEGRAPHICSENUMS_H_

#include "GL/glew.h"

typedef enum NpImagePixelFormat
{
    NpImagePixelFormatUnknown = -1,
    NpImagePixelFormatR = 0,
    NpImagePixelFormatRG = 1,
    NpImagePixelFormatRGB = 2,
    NpImagePixelFormatRGBA = 3,
    NpImagePixelFormatsRGB = 4,
    NpImagePixelFormatsRGBLinearA = 5
}
NpImagePixelFormat;

typedef enum NpImageDataFormat
{
    NpImageDataFormatUnknown = -1,
    NpImageDataFormatByte = 0,
    NpImageDataFormatFloat16 = 1,
    NpImageDataFormatFloat32 = 2
}
NpImageDataFormat;

typedef enum NpTextureType
{
    NpTextureTypeUnknown = -1,
    NpTextureTypeTexture1D = 0,
    NpTextureTypeTexture2D = 1,
    NpTextureTypeTexture3D = 2,
    NpTextureTypeTextureCube = 3,
    NpTextureTypeTextureBuffer = 4
}
NpTextureType;

typedef enum NpTexture2DFilter
{
    NpTexture2DFilterNearest = 0,
    NpTexture2DFilterLinear = 1,
    NpTexture2DFilterTrilinear = 2
}
NpTexture2DFilter;

typedef enum NpTextureWrap
{
    NpTextureWrapToBorder = 0,
    NpTextureWrapToEdge = 1,
    NpTextureWrapRepeat = 2
}
NpTextureWrap;

typedef NpImagePixelFormat NpTexturePixelFormat;
typedef NpImageDataFormat  NpTextureDataFormat;

typedef enum NpShaderType
{
    NpShaderTypeUnknown = -1,
    NpShaderTypeVertex = 0,
    NpShaderTypeFragment = 1
}
NpShaderType;

typedef enum NpEffectVariableType
{
    NpEffectVariableTypeUnknown = -1,
    NpEffectVariableTypeSemantic = 0,
    NpEffectVariableTypeSampler = 1,
    NpEffectVariableTypeUniform = 2
}
NpEffectVariableType;

typedef enum NpEffectSemantic
{
    NpSemanticUnknown = -1,
    NpModelMatrix = 0,
    NpInverseModelMatrix = 1,
    NpViewMatrix = 2,
    NpInverseViewMatrix = 3,
    NpProjectionMatrix = 4,
    NpInverseProjectionMatrix = 5,
    NpModelViewMatrix = 6,
    NpInverseModelViewMatrix = 7,
    NpViewProjectionMatrix = 8,
    NpInverseViewProjectionMatrix = 9,
    NpModelViewProjectionMatrix = 10,
    NpInverseModelViewProjection = 11
}
NpEffectSemantic;

typedef enum NpUniformType
{
    NpUniformUnknown = -1,
    NpUniformFloat,
    NpUniformFloat2,
    NpUniformFloat3,
    NpUniformFloat4,
    NpUniformInt,
    NpUniformInt2,
    NpUniformInt3,
    NpUniformInt4,
    NpUniformFMatrix2x2,
    NpUniformFMatrix3x3,
    NpUniformFMatrix4x4
}
NpUniformType;

typedef enum NpComparisonFunction
{
    NpComparisonNever = 0,
    NpComparisonAlways = 1,
    NpComparisonLess = 2,
    NpComparisonLessEqual = 3,
    NpComparisonEqual = 4,
    NpComparisonGreaterEqual = 5,
    NpComparisonGreater = 6
}
NpComparisonFunction;

typedef enum NpBlendingMode
{
    NpBlendingAdditive = 0,
    NpBlendingSubtractive = 1,
    NpBlendingAverage = 2,
    NpBlendingMin = 3,
    NpBlendingMax = 4
}
NpBlendingMode;

typedef enum NpCullface
{
    NpCullfaceFront = 0,
    NpCullfaceBack = 1
}
NpCullface;

typedef enum NpPolygonFillMode
{
    NpPolygonFillPoint = 0,
    NpPolygonFillLine = 1,
    NpPolygonFillFace = 2
}
NpPolygonFillMode;

typedef enum NpGeometryDataFormat
{
    NpGeometryDataFormatUnknown = -1,
    NpGeometryDataFormatInt8 = 0,
    NpGeometryDataFormatInt16 = 1,
    NpGeometryDataFormatInt32 = 2,
    NpGeometryDataFormatFloat16 = 3,
    NpGeometryDataFormatFloat32 = 4
}
NpGeometryDataFormat;

typedef enum NpRenderTargetType
{
    NpRenderTargetUnknown = -1,
    NpRenderTargetColor = 0,
	NpRenderTargetDepth = 1,
    NpRenderTargetStencil = 2,
    NpRenderTargetDepthStencil = 3
}
NpRenderTargetType;

typedef enum NpRenderBufferDataFormat
{
    NpRenderBufferDataFormatUnknown = -1,
    NpRenderBufferDataFormatByte = 0,
    NpRenderBufferDataFormatFloat16 = 1,
    NpRenderBufferDataFormatFloat32 = 2,
    NpRenderBufferDataFormatDepth16 = 3,
    NpRenderBufferDataFormatDepth24 = 4,
    NpRenderBufferDataFormatDepth32 = 5,
    NpRenderBufferDataFormatStencil8 = 6,
    NpRenderBufferDataFormatStencil16 = 7,
    NpRenderBufferDataFormatDepth24Stencil8 = 8,
}
NpRenderBufferDataFormat;

typedef NpImagePixelFormat NpRenderBufferPixelFormat;

typedef enum NpBufferDataUpdateRate
{
    NpBufferDataUpdateOnceUseOften,
    NpBufferDataUpdateOnceUseSeldom,
    NpBufferDataUpdateOftenUseOften,
}
NpBufferDataUpdateRate;

typedef enum NpBufferDataUsage
{
    NpBufferDataWriteCPUToGPU,
    NpBufferDataCopyGPUToCPU,
    NpBufferDataCopyGPUToGPU
}
NpBufferDataUsage;

typedef enum NpBufferObjectType
{
    NpBufferObjectTypeUnknown = -1,
    NpBufferObjectTypeGeometry = 0,
    NpBufferObjectTypeIndices = 1,
    NpBufferObjectTypePixelSource = 2,
    NpBufferObjectTypePixelTarget = 3,
    NpBufferObjectTypeUniforms = 4,
    NpBufferObjectTypeTransformFeedback = 5
}
NpBufferObjectType;

GLenum getGLTextureDataFormat(const NpImageDataFormat dataFormat);
GLenum getGLTexturePixelFormat(const NpImagePixelFormat pixelFormat);
GLenum getGLTextureWrap(const NpTextureWrap textureWrap);
GLint  getGLTextureInternalFormat(const NpImageDataFormat dataFormat,
            const NpImagePixelFormat pixelFormat,
            const int sRGBSupport);

GLenum getGLComparisonFunction(const NpComparisonFunction comparisonFunction);
GLenum getGLCullface(const NpCullface cullface);
GLenum getGLPolygonFillMode(const NpPolygonFillMode polygonFillMode);

GLenum getGLRenderBufferInternalFormat(const NpRenderTargetType Type,
            const NpRenderBufferPixelFormat PixelFormat,
            const NpRenderBufferDataFormat DataFormat);

GLenum getGLBufferUsage(const NpBufferDataUpdateRate UpdateRate,
            const NpBufferDataUsage Usage);

GLenum getGLBufferType(const NpBufferObjectType Type);

#endif


