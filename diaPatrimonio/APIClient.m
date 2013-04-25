//
//  APIClient.m
//  prototipoTabbed2
//
//  Created by Eduardo Alberti on 15-11-12.
//
//

#import "APIClient.h"
#import "AFJSONRequestOperation.h"
#import "Usuario.h"

@implementation APIClient

static NSString * const baseURL = @"http://dev.diadelpatrimonio.cl/";
static NSString * const prefixURL = @"ws";

+ (APIClient *)instance {
    static APIClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[APIClient alloc] initWithBaseURL:[NSURL URLWithString:baseURL]];
    });
    
    return _sharedClient;
}

-(void)apiClientGetPath:(NSString *)_path
             parameters:(NSDictionary *)_parameters
                success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))_success
                failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))_failure{
    
    [self getPath:[prefixURL stringByAppendingString:[_path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] parameters:_parameters success:_success failure:_failure];
}

- (id)initWithBaseURL:(NSURL *)url {
    self = [super initWithBaseURL:url];
    if (!self) {
        return nil;
    }
    
    [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
	
    [self setDefaultHeader:@"Accept" value:@"application/json"];
    [self setParameterEncoding:AFJSONParameterEncoding];
    
    [self setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case (AFNetworkReachabilityStatusNotReachable, AFNetworkReachabilityStatusUnknown):
                [[[UIAlertView alloc] initWithTitle:@"error" message:@"No hay conexión, intente más tarde" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
                break;
                
            case (AFNetworkReachabilityStatusReachableViaWiFi, AFNetworkReachabilityStatusReachableViaWWAN):
                //[[[UIAlertView alloc] initWithTitle:@"error" message:@"Sí hay conexión!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
                break;
                
            default:
                break;
        }
    }];
    
    return self;
}

- (void) revisaSiHayInternet{
    switch ([self networkReachabilityStatus]) {
        case AFNetworkReachabilityStatusNotReachable:
            [[[UIAlertView alloc] initWithTitle:@"Error" message:@"No hay conexión a internet" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
            break;
        case  AFNetworkReachabilityStatusUnknown:
            [[[UIAlertView alloc] initWithTitle:@"Error" message:@"No hay conexión a internet" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
            break;
            
        default:
            break;
    }
}

#pragma mark - requests busquedas

-(void)requestPuntosCulturalesCercanosWithSuccess:(void (^)(id results))success AndFail:(void (^)(NSError *error))fail{
    
    double latitud = [[Usuario instance] latitud];
    double longitud = [[Usuario instance] longitud];
    
    [self apiClientGetPath:[NSString stringWithFormat:@"/puntosCercanos/%f/%f", latitud, longitud] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            success(responseObject);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self revisaSiHayInternet];
        if (fail) {
            fail(error);
        }
    }];
}



-(void)requestPuntosCulturalesEntre:(CLLocationCoordinate2D)puntoNO
                                  Y:(CLLocationCoordinate2D)puntoSE
                        WithSuccess:(void (^)(id results))success
                            AndFail:(void (^)(NSError *error))fail{
    
    
    [self apiClientGetPath:[NSString stringWithFormat:@"/buscarAqui/%f/%f/%f/%f", puntoNO.latitude, puntoNO.longitude, puntoSE.latitude, puntoSE.longitude]
                parameters:nil
                   success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if (success) {
            success(responseObject);
        }
        
    }
                   failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                       [self revisaSiHayInternet];
        if (fail) {
            fail(error);
        }
    }];
}

-(void)requestBuscarConZonaID:(NSNumber *)id_zona
                   YSubZonaID:(NSNumber *)id_sub_zona
                 YCategoriaID:(NSNumber *)id_categoria
                       YTexto:(NSString *)texto
                  WithSuccess:(void (^)(NSArray *results))success
                      AndFail:(void (^)(NSError *error))fail{
    
    NSString *path = @"/buscarPuntos";
    
    if (id_zona) {
        path = [path stringByAppendingFormat:@"/%i", id_zona.intValue];
    }else{
        path = [path stringByAppendingString:@"/0"];
    }
    
    if (id_sub_zona) {
        path = [path stringByAppendingFormat:@"/%i", id_sub_zona.intValue];
    }else{
        path = [path stringByAppendingString:@"/0"];
    }
    
    if (id_categoria) {
        path = [path stringByAppendingFormat:@"/%i", id_categoria.intValue];
    }else{
        path = [path stringByAppendingString:@"/0"];
    }
    
    if (texto && ![texto isEqualToString:@""]) {
        path = [path stringByAppendingFormat:@"/%@", texto];
    }
    
    [self apiClientGetPath:path
                parameters:nil
                   success:^(AFHTTPRequestOperation *operation, id responseObject) {
                       if (success) {
                           success((NSArray *)responseObject);
                       }
                       
                   }
                   failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                       [self revisaSiHayInternet];
                       if (fail) {
                           fail(error);
                       }
                   }];
}

-(void)requestZonasYSubZonasWithSuccess:(void (^)(NSDictionary *results))success
                                AndFail:(void (^)(NSError *error))fail{
    [self apiClientGetPath:@"/getZonas"
                parameters:nil
                   success:^(AFHTTPRequestOperation *operation, id responseObject) {
                       if (success) {
                           success(responseObject);
                       }
                       
                   }
                   failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                       [self revisaSiHayInternet];
                       if (fail) {
                           fail(error);
                       }
                   }];
}

-(void)requestCategoriasWithSuccess:(void (^)(NSArray *results))success
                                AndFail:(void (^)(NSError *error))fail{
    [self apiClientGetPath:@"/getTipos"
                parameters:nil
                   success:^(AFHTTPRequestOperation *operation, id responseObject) {
                       if (success) {
                           success(responseObject);
                       }
                       
                   }
                   failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                       [self revisaSiHayInternet];
                       if (fail) {
                           fail(error);
                       }
                   }];
}

#pragma mark - requests informacion punto

-(void) requestCompletarInformacionPuntoCulturalConIDPunto:(NSNumber *)id_punto
                                                AndSuccess:(void (^)(NSDictionary *informacionPunto))success
                                                   AndFail:(void (^)(NSError *error))fail{
    [self apiClientGetPath:[NSString stringWithFormat:@"/verDetallePunto/%i", id_punto.intValue]
                parameters:nil
                   success:^(AFHTTPRequestOperation *operation, id responseObject) {
                       
                       if (success) {
                           success(responseObject);
                       }
                       
                   }
                   failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                       [self revisaSiHayInternet];
                       if (fail) {
                           fail(error);
                       }
                   }];
}

-(void)requestDescargarImagenAsincronaWithURLString:(NSString *)url_string
                                            success:(void (^)(id results, NSError *error))block
                              downloadProgressBlock:(void (^) (NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead))downloadProgressBlock{
    NSURL *url = [NSURL URLWithString:url_string];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"GET"];
    AFImageRequestOperation *requestOperation = [AFImageRequestOperation imageRequestOperationWithRequest:request success:^(UIImage *imagen)
                                                 {
                                                     if (block) {
                                                         block(imagen,nil);
                                                     }
                                                 }];
    [[self operationQueue] addOperation:requestOperation];
    
    if (downloadProgressBlock) {
        [requestOperation setDownloadProgressBlock:downloadProgressBlock];
    }
}

#pragma mark - requests mis puntos

-(void)requestAgregarPuntoId:(NSNumber *)id_punto
       AMisPuntosWithSuccess:(void (^)())success
                     AndFail:(void (^)(NSError *error))fail{
    [self apiClientGetPath:[NSString stringWithFormat:@"/guardarPunto/%@/%i",
                            [[Usuario instance] udid],
                            id_punto.intValue]
                parameters:nil
                   success:^(AFHTTPRequestOperation *operation, id responseObject) {
                       
                       if (success) {
                           success();
                       }
                       
                   }
                   failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                       [self revisaSiHayInternet];
                       if (fail) {
                           fail(error);
                       }
                   }];
}

-(void)requestEliminarPuntoId:(NSNumber *)id_punto
       DeMisPuntosWithSuccess:(void (^)())success
                      AndFail:(void (^)(NSError *error))fail{
    [self apiClientGetPath:[NSString stringWithFormat:@"/eliminarPunto/%@/%i",
                            [[Usuario instance] udid],
                            id_punto.intValue]
                parameters:nil
                   success:^(AFHTTPRequestOperation *operation, id responseObject) {
                       NSLog(@"res: %@", responseObject);
                       if (success) {
                           success();
                       }
                       
                   }
                   failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                       [self revisaSiHayInternet];
                       if (fail) {
                           fail(error);
                       }
                   }];
}

-(void)requestMisPuntosCulturalesWithSuccess:(void (^)(NSArray *misPuntosCulturales))success
                                     AndFail:(void (^)(NSError *error))fail{
    
    [self apiClientGetPath:[NSString stringWithFormat:@"/verListaAlmacenada/%@",
                            [[Usuario instance] udid]
                            ]
                parameters:nil
                   success:^(AFHTTPRequestOperation *operation, id responseObject) {
                       if (success) {
                           success(responseObject);
                       }
                       
                   }
                   failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                       [self revisaSiHayInternet];
                       if (fail) {
                           fail(error);
                       }
                   }];
}

-(void)requestCambiarEstadoPuntoCulturalID:(NSNumber *)id_punto
                               WithSuccess:(void (^)())success
                                     AndFail:(void (^)(NSError *error))fail{
    
    [self apiClientGetPath:[NSString stringWithFormat:@"/cambiarEstadoPunto/%@/%i",
                            [[Usuario instance] udid],
                            [id_punto intValue]
                            ]
                parameters:nil
                   success:^(AFHTTPRequestOperation *operation, id responseObject) {
                       if (success) {
                           success();
                       }
                       
                   }
                   failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                       [self revisaSiHayInternet];
                       if (fail) {
                           fail(error);
                       }
                   }];
}

#pragma mark - requests comentarios

-(void)requestDejarComentarioEnPuntoCulturalID:(NSNumber *)id_punto
                                      ConAutor:(NSString *)autor
                                        Titulo:(NSString *)titulo
                                   YComentario:(NSString *)comentario
                                   WithSuccess:(void (^)())success
                                       AndFail:(void (^)(NSError *error))fail{
    
    if (
        !autor ||
        !titulo ||
        !comentario ||
        [autor isEqualToString:@""] ||
        [titulo isEqualToString:@""] ||
        [comentario isEqualToString:@""]
        ) {
        NSError *err = [[NSError alloc] initWithDomain:@"no viene toda la información para dejar el comentario" code:101 userInfo:nil];
        if (fail) {
            fail(err);
        }
        return;
    }
    NSDictionary *parametros = [NSDictionary dictionaryWithObject:comentario forKey:
                                @"cuerpo"];
    [self apiClientGetPath:[NSString stringWithFormat:@"/setComentario/%i/%@/%@",
                            id_punto.intValue,
                            autor,
                            titulo
                            //comentario
                            //@"un comentario"
                            ]
                parameters:parametros
                   success:^(AFHTTPRequestOperation *operation, id responseObject) {
                       if (success) {
                           success();
                       }
                       
                   }
                   failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                       [self revisaSiHayInternet];
                       if (fail) {
                           fail(error);
                       }
                   }];
}
-(void)requestComentariosDePuntoCulturalID:(NSNumber *)id_punto
                               WithSuccess:(void (^)(NSArray *results))success
                                   AndFail:(void (^)(NSError *error))fail{
    
    [self apiClientGetPath:[NSString stringWithFormat:@"/getComentarios/%i",
                            id_punto.intValue
                            ]
                parameters:nil
                   success:^(AFHTTPRequestOperation *operation, id responseObject) {
                       if (success) {
                           success((NSArray *)responseObject);
                       }
                       
                   }
                   failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                       [self revisaSiHayInternet];
                       if (fail) {
                           fail(error);
                       }
                   }];
}
@end
