// texture manager
#define NP_GRAPHICS_TEXTURE_MODE_2D                         0
#define NP_GRAPHICS_TEXTURE_MODE_3D                         1

// Texture
#define NP_GRAPHICS_TEXTURE_DATAFORMAT_BYTE                  0
#define NP_GRAPHICS_TEXTURE_DATAFORMAT_HALF                  1
#define NP_GRAPHICS_TEXTURE_DATAFORMAT_FLOAT                 2

#define NP_GRAPHICS_TEXTURE_PIXELFORMAT_R                    0
#define NP_GRAPHICS_TEXTURE_PIXELFORMAT_RG                   1
#define NP_GRAPHICS_TEXTURE_PIXELFORMAT_RGB                  2
#define NP_GRAPHICS_TEXTURE_PIXELFORMAT_RGBA                 3

#define NP_GRAPHICS_TEXTURE_FILTER_MIPMAPPING_INACTIVE       0
#define NP_GRAPHICS_TEXTURE_FILTER_MIPMAPPING_ACTIVE         1

#define NP_GRAPHICS_TEXTURE_FILTER_NEAREST                   0
#define NP_GRAPHICS_TEXTURE_FILTER_LINEAR                    1
#define NP_GRAPHICS_TEXTURE_FILTER_NEAREST_MIPMAP_NEAREST    2
#define NP_GRAPHICS_TEXTURE_FILTER_LINEAR_MIPMAP_NEAREST     3
#define NP_GRAPHICS_TEXTURE_FILTER_NEAREST_MIPMAP_LINEAR     4
#define NP_GRAPHICS_TEXTURE_FILTER_LINEAR_MIPMAP_LINEAR      5

#define NP_GRAPHICS_TEXTURE_WRAP_S                           0
#define NP_GRAPHICS_TEXTURE_WRAP_T                           1

#define NP_GRAPHICS_TEXTURE_WRAPPING_CLAMP                   0
#define NP_GRAPHICS_TEXTURE_WRAPPING_CLAMP_TO_EDGE           1
#define NP_GRAPHICS_TEXTURE_WRAPPING_CLAMP_TO_BORDER         2
#define NP_GRAPHICS_TEXTURE_WRAPPING_REPEAT                  3

#define NP_GRAPHICS_TEXTURE_FILTER_ANISOTROPY_1X             1
#define NP_GRAPHICS_TEXTURE_FILTER_ANISOTROPY_2X             2
#define NP_GRAPHICS_TEXTURE_FILTER_ANISOTROPY_4X             4
#define NP_GRAPHICS_TEXTURE_FILTER_ANISOTROPY_8X             8
#define NP_GRAPHICS_TEXTURE_FILTER_ANISOTROPY_16X            16

// Image
#define NP_GRAPHICS_IMAGE_DATAFORMAT_BYTE     0
#define NP_GRAPHICS_IMAGE_DATAFORMAT_HALF     1
#define NP_GRAPHICS_IMAGE_DATAFORMAT_FLOAT    2

#define NP_GRAPHICS_IMAGE_PIXELFORMAT_R       0
#define NP_GRAPHICS_IMAGE_PIXELFORMAT_RG      1
#define NP_GRAPHICS_IMAGE_PIXELFORMAT_RGB     2
#define NP_GRAPHICS_IMAGE_PIXELFORMAT_RGBA    3

// Pixelbuffer
#define NP_GRAPHICS_PBO_UPLOAD_ONCE_USE_OFTEN    0
#define NP_GRAPHICS_PBO_UPLOAD_ONCE_USE_SELDOM   1
#define NP_GRAPHICS_PBO_UPLOAD_OFTEN_USE_OFTEN   2

#define NP_GRAPHICS_PBO_AS_DATA_TARGET           0
#define NP_GRAPHICS_PBO_AS_DATA_SOURCE           1

#define NP_GRAPHICS_PBO_DATAFORMAT_BYTE          0
#define NP_GRAPHICS_PBO_DATAFORMAT_HALF          1
#define NP_GRAPHICS_PBO_DATAFORMAT_FLOAT         2

#define NP_GRAPHICS_PBO_PIXELFORMAT_R            0
#define NP_GRAPHICS_PBO_PIXELFORMAT_RG           1
#define NP_GRAPHICS_PBO_PIXELFORMAT_RGB          2
#define NP_GRAPHICS_PBO_PIXELFORMAT_RGBA         3

// Vertexbuffer
#define NP_GRAPHICS_VBO_UPLOAD_ONCE_RENDER_OFTEN     0
#define NP_GRAPHICS_VBO_UPLOAD_ONCE_RENDER_SELDOM    1
#define NP_GRAPHICS_VBO_UPLOAD_OFTEN_RENDER_OFTEN    2

#define NP_GRAPHICS_VBO_DATAFORMAT_BYTE          0
#define NP_GRAPHICS_VBO_DATAFORMAT_HALF          1
#define NP_GRAPHICS_VBO_DATAFORMAT_FLOAT         2
#define NP_GRAPHICS_VBO_DATAFORMAT_SHORT         3
#define NP_GRAPHICS_VBO_DATAFORMAT_INT           4

#define NP_GRAPHICS_VBO_PRIMITIVES_POINTS            0
#define NP_GRAPHICS_VBO_PRIMITIVES_LINES             1
#define NP_GRAPHICS_VBO_PRIMITIVES_LINE_STRIP        3
#define NP_GRAPHICS_VBO_PRIMITIVES_TRIANGLES         4
#define NP_GRAPHICS_VBO_PRIMITIVES_TRIANGLE_STRIP    5
#define NP_GRAPHICS_VBO_PRIMITIVES_QUADS             7
#define NP_GRAPHICS_VBO_PRIMITIVES_QUAD_STRIP        8

// Font
#define NP_GRAPHICS_FONT_ALIGNMENT_LEFT     0
#define NP_GRAPHICS_FONT_ALIGNMENT_CENTER   1
#define NP_GRAPHICS_FONT_ALIGNMENT_RIGHT    2

// CG
#define NP_CG_IMMEDIATE_SHADER_PARAMETER_UPDATE  0
#define NP_CG_DEFERRED_SHADER_PARAMETER_UPDATE   1

#define NP_CG_DEBUG_MODE_INACTIVE                0
#define NP_CG_DEBUG_MODE_ACTIVE                  1

// Effect semantics
#define NP_GRAPHICS_MATERIAL_MODEL_MATRIX_SEMANTIC                  @"NPMODEL"
#define NP_GRAPHICS_MATERIAL_INVERSE_MODEL_MATRIX_SEMANTIC          @"NPINVERSEMODEL"
#define NP_GRAPHICS_MATERIAL_VIEW_MATRIX_SEMANTIC                   @"NPVIEW"
#define NP_GRAPHICS_MATERIAL_INVERSE_VIEW_MATRIX_SEMANTIC           @"NPINVERSEVIEW"
#define NP_GRAPHICS_MATERIAL_PROJECTION_MATRIX_SEMANTIC             @"NPPROJECTION"
#define NP_GRAPHICS_MATERIAL_INVERSE_PROJECTION_MATRIX_SEMANTIC     @"NPINVERSEPROJECTION"
#define NP_GRAPHICS_MATERIAL_MODELVIEW_MATRIX_SEMANTIC              @"NPMODELVIEW"
#define NP_GRAPHICS_MATERIAL_INVERSE_MODELVIEW_MATRIX_SEMANTIC      @"NPINVERSEMODELVIEW"
#define NP_GRAPHICS_MATERIAL_VIEWPROJECTION_MATRIX_SEMANTIC         @"NPVIEWPROJECTION"
#define NP_GRAPHICS_MATERIAL_INVERSEVIEWPROJECTION_MATRIX_SEMANTIC  @"NPINVERSEVIEWPROJECTION"
#define NP_GRAPHICS_MATERIAL_MODELVIEWPROJECTION_MATRIX_SEMANTIC    @"NPMODELVIEWPROJECTION"
#define NP_GRAPHICS_MATERIAL_INVERSE_MODELVIEWPROJECTION_MATRIX_SEMANTIC    @"NPINVERSEMODELVIEWPROJECTION"
#define NP_GRAPHICS_MATERIAL_VIEWPORTSIZE_SEMANTIC                  @"NPVIEWPORTSIZE"
#define NP_GRAPHICS_MATERIAL_RVIEWPORTSIZE_SEMANTIC                 @"NPRVIEWPORTSIZE"
#define NP_GRAPHICS_MATERIAL_FONT_SEMANTIC                          @"NPFONT"
#define NP_GRAPHICS_MATERIAL_COLORMAP_BASE_SEMANTIC                 @"NPCOLORMAP"
#define NP_GRAPHICS_MATERIAL_COLORMAP_SEMANTIC(_index)              [ NP_GRAPHICS_MATERIAL_COLORMAP_BASE_SEMANTIC stringByAppendingFormat:@"%d",_index ]
#define NP_GRAPHICS_MATERIAL_VOLUMEMAP_BASE_SEMANTIC                @"NPVOLUMEMAP"
#define NP_GRAPHICS_MATERIAL_VOLUMEMAP_SEMANTIC(_index)             [ NP_GRAPHICS_MATERIAL_VOLUMEMAP_BASE_SEMANTIC stringByAppendingFormat:@"%d",_index ]


// Framebuffer, colorbuffer, r2vb
#define NP_GRAPHICS_FRAMEBUFFER_LEFT_FRONT   0
#define NP_GRAPHICS_FRAMEBUFFER_RIGHT_FRONT  1
#define NP_GRAPHICS_FRAMEBUFFER_LEFT_BACK    2
#define NP_GRAPHICS_FRAMEBUFFER_RIGHT_BACK   3
#define NP_GRAPHICS_FRAMEBUFFER_FRONT        4
#define NP_GRAPHICS_FRAMEBUFFER_BACK         5


#define NP_GRAPHICS_COLORBUFFER_0    0
#define NP_GRAPHICS_COLORBUFFER_1    1
#define NP_GRAPHICS_COLORBUFFER_2    2
#define NP_GRAPHICS_COLORBUFFER_3    3
#define NP_GRAPHICS_COLORBUFFER_4    4
#define NP_GRAPHICS_COLORBUFFER_5    5
#define NP_GRAPHICS_COLORBUFFER_6    6
#define NP_GRAPHICS_COLORBUFFER_7    7

// State
#define NP_FRONT_FACE               0
#define NP_BACK_FACE                1
#define NP_FRONT_AND_BACK_FACE      2

#define NP_POLYGON_FILL_POINT       0
#define NP_POLYGON_FILL_LINE        1
#define NP_POLYGON_FILL_FACE        2

#define NP_COMPARISON_NEVER         0
#define NP_COMPARISON_ALWAYS        1
#define NP_COMPARISON_LESS          2
#define NP_COMPARISON_LESS_EQUAL    3
#define NP_COMPARISON_EQUAL         4
#define NP_COMPARISON_GREATER       5
#define NP_COMPARISON_GREATER_EQUAL 6

#define NP_BLENDING_ADDITIVE        0
#define NP_BLENDING_AVERAGE         1
#define NP_BLENDING_NEGATIVE        2
#define NP_BLENDING_MIN             3
#define NP_BLENDING_MAX             4

// Renderbuffer
#define NP_GRAPHICS_RENDERBUFFER_DEPTH_TYPE          0
#define NP_GRAPHICS_RENDERBUFFER_STENCIL_TYPE        1
#define NP_GRAPHICS_RENDERBUFFER_DEPTH_STENCIL_TYPE  2

#define NP_GRAPHICS_RENDERBUFFER_DEPTH16 		    0
#define NP_GRAPHICS_RENDERBUFFER_DEPTH24 		    1
#define NP_GRAPHICS_RENDERBUFFER_DEPTH32 		    2
#define NP_GRAPHICS_RENDERBUFFER_STENCIL1           3
#define NP_GRAPHICS_RENDERBUFFER_STENCIL4           4
#define NP_GRAPHICS_RENDERBUFFER_STENCIL8           5
#define NP_GRAPHICS_RENDERBUFFER_STENCIL16          6
#define NP_GRAPHICS_RENDERBUFFER_DEPTH24_STENCIL8	7

// Rendertexture
#define NP_GRAPHICS_RENDERTEXTURE_COLOR_TYPE     0
