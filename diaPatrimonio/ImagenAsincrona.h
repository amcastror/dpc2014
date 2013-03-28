//
//  ImagenAsincrona.h
//  prototipoTabbed2
//
//  Created by paOnde2 on 1/29/13.
//
//

#import <UIKit/UIKit.h>

@interface ImagenAsincrona : UIImageView

- (id)initWithFrame:(CGRect)frame AndURL:(NSString *)URL AndStartNow:(BOOL)start;
- (void)iniciaDescargaImagenWithBlock:(void (^)())block;
- (void) borraImagen;

@end
