#import <CoreFoundation/CoreFoundation.h>
#import <Foundation/Foundation.h>
#import <Security/Security.h>
#include <string.h>

typedef struct __SecCode *SecCodeRef;
typedef SecCodeRef SecStaticCodeRef;

extern OSStatus SecStaticCodeCreateWithPath(CFURLRef path, uint32_t flags, SecStaticCodeRef *staticCode);
extern OSStatus SecCodeCopySigningInformation(SecStaticCodeRef code, uint32_t flags, CFDictionaryRef *information);
extern const CFStringRef kSecCodeInfoTeamIdentifier;

enum {
    kSecCSSigningInformation = (1u << 1)
};

typedef struct __SecTask *SecTaskRef;
extern SecTaskRef SecTaskCreateFromSelf(CFAllocatorRef allocator);
extern CFTypeRef SecTaskCopyValueForEntitlement(SecTaskRef task, CFStringRef entitlement, CFErrorRef *error);

NSString *get_team_identifier_NSString(NSString *executable_path);
