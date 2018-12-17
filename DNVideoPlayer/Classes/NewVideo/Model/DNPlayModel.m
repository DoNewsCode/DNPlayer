//
//  DNPlayModel.m
//  DoNews
//
//  Created by Madjensen on 2018/8/16.
//  Copyright © 2018 donews. All rights reserved.
//

#import "DNPlayModel.h"

NS_ASSUME_NONNULL_BEGIN
@implementation DNPlayModel

- (instancetype)init
{
    self = [super init];
    if ( !self ) return nil;
    return self;
}

- (BOOL)isPlayInTableView { return NO; }
- (BOOL)isPlayInCollectionView { return NO; }
- (nullable UIView *)playerSuperview { return nil; }


+ (instancetype)UITableViewCellPlayModelWithPlayerSuperviewTag:(NSInteger)playerSuperviewTag
                                                   atIndexPath:(__strong NSIndexPath *)indexPath
                                                     tableView:(__weak UITableView *)tableView
{
    return [[DNUITableViewCellPlayModel alloc] initWithPlayerSuperviewTag:playerSuperviewTag atIndexPath:indexPath tableView:tableView];
}

@end

@implementation DNUITableViewCellPlayModel
- (instancetype)initWithPlayerSuperview:(__unused UIView<DNPlayModelViewProtocol> *)playerSuperview
atIndexPath:(__strong NSIndexPath *)indexPath
tableView:(__weak UITableView *)tableView
{
    return [self initWithPlayerSuperviewTag:playerSuperview.tag atIndexPath:indexPath tableView:tableView];
}

- (instancetype)initWithPlayerSuperviewTag:(NSInteger)playerSuperviewTag
                               atIndexPath:(__strong NSIndexPath *)indexPath
                                 tableView:(__weak UITableView *)tableView {
    NSParameterAssert(playerSuperviewTag != 0);
    NSParameterAssert(indexPath);
    NSParameterAssert(tableView);

    self = [super init];
    if ( !self ) return nil;
    _playerSuperviewTag = playerSuperviewTag;
    _indexPath = indexPath;
    _tableView = tableView;
    return self;
}
- (BOOL)isPlayInTableView { return YES; }
- (BOOL)isPlayInCollectionView { return NO; }
- (nullable UIView *)playerSuperview {
    return [[self.tableView cellForRowAtIndexPath:self.indexPath] viewWithTag:self.playerSuperviewTag];
}

@end

NS_ASSUME_NONNULL_END
