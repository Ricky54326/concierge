//
//  Copyright 2011 Twilio. All rights reserved.
//
 
// Notification strings used with NSNotification to convey significant events
// between the model and the views.

extern NSString* const CPLoginDidStart;
extern NSString* const CPLoginDidFinish;
extern NSString* const CPLoginDidFailWithError;

extern NSString* const CPConferenceConnectionIsConnecting;
extern NSString* const CPConferenceConnectionDidConnect;
extern NSString* const CPConferenceConnectionDidFailToConnect;
extern NSString* const CPConferenceConnectionIsDisconnecting;
extern NSString* const CPConferenceConnectionDidDisconnect;
extern NSString* const CPConferenceConnectionDidFailWithError;

extern NSString* const CPDialingParticipants;

// userInfo is an NSDictionary with an "error" (NSError*) key/value pair
extern NSString* const CPDialingParticipantsFailedWithError;

