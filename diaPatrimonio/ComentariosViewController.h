//
//  ComentariosViewController.h
//  DiaDelPatrimonio
//
//  Created by Matias Castro on 19-04-13.
//  Copyright (c) 2013 Matias Castro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GAITrackedViewController.h"

@interface ComentariosViewController : GAITrackedViewController <UITableViewDataSource, UITableViewDelegate>{
    IBOutlet UITableView *tablaComentarios;
    NSArray *comentarios;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil AndComentarios:(NSArray *)_comentarios;
@end
