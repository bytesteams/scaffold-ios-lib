//
//  UITextField+MBIBnspectable.m
//  MDHealth
//
//  Created by 林志军 on 2020/11/23.
//  Copyright © 2020 startgo. All rights reserved.
//

#import "UITextField+MBIBnspectable.h"
#import "UITextField+Placeholder.h"
@implementation UITextField (MBIBnspectable)

- (void)setLocalized:(NSString *)localized {
   
    self.placeholder = kLocalized(localized);
    self.placeholderColor = kText9A9;
    
}

- (NSString *)localized {
    return self.placeholder;
}


@end
