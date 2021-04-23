//
//  MDRullerSelectView.h
//  MDHealth
//
//  Created by 林志军 on 2020/8/28.
//  Copyright © 2020 startgo. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MDRullerSelectView;

@protocol MDRullerSelectViewDelegate <NSObject>

-(void)MDRullerSelectStr :(NSString *_Nullable)string :(MDRullerSelectView *_Nullable)rullerView;

@end

typedef NS_ENUM(NSInteger,MDRullerType){
    MDRullerHeight,
    MDRullerWeight
};
NS_ASSUME_NONNULL_BEGIN

@interface MDRullerSelectView : UIView
@property(nonatomic,assign)MDRullerType type;
@property(nonatomic,assign)id<MDRullerSelectViewDelegate> delegate;
@property(nonatomic,copy)NSString *titleStr;
@property(nonatomic,copy)NSString *currentValue;

@property(nonatomic,copy)NSString *myValue;
@end

NS_ASSUME_NONNULL_END
