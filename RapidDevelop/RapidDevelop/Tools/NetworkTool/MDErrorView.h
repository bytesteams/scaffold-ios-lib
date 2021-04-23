//
//  SGErrorView.h
//  MDHealth
//
//  Created by 林志军 on 2020/7/28.
//  Copyright © 2020 stargo. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^handelRefresh)(void);

NS_ASSUME_NONNULL_BEGIN

@interface MDErrorView : UIView


-(void)showErrorViewIn:(UIView *)contentView;

@property(nonatomic,copy)handelRefresh refreshBlock;

@property(nonatomic,assign)NSInteger code;
@end

NS_ASSUME_NONNULL_END
