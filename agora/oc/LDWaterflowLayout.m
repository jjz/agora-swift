//
//  LDWaterflowLayout.m
//  瀑布流
//
//  Created by iOS Tedu on 16/8/11.
//  Copyright © 2016年 huaxu. All rights reserved.
//

#import "LDWaterflowLayout.h"

/** 默认的列数 */
static const NSInteger DefaultColumnCount = 3;
/** 每一列之间的间距 */
static const CGFloat DefaultColumnMargin = 10;
/** 每一行之间的间距 */
static const CGFloat DefaultRowMargin = 10;
/** 边缘的间距 */
static const UIEdgeInsets DefaultEdgeInsets = {10, 10, 10, 10};

@interface LDWaterflowLayout()
/** 存放所有cell的布局属性 */
@property (nonatomic, strong) NSMutableArray *attrsArray;
/** 存放所有列的当前高度 */
@property (nonatomic, strong) NSMutableArray *columnHeights;
/** 内容的高度 */
@property (nonatomic, assign) CGFloat contentHeight;

//声明
- (CGFloat)rowMargin;
- (CGFloat)columnMargin;
- (CGFloat)columnCount;
- (UIEdgeInsets)edgeInsets;
@end

@implementation LDWaterflowLayout

#pragma mark - 常见数据处理
- (CGFloat)rowMargin {
    if ([self.delegate respondsToSelector:@selector(rowMarginInWaterflowLayout:)]) {
        return [self.delegate rowMarginInWaterflowLayout:self];
    }else {
        return DefaultRowMargin;
    }
}

- (CGFloat)columnMargin {
    if ([self.delegate respondsToSelector:@selector(columnMarginInWaterflowLayout:)]) {
        return [self.delegate columnMarginInWaterflowLayout:self];
    }else {
        return DefaultColumnMargin;
    }
}

- (CGFloat)columnCount {
    if ([self.delegate respondsToSelector:@selector(columnCountInWaterflowLayout:)]) {
        return [self.delegate columnCountInWaterflowLayout:self];
    }else {
        return DefaultColumnCount;
    }
}

- (UIEdgeInsets)edgeInsets {
    if ([self.delegate respondsToSelector:@selector(edgeInsetsInWaterflowLayout:)]) {
        return [self.delegate edgeInsetsInWaterflowLayout:self];
    }else {
        return DefaultEdgeInsets;
    }
}

#pragma mark - 懒加载
- (NSMutableArray *)attrsArray {
    if (!_attrsArray) {
        _attrsArray = [NSMutableArray array];
    }
    return _attrsArray;
}

- (NSMutableArray *)columnHeights {
    if (!_columnHeights) {
        _columnHeights = [NSMutableArray array];
    }
    return _columnHeights;
}

/**
 *  初始化方法
 */
- (void)prepareLayout {
    [super prepareLayout];
    
    self.contentHeight = 0;
    
    //清除以前计算的所有高度
    [self.columnHeights removeAllObjects];
    for (NSInteger i = 0; i < self.columnCount; i++) {
        [self.columnHeights addObject:@(self.edgeInsets.top)];
    }
    
    //清除之前所有的布局属性
    [self.attrsArray removeAllObjects];
    
    //开始创建每一个cell对应的布局属性
    NSInteger count = [self.collectionView numberOfItemsInSection:0];
    for (NSInteger i = 0; i < count; i++) {
        //创建位置
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        //获取indexPath位置cell对应的布局属性
        UICollectionViewLayoutAttributes *attrs = [self layoutAttributesForItemAtIndexPath:indexPath];
        [self.attrsArray addObject:attrs];
    }
    
}

/**
 *  决定cell的排布
 */
- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    return self.attrsArray;
}

/**
 *  返回indexPath位置cell对应的布局属性
 */
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    //创建布局属性
    UICollectionViewLayoutAttributes *attrs = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
    //collectionView的宽度
    CGFloat collectionViewW = self.collectionView.frame.size.width;
    
    //设置布局属性的frame
    CGFloat width = (collectionViewW - self.edgeInsets.left - self.edgeInsets.right - (self.columnCount - 1)*self.columnMargin) / self.columnCount;
    CGFloat height = [self.delegate waterflowLayout:self heightForItemAtIndex:indexPath.item itemWidth:width];
    
    //找出高度最短的那一列
    //    __block NSInteger destColumn = 0;
    //    __block CGFloat minColumnHeight = MAXFLOAT;
    //    [self.columnHeights enumerateObjectsUsingBlock:^(NSNumber *columnHeightNumber, NSUInteger idx, BOOL * _Nonnull stop) {
    //        CGFloat columnHeight = columnHeightNumber.doubleValue;
    //        if (minColumnHeight > columnHeight) {
    //            minColumnHeight = columnHeight;
    //            destColumn = idx;
    //        }
    //    }];
    
    NSInteger destColumn = 0;
    CGFloat minColumnHeight = [self.columnHeights[0] doubleValue];
    for (NSInteger i = 1; i < self.columnCount; i++) {
        //取出第i列的高度
        CGFloat columnHeight = [self.columnHeights[i] doubleValue];
        if (minColumnHeight > columnHeight) {
            minColumnHeight = columnHeight;
            destColumn = i;
        }
    }
    
    CGFloat x = self.edgeInsets.left + destColumn*(width + self.columnMargin);
    CGFloat y = minColumnHeight;
    //判断是不是第一行
    if (y != self.edgeInsets.top) {
        y += self.rowMargin;
    }
    attrs.frame = CGRectMake(x, y, width, height);
    
    //更新最短那列的高度
    self.columnHeights[destColumn] = @(CGRectGetMaxY(attrs.frame));
    
    //记录内容的高度
    CGFloat columnHeight = [self.columnHeights[destColumn] doubleValue];
    if (self.contentHeight < columnHeight) {
        self.contentHeight = columnHeight;
    }
    
    return attrs;
}

/**
 *  返回内容大小
 */
- (CGSize)collectionViewContentSize {
    return CGSizeMake(0, self.contentHeight + self.edgeInsets.bottom);
}

@end
