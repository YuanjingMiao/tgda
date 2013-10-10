#import <Foundation/NSArray.h>
#import <Foundation/NSDictionary.h>
#import <Foundation/NSError.h>
#import <Foundation/NSException.h>
#import "Core/Container/NPAssetArray.h"
#import "Core/World/NPTransformationState.h"
#import "Core/NPEngineCore.h"
#import "Graphics/Effect/NPEffect.h"
#import "Graphics/Effect/NPEffectTechnique.h"
#import "Graphics/Effect/NPEffectVariableFloat.h"
#import "Graphics/Model/NPSUX2Model.h"
#import "Graphics/Model/NPSUX2MaterialInstance.h"
#import "Graphics/State/NPStateSet.h"
#import "Input/NPInputAction.h"
#import "Input/NPInputActions.h"
#import "Input/NPEngineInput.h"
#import "NP.h"
#import "ODCamera.h"
#import "ODPreethamSkylight.h"


@implementation ODPreethamSkylight

- (id) init
{
    return [ self initWithName:@"ODPreethamSkylight" ];
}

- (id) initWithName:(NSString *)newName
{
    self =  [ super initWithName:newName ];

    sunZenithDistanceIncreaseAction
        = [[[ NP Input ] inputActions ]
                addInputActionWithName:@"SunZenithDistanceIncrease" inputEvent:NpKeyboardKeypad2 ];

    sunZenithDistanceDecreaseAction
        = [[[ NP Input ] inputActions ]
                addInputActionWithName:@"SunZenithDistanceDecrease" inputEvent:NpKeyboardKeypad8 ];

    sunAzimuthIncreaseAction
        = [[[ NP Input ] inputActions ]
                addInputActionWithName:@"SunAzimuthIncrease" inputEvent:NpKeyboardKeypad4 ];

    sunAzimuthDecreaseAction
        = [[[ NP Input ] inputActions ]
                addInputActionWithName:@"SunAzimuthDecrease" inputEvent:NpKeyboardKeypad6 ];

    // turbidity must be in the range 2 - 6
    turbidity = 2.0;

    // thetaSun must be between 0 and PI/2
    thetaSun = MATH_PI_DIV_4;
    phiSun = 0.0;

    return self;
}

- (void) dealloc
{
    [[[ NP Input ] inputActions ] removeInputAction:sunZenithDistanceIncreaseAction ];
    [[[ NP Input ] inputActions ] removeInputAction:sunZenithDistanceDecreaseAction ];
    [[[ NP Input ] inputActions ] removeInputAction:sunAzimuthIncreaseAction ];
    [[[ NP Input ] inputActions ] removeInputAction:sunAzimuthDecreaseAction ];

    [ super dealloc ];
}

- (FVector3) lightDirection
{
    return fv3_zero();
}

- (void) update:(const double)frameTime
{

    if ( [ sunZenithDistanceIncreaseAction active ] == YES )
    {
        thetaSun += (MATH_DEG_TO_RAD * 25.0 * frameTime);
    }

    if ( [ sunZenithDistanceDecreaseAction active ] == YES )
    {
        thetaSun -= (MATH_DEG_TO_RAD * 25.0 * frameTime);
    }

    if ( [ sunAzimuthIncreaseAction active ] == YES )
    {
        phiSun += (MATH_DEG_TO_RAD * 25.0 * frameTime);
    }

    if ( [ sunAzimuthDecreaseAction active ] == YES )
    {
        phiSun -= (MATH_DEG_TO_RAD * 25.0 * frameTime);
    }

    thetaSun = MIN(MAX(0.0, thetaSun), MATH_PI_DIV_2);


    if ( phiSun > MATH_2_MUL_PI )
    {
        phiSun -= MATH_2_MUL_PI;
    }

    if ( phiSun < 0.0f )
    {
        phiSun += MATH_2_MUL_PI;
    }

    const double sinThetaSun = sin(thetaSun);
    const double cosThetaSun = cos(thetaSun);
    const double sinPhiSun = sin(phiSun);
    const double cosPhiSun = cos(phiSun);

    Vector3 directionToSun;
    directionToSun.x = sinThetaSun * sinPhiSun;
    directionToSun.y = cosThetaSun;
    directionToSun.z = sinThetaSun * cosPhiSun;

    // zenith color computation
    // A Practical Analytic Model for Daylight
    // page 22/23    

    #define CBQ(X)		((X) * (X) * (X))
    #define SQR(X)		((X) * (X))

    Vector3 zenithColor;
    zenithColor.x
        = ( 0.00165 * CBQ(thetaSun) - 0.00374  * SQR(thetaSun) +
            0.00208 * thetaSun + 0.0f) * SQR(turbidity) +
          (-0.02902 * CBQ(thetaSun) + 0.06377  * SQR(thetaSun) -
            0.03202 * thetaSun  + 0.00394) * turbidity +
          ( 0.11693 * CBQ(thetaSun) - 0.21196  * SQR(thetaSun) +
            0.06052 * thetaSun + 0.25885);

    zenithColor.y
        = ( 0.00275 * CBQ(thetaSun) - 0.00610  * SQR(thetaSun) +
            0.00316 * thetaSun + 0.0) * SQR(turbidity) +
          (-0.04214 * CBQ(thetaSun) + 0.08970  * SQR(thetaSun) -
            0.04153 * thetaSun  + 0.00515) * turbidity  +
          ( 0.15346 * CBQ(thetaSun) - 0.26756  * SQR(thetaSun) +
            0.06669 * thetaSun  + 0.26688);

    zenithColor.z
        = (4.0453 * turbidity - 4.9710) * 
          tan((4.0 / 9.0 - turbidity / 120.0) * (M_PI - 2.0 * thetaSun))
          - 0.2155 * turbidity + 2.4192;

	// convert kcd/m² to cd/m²
	zenithColor.z *= 1000.0f;

    #undef SQR
    #undef CBQ
}

- (void) render
{
	double ABCDE_x[5], ABCDE_y[5], ABCDE_Y[5];

	ABCDE_x[0] = -0.01925 * turbidity - 0.25922;
	ABCDE_x[1] = -0.06651 * turbidity + 0.00081;
	ABCDE_x[2] = -0.00041 * turbidity + 0.21247;
	ABCDE_x[3] = -0.06409 * turbidity - 0.89887;
	ABCDE_x[4] = -0.00325 * turbidity + 0.04517;

	ABCDE_y[0] = -0.01669 * turbidity - 0.26078;
	ABCDE_y[1] = -0.09495 * turbidity + 0.00921;
	ABCDE_y[2] = -0.00792 * turbidity + 0.21023;
	ABCDE_y[3] = -0.04405 * turbidity - 1.65369;
	ABCDE_y[4] = -0.01092 * turbidity + 0.05291;

	ABCDE_Y[0] =  0.17872 * turbidity - 1.46303;
	ABCDE_Y[1] = -0.35540 * turbidity + 0.42749;
	ABCDE_Y[2] = -0.02266 * turbidity + 5.32505;
	ABCDE_Y[3] =  0.12064 * turbidity - 2.57705;
	ABCDE_Y[4] = -0.06696 * turbidity + 0.37027;

    const FVector3 A = { ABCDE_x[0], ABCDE_y[0], ABCDE_Y[0] };
    const FVector3 B = { ABCDE_x[1], ABCDE_y[1], ABCDE_Y[1] };
    const FVector3 C = { ABCDE_x[2], ABCDE_y[2], ABCDE_Y[2] };
    const FVector3 D = { ABCDE_x[3], ABCDE_y[3], ABCDE_Y[3] };
    const FVector3 E = { ABCDE_x[4], ABCDE_y[4], ABCDE_Y[4] };

    [ A_Yxy_P setFValue:A ];
    [ B_Yxy_P setFValue:B ];
    [ C_Yxy_P setFValue:C ];
    [ D_Yxy_P setFValue:D ];
    [ E_Yxy_P setFValue:E ];
    //[ zenithColor_P setFValue:zenithColor ];
    //[ lighDirection_P setFValue:lightDirection ];
}

@end

