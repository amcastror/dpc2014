//
//  TwitterController.m
//  DiaDelPatrimonio
//
//  Created by Matias Castro on 05-04-13.
//  Copyright (c) 2013 Matias Castro. All rights reserved.
//

#import "TwitterController.h"
#import <Twitter/Twitter.h>
#import <Accounts/Accounts.h>

@implementation TwitterController{
    
}

+(TwitterController *) instance
{
    static TwitterController *singleton = nil;
    @synchronized(self)
    {
        if (!singleton) {
            singleton = [[TwitterController alloc] init];
        }
    }
    return singleton;
    
}

-(id) init{
    if (self = [super init]) {
        
    }
    return self;
}

-(BOOL) canSendTweet{
    return [TWTweetComposeViewController canSendTweet];
}

-(void) imprimeCuentas{
    
    ACAccountStore *accountStore = [[ACAccountStore alloc] init];
    ACAccountType *accountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    
    NSArray *accountsArray = [accountStore accountsWithAccountType:accountType];
    
    if (accountsArray.count > 0) {
        for (ACAccount *cuenta in accountsArray) {
            NSLog(@"cuenta: %@", [cuenta username]);
        }
    }else{
        NSLog(@"no tengo ninguna cuenta...");
    } 
}

-(void) conectarseALasCuentasDelUsuarioWith:(void (^)(NSError *error))handler{
    
     // Create an account store object.
    ACAccountStore *accountStore = [[ACAccountStore alloc] init];
    
    // Create an account type that ensures Twitter accounts are retrieved.
    ACAccountType *accountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    
    // Request access from the user to use their Twitter accounts.

    [accountStore requestAccessToAccountsWithType:accountType withCompletionHandler:^(BOOL granted, NSError *error) {
        
        if (error) {
            [[[UIAlertView alloc] initWithTitle:@"Error" message:@"No se pudo acceder a su cuenta de Twitter, por favor intentelo más tarde" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
            if (handler) {
                NSError *err;
                handler(err);
            }
        }else{
            if (granted) {
                if (handler) {
                    handler(nil);
                }
            }else{
                [[[UIAlertView alloc] initWithTitle:@"Error" message:@"No se pudo acceder a su cuenta, es posible que la aplicación esté bloqueada en Ajustes/Twitter" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
                if (handler) {
                    NSError *err;
                    handler(err);
                }
            }
        }
    }];
}

-(BOOL) tengoCuentas{
    ACAccountStore *accountStore = [[ACAccountStore alloc] init];
    ACAccountType *accountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    NSArray *cuentas_tmp = [accountStore accountsWithAccountType:accountType];
    if (cuentas_tmp.count > 0) {
        return YES;
    }else{
        return NO;
    }
}

-(void) logout{
    ACAccountStore *accountStore = [[ACAccountStore alloc] init];
    
    // Create an account type that ensures Twitter accounts are retrieved.
    ACAccountType *accountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    NSArray *accountsArray = [accountStore accountsWithAccountType:accountType];
    for (ACAccount *cuenta in accountsArray) {
        [accountStore removeAccount:cuenta withCompletionHandler:^(BOOL success, NSError *error) {
            if (error) {
                NSLog(@"error al sacar una cuenta: %@", error);
            }
        }];
    }
}


-(void) enviarTweetWith:(void (^)(NSError *error))handler{
    
    if (![self tengoCuentas]) {
        NSError *err = [[NSError alloc] initWithDomain:@"sin cuentas" code:1 userInfo:nil]; //tengo que decirle que no hay sesión
        handler(err);
        return;
    }
    
    //ACAccount *twitterAccount = [cuentas objectAtIndex:0];
    
    ACAccountStore *accountStore = [[ACAccountStore alloc] init];
	
	// Create an account type that ensures Twitter accounts are retrieved.
    ACAccountType *accountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
	NSArray *accountsArray = [accountStore accountsWithAccountType:accountType];
    ACAccount *twitterAccount = [accountsArray objectAtIndex:0];
    TWRequest *postRequest = [[TWRequest alloc] initWithURL:[NSURL URLWithString:@"http://api.twitter.com/1/statuses/update.json"] parameters:[NSDictionary dictionaryWithObject:@"Hello." forKey:@"status"] requestMethod:TWRequestMethodPOST];
    
    [postRequest setAccount:twitterAccount];

    
    [postRequest performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
        //NSString *output = [NSString stringWithFormat:@"HTTP response status: %i", [urlResponse statusCode]];
        //[self performSelectorOnMainThread:@selector(displayText:) withObject:output waitUntilDone:NO];
    }];
}

/*
-(void) enviarTweetWith:(void (^)(NSError *error))handler{
    
    ACAccountStore *accountStore = [[ACAccountStore alloc] init];
	
	// Create an account type that ensures Twitter accounts are retrieved.
    ACAccountType *accountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
	
	// Request access from the user to use their Twitter accounts.
    [accountStore requestAccessToAccountsWithType:accountType withCompletionHandler:^(BOOL granted, NSError *error) {
        if(granted) {
			// Get the list of Twitter accounts.
            NSArray *accountsArray = [accountStore accountsWithAccountType:accountType];
			
			// For the sake of brevity, we'll assume there is only one Twitter account present.
			// You would ideally ask the user which account they want to tweet from, if there is more than one Twitter account present.
			if ([accountsArray count] > 0) {
				// Grab the initial Twitter account to tweet from.
				ACAccount *twitterAccount = [accountsArray objectAtIndex:0];
				
				// Create a request, which in this example, posts a tweet to the user's timeline.
				// This example uses version 1 of the Twitter API.
				// This may need to be changed to whichever version is currently appropriate.
				TWRequest *postRequest = [[TWRequest alloc] initWithURL:[NSURL URLWithString:@"http://api.twitter.com/1/statuses/update.json"] parameters:[NSDictionary dictionaryWithObject:@"Hello. This is another a tweet." forKey:@"status"] requestMethod:TWRequestMethodPOST];
				
				// Set the account used to post the tweet.
				[postRequest setAccount:twitterAccount];
				
				// Perform the request created above and create a handler block to handle the response.
				[postRequest performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
					NSString *output = [NSString stringWithFormat:@"HTTP response status: %i", [urlResponse statusCode]];
					//[self performSelectorOnMainThread:@selector(displayText:) withObject:output waitUntilDone:NO];
				}];
			}
        }
	}];
}
 */

@end
