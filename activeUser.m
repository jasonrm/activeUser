#import <Foundation/Foundation.h>
#import <SystemConfiguration/SystemConfiguration.h>

static CFStringRef CopyCurrentConsoleUsername(SCDynamicStoreRef store) {
    CFStringRef result;
    
    result = SCDynamicStoreCopyConsoleUser(store, NULL, NULL);
    
    // If the current console user is "loginwindow", treat that as equivalent to none.
    
    if ( (result != NULL) && CFEqual(result, CFSTR("loginwindow")) ) {
        CFRelease(result);
        result = NULL;
    }
    
    return result;
}

int main (int argc, const char * argv[]) {
    CFStringRef consoleUsername;
    CFStringEncoding encodingMethod;
    
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
    consoleUsername = CopyCurrentConsoleUsername(NULL);
    if (consoleUsername){
        encodingMethod = CFStringGetSystemEncoding();
        printf("%s\n", CFStringGetCStringPtr(consoleUsername, encodingMethod));
        CFRelease(consoleUsername);
    } else {
        printf("none\n");
    }

    [pool drain];
    return 0;
}
