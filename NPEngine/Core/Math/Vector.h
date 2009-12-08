#ifndef _NP_MATH_VECTOR_H_
#define _NP_MATH_VECTOR_H_

#include "Core/Basics/NpTypes.h"
#include "Core/Basics/NpFreeList.h"
#include "Accessors.h"

void npmath_vector_initialise();

typedef struct Vector2
{
    Double x, y;
}
Vector2;

typedef struct Vector3
{
    Double x, y, z;
}
Vector3;

typedef struct Vector4
{
    Double x, y, z, w;
}
Vector4;

extern Vector3 * NP_WORLD_X_AXIS;
extern Vector3 * NP_WORLD_Y_AXIS;
extern Vector3 * NP_WORLD_Z_AXIS;
extern Vector3 * NP_WORLD_FORWARD_VECTOR;

Vector2 * v2_alloc();
Vector2 * v2_alloc_init();
Vector2 * v2_alloc_init_with_v2(const Vector2 const * v);
Vector2 * v2_alloc_init_with_components(Double x, Double y);
Vector2 * v2_free(Vector2 * v);
void v2_v_init_with_zeros(Vector2 * v);
void v2_vv_init_with_v2(Vector2 * v1, const Vector2 const * v2);
void v2_vss_init_with_components(Vector2 * v, Double x, Double y);
void v2_v_invert(Vector2 * v);
void v2_v_invert_v(const Vector2 const * v, Vector2 * result);
void v2_v_normalise_v(const Vector2 * const v, Vector2 * normalised);
void v2_v_normalise(Vector2 * v);
void v2_sv_scale(Double scale, Vector2 * v);
void v2_sv_scalex(Double scale, Vector2 * v);
void v2_sv_scaley(Double scale, Vector2 * v);
void v2_sv_scale_v(Double scale, const Vector2 * const v, Vector2 * result);
void v2_sv_scalex_v(Double scale, const Vector2 * const v, Vector2 * result);
void v2_sv_scaley_v(Double scale, const Vector2 * const v, Vector2 * result);
void v2_vv_add_v(const Vector2 * const v, const Vector2 * const w, Vector2 * result);
void v2_vv_sub_v(const Vector2 * const v, const Vector2 * const w, Vector2 * result);
Double v2_vv_dot_product(const Vector2 * const v, const Vector2 * const w);
Double v2_v_square_length(const Vector2 * const v);
Double v2_v_length(const Vector2 * const v);
Vector2 v2_v_inverted(Vector2 * v);
Vector2 v2_vv_add(const Vector2 * const v, const Vector2 * const w);
Vector2 v2_vv_sub(const Vector2 * const v, const Vector2 * const w);
Vector2 v2_sv_scaled(Double scale, const Vector2 const * v);
Vector2 v2_sv_scaledx(Double scale, const Vector2 const * v);
Vector2 v2_sv_scaledy(Double scale, const Vector2 const * v);
const char * v2_v_to_string(Vector2 * v);

Vector3 * v3_alloc();
Vector3 * v3_alloc_init();
Vector3 * v3_alloc_init_with_v3(const Vector3 const * v);
Vector3 * v3_alloc_init_with_components(Double x, Double y, Double z);
Vector3 * v3_free(Vector3 * v);
void v3_v_init_with_zeros(Vector3 * v);
void v3_vv_init_with_v3(Vector3 * v1, const Vector3 const * v2);
void v3_vsss_init_with_components(Vector3 * v, Double x, Double y, Double z);
void v3_v_invert(Vector3 * v);
void v3_v_invert_v(const Vector3 const * v, Vector3 * result);
void v3_v_normalise_v(const Vector3 * const v, Vector3 * normalised);
void v3_v_normalise(Vector3 * v);
void v3_sv_scale(Double scale, Vector3 * v);
void v3_sv_scalex(Double scale, Vector3 * v);
void v3_sv_scaley(Double scale, Vector3 * v);
void v3_sv_scalez(Double scale, Vector3 * v);
void v3_sv_scale_v(Double scale, const Vector3 * const v, Vector3 * result);
void v3_sv_scalex_v(Double scale, const Vector3 * const v, Vector3 * result);
void v3_sv_scaley_v(Double scale, const Vector3 * const v, Vector3 * result);
void v3_sv_scalez_v(Double scale, const Vector3 * const v, Vector3 * result);
void v3_vv_add_v(const Vector3 * const v, const Vector3 * const w, Vector3 * result);
void v3_vv_sub_v(const Vector3 * const v, const Vector3 * const w, Vector3 * result);
void v3_vv_cross_product_v(const Vector3 * const v, const Vector3 * const w, Vector3 * cross);
Double v3_vv_dot_product(const Vector3 * const v, const Vector3 * const w);
Double v3_v_square_length(const Vector3 * const v);
Double v3_v_length(const Vector3 * const v);
Vector3 v3_v_inverted(Vector3 * v);
Vector3 v3_vv_add(const Vector3 * const v, const Vector3 * const w);
Vector3 v3_vv_sub(const Vector3 * const v, const Vector3 * const w);
Vector3 v3_vv_cross_product(const Vector3 * const v, const Vector3 * const w);
Vector3 v3_sv_scaled(Double scale, const Vector3 const * v);
Vector3 v3_sv_scaledx(Double scale, const Vector3 const * v);
Vector3 v3_sv_scaledy(Double scale, const Vector3 const * v);
Vector3 v3_sv_scaledz(Double scale, const Vector3 const * v);
const char * v3_v_to_string(Vector3 * v);

Vector4 * v4_alloc();
Vector4 * v4_alloc_init();
Vector4 * v4_alloc_init_with_v3(Vector3 * v);
Vector4 * v4_alloc_init_with_v4(Vector4 * v);
Vector4 * v4_alloc_init_with_components(Double x, Double y, Double z, Double w);
Vector4 * v4_free(Vector4 * v);
void v4_v_init_with_zeros(Vector4 * v);
void v4_vv_init_with_v3(Vector4 * v1, Vector3 * v2);
void v4_vssss_init_with_components(Vector4 * v, Double x, Double y, Double z, Double w);
const char * v4_v_to_string(Vector4 * v);

#endif

