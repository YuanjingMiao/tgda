#ifndef _NP_MATH_VECTOR_H_
#define _NP_MATH_VECTOR_H_

#include <math.h>

#include "Basics/Types.h"

typedef struct
{
    Double x, y;
}
Vector2;

typedef struct
{
    Double x, y, z;
}
Vector3;

typedef struct
{
    Double x, y, z, w;
}
Vector4;

Double v2_v_square_length(const Vector2 * const v);

Double v2_v_length(const Vector2 * const v);

void v2_v_normalize_v(const Vector2 * const v, Vector2 * n);

void v2_v_normalize(Vector2 * v);

Double v2_vv_dot_product(const Vector2 * const v, const Vector2 * const w);


Double v3_v_square_length(const Vector3 * const v);

Double v3_v_length(const Vector3 * const v);

void v3_v_normalize_v(const Vector3 * const v, Vector3 * n);

void v3_v_normalize(Vector3 * v);

Double v3_vv_dot_product(const Vector3 * const v, const Vector3 * const w);

void v3_vv_cross_product_v(const Vector3 * const v, const Vector3 * const w, Vector3 * out);


/*Double v2_v_square_length(const Vector2 * const v)
{
    return (v->x * v->x + v->y * v->y);
}

Double v2_v_length(const Vector2 * const v)
{
    return sqrt(v2_v_square_length(v));
}

void v2_v_normalize_v(const Vector2 * const v, Vector2 * n)
{
    Double length = v2_v_length(v);
    n->x = v->x/length;
    n->y = v->y/length;
}

void v2_v_normalize(Vector2 * v)
{
    Double length = v2_v_length(v);
    v->x = v->x/length;
    v->y = v->y/length;
}

Double v2_vv_dot_product(const Vector2 * const v, const Vector2 * const w)
{
    return (v->x * w->x + v->y * w->y);
}

Double v3_v_square_length(const Vector3 * const v)
{
    return (v->x * v->x + v->y * v->y + v->z * v->z);
}

Double v3_v_length(const Vector3 * const v)
{
    return sqrt(v3_v_square_length(v));
}

void v3_v_normalize_v(const Vector3 * const v, Vector3 * n)
{
    Double length = v3_v_length(v);
    n->x = v->x/length;
    n->y = v->y/length;
    n->z = v->z/length;
}

void v3_v_normalize(Vector3 * v)
{
    Double length = v3_v_length(v);
    v->x = v->x/length;
    v->y = v->y/length;
    v->z = v->z/length;
}

Double v3_vv_dot_product(const Vector3 * const v, const Vector3 * const w)
{
    return (v->x * w->x + v->y * w->y + v->z * w->z);
}

void v3_vv_cross_product_v(const Vector3 * const v, const Vector3 * const w, Vector3 * out)
{
    out->x = v->y * w->z - v->z * w->y;
    out->y = v->z * w->x - v->x * w->z;
    out->z = v->x * w->y - v->y * w->x;
}*/

#endif

