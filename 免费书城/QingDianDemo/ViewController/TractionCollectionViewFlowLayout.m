//
//  TractionCollectionViewFlowLayout.m
//  Contacts
//
//  Created by sg021 on 16/11/1.
//  Copyright © 2016年 sg021. All rights reserved.
//

#import "TractionCollectionViewFlowLayout.h"

// 背景色相关
static NSString *const TractionCollectionViewSectionColor = @"com.ulb.ULBCollectionElementKindSectionColor";

@interface TractionCollectionViewLayoutAttributes  : UICollectionViewLayoutAttributes
// 背景色
@property (nonatomic, strong) UIColor *backgroudColor;

@end

@implementation TractionCollectionViewLayoutAttributes

@end

@interface TractionCollectionReusableView : UICollectionReusableView

@end


@implementation TractionCollectionReusableView

- (void)applyLayoutAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes{
    [super applyLayoutAttributes:layoutAttributes];
    TractionCollectionViewLayoutAttributes *attr = (TractionCollectionViewLayoutAttributes *)layoutAttributes;
    self.backgroundColor = attr.backgroudColor;
}

@end
// 背景色相关




static const NSInteger kHeaderZIndex = 255;

@interface TractionCollectionViewFlowLayout ()

@property (nonatomic, strong) UIDynamicAnimator *animator;

@property (nonatomic, strong) NSMutableArray<UICollectionViewLayoutAttributes *> *decorationViewAttrs;  //背景色相关


@end

@implementation TractionCollectionViewFlowLayout

-(id)init {
    if ([super init]) {
        _springDamping = 0.0;
        _springFrequency = 0.0;
        _resistanceFactor = 0.0;
    }
    return self;
}

-(void)setSpringDamping:(CGFloat)springDamping {
    if (springDamping >= 0 && _springDamping != springDamping) {
        _springDamping = springDamping;
        for (UIAttachmentBehavior *spring in _animator.behaviors) {
            spring.damping = _springDamping;
        }
    }
}

-(void)setSpringFrequency:(CGFloat)springFrequency {
    if (springFrequency >= 0 && _springFrequency != springFrequency) {
        _springFrequency = springFrequency;
        for (UIAttachmentBehavior *spring in _animator.behaviors) {
            spring.frequency = _springFrequency;
        }
    }
}


-(void)prepareLayout {
    [super prepareLayout];
    
    if (!_animator) {
        _animator = [[UIDynamicAnimator alloc] initWithCollectionViewLayout:self];
    }
    if (_isRefresh) {
        [_animator removeAllBehaviors];
        CGSize contentSize = [self collectionViewContentSize];
        NSArray *items = [super layoutAttributesForElementsInRect:CGRectMake(0, 0, contentSize.width, contentSize.height)];
        for (UICollectionViewLayoutAttributes *item in items) {
            UIAttachmentBehavior *spring = [[UIAttachmentBehavior alloc] initWithItem:item attachedToAnchor:item.center];
            
            spring.length = 0;
            spring.damping = self.springDamping;
            spring.frequency = self.springFrequency;
            [_animator addBehavior:spring];
        }
    }
    
    // 背景色相关
    NSInteger sections = [self.collectionView numberOfSections];
    id<TractionCollectionViewDelegateFlowLayout> delegate  = self.collectionView.delegate;
    if ([delegate respondsToSelector:@selector(collectionView:layout:colorForSectionAtIndex:)]) {
    }else{
        return ;
    }
    
    //1.初始化
    [self registerClass:[TractionCollectionReusableView class] forDecorationViewOfKind:TractionCollectionViewSectionColor];
    [self.decorationViewAttrs removeAllObjects];
    
    for (NSInteger section =0; section < sections; section++) {
        NSInteger numberOfItems = [self.collectionView numberOfItemsInSection:section];
        if (numberOfItems > 0) {
            UICollectionViewLayoutAttributes *firstAttr = [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:section]];
            UICollectionViewLayoutAttributes *lastAttr = [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForRow:(numberOfItems - 1) inSection:section]];
            
            UIEdgeInsets sectionInset = self.sectionInset;
            if ([delegate respondsToSelector:@selector(collectionView:layout:insetForSectionAtIndex:)]) {
                UIEdgeInsets inset = [delegate collectionView:self.collectionView layout:self insetForSectionAtIndex:section];
                if (!UIEdgeInsetsEqualToEdgeInsets(inset, sectionInset)) {
                    sectionInset = inset;
                }
            }
            
            
            CGRect sectionFrame = CGRectUnion(firstAttr.frame, lastAttr.frame);
            sectionFrame.origin.x -= sectionInset.left;
            sectionFrame.origin.y -= sectionInset.top;
            if (self.scrollDirection == UICollectionViewScrollDirectionHorizontal) {
                sectionFrame.size.width += sectionInset.left + sectionInset.right;
                sectionFrame.size.height = self.collectionView.frame.size.height;
            }else{
                sectionFrame.size.width = self.collectionView.frame.size.width;
                sectionFrame.size.height += sectionInset.top + sectionInset.bottom;
            }
            
            //2. 定义
            TractionCollectionViewLayoutAttributes *attr = [TractionCollectionViewLayoutAttributes layoutAttributesForDecorationViewOfKind:TractionCollectionViewSectionColor withIndexPath:[NSIndexPath indexPathForRow:0 inSection:section]];
            // 这里是定义背景的位置的
            //            attr.frame = sectionFrame;
            attr.frame = CGRectMake(10, sectionFrame.origin.y, sectionFrame.size.width - 20, sectionFrame.size.height - (kWindowH - 134 - QDR_APP_HEIGHT));
            attr.zIndex = -1;
            attr.backgroudColor = [delegate collectionView:self.collectionView layout:self colorForSectionAtIndex:section];
            [self.decorationViewAttrs addObject:attr];
        }else{
            continue ;
        }
    }
    // 背景色相关
}

// 背景色相关
- (NSMutableArray<UICollectionViewLayoutAttributes *> *)decorationViewAttrs{
    if (!_decorationViewAttrs) {
        _decorationViewAttrs = [NSMutableArray array];
    }
    return _decorationViewAttrs;
}
// 背景色相关

//-(void)prepareLayout {
//    [super prepareLayout];
//
//    if (!_animator) {
//        _animator = [[UIDynamicAnimator alloc] initWithCollectionViewLayout:self];
//        CGSize contentSize = [self collectionViewContentSize];
//        NSArray *items = [super layoutAttributesForElementsInRect:CGRectMake(0, 0, contentSize.width, contentSize.height)];
//
//        for (UICollectionViewLayoutAttributes *item in items) {
//            UIAttachmentBehavior *spring = [[UIAttachmentBehavior alloc] initWithItem:item attachedToAnchor:item.center];
//
//            spring.length = 0;
//            spring.damping = self.springDamping;
//            spring.frequency = self.springFrequency;
//
//            [_animator addBehavior:spring];
//        }
//    }
//}
//
//-(NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
//
//    if (self.collectionView.dataSource != nil) {
//
//        //牵引效果
//        NSMutableArray *animatorRectArray = [NSMutableArray arrayWithArray:[_animator itemsInRect:rect]];
//        NSInteger headerIndex = 0;
//        BOOL HeaderExist = NO;
//        for (int i = 0; i < animatorRectArray.count; i++) {
//            UICollectionViewLayoutAttributes *originalAttribute = animatorRectArray[i];
//            if ([[originalAttribute representedElementKind] isEqualToString:UICollectionElementKindSectionHeader]) {
//                headerIndex = i;
//                HeaderExist = YES;
//            }
//        }
//
//        //普通效果
//        NSMutableArray *allItems = [NSMutableArray array];
//        NSArray *originalAttributes = [super layoutAttributesForElementsInRect:rect];
//        //Perform a deep copy of the attributes returned from super
//        for (UICollectionViewLayoutAttributes *originalAttribute in originalAttributes) {
//            [allItems addObject:[originalAttribute copy]];
//        }
//
//        NSMutableDictionary *headers = [[NSMutableDictionary alloc] init];
//        NSMutableDictionary *lastCells = [[NSMutableDictionary alloc] init];
//
//        [allItems enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
//            NSIndexPath *indexPath = [(UICollectionViewLayoutAttributes *)obj indexPath];
//            BOOL isHeader = [[obj representedElementKind] isEqualToString:UICollectionElementKindSectionHeader];
//            BOOL isFooter = [[obj representedElementKind] isEqualToString:UICollectionElementKindSectionFooter];
//
//            if (isHeader) {
//                [headers setObject:obj forKey:@(indexPath.section)];
//            } else if (isFooter) {
//                // Not implemeneted
//            } else {
//                UICollectionViewLayoutAttributes *currentAttribute = [lastCells objectForKey:@(indexPath.section)];
//
//                // Get the bottom most cell of that section
//                if ( ! currentAttribute || indexPath.row > currentAttribute.indexPath.row) {
//                    [lastCells setObject:obj forKey:@(indexPath.section)];
//                }
//
//            }
//        }];
//
//        [lastCells enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
//            NSIndexPath *indexPath = [obj indexPath];
//            NSNumber *indexPathKey = @(indexPath.section);
//            UICollectionViewLayoutAttributes *header = headers[indexPathKey];
//            // CollectionView automatically removes headers not in bounds
//            if ( ! header) {
//                header = [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader
//                                                              atIndexPath:[NSIndexPath indexPathForItem:0 inSection:indexPath.section]];
//
//                if (!CGSizeEqualToSize(CGSizeZero, header.frame.size)) {
//                    [animatorRectArray addObject:header];
//                }
//            }else{
//                [animatorRectArray replaceObjectAtIndex:headerIndex withObject:header];
//            }
//            if (!CGSizeEqualToSize(CGSizeZero, header.frame.size)) {
//                [self updateHeaderAttributes:header lastCellAttributes:lastCells[indexPathKey]];
//            }
//        }];
//            return animatorRectArray;
//    } else {
//        return nil;
//    }
//
//
//}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    return [_animator layoutAttributesForCellAtIndexPath:indexPath];
}

-(BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    UIScrollView *scrollView = self.collectionView;
    CGFloat scrollDelta = newBounds.origin.y - scrollView.bounds.origin.y;
    CGPoint touchLocation = [scrollView.panGestureRecognizer locationInView:scrollView];
    
    for (UIAttachmentBehavior *spring in _animator.behaviors) {
        CGPoint anchorPoint = spring.anchorPoint;
        CGFloat distanceFromTouch = fabs(touchLocation.y - anchorPoint.y);
        CGFloat scrollResistance = distanceFromTouch / self.resistanceFactor;
        
        UICollectionViewLayoutAttributes *item = (UICollectionViewLayoutAttributes *)[spring.items firstObject];
        CGPoint center = item.center;
        center.y += (scrollDelta > 0) ? MIN(scrollDelta, scrollDelta * scrollResistance)
        : MAX(scrollDelta, scrollDelta * scrollResistance);
        item.center = center;
        [_animator updateItemUsingCurrentState:item];
    }
    return YES;
}
//- (void)updateHeaderAttributes:(UICollectionViewLayoutAttributes *)attributes
//{
//    attributes.zIndex = kHeaderZIndex;
//    attributes.hidden = NO;
//
//    CGPoint origin = attributes.frame.origin;
//
//    if (origin.y <0 ) {
//        origin.y = 0;
//    }
//    attributes.frame = (CGRect){
//        origin,
//        attributes.frame.size
//    };
//}

#pragma mark Helper

- (void)updateHeaderAttributes:(UICollectionViewLayoutAttributes *)attributes lastCellAttributes:(UICollectionViewLayoutAttributes *)lastCellAttributes
{
    CGRect currentBounds = self.collectionView.bounds;
    attributes.zIndex = kHeaderZIndex;
    attributes.hidden = NO;
    
    CGPoint origin = attributes.frame.origin;
    
    CGFloat sectionMaxY = CGRectGetMaxY(lastCellAttributes.frame) - attributes.frame.size.height;
    CGFloat y = CGRectGetMaxY(currentBounds) - currentBounds.size.height + self.collectionView.contentInset.top;
    y -= 125;
    CGFloat maxY = MIN(MAX(y, attributes.frame.origin.y), sectionMaxY);
    
    origin.y = maxY;
    
    attributes.frame = (CGRect){
        origin,
        attributes.frame.size
    };
}

- (NSArray *) layoutAttributesForElementsInRect:(CGRect)rect
{
    
    NSMutableArray *superArray = [[NSMutableArray arrayWithArray:[_animator itemsInRect:rect]] mutableCopy];
    
    NSMutableIndexSet *noneHeaderSections = [NSMutableIndexSet indexSet];
    
    for (UICollectionViewLayoutAttributes *attributes in superArray)
    {
        if (attributes.representedElementCategory == UICollectionElementCategoryCell)
        {
            [noneHeaderSections addIndex:attributes.indexPath.section];
        }
    }
    for (UICollectionViewLayoutAttributes *attributes in superArray) {
        if ([attributes.representedElementKind isEqualToString:UICollectionElementKindSectionHeader]) {
            [noneHeaderSections removeIndex:attributes.indexPath.section];
        }
    }
    
    [noneHeaderSections enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:idx];
        UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader atIndexPath:indexPath];
        if (attributes) {
            [superArray addObject:attributes];
        }
    }];
    
    for (UICollectionViewLayoutAttributes *attributes in superArray) {
        
        //如果当前item是header
        if ([attributes.representedElementKind isEqualToString:UICollectionElementKindSectionHeader]) {
            
            //得到当前header所在分区的cell的数量
            NSInteger numberOfItemsInSection = [self.collectionView numberOfItemsInSection:attributes.indexPath.section];
            //得到第一个item的indexPath
            NSIndexPath *firstItemIndexPath = [NSIndexPath indexPathForItem:0 inSection:attributes.indexPath.section];
            //得到最后一个item的indexPath
            NSIndexPath *lastItemIndexPath = [NSIndexPath indexPathForItem:MAX(0, numberOfItemsInSection-1) inSection:attributes.indexPath.section];
            UICollectionViewLayoutAttributes *firstItemAttributes, *lastItemAttributes;
            if (numberOfItemsInSection>0) {
                
                firstItemAttributes = [self layoutAttributesForItemAtIndexPath:firstItemIndexPath];
                lastItemAttributes = [self layoutAttributesForItemAtIndexPath:lastItemIndexPath];
            }else{
                
                firstItemAttributes = [UICollectionViewLayoutAttributes new];
                
                CGFloat y = CGRectGetMaxY(attributes.frame) + self.sectionInset.top;
                firstItemAttributes.frame = CGRectMake(0, y, 0, 0);
                
                lastItemAttributes = firstItemAttributes;
            }
            
            //获取当前header的frame
            CGRect rect = attributes.frame;
            
            CGFloat offset = self.collectionView.contentOffset.y - QDR_HOME_CONTENTOFFSET;
            //第一个cell的y值 - 当前header的高度 - 可能存在的sectionInset的top
            CGFloat headerY = firstItemAttributes.frame.origin.y - rect.size.height - self.sectionInset.top;
            
            CGFloat maxY = MAX(offset,headerY);
            
            
            //  CGFloat headerMissingY = CGRectGetMaxY(lastItemAttributes.frame) + self.sectionInset.bottom - rect.size.height;
            
            //   rect.origin.y = MIN(maxY,headerMissingY);
            rect.origin.y = maxY;
            !_offsetBlock?:_offsetBlock(offset);
            attributes.frame = rect;
            
            attributes.zIndex = 2;
        }
    }
    
    // 背景色相关
    for (UICollectionViewLayoutAttributes *attr in self.decorationViewAttrs) {
        if (CGRectIntersectsRect(rect, attr.frame)) {
            [superArray addObject:attr];
        }
    }
    // 背景色相关
    
    //转换回不可变数组，并返回
    return [superArray copy];
    
}


@end
