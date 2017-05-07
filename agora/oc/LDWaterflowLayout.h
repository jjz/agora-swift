//
//  LDWaterflowLayout.h
//  瀑布流
//
//  Created by iOS Tedu on 16/8/11.
//  Copyright © 2016年 huaxu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LDWaterflowLayout;
@protocol LDWaterflowLayoutDelegate <NSObject>

@required
/** 返回每个Item的高度 */
- (CGFloat)waterflowLayout:(LDWaterflowLayout *)waterflowLayout heightForItemAtIndex:(NSUInteger)index itemWidth:(CGFloat)itemWidth;

@optional
/** 返回的列数，默认为3 */
- (CGFloat)columnCountInWaterflowLayout:(LDWaterflowLayout *)waterflowLayout;
/** 每一列之间的间距，默认为10 */
- (CGFloat)columnMarginInWaterflowLayout:(LDWaterflowLayout *)waterflowLayout;
/** 每一行之间的间距，默认为10 */
- (CGFloat)rowMarginInWaterflowLayout:(LDWaterflowLayout *)waterflowLayout;
/** 边缘的间距，默认为10 */
- (UIEdgeInsets)edgeInsetsInWaterflowLayout:(LDWaterflowLayout *)waterflowLayout;

@end

@interface LDWaterflowLayout : UICollectionViewLayout
/** 代理 */
@property (nonatomic, weak) id<LDWaterflowLayoutDelegate> delegate;
@end
