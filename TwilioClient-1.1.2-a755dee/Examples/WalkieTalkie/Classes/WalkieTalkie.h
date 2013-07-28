//
//  Copyright 2011 Twilio. All rights reserved.
//
 
#import <Foundation/Foundation.h>
#import "TCDevice.h"
#import "TCConnection.h"
#import "TCConnectionDelegate.h"

@interface WalkieTalkie : NSObject<TCDeviceDelegate, TCConnectionDelegate> 
{
@private
	TCDevice* _device;
	TCConnection* _connection;
	TCConnection* _pendingIncomingConnection;
}

@property (nonatomic,retain)	TCConnection* connection;
@property (nonatomic,retain)	TCConnection* pendingIncomingConnection;
@property (nonatomic)			BOOL muted;


//TCConnection related Methods
-(void)connect:(NSString*)clientName;
-(void)disconnect;
-(void)acceptIncomingConnection;
-(void)ignoreIncomingConnection;


@end
