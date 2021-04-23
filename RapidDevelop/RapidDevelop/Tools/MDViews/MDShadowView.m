//
//  MDShadowView.m
//  MDHealth
//
//  Created by 林志军 on 2020/9/27.
//  Copyright © 2020 startgo. All rights reserved.
//

#import "MDShadowView.h"

@implementation MDShadowView

-(void)awakeFromNib{
    [super awakeFromNib];
    self.layer.cornerRadius = kFitW(6);
    self.layer.shadowOpacity = 0.1;
    self.layer.shadowColor = RGB(50, 50, 50).CGColor;
    self.layer.shadowOffset = CGSizeMake(0, 1);//偏移距离
    self.layer.shadowRadius = 3;//半径
    self.clipsToBounds = NO;
}
@end
