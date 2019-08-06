//
//  UITableViewProxy.m
//  IOSMasterProj
//
//  Created by redye.hu on 2019/5/9.
//  Copyright © 2019 redye.hu. All rights reserved.
//

#import "UITableViewProxy.h"
#import "SMStatistic.h"

@implementation UITableViewProxy

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [[[SMStatistic create]
      message:[NSString stringWithFormat:@"tableView selected in %@ at row: %ld of section: %ld", NSStringFromClass([self.delegate class]), (long)indexPath.row, indexPath.section]]
     save] ;
    if (self.delegate && [self.delegate respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:)]) {
        [self.delegate tableView:tableView didSelectRowAtIndexPath:indexPath];
    }
}

@end
