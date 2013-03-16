//
//  APIClient.m
//  prototipoTabbed2
//
//  Created by Eduardo Alberti on 15-11-12.
//
//

#import "APIClient.h"
#import "AFJSONRequestOperation.h"

@implementation APIClient

static NSString * const baseURL = @"http://diadelpatrimonio.dsarhoya.cl/";
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
    
    [self getPath:[prefixURL stringByAppendingString:_path] parameters:_parameters success:_success failure:_failure];
}

- (id)initWithBaseURL:(NSURL *)url {
    self = [super initWithBaseURL:url];
    if (!self) {
        return nil;
    }
    
    [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
	
    [self setDefaultHeader:@"Accept" value:@"application/json"];
    [self setParameterEncoding:AFJSONParameterEncoding];
        
    return self;
}

#pragma mark - requests
-(void)requestCustomWithSuccess:(void (^)(id results))success AndFail:(void (^)(NSError *error))fail
{
    //Estos son datos propios de esta consulta
    NSDictionary *datos = [NSDictionary dictionaryWithObjectsAndKeys:
                           @"bs",@"c"
                           , nil];
    
    /*
     "id_tipo": 1,
     "id_usuario": 11,
     "id_sesion": 33,
     "id": 0,
     "udid": "45j63o4iu5h2o589",
     "latitud": -33.541,
     "longitud": -70.549
     */
    NSDictionary *usuario = [NSDictionary dictionaryWithObjectsAndKeys:
                             @"1",@"id_tipo",
                             @"11",@"id_usuario",
                             @"33",@"id_sesion",
                             @"0",@"id",
                             @"45j63o4iu5h2o589",@"udid",
                             @"-33.541",@"clatitud",
                             @"-70.549",@"longitud",
                             nil];
    
    /*
     "ps": "alkjrnv9ap84ejvqaw4ijfapwoi34f",
     "va": "1.3.1",
     "ba": "4.65"
     */
    NSDictionary *conexion = [NSDictionary dictionaryWithObjectsAndKeys:
                              @"alkjrnv9ap84ejvqaw4ijfapwoi34f",@"ps",
                              @"1.3.1",@"va",
                              @"4.65",@"ba",
                              nil];
    
    //El set de parámetros necesarios incluye parámetros generales y los propios de esta consulta
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                usuario,@"usuario",
                                conexion,@"conexion",
                                datos,@"datos",
                                nil];
    
    //Realizamos la consulta (Automáticamente se crea el request y la consulta se almacena en una cola de espera
    [self postPath:@"/consultas/busquedaSucursales.php" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if (success) {
            success(responseObject);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (fail) {
            fail(error);
        }
    }];
}

-(void)requestPuntosCulturalesWithSuccess:(void (^)(id results))success AndFail:(void (^)(NSError *error))fail{
    
    [self apiClientGetPath:@"/puntosCercanos/-33.54322/-70.6043" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if (success) {
            success(responseObject);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (fail) {
            fail(error);
        }
    }];
}

@end
