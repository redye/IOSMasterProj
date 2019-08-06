//
//  UIMacroDefinition.h
//  IOSMasterProj
//
//  Created by redye.hu on 2019/5/31.
//  Copyright © 2019 redye.hu. All rights reserved.
//

#ifndef UIMacroDefinition_h
#define UIMacroDefinition_h

#define SMRGBColor(r, g, b) [UIColor colorWithRed: r / 255.0 green:g / 255.0 blue: b / 255.0 alpha: 1]
#define SMRGBAColor(r, g, b, a) [UIColor colorWithRed: r / 255.0 green:g / 255.0 blue: b / 255.0 alpha: a]

#define ThemeColor SMRGBColor(0xFE, 0xAF, 0x38)
#define LineColor SMRGBColor(0xf0, 0xf0, 0xf0)
#define TextColor SMRGBColor(0x33, 0x33, 0x33)
#define PlaceholerColor SMRGBColor(0x99, 0x99, 0x99)
#define BackgroundColor SMRGBColor(0xf4, 0xf6, 0xfa)


#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREENH_HEIGHT [UIScreen mainScreen].bounds.size.height
#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREENH_HEIGHT))
#define IS_IPHONE_X (IS_IPHONE && (SCREEN_MAX_LENGTH == 812.0 || SCREEN_MAX_LENGTH == 896.0))


#endif /* UIMacroDefinition_h */
