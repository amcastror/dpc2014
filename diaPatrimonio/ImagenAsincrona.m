//
//  ImagenAsincrona.m
//  prototipoTabbed2
//
//  Created by paOnde2 on 1/29/13.
//
//

#import "ImagenAsincrona.h"
#import "AFImageRequestOperation.h"
#import "APIClient.h"
#import "DejalActivityView.h"

@implementation ImagenAsincrona{
    UIProgressView *progress_view;
    BOOL descargada;
    NSString *URL;
}

- (id)initWithFrame:(CGRect)frame AndURL:(NSString *)_URL AndStartNow:(BOOL)start
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        progress_view = [[UIProgressView alloc] initWithFrame:CGRectMake(self.frame.size.width*1/6, self.frame.size.height/2 - 10, self.frame.size.width*2/3, 20)];
        
        if (_URL) {
            URL = _URL;
            /*
            path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory,
                                                        NSUserDomainMask,
                                                        YES) lastObject];
            path = [NSString stringWithFormat:@"%@/%@_img.png", path, [URL stringFromMD5]];
             */
        }
         
        descargada = NO;
         
        if(start){
            [self iniciaDescargaImagenWithBlock:nil];
        }
    }
    return self;
}

-(void)iniciaDescargaImagenWithBlock:(void (^)())block{
    if (!descargada) { //Si no no hago nada...
        descargada = YES; //asumo que si va a funcionar
        
        [self addSubview:progress_view];
        
        
        if (0){//[fileManager fileExistsAtPath:path]){
            [self performSelectorInBackground:@selector(rescataYMuestraImagen) withObject:nil];
            if (block) {
                block();
            }
        }else{
            
            [[APIClient instance] requestDescargarImagenAsincronaWithURLString:URL
                                                                           success:^(id results, NSError *error) {
                                                                               
                                                                               if (!error) {
                                                                                   dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                                                                                       // No explicit autorelease pool needed here.
                                                                                       // The code runs in background, not strangling
                                                                                       // the main run loop.
                                                                                       UIImage *imagen_original = (UIImage *)results;
                                                                                       UIImage *imagen = [self imageWithImage:imagen_original scaledToSize:CGSizeMake(320, imagen_original.size.height*320/imagen_original.size.width)];
                                                                                       
                                                                                       
                                                                                       dispatch_sync(dispatch_get_main_queue(), ^{
                                                                                           // This will be called on the main thread, so that
                                                                                           // you can update the UI, for example.
                                                                                           self.frame = [self calculaFrameSegunImageSize:imagen.size];
                                                                                           self.image = imagen;
                                                                                           [self setNeedsDisplay];
                                                                                           [progress_view removeFromSuperview];
                                                                                       });
                                                                                   });
                                                                                   /*
                                                                                   UIImage *imagen_original = (UIImage *)results;
                                                                                   UIImage *imagen = [self imageWithImage:imagen_original scaledToSize:CGSizeMake(320, imagen_original.size.height*320/imagen_original.size.width)];
                                                                                   
                                                                                   self.frame = [self calculaFrameSegunImageSize:imagen.size];
                                                                                   self.image = imagen;
                                                                                   [self setNeedsDisplay];
                                                                                    */
                                                                                   
                                                                               }else{
                                                                                   NSLog(@"error al descargar la imagen");
                                                                                   [progress_view removeFromSuperview];
                                                                               }
                                                                               if (block) {
                                                                                   block();
                                                                               }
                                                                               
                                                                           }
                                                             downloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
                                                                 float progress = ((float)totalBytesRead) / totalBytesExpectedToRead;
                                                                 progress_view.progress = progress;
                                                             }];
            
        }
    }
}

- (void) borraImagen{
    //[self removeFromSuperview];
    self.image = nil; //esto es lo que consume memoria, no la clase.
    descargada = NO;
}

- (CGRect) calculaFrameSegunImageSize:(CGSize )size{
    CGRect frame_self = self.frame;
    if (size.width/size.height < self.frame.size.width/self.frame.size.height) {
        // La imágen es alta que ancha... Entonces se acota con el alto.
        frame_self.size.width = size.width*self.frame.size.height/size.height;
        //Y la centro...
        frame_self.origin.x = self.frame.origin.x + self.frame.size.width/2 - frame_self.size.width/2;
    } else {
        // La imagen es mas ancha que alta... Entonces se acota con el ancho.
        frame_self.size.height = self.frame.size.width*size.height/size.width;
        //Y la centro...
        frame_self.origin.y = self.frame.origin.y + self.frame.size.height/2 - frame_self.size.height/2;
    }
    
    return frame_self;
}

-(UIImage *)imageWithImage:(UIImage *)imageToCompress scaledToSize:(CGSize)newSize {
    
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [imageToCompress drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

@end
