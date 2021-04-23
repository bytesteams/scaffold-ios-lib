//
//  PGImageViewFixLTR.m
//  Whisper
//
//  Created by 林志军 on 2020/5/25.
//  Copyright © 2020 PAGO. All rights reserved.
//

#import "PGImageViewFixLTR.h"

@implementation PGImageViewFixLTR

-(void)awakeFromNib{
    [super awakeFromNib];
    self.image = self.image.imageFlippedForRightToLeftLayoutDirection;
}
@end
