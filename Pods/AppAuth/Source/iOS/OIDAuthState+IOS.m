/*! @file OIDAuthState+IOS.m
    @brief AppAuth iOS SDK
    @copyright
        Copyright 2016 Google Inc. All Rights Reserved.
    @copydetails
        Licensed under the Apache License, Version 2.0 (the "License");
        you may not use this file except in compliance with the License.
        You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

        Unless required by applicable law or agreed to in writing, software
        distributed under the License is distributed on an "AS IS" BASIS,
        WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
        See the License for the specific language governing permissions and
        limitations under the License.
 */

#import "OIDAuthState+IOS.h"
<<<<<<< HEAD
#import "OIDExternalUserAgentIOS.h"
#import "OIDExternalUserAgentCatalyst.h"
=======

#import "OIDExternalUserAgentIOS.h"
>>>>>>> 85cdc9998299efb8f2313da5d774f217a2cbce0d

@implementation OIDAuthState (IOS)

+ (id<OIDExternalUserAgentSession>)
    authStateByPresentingAuthorizationRequest:(OIDAuthorizationRequest *)authorizationRequest
                     presentingViewController:(UIViewController *)presentingViewController
                                     callback:(OIDAuthStateAuthorizationCallback)callback {
<<<<<<< HEAD
  id<OIDExternalUserAgent> externalUserAgent;
#if TARGET_OS_MACCATALYST
  externalUserAgent = [[OIDExternalUserAgentCatalyst alloc]
      initWithPresentingViewController:presentingViewController];
#else // TARGET_OS_MACCATALYST
  externalUserAgent = [[OIDExternalUserAgentIOS alloc] initWithPresentingViewController:presentingViewController];
#endif // TARGET_OS_MACCATALYST
=======
    OIDExternalUserAgentIOS *externalUserAgent =
        [[OIDExternalUserAgentIOS alloc]
            initWithPresentingViewController:presentingViewController];
>>>>>>> 85cdc9998299efb8f2313da5d774f217a2cbce0d
  return [self authStateByPresentingAuthorizationRequest:authorizationRequest
                                       externalUserAgent:externalUserAgent
                                                callback:callback];
}

<<<<<<< HEAD
#if !TARGET_OS_MACCATALYST
=======
>>>>>>> 85cdc9998299efb8f2313da5d774f217a2cbce0d
+ (id<OIDExternalUserAgentSession>)
    authStateByPresentingAuthorizationRequest:(OIDAuthorizationRequest *)authorizationRequest
                                  callback:(OIDAuthStateAuthorizationCallback)callback {
  OIDExternalUserAgentIOS *externalUserAgent = [[OIDExternalUserAgentIOS alloc] init];
  return [self authStateByPresentingAuthorizationRequest:authorizationRequest
                                       externalUserAgent:externalUserAgent
                                                callback:callback];
}
<<<<<<< HEAD
#endif // !TARGET_OS_MACCATALYST
=======
>>>>>>> 85cdc9998299efb8f2313da5d774f217a2cbce0d

@end
