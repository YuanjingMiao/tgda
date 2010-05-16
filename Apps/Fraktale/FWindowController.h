#import <AppKit/NSWindowController.h>
#import "Core/Basics/NpTypes.h"

@interface FWindowController : NSWindowController
{
    id tabView;

    // Terrain Stuff
    id lodPopUp;

    id widthTextfield;
    id lengthTextfield;
    id minimumHeightTextfield;
    id maximumHeightTextfield;

    id rngOnePopUp;
    id rngTwoPopUp;
    id rngOneSeedTextfield;
    id rngTwoSeedTextfield;

    id sigmaTextfield;
    id hTextfield;

    id iterationsTextfield;

    // Attractor stuff
    id typePopUp;

    id aTextfield;
    id bTextfield;
    id cTextfield;
    id rTextfield;
    id attractorSigmaTextfield;

    id startingPointXTextfield;
    id startingPointYTextfield;
    id startingPointZTextfield;

    id attractorIterationsTextfield;

    Double bLorentzValue;
    Double bRoesslerValue;

    // Buttons on the bottom
    id resetButton;
    id generateButton;
}

// populate popup buttons
- (void) initPopUpButtons;

// initialise text field values
- (void) initialiseSettingsUsingDictionary:(NSDictionary *)dictionary;

// Terrain
- (void) setWidthTextfieldString:(NSString *)newString;
- (void) setLengthTextfieldString:(NSString *)newString;
- (void) setMinimumHeightTextfieldString:(NSString *)newString;
- (void) setMaximumHeightTextfieldString:(NSString *)newString;
- (void) setSigmaTextfieldString:(NSString *)newString;
- (void) setHTextfieldString:(NSString *)newString;
- (void) setIterationsTextfieldString:(NSString *)newString;

- (void) addLodPopUpItemWithNumber:(Int32)number;
- (void) removeLodPopUpItemWithNumber:(Int32)number;
- (void) selectLodPopUpItemWithIndex:(Int32)index;

// Terrain
- (void) selectLod:(id)sender;
- (void) selectRngOne:(id)sender;
- (void) selectRngTwo:(id)sender;
- (void) setRngOneSeed:(id)sender;
- (void) setRngTwoSeed:(id)sender;

// Attractor
- (void) selectAttractorType:(id)sender;

// Buttons
- (void) reset:(id)sender;
- (void) generate:(id)sender;

@end
