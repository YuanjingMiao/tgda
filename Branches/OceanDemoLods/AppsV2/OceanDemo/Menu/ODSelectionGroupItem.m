#import <Foundation/NSArray.h>
#import <Foundation/NSDictionary.h>
#import <Foundation/NSError.h>
#import <Foundation/NSException.h>
#import "Graphics/Geometry/NPIMRendering.h"
#import "Graphics/Effect/NPEffectVariableFloat.h"
#import "Graphics/Effect/NPEffectTechnique.h"
#import "Graphics/Effect/NPEffect.h"
#import "Graphics/Font/NPFont.h"
#import "ODMenu.h"
#import "ODSelectionGroupItem.h"

@interface ODSelectionGroupItem (Private)

- (void) renderGeometry;
- (void) renderLabels;

@end

@implementation ODSelectionGroupItem (Private)

- (void) renderGeometry
{
    const FVector4 lineColor = {1.0f, 1.0f, 1.0f, [ menu opacity ]};
    const FVector4 quadColor = {1.0f, 1.0f, 1.0f, [ menu opacity ] * 0.25f};

    // start with the lower left of the upper left item
    FVector2 lowerLeft
        = {alignedGeometry.min.x, alignedGeometry.max.y - itemSize.y};

    // draw items row wise
    for ( int32_t i = 0; i < layout.y; i++ )
    {
        for ( int32_t j = 0; j < layout.x; j++ )
        {
            const NSUInteger index = i * layout.x + j;

            FRectangle itemGeometry;
            frectangle_rvv_init_with_min_and_size(&itemGeometry, &lowerLeft, &itemSize);

            if ( index == indexOfActiveItem )
            {
                [ color setFValue:quadColor ];
                [ technique activate ];

                [ NPIMRendering renderFRectangle:itemGeometry
                                   primitiveType:NpPrimitiveQuads ];
            }

            FRectangle pixelCenterGeometry = itemGeometry;
            pixelCenterGeometry.min.x += 0.5f;
            pixelCenterGeometry.min.y += 0.5f;
            pixelCenterGeometry.max.x -= 0.5f;
            pixelCenterGeometry.max.y -= 0.5f;

            // draw line
            [ color setFValue:lineColor ];
            [ technique activate ];

            [ NPIMRendering renderFRectangle:pixelCenterGeometry
                               primitiveType:NpPrimitiveLineLoop ];

			lowerLeft.x = lowerLeft.x + itemSize.x + itemSpacing.x;
        }

		lowerLeft.x = alignedGeometry.min.x;
		lowerLeft.y = lowerLeft.y - itemSpacing.y - itemSize.y;
    }
}

- (void) renderLabels
{
    NPFont * font = [ menu fontForSize:textSize ];

    const FVector4 textColor = {1.0f, 1.0f, 1.0f, [ menu opacity ]};

    // start with the lower left of the upper left item
    FVector2 lowerLeft
        = {alignedGeometry.min.x, alignedGeometry.max.y - itemSize.y};

    for ( int32_t i = 0; i < layout.y; i++ )
    {
        for ( int32_t j = 0; j < layout.x; j++ )
        {
            const NSUInteger index = i * layout.x + j;
            NSString * label = [ labels objectAtIndex:index ];
            IVector2 labelBounds = [ font boundsForString:label size:textSize ];

            FRectangle itemGeometry;
            frectangle_rvv_init_with_min_and_size(&itemGeometry, &lowerLeft, &itemSize);

            int32_t centeringX = (int32_t)round((itemSize.x - labelBounds.x) / 2.0f);
            int32_t centeringY = (int32_t)round((itemSize.y - labelBounds.y) / 2.0f);
            IVector2 labelPosition;
            labelPosition.x = itemGeometry.min.x + centeringX;
            labelPosition.y = itemGeometry.max.y - centeringY + 1;

            [ font renderString:label
                      withColor:textColor
                     atPosition:labelPosition
                           size:textSize ];

			lowerLeft.x = lowerLeft.x + itemSize.x + itemSpacing.x;
        }

		lowerLeft.x = alignedGeometry.min.x;
		lowerLeft.y = lowerLeft.y - itemSpacing.y - itemSize.y;
    }
}

@end

@implementation ODSelectionGroupItem

- (id) init
{
    [ self notImplemented:_cmd ];
    return nil;
}

- (id) initWithName:(NSString *)newName
{
    [ self notImplemented:_cmd ];
    return nil;
}

- (id) initWithName:(NSString *)newName
               menu:(ODMenu *)newMenu
{
    self = [ super initWithName:newName menu:newMenu ];

    itemSize.x = itemSize.y = 0.0f;
    itemSpacing.x = itemSpacing.y = 0.0f;
    layout.x = layout.y = 0;
    indexOfActiveItem = ULONG_MAX;

    return self;
}

- (void) dealloc
{
    SAFE_DESTROY(labels);
    SAFE_DESTROY(technique);
    SAFE_DESTROY(color);

    [ super dealloc ];
}

- (BOOL) loadFromDictionary:(NSDictionary *)source
                      error:(NSError **)error
{
    BOOL result
        = [ super loadFromDictionary:source error:error ];

    if ( result == NO )
    {
        return NO;
    }

    NSArray * itemSizeStrings     = [ source objectForKey:@"ItemSize" ];
    NSArray * itemSpacingStrings  = [ source objectForKey:@"Spacing"  ];
    NSArray * layoutStrings       = [ source objectForKey:@"Layout"   ];
    NSArray * itemLabels          = [ source objectForKey:@"Labels"   ];

    NSAssert(itemSizeStrings != nil && itemSpacingStrings != nil
             && layoutStrings != nil && itemLabels != nil, @"");

    itemSize.x = [[ itemSizeStrings objectAtIndex:0 ] intValue ];
    itemSize.y = [[ itemSizeStrings objectAtIndex:1 ] intValue ];

    itemSpacing.x = [[ itemSpacingStrings objectAtIndex:0 ] intValue ];
    itemSpacing.y = [[ itemSpacingStrings objectAtIndex:1 ] intValue ];

    layout.x = [[ layoutStrings objectAtIndex:0 ] intValue ];
    layout.y = [[ layoutStrings objectAtIndex:1 ] intValue ];

    labels = [[ NSArray alloc ] initWithArray:itemLabels copyItems:YES ];


    FVector2 realSize = {0.0f, 0.0f};

	for ( int32_t i = 0; i < layout.x; i++ )
	{
		realSize.x += itemSize.x;

		if ( i != (layout.x - 1 ))
		{
			realSize.x += itemSpacing.x;
		}
	}

	for (int32_t i = 0; i < layout.y; i++)
	{
		realSize.y += itemSize.y;

		if ( i != (layout.y - 1 ))
		{
			realSize.y += itemSpacing.y;
		}
	}

    FVector2 position = geometry.min;
    frectangle_rvv_init_with_min_and_size(&geometry, &position, &realSize);

    technique = RETAIN([ menu colorTechnique ]);
    color = RETAIN([[ menu effect ] variableWithName:@"color" ]);

    return YES;
}

- (void) onClick:(const FVector2)mousePosition
{
    FVector2 lowerLeft
        = {alignedGeometry.min.x, alignedGeometry.max.y - itemSize.y};

    for ( int32_t i = 0; i < layout.y; i++ )
    {
        for ( int32_t j = 0; j < layout.x; j++ )
        {
            const NSUInteger index = i * layout.x + j;

            FRectangle itemGeometry;
            frectangle_rvv_init_with_min_and_size(&itemGeometry, &lowerLeft, &itemSize);
            if ( frectangle_vr_is_point_inside(&mousePosition, &itemGeometry) != 0 )
            {
                indexOfActiveItem = index;

                // set target property
                if ( target != nil )
                {
                    ODObjCSetVariable(target, offset, size, &indexOfActiveItem);
                }

                return;
            }

			lowerLeft.x = lowerLeft.x + itemSize.x + itemSpacing.x;
        }

		lowerLeft.x = alignedGeometry.min.x;
		lowerLeft.y = lowerLeft.y - itemSpacing.y - itemSize.y;
    }
}

- (void) update:(const float)frameTime
{
    alignedGeometry
        = [ ODMenu alignRectangle:geometry withAlignment:alignment ];

        // get value from target
    if ( target != nil )
    {
        ODObjCGetVariable(target, offset, size, &indexOfActiveItem);
    }
}

- (void) render
{
    [ self renderGeometry ];
    [ self renderLabels ];
}

@end
