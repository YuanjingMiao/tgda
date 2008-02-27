#import "Core/NPObject/NPObject.h"
#import "Core/Resource/NPResource.h"
#import "Core/Resource/NPPResource.h"

#define NP_VBO_UPLOAD_ONCE_RENDER_OFTEN     0
#define NP_VBO_UPLOAD_ONCE_RENDER_SELDOM    1
#define NP_VBO_UPLOAD_OFTEN_RENDER_OFTEN    2

#define NP_VBO_PRIMITIVES_POINTS            0
#define NP_VBO_PRIMITIVES_LINES             1
#define NP_VBO_PRIMITIVES_LINE_STRIP        3
#define NP_VBO_PRIMITIVES_TRIANGLES         4
#define NP_VBO_PRIMITIVES_TRIANGLE_STRIP    5
#define NP_VBO_PRIMITIVES_QUADS             7
#define NP_VBO_PRIMITIVES_QUAD_STRIP        8

@class NPFile;

typedef struct NpVertexFormat
{
    Int elementsForNormal;
    Int elementsForColor;
    Int elementsForWeights;
    Int elementsForTextureCoordinateSet[8];
    Int maxTextureCoordinateSet;
}
NpVertexFormat;

void reset_npvertexformat(NpVertexFormat * vertex_format);

typedef struct NpVertices
{
    NpVertexFormat format;
    Int primitiveType;
    BOOL indexed;
    Float * positions;
    Float * normals;
    Float * colors;
    Float * weights;
    Float * textureCoordinates;
    Int * indices;
    Int maxVertex;
    Int maxIndex;
}
NpVertices;

void reset_npvertices(NpVertices * vertices);

typedef struct NpVertexBuffer
{
    UInt positionsID;
    UInt normalsID;
    UInt colorsID;
    UInt weightsID;
    UInt textureCoordinatesSetID[8];
    UInt indicesID;    
}
NpVertexBuffer;

void reset_npvertexbuffer(NpVertexBuffer * vertex_buffer);

@interface NPVertexBuffer : NPResource < NPPResource >
{
    NpVertexBuffer vertexBuffer;
    NpVertices vertices;
}

- (id) init;
- (id) initWithParent:(NPObject *)newParent;
- (id) initWithName:(NSString *)newName parent:(NPObject *)newParent;

- (BOOL) loadFromFile:(NPFile *)file;
- (void) reset;
- (BOOL) isReady;

- (void) uploadVBOWithUsageHint:(NPState)usage;
- (void) deleteVBO;
- (void) render;
- (void) renderElementWithFirstindex:(Int)firstIndex andLastindex:(Int)lastIndex;

- (void) setPositions:(Float *)newPositions;
- (void) setNormals:(Float *)newNormals withElementsForNormal:(Int)newElementsForNormal;
- (void) setColors:(Float *)newColors withElementsForColor:(Int)newElementsForColor;
- (void) setWeights:(Float *)newWeights withElementsForWeights:(Int)newElementsForWeights;
- (void) setTextureCoordinates:(Float *)textureCoordinates forSet:(Int)textureCoordinateSet;

@end
